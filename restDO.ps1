
function get-droplet {
<#
.Synopsis
   Inwentaryzator dropletów
.DESCRIPTION
   Funkcja prezentuje podstawowe informacje o aktywnych VM-kach na naszym koncie Digital Ocean.
   Korzysta z api v2 Digital Ocean.
.PARAMETER tokenfile
   Ścieżka pliku tekstowego z naszym kluczem dostępu.
.EXAMPLE 
   get-droplet .\DOtoken.txt
#>

    param(
    [parameter(valuefrompipeline)]
    [ValidateScript({Test-Path $_})]
    [string]$tokenfile = ".\DOtoken.txt"
    )
    

$apiKey = Get-Content $tokenfile
$url = "https://api.digitalocean.com/v2"
$header = @{"Authorization"="Bearer " + $apikey;"Content-Type"="application/json"}
$rest = Invoke-RestMethod -Uri $url/droplets -Headers $header -method Get
$rest.droplets.id | ForEach-Object {
    #pobieram pojedynczy droplet
    $d = Invoke-RestMethod -uri $url/droplets/$_ -Headers $header -method Get | select -ExpandProperty droplet 
    #ostatnie zdarzenie
    $act = Invoke-RestMethod -Uri $url/droplets/$_/actions -Headers $header -method get | select -ExpandProperty actions 
    $maxactionid = $act.id | measure -Maximum | select -ExpandProperty maximum
    $lastaction = $act | where id -eq $maxactionid
    #ostatni backup
    $b = $d.backup_ids
    $bmax = $b.id | measure -Maximum | select  -ExpandProperty maximum
    $lastbackup = $b | where id -eq $bmax
    #buduje obiekt
    $props = [ordered]@{
        name = $d.name
        id = $_
        status= $d.status
        kernel = $d.kernel.name
        created = $d.created_at
        'memory[MB]' = $d.size.memory
        'HDD[GB]' = $d.size.disk
        vcores = $d.size.vcpus
        ip = $d.networks.v4.ip_address
        price = $d.size.price_hourly
        region = $d.region.name
        backup = if($b){$lastbackup}else{'brak'}
        lastAction = $lastaction.type
    }#end props
$obj = New-Object -TypeName PSObject -Property $props
Write-Output $obj
}#end foreach
}#end get-droplets


function set-droplet {
<#
.Synopsis
   Kontroler dropletów
.DESCRIPTION
   Funkcja pozwala zrestartować lub zatrzymać VM-ki na Digital Ocean
.PARAMETER tokenfile
   Ścieżka pliku tekstowego z naszym kluczem dostępu
.PARAMETER action
   reboot, shutdown lub power_on
.PARAMETER id
   Unikalny id dropleta
.EXAMPLE 
   set-droplet .\DOtoken.txt -id 3280834 -action reboot
.EXAMPLE
   get-droplet | where name -like *fedora* | set-droplet -action shutdown
.NOTES
   todo: resize, rename, create, delete
#>
  param(
   [parameter()]
   [ValidateScript({Test-Path $_})]
   [string]$tokenfile = ".\DOZapis.txt",

   [parameter(mandatory)]
   [ValidateSet('reboot','shutdown','power_on')]
   $action,

   [parameter(mandatory,Valuefrompipeline,valuefrompipelinebypropertyname)]
   [long]$id

  )#end param

$apiKey = Get-Content $tokenfile
$url = "https://api.digitalocean.com/v2"
$header = @{"Authorization"="Bearer " + $apikey;"Content-Type"="application/json"}
$command  = @"
{"type": "$action"}
"@

Invoke-RestMethod -Uri $url/droplets/$id/actions -Headers $header -method post -Body $command -ContentType Application/JSON

}#end set-droplet

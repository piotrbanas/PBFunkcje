function Get-HDDinfo {
<#
.Synopsis
   Pobieranie informacji o fizycznych twardych dyskach.
.DESCRIPTION
   Funkcja odpytuje urządzenia przez WMI.
.PARAMETER computername
   Jeden lub więcej Hostname lub IP odpytywanej maszyny
.PARAMETER typ
   3 - dyski logiczne, 4 - sieciowe
.PARAMETER credential
   Poświadczenia
.EXAMPLE
   get-HDDInfo -computername 192.168.10.32 -credential Administrator
.EXAMPLE
   get-HDDInfo -typ 4
   Podaje zamontowane dyski sieciowe
.EXAMPLE
   get-HDDInfo -computername (Get-content .\ListaIP.txt) -credential Administrator | ConvertTo-Csv -NoTypeInformation > .\hdd.csv
.EXAMPLE
   get-ADComputer -filter * -SearchBase "OU=Computers, OU=HR, DC=pl, DC=xper" | select -ExpandProperty Name | Get-HDDinfo
.NOTES
    Kontakt piotrbanas@xper.pl
#>
[cmdletbinding()]
param(
    [Parameter(ValueFromPipeline)        ]
    [string[]]$computername = $env:COMPUTERNAME,

    [ValidateRange(0,6)]
    [int]$typ = 3,

    [System.Management.Automation.CredentialAttribute()]$cred
)#end param

PROCESS{
    Foreach ($computer in $computername) {
    try{
    $drives = Get-WmiObject -Class win32_logicalDisk -Filter "Drivetype = $typ" -ComputerName $computer -Credential $cred -ErrorAction Stop
        Foreach ($drive in $drives) {
            $props = [ordered]@{
                Urządzenie = $computer
                DriveLetter = $drive.DeviceID
                Size_GB = $drive.Size / 1GB -as [int]
                FreeSpace_GB = $drive.FreeSpace / 1GB -as [int]
            }
            
            $obj = New-Object -TypeName PSObject -Property $props
            Write-Output $obj
    
        }#end foreach $drive
    }#end try 
    
    catch {
        $props = [ordered]@{
                Urządzenie = $computer
                DriveLetter = 'BŁĄD'
                Size_GB = $null
                FreeSpace_GB = $null
            }
            
            $obj = New-Object -TypeName PSObject -Property $props
            Write-Output $obj
    }#end catch
    }#end foreach $computer
}#end process

}#end function
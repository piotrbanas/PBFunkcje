function Get-ADpassDate {
<#
    .SYNOPSIS
    Narzędzie wyciąga z AD datę ważności oraz ostatniej zmiany hasła użytkownika.
    .DESCRIPTION
    Narzędzie wyciąga z AD oraz konwertuje do formatu ludzkiego termin wygaśnięcia oraz datę ostatniej zmiany hasła użytkownika.
    .PARAMETER name
    Nazwa konta w AD. Przyjmuje z pipe'a samaccountname.
    .EXAMPLE
    get-ADpassDate jkowalski
    .EXAMPLE
    get-aduser -Filter * -SearchBase "OU=users,OU=CENTRALA,DC=pol,DC=firma" | select samaccountname | get-ADpassDate
    Sprawdza daty użytkowników całej Jednostki organizacyjnej.
    .EXAMPLE
    get-aduser -Filter * | select samaccountname | get-ADpassDate | where {$_.wygasa -gt (Get-Date) -and $_.wygasa -lt (Get-Date).AddDays(5)}
    Podaje użytkowników, którym hasło wygasa w najbliższych 5. dniach.
    .NOTES
    Autor: piotrbanas@xper.pl
    .LINK
    https://github.com/piotrbanas/PBfunkcje.git
  #>

[CmdletBinding()] 
param
    (
        [parameter(
                   ValueFromPipeline=$True,
                   ValueFromPipelineByPropertyName=$True,
                   Position = 0,
                   HelpMessage="Podaj nazwę AD użytkownika.")]
        [Alias('username','samaccountname')]
        [string[]]$name
    ) # end param

BEGIN {Import-Module ActiveDirectory}

PROCESS {
ForEach ($n in $name) {
    try{
    $query = Get-AdUser -Identity $n -Properties Name, pwdlastset, msDS-UserPasswordExpiryTimeComputed
    $t = $query | select -ExpandProperty pwdlastset
    $p = $query | select -ExpandProperty msDS-UserPasswordExpiryTimeComputed

        $props = @{
            Name = $query.Name
            SamaccountName = $n
            HaslozDnia = [datetime]::FromFileTime("$t")
            Wygasa = [datetime]::FromFileTime("$p")
            }
     } # end try
    catch {
        $props = @{
            Name = 'Brak obiektu'
            SamaccountName = $null
            HaslozDnia = $null
            Wygasa = $null
        }
    } # end catch
    finally {
        $obj = New-Object -TypeName PSObject -Property $props
        Write-Output $obj
        }

} # end foreach
} # end PROCESS

END {}
 } # end get-adpassdate
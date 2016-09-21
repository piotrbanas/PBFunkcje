function Set-ADpassDate {
<#
    .SYNOPSIS
    Narzędzie resetuje datę ostatniej zmiany hasła użytkownika.
    .DESCRIPTION
    Narzędzie resetuje parametr pwdlastset, dzięki czemu oddala w czasie datę wygaśnięcia hasła.
    .PARAMETER samaccountname
    Nazwa konta w AD. Przyjmuje wartości z pipe'a.
    .EXAMPLE
    set-ADpassDate jkowalski
    .EXAMPLE
    set-aduser -Filter * -SearchBase "OU=users,OU=HR,OU=Business,DC=pol,DC=domena" | select samaccountname | set-ADpassDate
    Resetuje parametr pwdlastset użytkowników całej Jednostki organizacyjnej.
    .EXAMPLE
    get-aduser -Filter * | select samaccountname | get-ADpassDate | where {$_.wygasa -gt (Get-Date) -and $_.wygasa -lt (Get-Date).AddDays(5)} | set-ADpassDate
    Funkcja get-adpassdate wyszuka użytkowników, którym hasło wygasa w najbliższych 5. dniach i przekazuje ich do set-ADpassDate.
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
        [Alias('username','name')]
        [string[]]$samaccountname
    ) # end param

BEGIN {Import-Module ActiveDirectory}

PROCESS {
    ForEach ($n in $samaccountname) {
    
    $User = Get-ADUser $n -properties pwdlastset 
    $User.pwdlastset = 0 
    Set-ADUser -Instance $User 
    $user.pwdlastset = -1 
    Set-ADUser -instance $User
    } # end foreach

} # end PROCESS

END {}
 } # end set-adpassdate
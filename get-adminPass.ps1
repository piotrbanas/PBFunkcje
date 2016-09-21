function get-adminPass {
  <#
    .SYNOPSIS
    Narzędzie wyciąga z AD hasło lokalnego administratora komputera
    
    .DESCRIPTION
    Narzędzie wyciąga z AD aktualne hasło lokalnego administratora komputera oraz datę wygaśnięcia.
    Przydatne w środowiskach, w których używany jest Local Administrator Password Solution (LAPS).

    .PARAMETER computername
    Nazwa hosta, alias 'c', 'cn' lub 'Hostname'

    .EXAMPLE
    get-adminPass -c Nazwa_hosta1,Nazwa_Hosta2

    .EXAMPLE
    Get-ADComputer -Filter * -SearchBase "OU=Computers,OU=Business,DC=pol,DC=domena" | get-adminPass

    .NOTES
    Kontakt: piotrbanas@xper.pl
    .LINK
    http://github.com/piotrbanas

  #>


[CmdletBinding()] 
param
    (
        [parameter(
                   Mandatory=$true,ValueFromPipeline=$True,
                   ValueFromPipelineByPropertyName=$True,
                   Position = 0,
                   HelpMessage='Potrzebna nazwa kompa.')]
        [Alias('Hostname','cn','c')]
        [string[]]$computername
    )
BEGIN{Import-Module ActiveDirectory}

PROCESS{
    foreach ($computer in $computername) {
        try {
            $p = Get-ADComputer $computer -Property Name, ms-Mcs-AdmPwd -ErrorAction Stop
            $t = Get-ADComputer $computer -Property ms-Mcs-AdmPwdExpirationTime | Select-Object -ExpandProperty ms-Mcs-AdmPwdExpirationTime
        
            $props = @{
                Nazwa = $computer
                Hasło = $p."ms-Mcs-AdmPwd"
                Wygasa = [datetime]::FromFileTime("$t")
            }
        }

        catch{
            $props = @{
                Nazwa = $computer
                Hasło = 'Brak obiektu'
                Wygasa = $null
                }
        }

        finally {
        $obj = New-Object -TypeName PSObject -Property $props
        Write-Output $obj
        }
        }
    }

END {
   # Write-Output $pass | ft -Property Name, ms-Mcs-AdmPwd -AutoSize
   }

}


#Narzędzie wyciąga z AD hasło lokalnego administratora komputera
#Użycie: .\adminPass.ps1 -c Nazwa_hosta1,Nazwa_Hosta2

function get-adminPass {
[CmdletBinding()] 
param
    (
        [parameter(
                   ValueFromPipeline=$True,
                   ValueFromPipelineByPropertyName=$True,
                   Position = 0,
                   HelpMessage="Potrzebna nazwa kompa.")]
        [Alias('Hostname','cn','c')]
        [string[]]$computername
    )
BEGIN{Import-Module ActiveDirectory}

PROCESS{
    foreach ($computer in $computername) {
        try {
            $p = Get-ADComputer $computer -Property Name, ms-Mcs-AdmPwd -ErrorAction Stop
        
            $props = @{
                Nazwa = $computer
                Hasło = $p."ms-Mcs-AdmPwd"
            }
        }

        catch{
            $props = @{
                Nazwa = $computer
                Hasło = 'Brak obiektu'
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


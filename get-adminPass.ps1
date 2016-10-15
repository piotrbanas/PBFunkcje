function get-adminPass {
  <#
    .SYNOPSIS
    Get LAPS-generated local admin password.
    
    .DESCRIPTION
    Tool queries Active Directory for computer's Local Administrator Password Solution (LAPS) attributes. 

    .PARAMETER computername
    Hostname, aliases: 'c', 'cn', 'Hostname'

    .EXAMPLE
    get-adminPass -c Hostname1, Hostname2

    .EXAMPLE
    Get-ADComputer -Filter * -SearchBase "OU=Computers,OU=Business,DC=local,DC=domain" | get-adminPass
	Get local admin passwords for every computer object in OU.
    .NOTES
    Contact: piotrbanas@xper.pl
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
                   HelpMessage='Provide Computername')]
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
                Name = $computer
                Password = $p."ms-Mcs-AdmPwd"
                Expires = [datetime]::FromFileTime("$t")
            }
        }

        catch{
            $props = @{
                Name = $computer
                Password = 'Object not found'
                Expires = $null
                }
        }

        finally {
        $obj = New-Object -TypeName PSObject -Property $props
        Write-Output $obj
        }
        }
    }

END {}
}


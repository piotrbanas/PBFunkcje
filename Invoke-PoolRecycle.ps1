Function Invoke-PoolRecycle {
<#
.Synopsis
Recycle IIS pools.
.DESCRIPTION
Script connects to specified IIS servers and recycles application pools.
Requires remoting (admin) rights.
.PARAMETER computername
Hostname of IIS server. Accepts multiple values as parameter or from pipeline.
.EXAMPLE
Invoke-PoolRecycle.ps1 -computername 'Server1', 'Server2' -Verbose
.EXAMPLE
@('Server1', 'Server2') | Invoke-PoolRecycle.ps1
.NOTES
Contact: piotrbanas@xper.pl
#>
[cmdletbinding()]
param(
    [Parameter(Mandatory,
               ValueFromPipeline,
               HelpMessage='Please provide hostname[s] of target IIS server')]
    [string[]]$computername
)#end param

PROCESS {
    Foreach ($c in $computername) {
        try {
            Write-Verbose "Remoting to $c"
            New-PSSession -ComputerName $c -OutVariable iissession -ErrorAction Stop 
        }
        catch {
            Write-Verbose "Could not remote to $c"
            Throw $Error[0]
        }
        
        Invoke-Command -Session $iissession -ScriptBlock {
            
            Import-Module WebAdministration
            $VerbosePreference='Continue'
            Get-ChildItem –Path IIS:\Sites | select -ExpandProperty applicationpool | ForEach-Object { Write-Verbose "Restarting $_"; Restart-WebAppPool -Name $_}  
            } -Verbose # end scriptblock
        Remove-PSSession -Session $iissession
    } #end foreach
} # end PROCESS
} # end Function
function Set-AppPoolRecycleLogging {
<#
.SYNOPSIS
Sets event logging for app pool recycles.
.DESCRIPTION
.PARAMETER computername
.EXAMPLE
get-content .\ServerList.txt | Set-AppPoolRecycleLogging
.EXAMPLE
Set-AppPoolRecycleLogging -computername (get-content .\ServerList.txt)
.NOTES
Contact: piotrbanas@xper.pl
.LINK
#>


[CmdletBinding()] 
param(
[parameter(ValueFromPipeline=$True,
    ValueFromPipelineByPropertyName=$True,
    Position = 0,
    HelpMessage='Provide Computername')]
[Alias('Hostname','cn','c')]
[string[]]$computername
)

PROCESS {
    Foreach ($computer in $computername) {
        Invoke-Command -ComputerName $computer -ScriptBlock {
            Import-module WebAdministration
            $logEventOnRecycle="Time,Requests,Schedule,Memory,IsapiUnhealthy,OnDemand,ConfigChange,PrivateMemory"
            $apppools = Get-ChildItem -Path IIS:\AppPools
            Foreach ($pool in $apppools) {
                Set-ItemProperty -path $pool.PSPath -name "recycling.logEventOnRecycle" -Value $logEventOnRecycle
            }
        }
    }
}
}
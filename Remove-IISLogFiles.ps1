
Function Remove-IISLogFiles {
<#
.Synopsis
Cleanup IIS log files.
.DESCRIPTION
Delete logfiles older than given number of days.
.PARAMETER computername
Hostname of IIS server. Accepts multiple values as parameter or from pipeline.
.PARAMETER days
Age of files to keep.
.PARAMETER path
Path to logfiles.
.EXAMPLE
Remove-IISLogFile -computername 'Webserver1', 'Webserver2' -Verbose
.EXAMPLE
@('Webserver1', 'Webserver2') | Remove-IISLogFile -Days 45 -Path 'C$\inetpub\logs\logfiles\W3SVC1'
#>
[cmdletbinding(SupportsShouldProcess = $true)]
Param (
    [Parameter(Mandatory,
        Position=0,
        ValueFromPipeline=$true,
        HelpMessage='Please provide hostname[s] of target IIS server')]
    [ValidateNotNullOrEmpty()]
    [string[]]$Computername,

    [int]$Days = 30,
    
    [string]$Path = 'F$\inetpub\logs\logfiles\W3SVC1'
) # end param

PROCESS {
    Foreach ($Computer in $Computername) {     
        $uncpath = Join-Path "\\$Computer" $Path
        Get-ChildItem -Path $uncpath -Filter "*.log" | Where-Object -FilterScript {$_.LastWriteTime -lt (Get-Date).AddDays(-$Days)} | Remove-Item -Verbose
    } # end foreach
} # end PROCESS
} # end function

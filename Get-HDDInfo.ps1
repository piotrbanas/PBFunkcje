function Get-HDDinfo {
<#
.Synopsis
   Retrieve hard drive info.
.DESCRIPTION
   Uses WMI
.PARAMETER computername
   One or more hostname or IP
.PARAMETER type
   3 - logical drives (default), 4 - network drives
.PARAMETER credential
   Optionally provide credentials object.
.EXAMPLE
   get-HDDInfo -computername 192.168.10.32 -credential Administrator
.EXAMPLE
   get-HDDInfo -typ 4
.EXAMPLE
   get-HDDInfo -computername (Get-content .\IPList.txt) -credential Administrator | ConvertTo-Csv -NoTypeInformation > .\hdd.csv
.EXAMPLE
   get-ADComputer -filter * -SearchBase "OU=Computers, OU=HR, DC=pl, DC=xper" | select -ExpandProperty Name | Get-HDDinfo
.NOTES
    Contact: piotrbanas@xper.pl
#>
[cmdletbinding()]
param(
    [Parameter(ValueFromPipeline)        ]
    [string[]]$computername = $env:COMPUTERNAME,

    [ValidateRange(0,6)]
    [int]$type = 3,

    [System.Management.Automation.CredentialAttribute()]$cred
)#end param

PROCESS{
    Foreach ($computer in $computername) {
    try{
    If ($cred) {
    $drives = Get-WmiObject -Class win32_logicalDisk -Filter "Drivetype = $type" -ComputerName $computer -Credential $cred -ErrorAction Stop
    }
    Else {
    $drives = Get-WmiObject -Class win32_logicalDisk -Filter "Drivetype = $type" -ComputerName $computer -ErrorAction Stop

    }
        Foreach ($drive in $drives) {
            $props = [ordered]@{
                Device = $computer
                DriveLetter = $drive.DeviceID
                Size_GB = $drive.Size / 1GB -as [int]
                FreeSpace_GB = $drive.FreeSpace / 1GB -as [int]
                PctFree = ($drive.FreeSpace/$drive.Size).ToString("P")

            }
            
            $obj = New-Object -TypeName PSObject -Property $props
            Write-Output $obj
    
        }#end foreach $drive
    }#end try 
    
    catch {
        $props = [ordered]@{
                Device = $computer
                DriveLetter = 'Error'
                Size_GB = $null
                FreeSpace_GB = $null
            }
            
            $obj = New-Object -TypeName PSObject -Property $props
            Write-Output $obj
    }#end catch
    }#end foreach $computer
}#end process

}#end function
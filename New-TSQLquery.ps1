Function New-TSQLquery {
<#
.SYNOPSIS
Execute T-SQL query against remote database.
.DESCRIPTION
Script connects to specified SQL server and imports SQL module to a local session to execute a query.
Uses default credentials.
Uses implicit remoting.
.PARAMETER Computername
Hostname of SQL server.
.PARAMETER Database
Name of the database
.PARAMETER TSQLQuery
Statement to execute. Leave blank to list tables.
.EXAMPLE
Get-DBTables -Computername 'MSSQLServer1' -Database 'Db1'
.NOTES
Contact: piotrbanas@xper.pl
#>
[Cmdletbinding()]
Param (
    [String]$Computername = 'DBServer1',
    [String]$Database = 'DB1',
    [String]$TSQLQuery = "SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE='BASE TABLE'"
)

    Try {
        $sqlsession = New-PSSession -ComputerName $Computername -ErrorAction Stop
    }
    Catch {
        Throw
        
    }
    Invoke-Command -Session $sqlsession -ScriptBlock {
    $WarningPreference = 'SilentlyContinue'
        Import-module SQLPS | Out-Null
        }
    Import-PSSession -Prefix REM -Module SQLPS -Session $sqlsession -WarningAction SilentlyContinue | Out-Null

    Invoke-REMSqlcmd -ServerInstance $Computername -Database  $Database -Query $TSQLQuery

    Remove-PSSession -Session $sqlsession

}
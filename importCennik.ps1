<#
.Synopsis
   Import cennika do postaci obiektowej.
.DESCRIPTION
   Funkcja przerabia cennik (np. FHAUCP00) z postaci tekstowej do obiektowej.
.EXAMPLE
   Import-Cennik -fhaucp '.\FHAUCP00.20160818.1'
#>

function Import-Cennik
{
[CmdletBinding()] 
param (
[Parameter(Mandatory=$True, 
    ValueFromPipeline=$True, 
    ValueFromPipelineByPropertyName=$True)]
    [string[]]$fhaucp
) # end Param

$f = Get-Content $fhaucp -Encoding OEM

$cennik = Foreach($c in $f) {
    $properties = [ordered]@{
        sklep = $c.substring(0,3)
        Data = $c.substring(3,8)
        EAN = $c.substring(21,13)
        Segment = $c.substring(38,3)
        Nazwa = $c.substring(41,30)
        Cena = $c.substring(76,6) / 1000
        } # end properties
    $obj = New-Object -TypeName PSObject -Property $properties
    Write-Output $obj 
    } # end foreach
} # end Import-Cennik
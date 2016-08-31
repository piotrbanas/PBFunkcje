<#
.Synopsis
   Import cennika do postaci obiektowej.
.DESCRIPTION
   Funkcja przerabia cennik (np. FHAUCP00) z postaci tekstowej do obiektowej.
   Udostępnia obiekt $cennik w ramach sesji PowerShell.
.EXAMPLE
   Import-Cennik -fhaucp .\FHAUCP00.20160818.1
   $cennik | Where segment -eq 302

#>

function global:Import-Cennik
{
[CmdletBinding()] 
param (
[Parameter(Mandatory=$True, 
    ValueFromPipeline=$True)]
    $fhaucp	
) # end Param

$fhaucp = Get-Content $fhaucp -Encoding OEM

$global:cennik = Foreach($f in $fhaucp) {
    $properties = [ordered]@{
        sklep = $f.substring(0,3)
        Data = $f.substring(3,8)
        EAN = $f.substring(21,13)
        Segment = $f.substring(38,3)
        Nazwa = $f.substring(41,30)
        Cena = $f.substring(76,6) / 1000
        } # end properties
    $obj = New-Object -TypeName PSObject -Property $properties
    Write-Output $obj 
    } # end foreach

$cennik.count
} # end Import-Cennik
﻿function ping-urz {
 <#
    .SYNOPSIS
    Pingowanie urządzeń z listy w pliku tekstowym

    .DESCRIPTION
    Funkcja odczytuje plik tekstowy i sprawdza połączenie.

    .PARAMETER lista
    Ścieźka do pliku z adresami.

    .EXAMPLE
    ping-urz C:\skrypty\wagi\121\wagi121.txt
    Skan urządzeń z pliku.

    .EXAMPLE
    ls wagi*.txt | ping-urz
    Skan urządzeń z wielu plików.
    
    .NOTES
    Część modułu PBFunkcje
    kontakt: piotrbanas@xper.pl
    Aktualna wersja github.com/piotrbanas

  #>
[cmdletBinding()]
param(
    [Parameter(Mandatory=$true,
    ValueFromPipeline)]
    [string]$lista
    )
PROCESS{
$txList = Get-Content -Path "$lista"
$txp = foreach ($txL in $txList){
        if (Test-Connection -ComputerName $txL -count 1 -ErrorAction SilentlyContinue)
        {
        $props = @{
            Adres = $txL
            Status = 'OK'
            } # props
        
        } # if
        else {
        $props = @{
            Adres = $txL
            Status = 'Błąd'
            } # props
        } # else

        $obj = New-Object -TypeName psobject -Property $props
        Write-Output $obj
        } # end foreach

$txp | Format-Table -AutoSize
}
}

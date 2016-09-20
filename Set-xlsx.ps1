function Set-xlsx {
  <#
      .SYNOPSIS
      Funkcja do wypełniania arkuszy Excela, np. wklejania wyników do checklisty.

      .DESCRIPTION
      Używana razem z . open-xlsx i save-xlsx. 
      Należy unikać złączonych komórek.

      .PARAMETER worksheet
      Arkusz do edytowania.

      .PARAMETER range
      Zakres, lub komórka do której chcemy wklejać.

      .PARAMETER value
      Wartości, które wklejamy.

      .EXAMPLE
      . open-xlsx -xlsx ".\Checklista.xlsm" -visible $false
      set-xlsx -worksheet 'Arkusz' -range 'A1:A5' -value "$coś"
      save-xlsx

      Otwiera plik w trybie niewidocznym, wkleja wartość $coś w komórki A1:A5 arkusza Arkusz i zapisuje plik.

      .EXAMPLE
      Set-xlsx -worksheet 'Arkusz1' -range 'C4' -value (Get-Date)
      Wkleja datę do komórki C4 w arkuszu Arkusz1

      .EXAMPLE
      set-xlsx -worksheet 'Arkusz2' -range 'C4' -value (Get-content .\plik.txt)

      .NOTES
      Kontakt: piotrbanas@xper.pl
      Część modułu PBFunkcje. 

  #>

  [CmdletBinding()]
  Param( 
    [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
    $worksheet, 
    [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=1)]
    $range,  
    [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=2)]
    $value
  ) #end param 
  
  BEGIN {}

  PROCESS {
    $Worksheet = $Workbook.WorkSheets.item($worksheet) 
    $value | set-clipboard
    $range = $WorkSheet.Range($range)
    $Worksheet.Paste($range)
  }
  END{}
} # End Set-xlsx


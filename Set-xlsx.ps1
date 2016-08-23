function Set-xlsx {
  <#
      .SYNOPSIS
      Funkcja do wypełniania arkuszy Excela, np. wklejania wyników do checklisty.

      .DESCRIPTION
      Używana razem z open-xlsx i save-xlsx.

      .PARAMETER worksheet
      Arkusz do edytowania.

      .PARAMETER range
      Zakres, lub komórka do której chcemy wklejać.

      .PARAMETER value
      Wartości, które wklejamy.

      .EXAMPLE
      Set-xlsx -worksheet 'Arkusz1' -range 'C4' -value (Get-Date)
      Wkleja datę do komórki C4 w arkuszu Arkusz1

      .EXAMPLE
      set-xlsx -worksheet 'Arkusz' -range 'A1:A5' -value "$coś"

      .EXAMPLE
      set-xlsx -worksheet 'Arkusz2' -range 'C4' -value (Get-content .\plik.txt)

      .NOTES
      Kontakt: p.banas@***REMOVED***.com.pl

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


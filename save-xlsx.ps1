function save-xlsx{
    
  $workbook.Save()
  $Excel.Quit() 
  Remove-Variable -Name Excel -ErrorAction SilentlyContinue
  [gc]::collect() 
  [gc]::WaitForPendingFinalizers()
}
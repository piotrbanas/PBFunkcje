function open-xlsx {
  Param(
    $xlsx = "C:\temp\Checklista.xls",
	$visible = $false
  )
  $Excel = New-Object -ComObject excel.application
  $Excel.visible = $visible
  $Workbook = $excel.Workbooks.open($xlsx)
  
}
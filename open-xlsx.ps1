function open-xlsx {
  Param(
    $xlsx = "C:\Users\Piotr\Desktop\ps1\***REMOVED***\***REMOVED*** ping\Kiabi_Checklist.xls",
	$visible = $false
  )
  $Excel = New-Object -ComObject excel.application
  $Excel.visible = $visible
  $Workbook = $excel.Workbooks.open($xlsx)
  
}
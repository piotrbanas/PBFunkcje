function open-xlsx {
  Param(
    $xlsx = "C:\Users\Piotr\Desktop\ps1\***REMOVED***\***REMOVED*** ping\Kiabi_Checklist.xls"
  )
  $Excel = New-Object -ComObject excel.application
  $Excel.visible = $true
  $Workbook = $excel.Workbooks.open($xlsx)
  
}
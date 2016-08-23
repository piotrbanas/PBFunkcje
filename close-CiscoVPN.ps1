function close-CiscoVPN
{
  # Zamykam VPN UI
    $proces = Get-Process vpnui -ErrorAction SilentlyContinue
  if (!($proces -eq $null))
  {
    Stop-Process $proces
  } 
  # Rozłączam sesję
  &"c:\Program Files (x86)\Cisco\Cisco AnyConnect Secure Mobility Client\vpncli.exe" disconnect | out-null
  
}
function enter-CiscoVPN
{
  param
  (
    [String]
    $user = "$env:USERNAME",

    [String]
    $passfile = "vpnSecure$user.txt",
    
    [String]
    $ip = '***REMOVED***'
  )
  
  # Zamykam klienta graficznego
  $proces = Get-Process vpnui -ErrorAction SilentlyContinue
  if (!($proces -eq $null))
  {
    Stop-Process $proces
  } 
    
  # Zbieram poświadczenia VPN

  if (!(Test-Path $passfile))
  {
    new-passfile -user $user -passfile $passfile
  }
  

  $pass = Get-Content -path $passfile | ConvertTo-SecureString
  $cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $user, $pass
  
  # Tworzę dane połączeniowe dla vpncli
  $s = "connect $ip" | out-string
  $s += 'y' | Out-String
  $s += "$user" | Out-String
  $s += $cred.GetNetworkCredential().password
    
  # Nawiązuję sesję
  $s  | &"c:\Program Files (x86)\Cisco\Cisco AnyConnect Secure Mobility Client\vpncli.exe" -s | out-null
  
  # Czyszczę obiekt połączeniowy
  $s = $null

}
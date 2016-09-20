function enter-CiscoVPN {
<#
.Synopsis
   Zestawianie połączenia VPN Cisco AnyConnect
.DESCRIPTION
   Wymaga zainstalowanego Cisco AnyConnect Secure Mobility Client.
.EXAMPLE
   enter-CiscoVPN -ip 'x.x.x.x' -user uzytkownikvpn -passfile .\vpnSecure.txt
.NOTES
   Część modułu PBFunkcje. Aktualna wersja zawsze w github.com/piotrbanas
   Kontakt: piotrbanas@xper.pl
#>
[cmdletbinding()]

  param
  (
    [String]
    $user = "$env:USERNAME",

    [String]
    $passfile = "vpnSecure$user.txt",
    
    [Parameter (mandatory,HelpMessage='Adres docelowy')]
    [String]
    $ip
  )
  
  # Zamykam klienta graficznego
  $proces = Get-Process vpnui -ErrorAction SilentlyContinue
  if ($proces)
  {
    Write-Verobse 'Zamykam klienta graficznego'
    Stop-Process $proces
  } 
    
  # Zbieram poświadczenia VPN

  if (!(Test-Path $passfile))
  {
    Write-Verbose 'Wywołuję new-passfile'
    new-passfile -user $user -passfile $passfile
  }
  
  Write-Verbose 'Tworzę obiekt poświadczeń'
  $pass = Get-Content -path $passfile | ConvertTo-SecureString
  $cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $user, $pass
  
  Write-Verbose 'Tworzę dane połączeniowe dla vpncli'
  $s = "connect $ip" | out-string
  $s += 'y' | Out-String
  $s += "$user" | Out-String
  $s += $cred.GetNetworkCredential().password
    
  Write-Verbose 'Nawiązuję sesję'
  $s  | &"c:\Program Files (x86)\Cisco\Cisco AnyConnect Secure Mobility Client\vpncli.exe" -s | out-null
  
  # Czyszczę obiekt połączeniowy
  $s = $null

}
function new-mount
{

  param
  (
    [String]
    $user = '$env:USERNAME',

    [String]
    $passfile = "Pass$user.txt",
    
    [Parameter(Mandatory=$true)][String]
    $mountpoint,
  
    [String]
    #Jeśli nie dostanę nazwy dysku, przypiszę losową, trzyznakową
    $mountname = ([char[]]([char]'a'..[char]'z') + 0..9 | sort {get-random})[0..2] -join ''
  )

  # Jeśli nie znajdę bezpiecznego pliku, odwołam się do funkcji, która zapyta o hasło i go stworzy.
  if (!(Test-Path $passfile))
  {
    new-passfile -user $user -passfile $passfile
  }
  
  # Tworzę obiekt poświadczeń z dostarczonej nazwy użytkownika i bezpiecznego pliku
  $pass = Get-Content -path $passfile | ConvertTo-SecureString
  $cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $user, $pass
  
  # Montuję zasób sieciowy
  New-PSDrive -name $mountname -PSProvider FileSystem -Root $mountpoint -Credential $cred -Scope global

}
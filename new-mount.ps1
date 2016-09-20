function new-mount {
<#
.SYNOPSIS
   Montowanie zasobu sieciowego.
.DESCRIPTION
   Mapowanie zasobów sieciowych na potrzeby skryptów.
   Nie przechowuje haseł otwartym tekstem.
.PARAMETER user
   Użytkownik na którym chcemy się połączyć. Jeśli żaden nie zostanie wymieniony, będzie to użytkownik sesji wywołującej funkcję.
.PARAMETER passfile
   Ścieżka do pliku z zaszyfrowanym hasłem. Jeśli plik nie istnieje, zostanie wywołana funkcja new-passfile.
.PARAMETER mountpoint
   Zasób, który chcemy zamontować
.PARAMETER mountname
   Nazwa dysku w naszej sesji Powershella. Nie jest ograniczona do jednej litery, jak w Explorerze.
.EXAMPLE
   new-mount -user Administrator -passfile admSecurePass.txt -mountpoint '\\server\folder' -mountname 'DyskABC'
   Montuje \\server\folder pod nazwą 'DyskABC' na poświadczeniach Administrator.
.NOTES
   Autor: piotrbanas@xper.pl
   Część modułu PBFunkcje. Aktualna wersja w github.com/piotrbanas

#>
[CmdletBinding()]
  param
  (
    [String]
    $user = "$env:USERNAME",

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
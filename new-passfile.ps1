function new-passfile
{
  <#
    .SYNOPSIS
    Funkcja tworzy plik z szyfrowanym hasłem.

    .DESCRIPTION
    Funkcja pyta użytkowika o hasło do zaszyfrowania.
    Plik jest ważny dla użytkownika/maszyny na których został utworzony.

    .PARAMETER user
    Użytkownik, dla którego będziemy przechowywać hasło.

    .PARAMETER passfile
    Nazwa tworzonego pliku.

    .EXAMPLE
    new-passfile -user Administrator -passfile AdmPass.txt
    
    .NOTES
    kontakt: p.banas@***REMOVED***.com.pl
    Aktualna wersja zawsze w ***REMOVED***\IT_DEV\Repo\SCHFunkcje

  #>


  param
  (
    [Parameter(Mandatory=$true)][String]
    $user,
  
    [Parameter(Mandatory=$true)][String]
    $passfile
  )
  
  Read-Host "Podaj hasło dla $user" -AsSecureString | ConvertFrom-SecureString | Out-File "$passfile"
  
}
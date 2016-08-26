function new-sesja
{
  <#
      .SYNOPSIS
      Nawiązuje zdalne sesje z jednym lub więcej komputerów.

      .DESCRIPTION
      Funkcja buduje obiekt poświadczeń i nawiązuje połączenie z komputerami przekazanymi w parametrze -computername

      .PARAMETER computername
      (Wymagany)  Nazwa komptera lub IP. Przyjmuje wartości z pipe'a lub wymienone po przecinku.

      .PARAMETER user
      Użytkownik na którym checmy się połączyć. Jeśli żaden nie zostanie wymieniny, będzie to użytkownik sesji wywyołującej funkcję.

      .PARAMETER passfile
      Ścieżka do pliku z zaszyfrowanym hasłem. Jeśli nie ma, zostanie wywołana funkcja new-passfile.

      .EXAMPLE
      new-sesja -computername Server01, Server02 -user Adminsitrator -passfile .\AdmPass.txt
      Otwiera PSsesję z serwerami 01 i 02

      .EXAMPLE
      Get-content .\Serwery.txt | new-sesja -user Administrator
      Otwiera sesje z serwerami wymienionymi w pliku tekstowym.

      .NOTES
      Autor: p.banas@***REMOVED***.com.pl
      Część modułu SCHFunkcje. Aktualna wersja zawsze w ***REMOVED***\IT_DEV\Repo\SCHFunkcje
    
  #>
  
  [CmdletBinding()] 
  param
  (
    [Parameter(Mandatory,
             ValuefromPipeline)] 
    [String[]]
    $computername,

    [String]
    $user = "$env:USERNAME",

    [String]
    $passfile = "Pass$user.txt" 
  ) # end param

  BEGIN{
      Write-Verbose -Message 'Sprawdzam bezpieczny plik.'
      if (!(Test-Path -Path $passfile))
          {
      Write-Verbose -Message 'Jeśli nie znajdę bezpiecznego pliku, odwołam się do funkcji, która zapyta o hasło i go stworzy.'
            new-passfile -user $user -passfile $passfile
          }
      Write-Verbose -Message 'Tworzę obiekt poświadczeń z dostarczonej nazwy użytkownika i bezpiecznego pliku'
      $pass = Get-Content -path $passfile | ConvertTo-SecureString
      $cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $user, $pass
      } # End Begin

  PROCESS{
        Write-Verbose -Message "Zestawiam sesję z $computername"
        New-PSSession -ComputerName $computername -Credential $cred
        } # End Process

  END{
    #    Write-Verbose -Message 'Tworzę listę sesji'
    #    $sesje = Get-PSSession | Where-Object -Property ComputerName -like '131.*'
    #    Return $sesje
  } # End End
}
function new-sesja
{
  <#
      .SYNOPSIS
      Nawiązuje zdalne sesje z jednym lub więcej komputerów.

      .DESCRIPTION
      Funkcja buduje obiekt poświadczeń i nawiązuje połączenie z komputerami przekazanymi w parametrze -computername

      .PARAMETER computername
      (Wymagany) Nazwa komptera lub IP. Przyjmuje wartości z pipe'a.

      .PARAMETER user
      Użytkownik na którym checmy się połączyć. Jeśli żaden nie zostanie wymieniony, będzie to użytkownik sesji wywyołującej funkcję.

      .PARAMETER passfile
      Ścieżka do pliku z zaszyfrowanym hasłem. Jeśli nie ma, zostanie wywołana funkcja new-passfile.

      .EXAMPLE
      new-sesja -computername PC01 -user Administrator -passfile .\AdmPass.txt
      Otwiera PSsesję z PC01

      .EXAMPLE
      Get-content .\Serwery.txt | new-sesja -user Administrator
      Otwiera sesje z serwerami wymienionymi w pliku tekstowym.

      .NOTES
      Autor: piotrbanas@xper.pl
      Część modułu PBFunkcje.
    
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
    #    Return $sesje
  } # End End
} # End function
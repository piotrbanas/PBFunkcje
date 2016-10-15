<#
.Synopsis
   Wysyłanie e-maili ze skryptów.
.DESCRIPTION
   Wysyłanie email bez uwierzytelniania SMTP, a więc tylko pomiędzy kontami tego samego serwera pocztowego.
   Nadawca nie może być listą mailingową.
.EXAMPLE
   send-smtp -nadawca 'konto@mail.pl' -odbiorca 'konto2@mail.pl', 'konto3@mail.pl' -temat 'Tytuł' -tresc 'Treść maila' -serwerSMTP 'smtp.mail.pl'
 .NOTES
   Kontakt: piotrbanas@xper.pl
   Część modułu PBFunkcje. Aktualna wersja zawsze w github.com/piotrbanas
#>

function send-smtp
{
[CmdletBinding()]
  PARAM(
        [string]
        $SerwerSMTP = 'smtp.domain.com',
        
        [Parameter(
        mandatory)]
        [string]$nadawca,
        
        [Parameter(
        mandatory)]
        [string[]]$odbiorca,
        
        [string]$temat = 'Wysłane z funkcji send-smtp',
        
        [Parameter]
        [string]$tresc = 'Wiadomość testowa'

  ) # End param
foreach ($adres in $odbiorca){
    $smtp = New-Object Net.Mail.SmtpClient("$SerwerSMTP")
    $smtp.Send("$nadawca","$adres","$temat","$tresc")
    } # End foreach
} # end function

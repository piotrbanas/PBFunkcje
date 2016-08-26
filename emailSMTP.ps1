<#
.Synopsis
   Wysyłanie e-maili ze skryptów.
.DESCRIPTION
   Wysyłanie email bez uwierzytelniania SMTP, a więc tylko pomiędzy kontami tego samego serwera pocztowego.
   Nadawca nie może być listą mailingową.
.EXAMPLE
   send-smtp -nadawca 'konto@***REMOVED***.com.pl' -odbiorca 'konto2@***REMOVED***.com.pl', 'konto3@***REMOVED***.com.pl' -temat 'Tytuł' -tresc 'Treść maila'
 .NOTES
   Autor: p.banas@***REMOVED***.com.pl
   Część modułu SCHFunkcje. Aktualna wersja zawsze w ***REMOVED***\IT_DEV\Repo\SCHFunkcje
#>

function send-smtp
{
[CmdletBinding()]
  PARAM(
        [Parameter(
        ValueFromPipeline
        )]
        $SerwerSMTP = '***REMOVED***.home.pl',
        [Parameter(
        ValueFromPipeline,
        mandatory)]
        $nadawca,
        [Parameter(
        ValueFromPipeline,
        mandatory)]
        [string[]]$odbiorca,
        [Parameter(
        ValueFromPipeline
        )]
        $temat,
        [Parameter(
        ValueFromPipeline
        )]
        $tresc

  ) # End param
foreach ($adres in $odbiorca){
    $smtp = New-Object Net.Mail.SmtpClient("$SerwerSMTP")
    $smtp.Send("$nadawca","$adres","$temat","$tresc")
    } # End foreach
} # end function

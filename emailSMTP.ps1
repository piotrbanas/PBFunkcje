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
        $odbiorca,
        [Parameter(
        ValueFromPipeline
        )]
        $tytul,
        [Parameter(
        ValueFromPipeline
        )]
        $tresc

  ) 
$smtp = New-Object Net.Mail.SmtpClient("$SerwerSMTP")
$smtp.Send("$nadawca","$odbiorca","$tytul","$tresc")

}
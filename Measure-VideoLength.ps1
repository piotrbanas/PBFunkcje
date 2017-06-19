Function Measure-VideoLength {
[cmdletbinding()]
param (
    [ValidateScript({Test-Path $_ -PathType ‘Container’})]
    $path = "$env:USERPROFILE\Videos"
)

$folders = Get-ChildItem $path -Directory -Recurse

$globalduration = [timespan]0
Foreach ($subfolder in (Get-ChildItem $path -Directory -Recurse).FullName) {
    $totalduration = [timespan]0
    $shell = New-Object -COMObject Shell.Application
    $shellfolder = $shell.Namespace($subfolder)

        foreach($file in (Get-ChildItem $subfolder -filter "*.mp4"))
        {
            $shellfile = $shellfolder.ParseName($file.Name)
            $totalduration = $totalduration + [timespan]$shellfolder.GetDetailsOf($shellfile, 27);
        }
    Write-Verbose "Videos in $subfolder are $total_duration long"
    $globalduration += $totalduration
}
Write-Verbose "Videos in $path and all it's subfolders are $globalduration long"
$globalduration
}
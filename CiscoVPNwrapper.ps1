Function Invoke-CiscoVPN {
	<#
	.SYNOPSIS
	Establish a VPN connection using vpncli.

	.DESCRIPTION
	Wrapper for Cisco AnyConnect Secure Mobility Client. Optionally uses two-factor authentication.
	Will ask for password on first run.

	.PARAMETER Operation
	'connect', 'disconnect', 'state', 'stats'
	.PARAMETER user

	.PARAMETER vpn

	.PARAMETER 2FA
	Two-factor Authentication
	.EXAMPLE
	Invoke-CiscoVPN -user vpnuser -gateway hostname.domain.org -2FA

	.EXAMPLE
	Invoke-CiscoVPN state

	.NOTES
	Contact: piotrbanas@xper.pl
	#>
	[Cmdletbinding()]
	param
	(
	[Parameter(Position = 0)]
	[ValidateSet('connect', 'disconnect', 'state', 'stats')]
	[String]$Operation = 'connect',

	[Parameter()]
	[String]$User = "$env:USERNAME",

	[Parameter()]
	[switch]$2FA,

	[Parameter()]
	[Alias('ComputerName', 'Hostname', 'Address', 'Gateway', 'Server')]
	[ValidateSet('vpn-emea.xper.pl', 'vpn-am1.xper.pl')]
	[String]$vpn = 'vpn-emea.xper.pl'
	)

	Write-Verbose "Closing graphical client"
	Get-Process vpnui -ErrorAction SilentlyContinue | Stop-Process -force

	If ($Operation -eq 'connect') {
		Write-Verbose "Gathering credentials"
		$passfile = Join-Path (Split-Path $profile) VPN$user.txt
		if (!(Test-Path $passfile)) {
			Write-Verbose "Secure pass file not found"
			Read-Host "Enter password for VPN $user" -AsSecureString | ConvertFrom-SecureString | Out-File "$passfile"
		}

		$pass = Get-Content -path $passfile | ConvertTo-SecureString
		$cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $user, $pass

		Write-Verbose "constructing vpncli input options"
		$s = "connect $vpn" | out-string
		$s += "$user" | Out-String
		$s += $cred.GetNetworkCredential().password | Out-String
		If ($2FA) {
			$s += 'push' | Out-String
		}
		$s += 'y' | Out-String

		Write-Verbose "Calling cli exe"
		$s  | &"c:\Program Files (x86)\Cisco\Cisco AnyConnect Secure Mobility Client\vpncli.exe" -s | out-null

		# cleanup
		$s = $null
	}

	Else {
		 &"c:\Program Files (x86)\Cisco\Cisco AnyConnect Secure Mobility Client\vpncli.exe" $Operation.ToLower()
	}
}

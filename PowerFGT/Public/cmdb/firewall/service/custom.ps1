#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
# Copyright 2019, Benjamin Perrier <ben dot perrier at outlook dot com>
#
# SPDX-License-Identifier: Apache-2.0
#
function Get-FGTFirewallServiceCustom {

	<#
        .SYNOPSIS
        Get list of all "services"

        .DESCRIPTION
        Get list of all "services" (SMTP, HTTP, HTTPS, DNS...)

        .EXAMPLE
        Get-FGTFirewallServiceCustom

        Get list of all services object

        .EXAMPLE
        Get-FGTFirewallServiceCustom -name myFirewallServiceCustom

        Get services object named myFirewallServiceCustom

        .EXAMPLE
        Get-FGTFirewallServiceCustom -name FGT -filter_type contains

        Get services object contains with *FGT*

        .EXAMPLE
        Get-FGTFirewallServiceCustom -skip

        Get list of all services object (but only relevant attributes)

        .EXAMPLE
        Get-FGTFirewallServiceCustom -vdom vdomX

        Get list of all services object on vdomX

    #>

	[CmdletBinding(DefaultParameterSetName = "default")]
	Param(
		[Parameter (Mandatory = $false, Position = 1, ParameterSetName = "name")]
		[string]$name,
		[Parameter (Mandatory = $false)]
		[Parameter (ParameterSetName = "filter")]
		[string]$filter_attribute,
		[Parameter (Mandatory = $false)]
		[Parameter (ParameterSetName = "name")]
		[Parameter (ParameterSetName = "filter")]
		[ValidateSet('equal', 'contains')]
		[string]$filter_type = "equal",
		[Parameter (Mandatory = $false)]
		[Parameter (ParameterSetName = "filter")]
		[psobject]$filter_value,
		[Parameter(Mandatory = $false)]
		[switch]$skip,
		[Parameter(Mandatory = $false)]
		[String[]]$vdom,
		[Parameter(Mandatory = $false)]
		[psobject]$connection = $DefaultFGTConnection
	)

	Begin {
	}

	Process {

		Write-Output $DefaultFGTConnection.headers

		$invokeParams = @{ }
		if ( $PsBoundParameters.ContainsKey('skip') ) {
			$invokeParams.add( 'skip', $skip )
		}
		if ( $PsBoundParameters.ContainsKey('vdom') ) {
			$invokeParams.add( 'vdom', $vdom )
		}

		#Filtering
		switch ( $PSCmdlet.ParameterSetName ) {
			"name" {
				$filter_value = $name
				$filter_attribute = "name"
			}
			default { }
		}

		#if filter value and filter_attribute, add filter (by default filter_type is equal)
		if ( $filter_value -and $filter_attribute ) {
			$invokeParams.add( 'filter_value', $filter_value )
			$invokeParams.add( 'filter_attribute', $filter_attribute )
			$invokeParams.add( 'filter_type', $filter_type )
		}

		$response = Invoke-FGTRestMethod -uri 'api/v2/cmdb/firewall.service/custom' -method 'GET' -connection $connection @invokeParams
		$response.results
	}

	End {
	}
}

function Add-FGTFirewallServiceCustom {

	<#
	.SYNOPSIS
		Add a FortiGate service object
	.DESCRIPTION
		Add a Fortigate service object (tcp/udp/sctp, ip, icmp)
	.NOTES
		This function is only testet on FortiOS 7.2.3

	.EXAMPLE
		Add-FGTFirewallServiceCustom -Name MyHTTP protocolType tcp/udp/sctp -protocol tcp -startPort 80 -comment "default http port"

		Add service object with protocol type TCP/UDP/SCTP and destination port tcp/80 with the service object name MyHttp and the comment default http port
	.EXAMPLE
		Add-FGTFirewallServiceCustom -Name MyFTP protocolType tcp/udp/sctp -protocol tcp -startPort 20 -endPort 21 -comment "default ftp port range"

		Add service object with protocol type TCP/UDP/SCTP and destination port range from tcp/20 to tcp/21 with the service object name MyFTP and the comment default ftp port range
	.EXAMPLE
		Add-FGTFirewallServiceCustom -Name MyPING protocolType icmp -icmpType 8 -icmpCode 0 -comment "service object for ping"

		Add service object with protocol type ICMP and ICMP type 8 (echo request), ICMP code 0 and the commect service object for ping
	.EXAMPLE
		Add-FGTFirewallServiceCustom -Name MyTCP protocolType ip -protocolNumber 6 -comment "default protocol number for tcp"

		Add service object with protocol type ip, protocol number 6 (tcp) and the commect default protocol number for tcp
	#>



	[CmdletBinding(DefaultParameterSetName = "tcp/udp/sctp")]
	param (
		[Parameter (Mandatory = $true, Position = 0)]
		[string]$name,

		# Parameter help description
		[Parameter(Mandatory = $true)]
		[ValidateSet("tcp/udp/sctp", "icmp", "ip")]
		[string]$protocolType = "tcp/udp/sctp",

		# Parameter help description
		[Parameter(Mandatory = $true, ParameterSetName = "tcp/udp/sctp")]
		[ValidateSet("tcp", "udp", "sctp")]
		[string]$protocol,

		# Parameter help description
		[Parameter(Mandatory = $true, ParameterSetName = "tcp/udp/sctp")]
		# [ValidateScript({ $protocolType -eq 'tcp/udp/sctp' })]
		[int]$startPort,

		# Parameter help description
		[Parameter(Mandatory = $false, ParameterSetName = "tcp/udp/sctp")]
		[ValidateScript({ $protocolType -eq 'tcp/udp/sctp' })]
		[int]$endPort,

		# Parameter help description
		[Parameter(ParameterSetName = "ip", Mandatory = $true)]
		[ValidateScript({ $protocolType -eq 'ip' })]
		[int]$protocolNumber,

		# Parameter help description
		[Parameter(ParameterSetName = "icmp", Mandatory = $true)]
		[ValidateScript({ $protocolType -eq 'icmp' })]
		[ValidateRange(0, 255)]
		[int]$icmpType,

		# Parameter help description
		[Parameter(ParameterSetName = "icmp", Mandatory = $true)]
		[ValidateScript({ $protocolType -eq 'icmp' })]
		[ValidateRange(0, 16)]
		[int]$icmpCode,

		# Parameter help description
		[Parameter(Mandatory = $false)]
		[ValidateLength(0, 255)]
		[string]$comment,

		[Parameter(Mandatory = $false)]
		[String[]]$vdom,

		[Parameter(Mandatory = $false)]
		[psobject]$connection = $DefaultFGTConnection
	)

	begin {

	}

	process {


		Write-Output $DefaultFGTConnection
		$invokeParams = @{ }

		if ( $PsBoundParameters.ContainsKey('vdom') ) {
			$invokeParams.add( 'vdom', $vdom )
		}

		$uri = "api/v2/cmdb/firewall.service/custom"

		$customService = New-Object -TypeName PSObject

		$customService | Add-Member -Name "name" -MemberType NoteProperty -Value $name

		switch ( $PSCmdlet.ParameterSetName ) {
			"tcp/udp/sctp" {
				switch ($protocol) {
					"tcp" {
						if (-not $endPort) {
							$customService | Add-Member -Name "tcp-portrange" -MemberType NoteProperty -Value $startPort
						}
						else {
							$customService | Add-Member -Name "tcp-portrange" -MemberType NoteProperty -Value "$($startPort)-$($endPort)"
						}
					}
					"udp" {
						if (-not $endPort) {
							$customService | Add-Member -Name "udp-portrange" -MemberType NoteProperty -Value $startPort
						}
						else {
							$customService | Add-Member -Name "udp-portrange" -MemberType NoteProperty -Value "$($startPort)-$($endPort)"
						}
					}
					"sctp" {
						if (-not $endPort) {
							$customService | Add-Member -Name "sctp-portrange" -MemberType NoteProperty -Value $startPort
						}
						else {
							$customService | Add-Member -Name "sctp-portrange" -MemberType NoteProperty -Value "$($startPort)-$($endPort)"
						}

					}
					Default {}
				}
			}
			"ip" {
				$customService | Add-Member -Name "protocol" -MemberType NoteProperty -Value $protocol

				$customService | Add-Member -Name "protocol-number" -MemberType NoteProperty -Value $protocolNumber

			}
			"icmp" {

				$customService | Add-Member -Name "icmpcode" -MemberType NoteProperty -Value $icmpCode

				$customService | Add-Member -Name "icmptype" -MemberType NoteProperty -Value $icmpType

			}
		}

		if ($comment) {
			$customService | Add-Member -Name "comment" -MemberType NoteProperty -Value $comment
		}


		Invoke-FGTRestMethod -method "POST" -body $customService -uri $uri -connection $connection @invokeParams | Out-Null

		Get-FGTFirewallServiceCustom -connection $connection @invokeParams -name $name
	}

	end {

	}
}
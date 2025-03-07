#
# Copyright 2021, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#
function Get-FGTLogEvent {

    <#
        .SYNOPSIS
        Get Log Event

        .DESCRIPTION
        Get Log Event (disk, fortianalyzer, memory...)

        .EXAMPLE
        Get-FGTLogEvent -type forticloud -subtype local

        Get Log Event from forticloud on subtype local

        .EXAMPLE
        Get-FGTLogEvent -type memory -subtype vpn -rows 10000

        Get Log Event from memory on subtype vpn with 10 000 rows

        .EXAMPLE
        Get-FGTLogEvent -type disk -subtype user -rows 10000 -srcip 192.0.2.1

        Get Log Event from disk on subtype user with 10 000 rows with Source IP 192.0.0.1

        .EXAMPLE
        Get-FGTLogEvent -type fortianalyzer -subtype system -rows 10000 -since 7d

        Get Log Event from fortianalyzer on subtype system with 10 000 rows since 7 day

        .EXAMPLE
        Get-FGTLogEvent -type disk -subtype vpn -rows 10000 -extra reverse_lookup

        Get Log Event from disk on subtype vpn with 10 000 rows with reverse lookup

        .EXAMPLE
        Get-FGTLogEvent -type fortianalyzer -subtype system -rows 10000 -wait 5000

        Get Log Event from fortianalyzer on subtype system with 10 000 rows and wait 5000 Milliseconds between each request

    #>

    [CmdletBinding(DefaultParameterSetName = 'default')]
    Param(
        [Parameter (Mandatory = $true, Position = 1)]
        [ValidateSet('disk', 'fortianalyzer', 'forticloud', 'memory', IgnoreCase = $false)]
        [string]$type,
        [Parameter (Mandatory = $true, Position = 2)]
        [ValidateSet('vpn', 'user', 'router', 'wireless', 'wad', 'endpoint', 'ha', 'compliance-check', 'security-rating', 'fortiextender', 'connector', 'system', IgnoreCase = $false)]
        [string]$subtype,
        [Parameter (Mandatory = $false)]
        [int]$rows = 20,
        [ValidateSet('country_id', 'reverse_lookup', IgnoreCase = $false)]
        [string[]]$extra,
        [Parameter (Mandatory = $false)]
        [ValidateSet('1h', '6h', '1d', '7d', '30d', IgnoreCase = $false)]
        [string]$since,
        [Parameter (Mandatory = $false)]
        [int]$wait = 1000,
        [Parameter (Mandatory = $false)]
        [Parameter (ParameterSetName = "filter")]
        [string]$filter_attribute,
        [Parameter (Mandatory = $false)]
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

        $invokeParams = @{ }
        if ( $PsBoundParameters.ContainsKey('skip') ) {
            $invokeParams.add( 'skip', $skip )
        }
        if ( $PsBoundParameters.ContainsKey('vdom') ) {
            $invokeParams.add( 'vdom', $vdom )
        }

        if ( $PsBoundParameters.ContainsKey('extra') -or $PsBoundParameters.ContainsKey('since')) {
            $filter = ""

            #by default, there is last 1hour of log, need to specifiy _metadata.timestamp (Unix)
            if ($since) {
                $currentime = [DateTimeOffset]::Now.ToUnixTimeMilliSeconds()
                Switch ($since) {
                    '1h' { $mtimestamp = $currentime - 3600000 }
                    '6h' { $mtimestamp = $currentime - 21600000 }
                    '1d' { $mtimestamp = $currentime - 86400000 }
                    '7d' { $mtimestamp = $currentime - 604800000 }
                    '30d' { $mtimestamp = $currentime - 2592000000 }
                }
                $filter += "_metadata.timestamp>=$mtimestamp"
            }

            #Add list of extra parameter (reverse_lookup, country_id...)
            foreach ($e in $extra) {
                $filter += "&extra=$e"
            }

            $filter = "&filter=" + $filter

            $invokeParams.add( 'extra', $filter )

        }

        #if filter value and filter_attribute, add filter (by default filter_type is equal)
        if ( $filter_value -and $filter_attribute ) {
            $invokeParams.add( 'filter_value', $filter_value )
            $invokeParams.add( 'filter_attribute', $filter_attribute )
            $invokeParams.add( 'filter_type', $filter_type )
        }

        if ($type -eq "fortianalyzer") {
            $r = $rows
            if ($rows -gt 1024) {
                $rows = 1024
            }
            $uri = "api/v2/log/${type}/event/${subtype}?rows=${rows}"
            #Add Serial Number Info
            $uri += "&serial_no=$($connection.serial)"
            $results = @()
            $i = 0
            $response = Invoke-FGTRestMethod -uri $uri -method 'GET' -connection $connection @invokeParams
            $uri += "&session_id=$($response.session_id)"
            while ($i -lt $r) {
                $uri2 = $uri + "&start=$($i)"
                $response = Invoke-FGTRestMethod -uri $uri2 -method 'GET' -connection $connection @invokeParams
                Write-Debug "start=$($i), total_lines=$($response.total_lines) completed=$($response.completed) "
                while ($response.completed -ne "100") {
                    #Wait X Milliseconds to result
                    Start-Sleep -Milliseconds $wait
                    $response = Invoke-FGTRestMethod -uri $uri2 -method 'GET' -connection $connection @invokeParams
                    Write-Debug "start=$($i), total_lines=$($response.total_lines) completed=$($response.completed) "
                }

                $i += 1024
                $results += $response.results
            }
            $results

        }
        else {
            $uri = "api/v2/log/${type}/event/${subtype}?rows=${rows}"
            $response = Invoke-FGTRestMethod -uri $uri -method 'GET' -connection $connection @invokeParams
            $response.results
        }
    }

    End {
    }
}
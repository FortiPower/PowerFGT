#
# Copyright 2021, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#
function Get-FGTLogTraffic {

    <#
        .SYNOPSIS
        Get Log Traffic

        .DESCRIPTION
        Get Log Traffic(disk, fortianalyzer, memory...)

        .EXAMPLE
        Get-FGTLogTraffic -type forticloud -subtype local

        Get Log Traffic from forticloud on subtype local

        .EXAMPLE
        Get-FGTLogTraffic -type memory -subtype forward -rows 10000

        Get Log Traffic from memory on subtype forward with 10 000 rows

        .EXAMPLE
        Get-FGTLogTraffic -type disk -subtype forward -rows 10000 -srcip 192.0.2.1

        Get Log Traffic from disk on subtype forward with 10 000 rows with Source IP 192.0.0.1

        .EXAMPLE
        Get-FGTLogTraffic -type fortianalyzer -subtype forward -rows 10000 -since 7d

        Get Log Traffic from fortianalyzer on subtype forward with 10 000 rows since 7 day

        .EXAMPLE
        Get-FGTLogTraffic -type disk -subtype forward -rows 10000 -extra reverse_lookup

        Get Log Traffic from disk on subtype forward with 10 000 rows with reverse lookup

    #>

    [CmdletBinding(DefaultParameterSetName = 'default')]
    Param(
        [Parameter (Mandatory = $true, Position = 1)]
        [ValidateSet('disk', 'fortianalyzer', 'forticloud', 'memory', IgnoreCase = $false)]
        [string]$type,
        [Parameter (Mandatory = $true, Position = 2)]
        [ValidateSet('forward', 'local', 'multicast', 'sniffer', 'fortiview', 'threat', IgnoreCase = $false)]
        [string]$subtype,
        [Parameter (Mandatory = $false)]
        [int]$rows = 20,
        [Parameter (Mandatory = $false)]
        [Parameter (ParameterSetName = "srcip")]
        [string]$srcip,
        [Parameter (Mandatory = $false)]
        [Parameter (ParameterSetName = "srcintf")]
        [string]$srcintf,
        [Parameter (Mandatory = $false)]
        [Parameter (ParameterSetName = "dstip")]
        [string]$dstip,
        [Parameter (Mandatory = $false)]
        [Parameter (ParameterSetName = "dstinf")]
        [string]$dstintf,
        [Parameter (Mandatory = $false)]
        [ValidateRange(0, 65535)]
        [Parameter (ParameterSetName = "dstport")]
        [int]$dstport,
        [Parameter (Mandatory = $false)]
        [ValidateSet('accept', 'client-rst', 'server-rst', 'close', 'ip-conn', 'timeout', IgnoreCase = $false)]
        [Parameter (ParameterSetName = "action")]
        [string]$action,
        [Parameter (Mandatory = $false)]
        [Parameter (ParameterSetName = "policyid")]
        [int]$policyid,
        [Parameter (Mandatory = $false)]
        [Parameter (ParameterSetName = "poluuid")]
        [string]$poluuid,
        [Parameter (Mandatory = $false)]
        [ValidateSet('country_id', 'reverse_lookup', IgnoreCase = $false)]
        [string[]]$extra,
        [Parameter (Mandatory = $false)]
        [ValidateSet('1h', '6h', '1d', '7d', '30d', IgnoreCase = $false)]
        [string]$since,
        [Parameter (Mandatory = $false)]
        [Parameter (ParameterSetName = "filter")]
        [string]$filter_attribute,
        [Parameter (Mandatory = $false)]
        [Parameter (ParameterSetName = "srcip")]
        [Parameter (ParameterSetName = "srcintf")]
        [Parameter (ParameterSetName = "dstip")]
        [Parameter (ParameterSetName = "dstinf")]
        [Parameter (ParameterSetName = "dstport")]
        [Parameter (ParameterSetName = "action")]
        [Parameter (ParameterSetName = "policyid")]
        [Parameter (ParameterSetName = "poluuid")]
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

        switch ( $PSCmdlet.ParameterSetName ) {
            "srcip" {
                $filter_value = $srcip
                $filter_attribute = "srcip"
            }
            "srcintf" {
                $filter_value = $srcintf
                $filter_attribute = "srcintf"
            }
            "dstip" {
                $filter_value = $dstcip
                $filter_attribute = "dstip"
            }
            "dstintf" {
                $filter_value = $dstintf
                $filter_attribute = "dstintf"
            }
            "dstport" {
                $filter_value = $dstport
                $filter_attribute = "dstport"
            }
            "action" {
                $filter_value = $action
                $filter_attribute = "action"
            }
            "policyid" {
                $filter_value = $policyid
                $filter_attribute = "policyid"
            }
            "poluuid" {
                $filter_value = $poluuid
                $filter_attribute = "poluuid"
            }
            default { }
        }

        if ( $PsBoundParameters.ContainsKey('extra') -or $PsBoundParameters.ContainsKey('since')) {
            $filter = ""

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

            foreach ($e in $extra) {
                $filter += "&extra=$e"
            }
            if ( $filter_value -and $filter_attribute ) {

                $filter_value += "&filter=" + $filter
            }
            else {
                $invokeParams.add( 'filter', $filter )
            }

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
            $uri = "api/v2/log/${type}/traffic/${subtype}?rows=${rows}"
            #Add Serial Number Info
            $uri += "&serial_no=$($connection.serial)"
            $results = @()
            $i = 0
            $response = Invoke-FGTRestMethod -uri $uri -method 'GET' -connection $connection @invokeParams
            $uri += "&session_id=$($response.session_id)"
            while ($i -lt $r) {
                $uri2 = $uri + "&start=$($i)"
                $response = Invoke-FGTRestMethod -uri $uri2 -method 'GET' -connection $connection @invokeParams
                while ($response.completed -ne "100") {
                    #Wait 1s to result
                    Start-Sleep 1
                    $response = Invoke-FGTRestMethod -uri $uri2 -method 'GET' -connection $connection @invokeParams
                }

                $i += 1024
                $results += $response.results
            }
            $results

        }
        else {
            $uri = "api/v2/log/${type}/traffic/${subtype}?rows=${rows}"
            $response = Invoke-FGTRestMethod -uri $uri -method 'GET' -connection $connection @invokeParams
            $response.results
        }
    }

    End {
    }
}
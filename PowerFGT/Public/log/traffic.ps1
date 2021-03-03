#
# Copyright 2021, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#
function Get-FGTLogTraffic {

    <#
        .SYNOPSIS
        Get System Config Backup

        .DESCRIPTION
        Get System Config Backup

        .EXAMPLE
        Get-FGTMonitorSystemConfigBackup

        Get System Config Backup

        .EXAMPLE
        Get-FGTMonitorSystemConfigBackup -skip

        Get System Config Backup (but only relevant attributes)

        .EXAMPLE
        Get-FGTMonitorSystemConfigBackup -vdom vdomX

        Get System Config Backup on vdomX
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
        [int]$rows=20,
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
        [ValidateRange(0,65535)]
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
            default { }
        }

        #if filter value and filter_attribute, add filter (by default filter_type is equal)
        if ( $filter_value -and $filter_attribute ) {
            $invokeParams.add( 'filter_value', $filter_value )
            $invokeParams.add( 'filter_attribute', $filter_attribute )
            $invokeParams.add( 'filter_type', $filter_type )
        }

        $uri = "api/v2/log/${type}/traffic/${subtype}?rows=${rows}"
        $response = Invoke-FGTRestMethod -uri $uri -method 'GET' -connection $connection @invokeParams
        $response.results
    }

    End {
    }
}
#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#
function Get-FGTLogSetting {

    <#
        .SYNOPSIS
        Get list of all syslog

        .DESCRIPTION
        Get list of all syslog settings

        .EXAMPLE
        Get-FGTLogSetting -type syslogd

        Get settings of Syslogd (1)

        .EXAMPLE
        Get-FGTLogSetting -type syslogd2 -name status

        Get status from server Syslog Setting 2

        .EXAMPLE
        Get-FGTLogSetting -type fortianalyzer

        Get FortiAnalyzer Log Settings

        .EXAMPLE
        Get-FGTLogSetting -type fortiguard

        Get FortiGuard Log Settings

        .EXAMPLE
        Get-FGTLogSetting -type disk

        Get disk Log Settings

        .EXAMPLE
        Get-FGTLogSetting -meta

        Get list of all settings object with metadata (q_...) like usage (q_ref)

        .EXAMPLE
        Get-FGTLogSetting -skip

        Get list of all settings object (but only relevant attributes)

       .EXAMPLE
        Get-FGTLogSetting -vdom vdomX

        Get list of all settings object on vdomX
    #>

    [CmdletBinding(DefaultParameterSetName = "default")]
    Param(
        [Parameter (Mandatory = $false, Position = 1, ParameterSetName = "name")]
        [string[]]$name,
        [Parameter (Mandatory = $true)]
        [ValidateSet('syslogd', 'syslogd2', 'syslogd3', 'syslog4d', 'fortianalyzer', 'fortianalyzer2', 'fortianalyzer3', 'fortianalyzer-cloud', 'fortiguard', 'disk', 'memory', IgnoreCase = $false)]
        [string]$type,
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
        [switch]$meta,
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
        if ( $PsBoundParameters.ContainsKey('meta') ) {
            $invokeParams.add( 'meta', $meta )
        }
        if ( $PsBoundParameters.ContainsKey('skip') ) {
            $invokeParams.add( 'skip', $skip )
        }
        if ( $PsBoundParameters.ContainsKey('vdom') ) {
            $invokeParams.add( 'vdom', $vdom )
        }

        #if filter value and filter_attribute, add filter (by default filter_type is equal)
        if ( $filter_value -and $filter_attribute ) {
            $invokeParams.add( 'filter_value', $filter_value )
            $invokeParams.add( 'filter_attribute', $filter_attribute )
            $invokeParams.add( 'filter_type', $filter_type )
        }

        $uri = 'api/v2/cmdb/log.' + $type + '/setting'

        $response = Invoke-FGTRestMethod -uri $uri -method 'GET' -connection $connection @invokeParams
        if ( $PsBoundParameters.ContainsKey('name') ) {
            $ls = new-Object -TypeName PSObject
            #display value to PSObject (with name and value)
            foreach ($n in $name) {
                $n = $n -replace "_", "-" # replace _ by - can be useful for search setting name
                if ($response.results.$n) {
                    $ls | Add-member -name $n -membertype NoteProperty -Value $response.results.$n
                }
            }
            $ls
        }
        else {
            $response.results
        }
    }

    End {
    }
}
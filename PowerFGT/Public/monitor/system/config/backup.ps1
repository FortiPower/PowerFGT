#
# Copyright 2022, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#
function Get-FGTMonitorSystemConfigBackup {

    <#
        .SYNOPSIS
        Get System Config Backup

        .DESCRIPTION
        Get System Config Backup

        .EXAMPLE
        Get-FGTMonitorSystemConfigBackup

        Get System Config Backup on global scope

        .EXAMPLE
        Get-FGTMonitorSystemConfigBackup -skip

        Get System Config Backup (but only relevant attributes)

        .EXAMPLE
        Get-FGTMonitorSystemConfigBackup -scope vdom -vdom vdomX

        Get System Config Backup on vdomX
    #>

    Param(
        [Parameter(Mandatory = $false)]
        [switch]$skip,
        [Parameter(Mandatory = $false)]
        [switch]$schema,
        [Parameter(Mandatory = $false)]
        [String[]]$vdom,
        [Parameter(Mandatory = $false)]
        [ValidateSet("global", "vdom")]
        [string]$scope = "global",
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
        if ( $PsBoundParameters.ContainsKey('schema') ) {
            $invokeParams.add('schema', $schema)
        }
        if ($PsBoundParameters.ContainsKey('vdom')) {
            $invokeParams.add('vdom', $vdom)
        }

        #before 7.6.x, config/backup is available with get method and using paramater
        if ($connection.version -lt "7.6.0") {
            $method = "get"
            $uri = "api/v2/monitor/system/config/backup?scope=$scope"
            $body = ""
        }
        else {
            $method = "post"
            $uri = 'api/v2/monitor/system/config/backup'
            $body = @{
                "scope" = "$scope"
            }
        }

        $response = Invoke-FGTRestMethod -uri $uri -method $method -body $body -connection $connection @invokeParams
        $response
    }

    End {
    }
}

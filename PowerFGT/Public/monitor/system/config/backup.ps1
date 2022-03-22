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

        Get System Config Backup

        .EXAMPLE
        Get-FGTMonitorSystemConfigBackup -skip

        Get System Config Backup (but only relevant attributes)

        .EXAMPLE
        Get-FGTMonitorSystemConfigBackup -vdom vdomX

        Get System Config Backup on vdomX
    #>

    Param(
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

        $uri = 'api/v2/monitor/system/config/backup?scope=global'
        $response = Invoke-FGTRestMethod -uri $uri -method 'GET' -connection $connection @invokeParams
        $response
    }

    End {
    }
}

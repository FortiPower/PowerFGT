#
# Copyright 2022, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#
function Get-FGTMonitorSystemHAPeer {

    <#
        .SYNOPSIS
        Get HA Peer

        .DESCRIPTION
        Get HA Peer Information

        .EXAMPLE
        Get-FGTMonitorSystemHAPeer

        Get HA Peer Monitor information (serial_no, priority, hostname...)

    #>

    Param(
        [Parameter (Mandatory = $false)]
        [switch]$skip,
        [Parameter(Mandatory = $false)]
        [switch]$schema,
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
            $invokeParams.add( 'schema', $schema )
        }

        #before 6.2.x, it is not available if HA is not configured
        if ($connection.version -lt "6.2.0") {
            $ha = Get-FGTSystemHA -connection $connection
            if ($ha.mode -eq "standalone") {
                Throw "You can't check HA Peer with FortiOS < 6.2.0"
            }
        }

        $uri = 'api/v2/monitor/system/ha-peer'

        $response = Invoke-FGTRestMethod -uri $uri -method 'GET' -connection $connection @invokeParams
        $response.results
    }

    End {
    }
}

function Get-FGTMonitorSystemHAChecksum {

    <#
        .SYNOPSIS
        Get HA Checksum

        .DESCRIPTION
        Get HA Checksum Information

        .EXAMPLE
        Get-FGTMonitorSystemHAChecksum

        Get HA Checksum Monitor information (checksum for global/root/all...)

    #>

    Param(
        [Parameter (Mandatory = $false)]
        [switch]$skip,
        [Parameter(Mandatory = $false)]
        [switch]$schema,
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
            $invokeParams.add( 'schema', $schema )
        }

        #before 6.2.x, it is not available if HA is not configured
        if ($connection.version -lt "6.2.0") {
            $ha = Get-FGTSystemHA -connection $connection
            if ($ha.mode -eq "standalone") {
                Throw "You can't check HA Checksum with FortiOS < 6.2.0"
            }
        }

        $uri = 'api/v2/monitor/system/ha-checksums'

        $response = Invoke-FGTRestMethod -uri $uri -method 'GET' -connection $connection @invokeParams
        $response.results
    }

    End {
    }
}

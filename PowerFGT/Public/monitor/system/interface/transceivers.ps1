#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#
function Get-FGTMonitorSystemInterfaceTransceivers {

    <#
        .SYNOPSIS
        Get Interface Transceivers

        .DESCRIPTION
        Get System Interface Transceivers (interface, type, vendor, Part Number, Serial Number)

        .EXAMPLE
        Get-FGTMonitorSystemInterfaceTransceivers

        Get System Interface Transceivers

    #>

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseSingularNouns", "")]
    Param(
        [Parameter(Mandatory = $false)]
        [String[]]$vdom,
        [ValidateSet("global", "vdom")]
        [string]$scope = "global",
        [Parameter(Mandatory = $false)]
        [psobject]$connection = $DefaultFGTConnection
    )

    Begin {
    }

    Process {

        if ( $PsBoundParameters.ContainsKey('vdom') ) {
            $invokeParams.add( 'vdom', $vdom )
        }

        $uri = "api/v2/monitor/system/interface/transceivers"

        if ($PsBoundParameters.ContainsKey('scope')) {
            $uri += "&scope=$($scope)"
        }

        $response = Invoke-FGTRestMethod -uri $uri -method 'GET' -connection $connection
        $response.results
    }

    End {
    }
}

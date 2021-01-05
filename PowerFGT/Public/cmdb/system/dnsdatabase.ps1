#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
# Copyright 2021, Jelmer Jaarsma <jelmerjaarsma at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

function Get-FGTSystemDnsDatabase {

    <#
        .SYNOPSIS
        Get DNS database entries

        .DESCRIPTION
        Show DNS datbase entries configured on the FortiGate

        .EXAMPLE
        Get-FGTSystemDnsDatabase

        Display DNS configured on the FortiGate

        .EXAMPLE
        Get-FGTSystemDnsDatabase -filter_attribute primary -filter_value 192.0.2.1

        Get System DNS datbase entries with primary (DNS) equal 192.0.2.1

        .EXAMPLE
        Get-FGTSystemDnsDatabase -filter_attribute domain -filter_value Fortinet -filter_type contains

        Get System DNS database with domain contains Fortinet

        .EXAMPLE
        Get-FGTSystemDnsDatabase -skip

        Display DNS configured on the FortiGate (but only relevant attributes)

        .EXAMPLE
        Get-FGTSystemDnsDatabase -vdom vdomX

        Display DNS database entries configured on the FortiGate on vdomX
    #>

    [CmdletBinding(DefaultParameterSetName = "default")]
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

        $response = Invoke-FGTRestMethod -uri 'api/v2/cmdb/system/dns-database' -method 'GET' -connection $connection @invokeParams
        $response.results
    }

    End {
    }
}
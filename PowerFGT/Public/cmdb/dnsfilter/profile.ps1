#
# Copyright, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#
function Get-FGTDnsfilterProfile {

    <#
        .SYNOPSIS
        Get list of all Dnsfilter Profile settings

        .DESCRIPTION
        Get list of all Dnsfilter Profile (name, sdns, ftgd-dns ...)

        .EXAMPLE
        Get-FGTDnsfilterProfile

        Get list of all settings of Dnsfilter Profile

        .EXAMPLE
        Get-FGTDnsfilterProfile -name myDnsfilterProfile

        Get Dnsfilter Profile named myDnsfilterProfile

        .EXAMPLE
        Get-FGTDnsfilterProfile -name FGT -filter_type contains

        Get Dnsfilter Profile contains with *FGT*

        .EXAMPLE
        Get-FGTDnsfilterProfile -meta

        Get list of all settings of Dnsfilter Profile with metadata (q_...) like usage (q_ref)

        .EXAMPLE
        Get-FGTDnsfilterProfile -skip

        Get list of all settings of Dnsfilter Profile (but only relevant attributes)

        .EXAMPLE
        Get-FGTDnsfilterProfile -vdom vdomX

        Get list of all settings of Dnsfilter Profile on vdomX
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

        $uri = 'api/v2/cmdb/dnsfilter/profile'

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


        $response = Invoke-FGTRestMethod -uri $uri -method 'GET' -connection $connection @invokeParams
        $response.results
    }

    End {
    }
}

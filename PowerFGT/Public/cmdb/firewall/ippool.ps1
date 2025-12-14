#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
# Copyright 2019, Benjamin Perrier <ben dot perrier at outlook dot com>
#
# SPDX-License-Identifier: Apache-2.0
#
function Get-FGTFirewallIPPool {

    <#
        .SYNOPSIS
        Get list of all (NAT) ip pool"

        .DESCRIPTION
        Get list of all (nat) ip pool"

        .EXAMPLE
        Get-FGTFirewallIPPool

        Get list of all (NAT) ip pool object

        .EXAMPLE
        Get-FGTFirewallIPPool -name myIPPool

        Get ip pool named myIPPool

        .EXAMPLE
        Get-FGTFirewallIPPool -name FGT -filter_type contains

        Get ip pool contains with *FGT*

        .EXAMPLE
        Get-FGTFirewallIPPool -meta

        Get list of all (NAT) ip pool object with metadata (q_...) like usage (q_ref)

        .EXAMPLE
        Get-FGTFirewallIPPool -skip

        Get list of all (NAT) ip pool object (but only relevant attributes)

        .EXAMPLE
        Get-FGTFirewallIPPool -schema

        Get schema of IP Pool object

       .EXAMPLE
        Get-FGTFirewallIPPool -vdom vdomX

        Get list of all (NAT) ip pool object on vdomX
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
        [switch]$schema,
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
        if ( $PsBoundParameters.ContainsKey('schema') ) {
            $invokeParams.add( 'schema', $schema )
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

        $response = Invoke-FGTRestMethod -uri 'api/v2/cmdb/firewall/ippool' -method 'GET' -connection $connection @invokeParams
        $response.results

    }

    End {
    }
}
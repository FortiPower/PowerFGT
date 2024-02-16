#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#
function Get-FGTFirewallInternetServiceName {

    <#
        .SYNOPSIS
        Get list of all Internet Service Name (ISDB)

        .DESCRIPTION
        Get list of all Internet Service Name

        .EXAMPLE
        Get-FGTFirewallInternetServiceName

        Get list of all Internet Service Name object

        .EXAMPLE
        Get-FGTFirewallInternetServiceName -name myInternetServiceName

        Get Internet Service Name named myInternetServiceName

        .EXAMPLE
        Get-FGTFirewallInternetServiceName -id 1245185

        Get Internet Service Name with id 1245185

        .EXAMPLE
        Get-FGTFirewallInternetServiceName -name Fortinet -filter_type contains

        Get Internet Service Name contains with *Fortinet*

        .EXAMPLE
        Get-FGTFirewallInternetServiceName -meta

        Get list of all Internet Service Name object with metadata (q_...) like usage (q_ref)

        .EXAMPLE
        Get-FGTFirewallInternetServiceName -skip

        Get list of all Internet Service Name object (but only relevant attributes)

       .EXAMPLE
        Get-FGTFirewallInternetServiceName -vdom vdomX

        Get list of all Internet Service Name object on vdomX
    #>

    [CmdletBinding(DefaultParameterSetName = "default")]
    Param(
        [Parameter (Mandatory = $false, Position = 1, ParameterSetName = "name")]
        [string]$name,
        [Parameter (Mandatory = $false, ParameterSetName = "id")]
        [string]$id,
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

        #no the same URI before FortiOS 6.4.x
        if ($connection.version -lt "6.4.0") {
            $uri = 'api/v2/cmdb/firewall/internet-service'
        }
        else {
            $uri = 'api/v2/cmdb/firewall/internet-service-name'
        }
        #Filtering
        switch ( $PSCmdlet.ParameterSetName ) {
            "name" {
                $filter_value = $name
                $filter_attribute = "name"
            }
            "id" {
                $filter_value = $id
                $filter_attribute = "internet-service-id"
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
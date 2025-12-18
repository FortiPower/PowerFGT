#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

function Get-FGTSystemVirtualSwitch {

    <#
        .SYNOPSIS
        Get list of Virtual Switch Settings

        .DESCRIPTION
        Get list of Virtual Switch Settings (Physical-switch, vlan, port, span...)

        .EXAMPLE
        Get-FGTSystemVirtualSwitch

        Get Virtual Switch Settings

        .EXAMPLE
        Get-FGTSystemVirtualSwitch -filter_attribute 'physical-switch' -filter_value sw0

        Get Virtual Switch with physical-switch equal sw0

        .EXAMPLE
        Get-FGTSystemVirtualSwitch -filter_attribute port -filter_value port1 -filter_type contains

        Get Virtual Switch with port contains port1

        .EXAMPLE
        Get-FGTSystemVirtualSwitch -skip

        Get Virtual Switch Settings (but only relevant attributes)

        .EXAMPLE
        Get-FGTSystemVirtualSwitch -schema

        Get schema of System Virtual Switch

        .EXAMPLE
        Get-FGTSystemVirtualSwitch -vdom vdomX

        Get Virtual Switch Settings on vdomX
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
        [Parameter(Mandatory = $false, ParameterSetName = "schema")]
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
        if ( $PsBoundParameters.ContainsKey('vdom') ) {
            $invokeParams.add( 'vdom', $vdom )
        }

        if ( $PsBoundParameters.ContainsKey('schema') ) {
            $invokeParams.add( 'extra', "&action=schema" )
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

        #with 5.2.x, it is a olds uri
        if ($connection.version -le [version]"5.2.15") {
            $uri = 'api/v2/cmdb/system/switch-interface'
        }
        else {
            $uri = 'api/v2/cmdb/system/virtual-switch'
        }

        $response = Invoke-FGTRestMethod -uri $uri -method 'GET' -connection $connection @invokeParams
        $response.results
    }

    End {
    }
}
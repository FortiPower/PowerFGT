#Get-FGTUserTACACS
# Copyright 2024, Cédric Moreau <moreaucedric0 at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

function Get-FGTUserTACACS {

    <#
        .SYNOPSIS
        Get list of all TACACS servers

        .DESCRIPTION
        Get list of all TACACS servers

        .EXAMPLE
        Get-FGTUserTACACS

        Display all TACACS servers

        .EXAMPLE
        Get-FGTUserTACACS -name FGT -filter_type contains

        Get TACACS servers that contains *FGT*

        .EXAMPLE
        Get-FGTUserTACACS -meta

        Display all TACACS servers with metadata (q_...) like usage (q_ref)

        .EXAMPLE
        Get-FGTUserTACACS -skip

        Display all TACACS servers (but only relevant attributes)

        .EXAMPLE
        Get-FGTUserTACACS -vdom vdomX

        Display all TACACS servers on vdomX
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

        $reponse = Invoke-FGTRestMethod -uri 'api/v2/cmdb/user/tacacs+' -method 'GET' -connection $connection @invokeParams
        $reponse.results
    }

    End {
    }
}

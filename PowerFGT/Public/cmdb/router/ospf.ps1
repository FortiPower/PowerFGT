#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

function Get-FGTRouterOSPF {

    <#
        .SYNOPSIS
        Get list of all OSPF

        .DESCRIPTION
        Get list of all OSPF (area, router-id, neighbor, network...)

        .EXAMPLE
        Get-FGTRouterOSPF

        Get list of all router OSPF object

        .EXAMPLE
        Get-FGTRouterOSPF -meta

        Get list of all router OSPF object with metadata (q_...) like usage (q_ref)

        .EXAMPLE
        Get-FGTRouterOSPF -skip

        Get list of all router OSPF object (but only relevant attributes)

        .EXAMPLE
        Get-FGTRouterOSPF -schema

        Get schema of Router OSPF

        .EXAMPLE
        Get-FGTRouterOSPF -vdom vdomX

        Get list of all router OSPF object on vdomX
    #>

    [CmdletBinding(DefaultParameterSetName = "default")]
    Param(
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

        $response = Invoke-FGTRestMethod -uri 'api/v2/cmdb/router/ospf' -method 'GET' -connection $connection @invokeParams
        $response.results
    }

    End {
    }
}

function Set-FGTRouterOSPF {

    <#
        .SYNOPSIS
        Configure Router OSPF Configuration

        .DESCRIPTION
        Configure OSPF configuration (router id...)

        .EXAMPLE
        Set-FGTRouterOSPF -router_id "192.0.2.1"

        Set OSPF Router ID to 192.0.2.1

        .EXAMPLE
        $data = @{ "bfd" = "enable" }
        PS C> Set-FGTRouterOSPF -data $data

        Change bfd settings using -data parameter

    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'medium')]
    Param(
        [Parameter (Mandatory = $false)]
        [int]$as,
        [Parameter (Mandatory = $false)]
        [string]$router_id,
        [Parameter (Mandatory = $false)]
        [hashtable]$data,
        [Parameter(Mandatory = $false)]
        [String[]]$vdom,
        [Parameter(Mandatory = $false)]
        [psobject]$connection = $DefaultFGTConnection
    )

    Begin {
    }

    Process {

        $invokeParams = @{ }
        if ( $PsBoundParameters.ContainsKey('vdom') ) {
            $invokeParams.add( 'vdom', $vdom )
        }

        $_ospf = new-Object -TypeName PSObject

        if ( $PsBoundParameters.ContainsKey('router_id') ) {
            $_ospf | add-member -name "router-id" -membertype NoteProperty -Value $router_id
        }

        if ( $PsBoundParameters.ContainsKey('data') ) {
            $data.GetEnumerator() | ForEach-Object {
                $_ospf | Add-member -name $_.key -membertype NoteProperty -Value $_.value
            }
        }

        $uri = 'api/v2/cmdb/router/ospf'

        if ($PSCmdlet.ShouldProcess("OSPF", 'Configure Router OSPF')) {
            Invoke-FGTRestMethod -uri $uri -method 'PUT' -body $_ospf -connection $connection @invokeParams | Out-Null
        }

        Get-FGTRouterOSPF -connection $connection @invokeParams
    }

    End {
    }
}

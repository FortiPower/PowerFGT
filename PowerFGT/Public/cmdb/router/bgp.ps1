#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

function Get-FGTRouterBGP {

    <#
        .SYNOPSIS
        Get list of all BGP

        .DESCRIPTION
        Get list of all BGP (AS, router-id, neighbor, network...)

        .EXAMPLE
        Get-FGTRouterBGP

        Get list of all route BGP object

        .EXAMPLE
        Get-FGTRouterBGP -meta

        Get list of all route BGP object with metadata (q_...) like usage (q_ref)

        .EXAMPLE
        Get-FGTRouterBGP -skip

        Get list of all route BGP object (but only relevant attributes)

        .EXAMPLE
        Get-FGTRouterBGP -vdom vdomX

        Get list of all route BGP object on vdomX
    #>

    [CmdletBinding(DefaultParameterSetName = "default")]
    Param(
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

        $response = Invoke-FGTRestMethod -uri 'api/v2/cmdb/router/bgp' -method 'GET' -connection $connection @invokeParams
        $response.results
    }

    End {
    }
}

function Set-FGTRouterBGP {

    <#
        .SYNOPSIS
        Configure Router BGP Configuration

        .DESCRIPTION
        Configure BGP configuration (as, router id...)

        .EXAMPLE
        Set-FGTRouterBGP -as 65000 -router_id "192.0.2.1"

        Set BGP AS to 65000 and Router ID to 192.0.2.1

        .EXAMPLE
        $data = @{ "ebgp-multipath" = "enable" }
        PS C> Set-FGTRouterBGP -data $data

        Change ebgp-multipath settings using -data parameter

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

        $_bgp = new-Object -TypeName PSObject

        if ( $PsBoundParameters.ContainsKey('as') ) {
            $_bgp | add-member -name "as" -membertype NoteProperty -Value $as
        }

        if ( $PsBoundParameters.ContainsKey('router_id') ) {
            $_bgp | add-member -name "router-id" -membertype NoteProperty -Value $router_id
        }

        if ( $PsBoundParameters.ContainsKey('data') ) {
            $data.GetEnumerator() | ForEach-Object {
                $_bgp | Add-member -name $_.key -membertype NoteProperty -Value $_.value
            }
        }

        $uri = 'api/v2/cmdb/router/bgp'

        if ($PSCmdlet.ShouldProcess("BGP", 'Configure Router BGP')) {
            Invoke-FGTRestMethod -uri $uri -method 'PUT' -body $_bgp -connection $connection @invokeParams | Out-Null
        }

        Get-FGTRouterBGP -connection $connection @invokeParams
    }

    End {
    }
}
#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#


function Get-FGTVpnIpsecPhase2Interface {

    <#
        .SYNOPSIS
        Get list of all VPN IPsec phase 2 (IKE) settings

        .DESCRIPTION
        Get list of all VPN IPsec phase 2 (Local / Remote Network PFS, Cipher, Hash...)

        .EXAMPLE
        Get-FGTVpnIPsecPhase2Interface

        Get list of all settings of VPN IPsec Phase 2 interface

        .EXAMPLE
        Get-FGTVpnIPsecPhase2Interface -skip

        Get list of all settings of VPN IPsec Phase 2 interface (but only relevant attributes)

        .EXAMPLE
        Get-FGTVpnIPsecPhase2Interface -vdom vdomX

        Get list of all settings of VPN IPsec Phase 2 interface on vdomX
    #>

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

        $response = Invoke-FGTRestMethod -uri 'api/v2/cmdb/vpn.ipsec/phase2-interface' -method 'GET' -connection $connection @invokeParams
        $response.results
    }

    End {
    }
}

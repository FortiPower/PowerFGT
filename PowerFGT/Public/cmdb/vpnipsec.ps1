#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#
function Get-FGTVpnIpsecPhase1Interface {

    <#
        .SYNOPSIS
        Get list of all VPN IPsec phase 1 (ISAKMP) settings

        .DESCRIPTION
        Get list of all VPN IPsec phase 1 (name, IP Address, description, pre shared key ...)

        .EXAMPLE
        Get-FGTVpnIPsecPhase1Interface

        Get list of all settings of VPN IPsec Phase 1 interface

    #>

    Begin {
    }

    Process {

        $invokeParams = @{ }
        if ( $PsBoundParameters.ContainsKey('skip') ) {
            $invokeParams.add( 'skip', $skip )
        }

        $response = Invoke-FGTRestMethod -uri 'api/v2/cmdb/vpn.ipsec/phase1-interface' -method 'GET' @invokeParams
        $response.results
    }

    End {
    }
}



function Get-FGTVpnIpsecPhase2Interface {

    <#
        .SYNOPSIS
        Get list of all VPN IPsec phase 2 (IKE) settings

        .DESCRIPTION
        Get list of all VPN IPsec phase 2 (Local / Remote Network PFS, Cipher, Hash...)

        .EXAMPLE
        Get-FGTVpnIPsecPhase2Interface

        Get list of all settings of VPN IPsec Phase 2 interface

    #>

    Begin {
    }

    Process {
        $response = Invoke-FGTRestMethod -uri 'api/v2/cmdb/vpn.ipsec/phase2-interface' -method 'GET'
        $response.results
    }

    End {
    }
}

#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#
function Get-FGTVpnIpsecPhase1 {

    <#
      .SYNOPSIS
      Get list of all VPN IPsec phase 1 (ISAKMP) settings

      .DESCRIPTION
      Get list of all VPN IPsec phase 1 (name, IP Address, description, pre shared key ...)

      .EXAMPLE
      Get-FGTVpnIPsecPhase1

      Get list of all settings of VPN IPsec Phase 1

    #>


    $response = Invoke-FGTRestMethod -uri 'api/v2/cmdb/vpn.ipsec/phase1' -method 'GET'
    $response.results
}

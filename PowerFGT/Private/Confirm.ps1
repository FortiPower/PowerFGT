
#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#
# Contribution by Brett Pound <brett underscore pound at hotmail dot com>, March 2020
#
Function Confirm-FGTAddress {

    Param (
        [Parameter (Mandatory = $true)]
        [object]$argument
    )

    #Check if it looks like an Address element

    if ( -not ( $argument | get-member -name name -Membertype Properties)) {
        throw "Element specified does not contain a name property."
    }
    if ( -not ( $argument | get-member -name uuid -Membertype Properties)) {
        throw "Element specified does not contain an uuid property."
    }
    if ( -not ( $argument | get-member -name type -Membertype Properties)) {
        throw "Element specified does not contain a type property."
    }
    if ( -not ( $argument | get-member -name country -Membertype Properties)) {
        throw "Element specified does not contain a country property."
    }

    $true

}

Function Confirm-FGTAddressGroup {

    Param (
        [Parameter (Mandatory = $true)]
        [object]$argument
    )

    #Check if it looks like an Address element

    if ( -not ( $argument | get-member -name name -Membertype Properties)) {
        throw "Element specified does not contain a name property."
    }
    if ( -not ( $argument | get-member -name uuid -Membertype Properties)) {
        throw "Element specified does not contain an uuid property."
    }
    if ( -not ( $argument | get-member -name member -Membertype Properties)) {
        throw "Element specified does not contain a member property."
    }
    if ( -not ( $argument | get-member -name comment -Membertype Properties)) {
        throw "Element specified does not contain a comment property."
    }

    $true

}

Function Confirm-FGTProxyAddress {

    Param (
        [Parameter (Mandatory = $true)]
        [object]$argument
    )

    #Check if it looks like an ProxyAddress element

    if ( -not ( $argument | get-member -name name -Membertype Properties)) {
        throw "Element specified does not contain a name property."
    }
    if ( -not ( $argument | get-member -name uuid -Membertype Properties)) {
        throw "Element specified does not contain an uuid property."
    }
    if ( -not ( $argument | get-member -name host -Membertype Properties)) {
        throw "Element specified does not contain an host property."
    }
    if ( -not ( $argument | get-member -name category -Membertype Properties)) {
        throw "Element specified does not contain a category property."
    }
    if ( -not ( $argument | get-member -name method -Membertype Properties)) {
        throw "Element specified does not contain a method property."
    }
    if ( -not ( $argument | get-member -name ua -Membertype Properties)) {
        throw "Element specified does not contain an ua property."
    }

    $true

}

Function Confirm-FGTProxyAddressGroup {

    Param (
        [Parameter (Mandatory = $true)]
        [object]$argument
    )

    #Check if it looks like an ProxyAddress Group element

    if ( -not ( $argument | get-member -name name -Membertype Properties)) {
        throw "Element specified does not contain a name property."
    }
    if ( -not ( $argument | get-member -name uuid -Membertype Properties)) {
        throw "Element specified does not contain an uuid property."
    }
    if ( -not ( $argument | get-member -name member -Membertype Properties)) {
        throw "Element specified does not contain a member property."
    }
    if ( -not ( $argument | get-member -name comment -Membertype Properties)) {
        throw "Element specified does not contain a comment property."
    }

    $true

}

Function Confirm-FGTRouterStatic {

    Param (
        [Parameter (Mandatory = $true)]
        [object]$argument
    )

    if ( -not ( $argument | get-member -name seq-num -Membertype Properties)) {
        throw "Element specified does not contain a seq-num property."
    }
    if ( -not ( $argument | get-member -name status -Membertype Properties)) {
        throw "Element specified does not contain a status property."
    }
    if ( -not ( $argument | get-member -name dst -Membertype Properties)) {
        throw "Element specified does not contain a dst property."
    }
    if ( -not ( $argument | get-member -name src -Membertype Properties)) {
        throw "Element specified does not contain a src property."
    }
    if ( -not ( $argument | get-member -name gateway -Membertype Properties)) {
        throw "Element specified does not contain a gateway property."
    }
    if ( -not ( $argument | get-member -name distance -Membertype Properties)) {
        throw "Element specified does not contain a distance property."
    }
    if ( -not ( $argument | get-member -name priority -Membertype Properties)) {
        throw "Element specified does not contain a priority property."
    }
    if ( -not ( $argument | get-member -name device -Membertype Properties)) {
        throw "Element specified does not contain a device property."
    }

    $true

}
Function Confirm-FGTFirewallPolicy {

    Param (
        [Parameter (Mandatory = $true)]
        [object]$argument
    )

    #Check if it looks like an Firewall Policy element

    if ( -not ( $argument | get-member -name policyid -Membertype Properties)) {
        throw "Element specified does not contain a policyid property."
    }
    if ( -not ( $argument | get-member -name name -Membertype Properties)) {
        throw "Element specified does not contain a name property."
    }
    if ( -not ( $argument | get-member -name uuid -Membertype Properties)) {
        throw "Element specified does not contain an uuid property."
    }
    if ( -not ( $argument | get-member -name srcintf -Membertype Properties)) {
        throw "Element specified does not contain a srcintf property."
    }
    if ( -not ( $argument | get-member -name dstaddr -Membertype Properties)) {
        throw "Element specified does not contain a dstaddr property."
    }
    if ( -not ( $argument | get-member -name srcaddr -Membertype Properties)) {
        throw "Element specified does not contain a srcaddr property."
    }
    if ( -not ( $argument | get-member -name dstaddr -Membertype Properties)) {
        throw "Element specified does not contain a dstaddr property."
    }
    if ( -not ( $argument | get-member -name action -Membertype Properties)) {
        throw "Element specified does not contain an action property."
    }
    if ( -not ( $argument | get-member -name status -Membertype Properties)) {
        throw "Element specified does not contain a status property."
    }

    $true

}

Function Confirm-FGTFirewallProxyPolicy {

    Param (
        [Parameter (Mandatory = $true)]
        [object]$argument
    )

    #Check if it looks like an Firewall ProxyPolicy element

    if ( -not ( $argument | get-member -name policyid -Membertype Properties)) {
        throw "Element specified does not contain a policyid property."
    }
    if ( -not ( $argument | get-member -name proxy -Membertype Properties)) {
        throw "Element specified does not contain a proxy property."
    }
    if ( -not ( $argument | get-member -name uuid -Membertype Properties)) {
        throw "Element specified does not contain an uuid property."
    }
    if ( -not ( $argument | get-member -name srcintf -Membertype Properties)) {
        throw "Element specified does not contain a srcintf property."
    }
    if ( -not ( $argument | get-member -name dstaddr -Membertype Properties)) {
        throw "Element specified does not contain a dstaddr property."
    }
    if ( -not ( $argument | get-member -name srcaddr -Membertype Properties)) {
        throw "Element specified does not contain a srcaddr property."
    }
    if ( -not ( $argument | get-member -name dstaddr -Membertype Properties)) {
        throw "Element specified does not contain a dstaddr property."
    }
    if ( -not ( $argument | get-member -name action -Membertype Properties)) {
        throw "Element specified does not contain a action property."
    }
    if ( -not ( $argument | get-member -name status -Membertype Properties)) {
        throw "Element specified does not contain a status property."
    }

    $true

}

Function Confirm-FGTVip {

    Param (
        [Parameter (Mandatory = $true)]
        [object]$argument
    )

    #Check if it looks like an VIP element

    if ( -not ( $argument | get-member -name name -Membertype Properties)) {
        throw "Element specified does not contain a name property."
    }
    if ( -not ( $argument | get-member -name uuid -Membertype Properties)) {
        throw "Element specified does not contain an uuid property."
    }
    if ( -not ( $argument | get-member -name type -Membertype Properties)) {
        throw "Element specified does not contain a type property."
    }
    if ( -not ( $argument | get-member -name extintf -Membertype Properties)) {
        throw "Element specified does not contain an extintf property."
    }
    if ( -not ( $argument | get-member -name extip -Membertype Properties)) {
        throw "Element specified does not contain an extip property."
    }
    if ( -not ( $argument | get-member -name mappedip -Membertype Properties)) {
        throw "Element specified does not contain a mappedip property."
    }

    $true

}

Function Confirm-FGTVipGroup {

    Param (
        [Parameter (Mandatory = $true)]
        [object]$argument
    )

    #Check if it looks like a VIP Group element

    if ( -not ( $argument | get-member -name name -Membertype Properties)) {
        throw "Element specified does not contain a name property."
    }
    if ( -not ( $argument | get-member -name uuid -Membertype Properties)) {
        throw "Element specified does not contain an uuid property."
    }
    if ( -not ( $argument | get-member -name member -Membertype Properties)) {
        throw "Element specified does not contain a member property."
    }

    $true
}

Function Confirm-FGTZone {

    Param (
        [Parameter (Mandatory = $true)]
        [object]$argument
    )

    #Check if it looks like an Zone element

    if ( -not ( $argument | get-member -name name -Membertype Properties)) {
        throw "Element specified does not contain a name property."
    }
    if ( -not ( $argument | get-member -name intrazone -Membertype Properties)) {
        throw "Element specified does not contain an intrazone property."
    }
    if ( -not ( $argument | get-member -name interface -Membertype Properties)) {
        throw "Element specified does not contain an interface property."
    }

    $true
}

Function Confirm-FGTInterface {

    Param (
        [Parameter (Mandatory = $true)]
        [object]$argument
    )

    #Check if it looks like an Interface element

    if ( -not ( $argument | get-member -name name -Membertype Properties)) {
        throw "Element specified does not contain a name property."
    }
    if ( -not ( $argument | get-member -name mode -Membertype Properties)) {
        throw "Element specified does not contain a mode property."
    }
    if ( -not ( $argument | get-member -name allowaccess -Membertype Properties)) {
        throw "Element specified does not contain an allowaccess property."
    }
    if ( -not ( $argument | get-member -name type -Membertype Properties)) {
        throw "Element specified does not contain a type property."
    }
    if ( -not ( $argument | get-member -name status -Membertype Properties)) {
        throw "Element specified does not contain a status property."
    }

    $true
}

Function Confirm-FGTVpnIpsecPhase1Interface {

    Param (
        [Parameter (Mandatory = $true)]
        [object]$argument
    )

    #Check if it looks like a VPN IPsec Phase 1 Interface  element

    if ( -not ( $argument | get-member -name name -Membertype Properties)) {
        throw "Element specified does not contain a name property."
    }
    if ( -not ( $argument | get-member -name type -Membertype Properties)) {
        throw "Element specified does not contain a type property."
    }
    if ( -not ( $argument | get-member -name interface -Membertype Properties)) {
        throw "Element specified does not contain an interface property."
    }
    if ( -not ( $argument | get-member -name proposal -Membertype Properties)) {
        throw "Element specified does not contain a proposal property."
    }

    $true
}

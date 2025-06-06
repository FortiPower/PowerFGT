
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

Function Confirm-FGTUserLDAP {

    Param (
        [Parameter (Mandatory = $true)]
        [object]$argument
    )

    #Check if it looks like a LDAP Server element

    if ( -not ( $argument | get-member -name name -Membertype Properties)) {
        throw "Element specified does not contain a name property."
    }
    if ( -not ( $argument | get-member -name secondary-server -Membertype Properties)) {
        throw "Element specified does not contain a secondary-server property."
    }
    if ( -not ( $argument | get-member -name tertiary-server -Membertype Properties)) {
        throw "Element specified does not contain a tertiary-server property."
    }
    if ( -not ( $argument | get-member -name server-identity-check -Membertype Properties)) {
        throw "Element specified does not contain a server-identity-check property."
    }
    if ( -not ( $argument | get-member -name source-ip -Membertype Properties)) {
        throw "Element specified does not contain a source-ip property."
    }
    if ( -not ( $argument | get-member -name cnid -Membertype Properties)) {
        throw "Element specified does not contain a cnid property."
    }
    if ( -not ( $argument | get-member -name dn -Membertype Properties)) {
        throw "Element specified does not contain a dn property."
    }
    if ( -not ( $argument | get-member -name type -Membertype Properties)) {
        throw "Element specified does not contain a type property."
    }
    if ( -not ( $argument | get-member -name username -Membertype Properties)) {
        throw "Element specified does not contain an username property."
    }
    if ( -not ( $argument | get-member -name password -Membertype Properties)) {
        throw "Element specified does not contain a password property."
    }
    if ( -not ( $argument | get-member -name secure -Membertype Properties)) {
        throw "Element specified does not contain a secure property."
    }
    if ( -not ( $argument | get-member -name port -Membertype Properties)) {
        throw "Element specified does not contain a port property."
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

Function Confirm-FGTSDNConnector {

    Param (
        [Parameter (Mandatory = $true)]
        [object]$argument
    )

    #Check if it looks like a SDN Connector element

    if ( -not ( $argument | get-member -name name -Membertype Properties)) {
        throw "Element specified does not contain a name property."
    }
    if ( -not ( $argument | get-member -name status -Membertype Properties)) {
        throw "Element specified does not contain a status property."
    }
    if ( -not ( $argument | get-member -name type -Membertype Properties)) {
        throw "Element specified does not contain a type property."
    }
    if ( -not ( $argument | get-member -name "ha-status" -Membertype Properties)) {
        throw "Element specified does not contain a ha-status property."
    }
    #if ( -not ( $argument | get-member -name "verify-certificate" -Membertype Properties)) {
    #    throw "Element specified does not contain a verify-certificate property."
    #}
    if ( -not ( $argument | get-member -name "server" -Membertype Properties)) {
        throw "Element specified does not contain a server property."
    }

    $true
}

Function Confirm-FGTServiceCustom {

    Param (
        [Parameter (Mandatory = $true)]
        [object]$argument
    )

    #Check if it looks like a Service Custom element

    if ( -not ( $argument | get-member -name name -Membertype Properties)) {
        throw "Element specified does not contain a name property."
    }
    if ( -not ( $argument | get-member -name proxy -Membertype Properties)) {
        throw "Element specified does not contain a proxy property."
    }
    if ( -not ( $argument | get-member -name category -Membertype Properties)) {
        throw "Element specified does not contain a category property."
    }
    if ( -not ( $argument | get-member -name protocol -Membertype Properties)) {
        throw "Element specified does not contain a protocol property."
    }
    if ( -not ( $argument | get-member -name session-ttl -Membertype Properties)) {
        throw "Element specified does not contain a session-ttl property."
    }

    $true

}

Function Confirm-FGTServiceGroup {

    Param (
        [Parameter (Mandatory = $true)]
        [object]$argument
    )

    #Check if it looks like a Service Group element

    if ( -not ( $argument | get-member -name name -Membertype Properties)) {
        throw "Element specified does not contain a name property."
    }
    if ( -not ( $argument | get-member -name member -Membertype Properties)) {
        throw "Element specified does not contain a member property."
    }
    if ( -not ( $argument | get-member -name comment -Membertype Properties)) {
        throw "Element specified does not contain a comment property."
    }

    $true

}

Function Confirm-FGTUserRADIUS {

    Param (
        [Parameter (Mandatory = $true)]
        [object]$argument
    )

    #Check if it looks like a RADIUS Server element

    if ( -not ( $argument | get-member -name name -Membertype Properties)) {
        throw "Element specified does not contain a name property."
    }
    if ( -not ( $argument | get-member -name server -Membertype Properties)) {
        throw "Element specified does not contain a server property."
    }
    if ( -not ( $argument | get-member -name secret -Membertype Properties)) {
        throw "Element specified does not contain a secret property."
    }
    if ( -not ( $argument | get-member -name secondary-server -Membertype Properties)) {
        throw "Element specified does not contain a secondary-server property."
    }
    if ( -not ( $argument | get-member -name secondary-secret -Membertype Properties)) {
        throw "Element specified does not contain a secondary-secret property."
    }
    if ( -not ( $argument | get-member -name tertiary-server -Membertype Properties)) {
        throw "Element specified does not contain a tertiary-server property."
    }
    if ( -not ( $argument | get-member -name tertiary-secret -Membertype Properties)) {
        throw "Element specified does not contain a tertiary-secret property."
    }
    if ( -not ( $argument | get-member -name timeout -Membertype Properties)) {
        throw "Element specified does not contain a timeout property."
    }
    if ( -not ( $argument | get-member -name nas-ip -Membertype Properties)) {
        throw "Element specified does not contain a nas-ip property."
    }
    if ( -not ( $argument | get-member -name auth-type -Membertype Properties)) {
        throw "Element specified does not contain an auth-type property."
    }

    $true
}

Function Confirm-FGTVpnIpsecPhase1Interface {

    Param (
        [Parameter (Mandatory = $true)]
        [object]$argument
    )

    #Check if it looks like a VPN IPsec Phase 1 Interface element

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

Function Confirm-FGTVpnIpsecPhase2Interface {

    Param (
        [Parameter (Mandatory = $true)]
        [object]$argument
    )

    #Check if it looks like a VPN IPsec Phase 2 Interface element

    if ( -not ( $argument | get-member -name name -Membertype Properties)) {
        throw "Element specified does not contain a name property."
    }
    if ( -not ( $argument | get-member -name phase1name -Membertype Properties)) {
        throw "Element specified does not contain a phase1name property."
    }
    if ( -not ( $argument | get-member -name src-addr-type -Membertype Properties)) {
        throw "Element specified does not contain a src-addr-type property."
    }
    if ( -not ( $argument | get-member -name dst-addr-type -Membertype Properties)) {
        throw "Element specified does not contain a dst-addr-type property."
    }

    $true
}

Function Confirm-FGTUserLocal {

    Param (
        [Parameter (Mandatory = $true)]
        [object]$argument
    )

    if ( -not ( $argument | get-member -name name -Membertype Properties)) {
        throw "Element specified does not contain a name property."
    }
    if ( -not ( $argument | get-member -name status -Membertype Properties)) {
        throw "Element specified does not contain a status property."
    }
    if ( -not ( $argument | get-member -name type -Membertype Properties)) {
        throw "Element specified does not contain a type property."
    }
    if ( -not ( $argument | get-member -name passwd -Membertype Properties)) {
        throw "Element specified does not contain a passwd property."
    }
    if ( -not ( $argument | get-member -name ldap-server -Membertype Properties)) {
        throw "Element specified does not contain a ldap-server property."
    }
    if ( -not ( $argument | get-member -name radius-server -Membertype Properties)) {
        throw "Element specified does not contain a radius-server property."
    }
    if ( -not ( $argument | get-member -name tacacs+-server -Membertype Properties)) {
        throw "Element specified does not contain a tacacs+-server property."
    }
    if ( -not ( $argument | get-member -name two-factor -Membertype Properties)) {
        throw "Element specified does not contain a two-factor property."
    }
    if ( -not ( $argument | get-member -name fortitoken -Membertype Properties)) {
        throw "Element specified does not contain a fortitoken property."
    }
    if ( -not ( $argument | get-member -name email-to -Membertype Properties)) {
        throw "Element specified does not contain an email-to property."
    }
    if ( -not ( $argument | get-member -name sms-server -Membertype Properties)) {
        throw "Element specified does not contain a sms-server property."
    }

    $true

}

Function Confirm-FGTUserTACACS {

    Param (
        [Parameter (Mandatory = $true)]
        [object]$argument
    )

    #Check if it looks like a TACACS Server element

    if ( -not ( $argument | get-member -name name -Membertype Properties)) {
        throw "Element specified does not contain a name property."
    }
    if ( -not ( $argument | get-member -name server -Membertype Properties)) {
        throw "Element specified does not contain a server property."
    }
    if ( -not ( $argument | get-member -name key -Membertype Properties)) {
        throw "Element specified does not contain a key property."
    }
    if ( -not ( $argument | get-member -name secondary-server -Membertype Properties)) {
        throw "Element specified does not contain a secondary-server property."
    }
    if ( -not ( $argument | get-member -name secondary-key -Membertype Properties)) {
        throw "Element specified does not contain a secondary-key property."
    }
    if ( -not ( $argument | get-member -name tertiary-server -Membertype Properties)) {
        throw "Element specified does not contain a tertiary-server property."
    }
    if ( -not ( $argument | get-member -name tertiary-key -Membertype Properties)) {
        throw "Element specified does not contain a tertiary-key property."
    }
    if ( -not ( $argument | get-member -name port -Membertype Properties)) {
        throw "Element specified does not contain a port property."
    }
    if ( -not ( $argument | get-member -name authorization -Membertype Properties)) {
        throw "Element specified does not contain a authorization property."
    }
    if ( -not ( $argument | get-member -name authen-type -Membertype Properties)) {
        throw "Element specified does not contain a authen-type property."
    }

    $true
}
Function Confirm-FGTUserGroup {

    Param (
        [Parameter (Mandatory = $true)]
        [object]$argument
    )

    if ( -not ( $argument | get-member -name name -Membertype Properties)) {
        throw "Element specified does not contain a name property."
    }
    if ( -not ( $argument | get-member -name id -Membertype Properties)) {
        throw "Element specified does not contain an id property."
    }
    if ( -not ( $argument | get-member -name group-type -Membertype Properties)) {
        throw "Element specified does not contain a group-type property."
    }

    $true

}
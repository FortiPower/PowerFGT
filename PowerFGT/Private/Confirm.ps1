
#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
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
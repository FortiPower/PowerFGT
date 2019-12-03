
#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#
Function ValidateFGTAddress {

    Param (
        [Parameter (Mandatory = $true)]
        [object]$argument
    )

    #Check if it looks like an Address element

    if ( -not ( $argument | get-member -name name -Membertype Properties)) {
        throw "Element specified does not contain an name property."
    }
    if ( -not ( $argument | get-member -name uuid -Membertype Properties)) {
        throw "Element specified does not contain a uuid property."
    }
    if ( -not ( $argument | get-member -name subnet -Membertype Properties)) {
        throw "Element specified does not contain an subnet property."
    }
    if ( -not ( $argument | get-member -name type -Membertype Properties)) {
        throw "Element specified does not contain an type property."
    }
    if ( -not ( $argument | get-member -name fqdn -Membertype Properties)) {
        throw "Element specified does not contain an fqdn property."
    }
    if ( -not ( $argument | get-member -name country -Membertype Properties)) {
        throw "Element specified does not contain an country property."
    }


    $true

}

Function ValidateFGTAddressGroup {

    Param (
        [Parameter (Mandatory = $true)]
        [object]$argument
    )

    #Check if it looks like an Address element

    if ( -not ( $argument | get-member -name name -Membertype Properties)) {
        throw "Element specified does not contain an name property."
    }
    if ( -not ( $argument | get-member -name uuid -Membertype Properties)) {
        throw "Element specified does not contain a uuid property."
    }
    if ( -not ( $argument | get-member -name member -Membertype Properties)) {
        throw "Element specified does not contain an member property."
    }
    if ( -not ( $argument | get-member -name comment -Membertype Properties)) {
        throw "Element specified does not contain an comment property."
    }
    if ( -not ( $argument | get-member -name exclude -Membertype Properties)) {
        throw "Element specified does not contain an exclude property."
    }
    if ( -not ( $argument | get-member -name exclude-member -Membertype Properties)) {
        throw "Element specified does not contain an exclude-member property."
    }

    $true

}

Function ValidateFGTVip {

    Param (
        [Parameter (Mandatory = $true)]
        [object]$argument
    )

    #Check if it looks like an VIP element

    if ( -not ( $argument | get-member -name name -Membertype Properties)) {
        throw "Element specified does not contain an name property."
    }
    if ( -not ( $argument | get-member -name uuid -Membertype Properties)) {
        throw "Element specified does not contain a uuid property."
    }
    if ( -not ( $argument | get-member -name type -Membertype Properties)) {
        throw "Element specified does not contain an type property."
    }
    if ( -not ( $argument | get-member -name extintf -Membertype Properties)) {
        throw "Element specified does not contain an extintf property."
    }
    if ( -not ( $argument | get-member -name extip -Membertype Properties)) {
        throw "Element specified does not contain an extip property."
    }
    if ( -not ( $argument | get-member -name mappedip -Membertype Properties)) {
        throw "Element specified does not contain an mappedip property."
    }

    $true

}
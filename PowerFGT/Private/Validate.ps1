
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
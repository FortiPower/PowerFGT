#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
# Copyright 2019, Benjamin Perrier <ben dot perrier at outlook dot com>
#
# SPDX-License-Identifier: Apache-2.0
#
function Add-FGTFirewallAddressGroup {

    <#
        .SYNOPSIS
        Add a FortiGate Address Group

        .DESCRIPTION
        Add a FortiGate Address Group

        .EXAMPLE
        Add-FGTFirewallAddressGroup -name MyAddressGroup -member MyAddress1

        Add Address Group with member MyAddress1

        .EXAMPLE
        Add-FGTFirewallAddressGroup -name MyAddressGroup -member MyAddress1, MyAddress2

        Add Address Group with members MyAddress1 and MyAddress2

        .EXAMPLE
        Add-FGTFirewallAddressGroup -name MyAddressGroup -member MyAddress1 -comment "My Address Group"

        Add Address Group with member MyAddress1 and a comment
    #>

    Param(
        [Parameter (Mandatory = $true)]
        [string]$name,
        [Parameter (Mandatory = $true)]
        [string[]]$member,
        [Parameter (Mandatory = $false)]
        [ValidateLength(0, 255)]
        [string]$comment,
        [Parameter (Mandatory = $false)]
        [boolean]$visibility,
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

        $uri = "api/v2/cmdb/firewall/addrgrp"

        $addrgrp = new-Object -TypeName PSObject

        $addrgrp | add-member -name "name" -membertype NoteProperty -Value $name

        #Add member to Member Array
        $members = @( )
        foreach ( $m in $member ) {
            $member_name = @{ }
            $member_name.add( 'name', $m)
            $members += $member_name
        }
        $addrgrp | add-member -name "member" -membertype NoteProperty -Value $members

        if ( $PsBoundParameters.ContainsKey('comment') ) {
            $addrgrp | add-member -name "comment" -membertype NoteProperty -Value $comment
        }

        if ( $PsBoundParameters.ContainsKey('visibility') ) {
            if ( $visibility ) {
                $addrgrp | add-member -name "visibility" -membertype NoteProperty -Value "enable"
            }
            else {
                $addrgrp | add-member -name "visibility" -membertype NoteProperty -Value "disable"
            }
        }

        Invoke-FGTRestMethod -method "POST" -body $addrgrp -uri $uri -connection $connection @invokeParams #| out-Null

        Get-FGTFirewallAddressGroup -connection $connection @invokeParams | Where-Object { $_.name -eq $name }
    }

    End {
    }
}
function Get-FGTFirewallAddressgroup {

    <#
        .SYNOPSIS
        Get addresses group configured

        .DESCRIPTION
        Show addresses group configured (Name, Member...)

        .EXAMPLE
        Get-FGTFirewallAddressgroup

        Display all addresses group.

        .EXAMPLE
        Get-FGTFirewallAddressgroup -skip

        Display all addresses group (but only relevant attributes)

        .EXAMPLE
        Get-FGTFirewallAddressgroup -vdom vdomX

        Display all addresses group on vdomX
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

        $response = Invoke-FGTRestMethod -uri 'api/v2/cmdb/firewall/addrgrp' -method 'GET' -connection $connection @invokeParams
        $response.results
    }

    End {
    }
}
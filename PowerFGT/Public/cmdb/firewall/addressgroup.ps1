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

        if ( Get-FGTFirewallAddressGroup @invokeParams -name $name -connection $connection) {
            Throw "Already an addressgroup object using the same name"
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

        Get-FGTFirewallAddressGroup -connection $connection @invokeParams -name $name
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

    [CmdletBinding(DefaultParameterSetName = "default")]
    Param(
        [Parameter (Mandatory = $false, Position = 1, ParameterSetName = "name")]
        [string]$name,
        [Parameter (Mandatory = $false, ParameterSetName = "match")]
        [string]$match,
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
        switch ( $PSCmdlet.ParameterSetName ) {
            "name" { $response.results | Where-Object { $_.name -eq $name } }
            "match" { $response.results | Where-Object { $_.name -match $match } }
            default { $response.results }
        }
    }

    End {
    }
}

function Set-FGTFirewallAddressGroup {

    <#
        .SYNOPSIS
        Configure a FortiGate Address Group

        .DESCRIPTION
        Change a FortiGate Address Group (name, member, comment...)

        .EXAMPLE
        $MyFGTAddressGroup = Get-FGTFirewallAddressGroup -name MyFGTAddressGroup
        PS C:\>$MyFGTAddressGroup | Set-FGTFirewallAddressGroup -member MyAddress1

        Change MyFGTAddressGroup member to MyAddress1

        .EXAMPLE
        $MyFGTAddressGroup = Get-FGTFirewallAddressGroup -name MyFGTAddressGroup
        PS C:\>$MyFGTAddressGroup | Set-FGTFirewallAddressGroup -member MyAddress1, MyAddress2

        Change MyFGTAddressGroup member to MyAddress1

        .EXAMPLE
        $MyFGTAddressGroup = Get-FGTFirewallAddressGroup -name MyFGTAddressGroup
        PS C:\>$MyFGTAddressGroup | Set-FGTFirewallAddressGroup -name MyFGTAddressGroup2

        Rename MyFGTAddressGroup member to MyFGTAddressGroup2

        .EXAMPLE
        $MyFGTAddressGroup = Get-FGTFirewallAddressGroup -name MyFGTAddressGroup
        PS C:\>$MyFGTAddressGroup | Set-FGTFirewallAddressGroup -visibility:$false

        Change MyFGTAddressGroup to set a new comment and disabled visibility

    #>

    Param(
        [Parameter (Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        [ValidateScript( { ValidateFGTAddressGroup $_ })]
        [psobject]$addrgrp,
        [Parameter (Mandatory = $false)]
        [string]$name,
        [Parameter (Mandatory = $false)]
        [string[]]$member,
        [Parameter (Mandatory = $false)]
        [ValidateLength(0, 255)]
        [string]$comment,
        [Parameter (Mandatory = $false)]
        [boolean]$visibility,
        [Parameter(Mandatory = $false)]
        [String[]]$vdom,
        [Parameter(Mandatory = $false)]
        [psobject]$connection=$DefaultFGTConnection
    )

    Begin {
    }

    Process {

        $invokeParams = @{ }
        if ( $PsBoundParameters.ContainsKey('vdom') ) {
            $invokeParams.add( 'vdom', $vdom )
        }

        $uri = "api/v2/cmdb/firewall/addrgrp/$($addrgrp.name)"

        $_addrgrp = new-Object -TypeName PSObject

        if ( $PsBoundParameters.ContainsKey('name') ) {
            #TODO check if there is no already a object with this name ?
            $_addrgrp | add-member -name "name" -membertype NoteProperty -Value $name
            $addrgrp.name = $name
        }

        if ( $PsBoundParameters.ContainsKey('member') ) {
            #Add member to Member Array
            $members = @( )
            foreach ( $m in $member ) {
                $member_name = @{ }
                $member_name.add( 'name', $m)
                $members += $member_name
            }
            $_addrgrp | add-member -name "member" -membertype NoteProperty -Value $members
        }

        if ( $PsBoundParameters.ContainsKey('comment') ) {
            $_addrgrp | add-member -name "comment" -membertype NoteProperty -Value $comment
        }

        if ( $PsBoundParameters.ContainsKey('visibility') ) {
            if ( $visibility ) {
                $_addrgrp | add-member -name "visibility" -membertype NoteProperty -Value "enable"
            }
            else {
                $_addrgrp | add-member -name "visibility" -membertype NoteProperty -Value "disable"
            }
        }

        Invoke-FGTRestMethod -method "PUT" -body $_addrgrp -uri $uri -connection $connection @invokeParams | out-Null

        Get-FGTFirewallAddressGroup -connection $connection @invokeParams -name $addrgrp.name
    }

    End {
    }
}
function Remove-FGTFirewallAddressGroup {

    <#
        .SYNOPSIS
        Remove a FortiGate Address

        .DESCRIPTION
        Remove an address group object on the FortiGate

        .EXAMPLE
        $MyFGTAddressGroup = Get-FGTFirewallAddressGroup -name MyFGTAddressGroup
        PS C:\>$MyFGTAddressGroup | Remove-FGTFirewallAddressGroup

        Remove address group object $MyFGTAddressGroup

        .EXAMPLE
        $MyFGTAddressGroup = Get-FGTFirewallAddressGroup -name MyFGTAddressGroup
        PS C:\>$MyFGTAddressGroup | Remove-FGTFirewallAddressGroup -noconfirm

        Remove address object $MyFGTAddressGroup with no confirmation

    #>

    Param(
        [Parameter (Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        [ValidateScript( { ValidateFGTAddressGroup $_ })]
        [psobject]$addrgrp,
        [Parameter(Mandatory = $false)]
        [switch]$noconfirm,
        [Parameter(Mandatory = $false)]
        [String[]]$vdom,
        [Parameter(Mandatory = $false)]
        [psobject]$connection=$DefaultFGTConnection
    )

    Begin {
    }

    Process {

        $invokeParams = @{ }
        if ( $PsBoundParameters.ContainsKey('vdom') ) {
            $invokeParams.add( 'vdom', $vdom )
        }

        $uri = "api/v2/cmdb/firewall/addrgrp/$($addrgrp.name)"

        if ( -not ( $Noconfirm )) {
            $message = "Remove address group on Fortigate"
            $question = "Proceed with removal of Address Group $($addrgrp.name) ?"
            $choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
            $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
            $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))

            $decision = $Host.UI.PromptForChoice($message, $question, $choices, 1)
        }
        else { $decision = 0 }
        if ($decision -eq 0) {
            Write-Progress -activity "Remove Address Group"
            $null = Invoke-FGTRestMethod -method "DELETE" -uri $uri -connection $connection @invokeParams
            Write-Progress -activity "Remove Address Group" -completed
        }
    }

    End {
    }
}
#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
# Copyright 2019, Benjamin Perrier <ben dot perrier at outlook dot com>
#
# Contribution  by Brett Pound <brett underscore pound at hotmail dot com>, March 2020
#
# SPDX-License-Identifier: Apache-2.0
#
function Add-FGTFirewallVipGroup {

    <#
        .SYNOPSIS
        Add a FortiGate VIP Group

        .DESCRIPTION
        Add a FortiGate VIP Group

        .EXAMPLE
        Add-FGTFirewallVipGroup -name MyVipGroup -member MyVip1 -interface wan1

        Add VIP Group with member MyVip1 associated to interface wan1

        .EXAMPLE
        Add-FGTFirewallVipGroup -name MyVipGroup -member MyVip1, MyVip2 -interface wan1

        Add VIP Group with members MyVip1 and MyVip2 associated to interface wan1

        .EXAMPLE
        Add-FGTFirewallVipGroup -name MyVipGroup -member MyVip1 -comment "My Address Group" -interface wan1

        Add VIP Group with member MyVip1 and a comment associated to interface wan1
    #>

    Param(
        [Parameter (Mandatory = $true)]
        [string]$name,
        [Parameter (Mandatory = $true)]
        [string[]]$member,
        [Parameter (Mandatory = $true)]
        [string[]]$interface,
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

        if ( Get-FGTFirewallVipGroup @invokeParams -name $name -connection $connection) {
            Throw "Already a VipGroup object using the same name"
        }

        $uri = "api/v2/cmdb/firewall/vipgrp"

        $vipgrp = new-Object -TypeName PSObject

        $vipgrp | add-member -name "name" -membertype NoteProperty -Value $name

        #Add member to Member Array
        $members = @( )
        foreach ( $m in $member ) {
            $member_name = @{ }
            $member_name.add( 'name', $m)
            $members += $member_name
        }
        $vipgrp | add-member -name "member" -membertype NoteProperty -Value $members

        if ( $PsBoundParameters.ContainsKey('interface') ) {
            $vipgrp | add-member -name "interface" -membertype NoteProperty -Value $interface
        }

        if ( $PsBoundParameters.ContainsKey('comment') ) {
            $vipgrp | add-member -name "comment" -membertype NoteProperty -Value $comment
        }

        if ( $PsBoundParameters.ContainsKey('visibility') ) {
            if ( $visibility ) {
                $vipgrp | add-member -name "visibility" -membertype NoteProperty -Value "enable"
            }
            else {
                $vipgrp | add-member -name "visibility" -membertype NoteProperty -Value "disable"
            }
        }

        Invoke-FGTRestMethod -method "POST" -body $vipgrp -uri $uri -connection $connection @invokeParams | Out-Null

        Get-FGTFirewallVipGroup -connection $connection @invokeParams -name $name
    }

    End {
    }
}

function Add-FGTFirewallVipGroupMember {

    <#
        .SYNOPSIS
        Add a FortiGate VIP Group Member

        .DESCRIPTION
        Add a FortiGate VIP Group Member

        .EXAMPLE
        $MyFGTVipGroup = Get-FGTFirewallVipGroup -name MyFGTVipGroup
        PS C:\>$MyFGTVipGroup | Add-FGTFirewallVipGroupMember -member MyVip1

        Add MyVip1 member to MyFGTVipGroup

        .EXAMPLE
        $MyFGTVipGroup = Get-FGTFirewallVipGroup -name MyFGTVipGroup
        PS C:\>$MyFGTVipGroup | Add-FGTFirewallVipGroupMember -member MyVip1, MyVip2

        Add MyVip1 and MyVip2 member to MyFGTVipGroup

    #>

    Param(
        [Parameter (Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        [ValidateScript( { Confirm-FGTVipGroup $_ })]
        [psobject]$vipgrp,
        [Parameter(Mandatory = $false)]
        [string[]]$member,
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

        $uri = "api/v2/cmdb/firewall/vipgrp/$($vipgrp.name)"

        $_vipgrp = new-Object -TypeName PSObject

        if ( $PsBoundParameters.ContainsKey('member') ) {
            #Add member to existing addrgrp member
            $members = $vipgrp.member
            foreach ( $m in $member ) {
                $member_name = @{ }
                $member_name.add( 'name', $m)
                $members += $member_name
            }
            $_vipgrp | add-member -name "member" -membertype NoteProperty -Value $members
        }

        Invoke-FGTRestMethod -method "PUT" -body $_vipgrp -uri $uri -connection $connection @invokeParams | out-Null

        Get-FGTFirewallVipGroup -connection $connection @invokeParams -name $vipgrp.name
    }

    End {
    }
}

function Copy-FGTFirewallVipGroup {

    <#
        .SYNOPSIS
        Copy/Clone a FortiGate VIP Group

        .DESCRIPTION
        Copy/Clone a FortiGate VIP Group (name, member...)

        .EXAMPLE
        $MyFGTVipGroup = Get-FGTFirewallVipGroup -name MyFGTVipGroup
        PS C:\>$MyFGTVipGroup | Copy-FGTFirewallVipGroup -name MyFGTVipGroup_copy

        Copy / Clone MyFGTVipGroup and name MyFGTVipGroup_copy

    #>

    Param(
        [Parameter (Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        [ValidateScript( { Confirm-FGTVipGroup $_ })]
        [psobject]$vipgrp,
        [Parameter (Mandatory = $true)]
        [string]$name,
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

        if ( Get-FGTFirewallVipGroup @invokeParams -name $name -connection $connection) {
            Throw "Already a VIP Group object using the same name"
        }

        $uri = "api/v2/cmdb/firewall/vipgrp/$($vipgrp.name)/?action=clone&nkey=$($name)"

        Invoke-FGTRestMethod -method "POST" -uri $uri -connection $connection @invokeParams | Out-Null

        Get-FGTFirewallVipGroup -connection $connection @invokeParams -name $name
    }

    End {
    }
}
function Get-FGTFirewallVipGroup {

    <#
        .SYNOPSIS
        Get VIP group(s) configured

        .DESCRIPTION
        Show VIP group(s) configured (Name, Member...)

        .EXAMPLE
        Get-FGTFirewallVipGroup

        Display all VIP groups.

        .EXAMPLE
        Get-FGTFirewallVipGroup -name myFGTVipGroup

        Get VIP Group named myFGTVipGroup

        .EXAMPLE
        Get-FGTFirewallVipGroup -name FGT -filter_type contains

        Get VIP Group(s) containing *FGT*

        .EXAMPLE
        Get-FGTFirewallVipGroup -uuid 9e73a10e-1772-51ea-a8d7-297686fd7702

        Get VIP Group with uuid 9e73a10e-1772-51ea-a8d7-297686fd7702

        .EXAMPLE
        Get-FGTFirewallVipGroup -skip

        Display all VIP groups (but only relevant attributes)

        .EXAMPLE
        Get-FGTFirewallVipGroup -vdom vdomX

        Display all VIP groups on vdomX
    #>

    [CmdletBinding(DefaultParameterSetName = "default")]
    Param(
        [Parameter (Mandatory = $false, Position = 1, ParameterSetName = "name")]
        [string]$name,
        [Parameter (Mandatory = $false, ParameterSetName = "uuid")]
        [string]$uuid,
        [Parameter (Mandatory = $false)]
        [Parameter (ParameterSetName = "filter")]
        [string]$filter_attribute,
        [Parameter (Mandatory = $false)]
        [Parameter (ParameterSetName = "name")]
        [Parameter (ParameterSetName = "uuid")]
        [Parameter (ParameterSetName = "filter")]
        [ValidateSet('equal', 'contains')]
        [string]$filter_type = "equal",
        [Parameter (Mandatory = $false)]
        [Parameter (ParameterSetName = "filter")]
        [psobject]$filter_value,
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

        #Filtering
        switch ( $PSCmdlet.ParameterSetName ) {
            "name" {
                $filter_value = $name
                $filter_attribute = "name"
            }
            "uuid" {
                $filter_value = $uuid
                $filter_attribute = "uuid"
            }
            default { }
        }

        #if filter value and filter_attribute, add filter (by default filter_type is equal)
        if ( $filter_value -and $filter_attribute ) {
            $invokeParams.add( 'filter_value', $filter_value )
            $invokeParams.add( 'filter_attribute', $filter_attribute )
            $invokeParams.add( 'filter_type', $filter_type )
        }

        $uri = "api/v2/cmdb/firewall/vipgrp"

        $response = Invoke-FGTRestMethod -uri $uri -method 'GET' -connection $connection @invokeParams

        $response.results
    }

    End {
    }
}

function Set-FGTFirewallVipGroup {

    <#
        .SYNOPSIS
        Configure a FortiGate VIP Group

        .DESCRIPTION
        Change a FortiGate VIP Group (name, member, comment...)

        .EXAMPLE
        $MyFGTVipGroup = Get-FGTFirewallVipGroup -name MyFGTVipGroup
        PS C:\>$MyFGTVipGroup | Set-FGTFirewallVipGroup -member MyVip1

        Change MyFGTVipGroup member to MyVip1

        .EXAMPLE
        $MyFGTVipGroup = Get-FGTFirewallVipGroup -name MyFGTVipGroup
        PS C:\>$MyFGTVipGroup | Set-FGTFirewallVipGroup -member MyVip1, MyVip2

        Change MyFGTVipGroup member to MyVip1 and MyVip2

        .EXAMPLE
        $MyFGTVipGroup = Get-FGTFirewallVipGroup -name MyFGTVipGroup
        PS C:\>$MyFGTVipGroup | Set-FGTFirewallVipGroup -name MyFGTVipGroup2

        Rename MyFGTVipGroup member to MyFGTVipGroup2

        .EXAMPLE
        $MyFGTVipGroup = Get-FGTFirewallVipGroup -name MyFGTVipGroup
        PS C:\>$MyFGTVipGroup | Set-FGTFirewallVipGroup -comment "invisible VIPGrp" -visibility:$false

        Change MyFGTVipGroup to set a new comment and disable visibility

    #>

    Param(
        [Parameter (Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        [ValidateScript( { Confirm-FGTVipGroup $_ })]
        [psobject]$vipgrp,
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
        [psobject]$connection = $DefaultFGTConnection
    )

    Begin {
    }

    Process {

        $invokeParams = @{ }
        if ( $PsBoundParameters.ContainsKey('vdom') ) {
            $invokeParams.add( 'vdom', $vdom )
        }

        $uri = "api/v2/cmdb/firewall/vipgrp/$($vipgrp.name)"

        $_vipgrp = new-Object -TypeName PSObject

        if ( $PsBoundParameters.ContainsKey('name') ) {
            #TODO check if there is no already a object with this name ?
            $_vipgrp | add-member -name "name" -membertype NoteProperty -Value $name
            $vipgrp.name = $name
        }

        if ( $PsBoundParameters.ContainsKey('member') ) {
            #Add member to Member Array
            $members = @( )
            foreach ( $m in $member ) {
                $member_name = @{ }
                $member_name.add( 'name', $m)
                $members += $member_name
            }
            $_vipgrp | add-member -name "member" -membertype NoteProperty -Value $members
        }

        if ( $PsBoundParameters.ContainsKey('comment') ) {
            $_vipgrp | add-member -name "comment" -membertype NoteProperty -Value $comment
        }

        if ( $PsBoundParameters.ContainsKey('visibility') ) {
            if ( $visibility ) {
                $_vipgrp | add-member -name "visibility" -membertype NoteProperty -Value "enable"
            }
            else {
                $_vipgrp | add-member -name "visibility" -membertype NoteProperty -Value "disable"
            }
        }

        Invoke-FGTRestMethod -method "PUT" -body $_vipgrp -uri $uri -connection $connection @invokeParams | out-Null

        Get-FGTFirewallVipGroup -connection $connection @invokeParams -name $vipgrp.name
    }

    End {
    }
}
function Remove-FGTFirewallVipGroup {

    <#
        .SYNOPSIS
        Remove a FortiGate VIP Group

        .DESCRIPTION
        Remove a VIP Group object on the FortiGate

        .EXAMPLE
        $MyFGTVipGroup = Get-FGTFirewallVipGroup -name MyFGTVipGroup
        PS C:\>$MyFGTVipGroup | Remove-FGTFirewallVipGroup

        Remove VIP Group object MyFGTVipGroup

        .EXAMPLE
        $MyFGTVipGroup = Get-FGTFirewallVipGroup -name MyFGTVipGroup
        PS C:\>$MyFGTVipGroup | Remove-FGTFirewallVipGroup -noconfirm

        Remove address object MyFGTAddressGroup with no confirmation

    #>

    Param(
        [Parameter (Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        [ValidateScript( { Confirm-FGTVipGroup $_ })]
        [psobject]$vipgrp,
        [Parameter(Mandatory = $false)]
        [switch]$noconfirm,
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

        $uri = "api/v2/cmdb/firewall/vipgrp/$($vipgrp.name)"

        if ( -not ( $Noconfirm )) {
            $message = "Remove VIP Group on Fortigate"
            $question = "Proceed with removal of VIP Group $($vipgrp.name) ?"
            $choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
            $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
            $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))

            $decision = $Host.UI.PromptForChoice($message, $question, $choices, 1)
        }
        else { $decision = 0 }
        if ($decision -eq 0) {
            Write-Progress -activity "Remove VIP Group"
            $null = Invoke-FGTRestMethod -method "DELETE" -uri $uri -connection $connection @invokeParams
            Write-Progress -activity "Remove VIP Group" -completed
        }
    }

    End {
    }
}

function Remove-FGTFirewallVipGroupMember {

    <#
        .SYNOPSIS
        Remove a FortiGate VIP Group Member

        .DESCRIPTION
        Remove a FortiGate VIP Group Member

        .EXAMPLE
        $MyFGTVipGroup = Get-FGTFirewallVipGroup -name MyFGTVipGroup
        PS C:\>$MyFGTVipGroup | Remove-FGTFirewallVipGroupMember -member MyVip1

        Remove MyVip1 member from MyFGTVipGroup

        .EXAMPLE
        $MyFGTVipGroup = Get-FGTFirewallVipGroup -name MyFGTVipGroup
        PS C:\>$MyFGTVipGroup | Remove-FGTFirewallVipGroupMember -member MyVip1, MyVip2

        Remove MyVip1 and MyVip2 member from MyFGTVipGroup

    #>

    Param(
        [Parameter (Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        [ValidateScript( { Confirm-FGTVipGroup $_ })]
        [psobject]$Vipgrp,
        [Parameter(Mandatory = $false)]
        [string[]]$member,
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

        $uri = "api/v2/cmdb/firewall/vipgrp/$($vipgrp.name)"

        $_vipgrp = new-Object -TypeName PSObject

        if ( $PsBoundParameters.ContainsKey('member') ) {
            #Create a new array
            $members = @()
            foreach ($m in $vipgrp.member) {
                $member_name = @{ }
                $member_name.add( 'name', $m.name)
                $members += $member_name
            }

            #Remove member
            foreach ($remove_member in $member) {
                #May be a better (and faster) solution...
                $members = $members | Where-Object { $_.name -ne $remove_member }
            }

            #check if there is always a member... (it is not possible don't have member on Address Group)
            if ( $members.count -eq 0 ) {
                Throw "You can't remove all members. Use Remove-FGTFirewallVipGroup to remove VIP Group"
            }

            $_vipgrp | add-member -name "member" -membertype NoteProperty -Value $members
        }

        Invoke-FGTRestMethod -method "PUT" -body $_vipgrp -uri $uri -connection $connection @invokeParams | Out-Null

        Get-FGTFirewallVipGroup -connection $connection @invokeParams -name $vipgrp.name
    }

    End {
    }
}

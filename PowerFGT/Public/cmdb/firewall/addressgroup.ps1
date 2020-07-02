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
            #with 6.4.x, there is no longer visibility parameter
            if ($connection.version -ge "6.4.0") {
                Write-Warning "-visibility parameter is not longer available with FortiOS 6.4.x and after"
            }
            else {
                if ( $visibility ) {
                    $addrgrp | add-member -name "visibility" -membertype NoteProperty -Value "enable"
                }
                else {
                    $addrgrp | add-member -name "visibility" -membertype NoteProperty -Value "disable"
                }
            }
        }

        Invoke-FGTRestMethod -method "POST" -body $addrgrp -uri $uri -connection $connection @invokeParams | Out-Null

        Get-FGTFirewallAddressGroup -connection $connection @invokeParams -name $name
    }

    End {
    }
}

function Add-FGTFirewallAddressGroupMember {

    <#
        .SYNOPSIS
        Add a FortiGate Address Group Member

        .DESCRIPTION
        Add a FortiGate Address Group Member

        .EXAMPLE
        $MyFGTAddressGroup = Get-FGTFirewallAddressGroup -name MyFGTAddressGroup
        PS C:\>$MyFGTAddressGroup | Add-FGTFirewallAddressGroupMember -member MyAddress1

        Add MyAddress1 member to MyFGTAddressGroup

        .EXAMPLE
        $MyFGTAddressGroup = Get-FGTFirewallAddressGroup -name MyFGTAddressGroup
        PS C:\>$MyFGTAddressGroup | Add-FGTFirewallAddressGroupMember -member MyAddress1, MyAddress2

        Add MyAddress1 and MyAddress2 member to MyFGTAddressGroup

    #>

    Param(
        [Parameter (Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        [ValidateScript( { Confirm-FGTAddressGroup $_ })]
        [psobject]$addrgrp,
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

        $uri = "api/v2/cmdb/firewall/addrgrp/$($addrgrp.name)"

        $_addrgrp = new-Object -TypeName PSObject

        if ( $PsBoundParameters.ContainsKey('member') ) {
            #Add member to existing addrgrp member
            $members = $addrgrp.member
            foreach ( $m in $member ) {
                $member_name = @{ }
                $member_name.add( 'name', $m)
                $members += $member_name
            }
            $_addrgrp | add-member -name "member" -membertype NoteProperty -Value $members
        }

        Invoke-FGTRestMethod -method "PUT" -body $_addrgrp -uri $uri -connection $connection @invokeParams | out-Null

        Get-FGTFirewallAddressGroup -connection $connection @invokeParams -name $addrgrp.name
    }

    End {
    }
}

function Copy-FGTFirewallAddressGroup {

    <#
        .SYNOPSIS
        Copy/Clone a FortiGate Address Group

        .DESCRIPTION
        Copy/Clone a FortiGate Address Group (name, member...)

        .EXAMPLE
        $MyFGTAddressGroup = Get-FGTFirewallAddressGroup -name MyFGTAddressGroup
        PS C:\>$MyFGTAddressGroup | Copy-FGTFirewallAddressGroup -name MyFGTAddressGroup_copy

        Copy / Clone MyFGTAddressGroup and name MyFGTAddress_copy

    #>

    Param(
        [Parameter (Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        [ValidateScript( { Confirm-FGTAddressGroup $_ })]
        [psobject]$addrgrp,
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

        if ( Get-FGTFirewallAddressGroup @invokeParams -name $name -connection $connection) {
            Throw "Already an Address Group object using the same name"
        }

        $uri = "api/v2/cmdb/firewall/addrgrp/$($addrgrp.name)/?action=clone&nkey=$($name)"

        Invoke-FGTRestMethod -method "POST" -uri $uri -connection $connection @invokeParams | Out-Null

        Get-FGTFirewallAddressGroup -connection $connection @invokeParams -name $name
    }

    End {
    }
}
function Get-FGTFirewallAddressGroup {

    <#
        .SYNOPSIS
        Get addresses group configured

        .DESCRIPTION
        Show addresses group configured (Name, Member...)

        .EXAMPLE
        Get-FGTFirewallAddressGroup

        Display all addresses group.

        .EXAMPLE
        Get-FGTFirewallAddressGroup -name myFGTAddressGroup

        Get  Address Group named myFGTAddressGroup

        .EXAMPLE
        Get-FGTFirewallAddressGroup -name FGT -filter_type contains

        Get  Address Group contains *FGT*

        .EXAMPLE
        Get-FGTFirewallAddressGroup -uuid 9e73a10e-1772-51ea-a8d7-297686fd7702

        Get Address Group with uuid 9e73a10e-1772-51ea-a8d7-297686fd7702

        .EXAMPLE
        Get-FGTFirewallAddressGroup -skip

        Display all addresses group (but only relevant attributes)

        .EXAMPLE
        Get-FGTFirewallAddressGroup -vdom vdomX

        Display all addresses group on vdomX
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

        $response = Invoke-FGTRestMethod -uri 'api/v2/cmdb/firewall/addrgrp' -method 'GET' -connection $connection @invokeParams

        $response.results
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

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'medium')]
    Param(
        [Parameter (Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        [ValidateScript( { Confirm-FGTAddressGroup $_ })]
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
        [psobject]$connection = $DefaultFGTConnection
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
            #with 6.4.x, there is no longer visibility parameter
            if ($connection.version -ge "6.4.0") {
                Write-Warning "-visibility parameter is not longer available with FortiOS 6.4.x and after"
            }
            else {
                if ( $visibility ) {
                    $_addrgrp | add-member -name "visibility" -membertype NoteProperty -Value "enable"
                }
                else {
                    $_addrgrp | add-member -name "visibility" -membertype NoteProperty -Value "disable"
                }
            }
        }

        if ($PSCmdlet.ShouldProcess($addrgrp.name, 'Configure Firewall Address Group')) {
            Invoke-FGTRestMethod -method "PUT" -body $_addrgrp -uri $uri -connection $connection @invokeParams | out-Null

            Get-FGTFirewallAddressGroup -connection $connection @invokeParams -name $addrgrp.name
        }
    }

    End {
    }
}
function Remove-FGTFirewallAddressGroup {

    <#
        .SYNOPSIS
        Remove a FortiGate Address

        .DESCRIPTION
        Remove an Address Group object on the FortiGate

        .EXAMPLE
        $MyFGTAddressGroup = Get-FGTFirewallAddressGroup -name MyFGTAddressGroup
        PS C:\>$MyFGTAddressGroup | Remove-FGTFirewallAddressGroup

        Remove Address Group object $MyFGTAddressGroup

        .EXAMPLE
        $MyFGTAddressGroup = Get-FGTFirewallAddressGroup -name MyFGTAddressGroup
        PS C:\>$MyFGTAddressGroup | Remove-FGTFirewallAddressGroup -confirm:$false

        Remove address object $MyFGTAddressGroup with no confirmation

    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'high')]
    Param(
        [Parameter (Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        [ValidateScript( { Confirm-FGTAddressGroup $_ })]
        [psobject]$addrgrp,
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

        $uri = "api/v2/cmdb/firewall/addrgrp/$($addrgrp.name)"

        if ($PSCmdlet.ShouldProcess($addrgrp.name, 'Remove Firewall Address Group')) {
            $null = Invoke-FGTRestMethod -method "DELETE" -uri $uri -connection $connection @invokeParams
        }
    }

    End {
    }
}

function Remove-FGTFirewallAddressGroupMember {

    <#
        .SYNOPSIS
        Remove a FortiGate Address Group Member

        .DESCRIPTION
        Remove a FortiGate Address Group Member

        .EXAMPLE
        $MyFGTAddressGroup = Get-FGTFirewallAddressGroup -name MyFGTAddressGroup
        PS C:\>$MyFGTAddressGroup | Remove-FGTFirewallAddressGroupMember -member MyAddress1

        Remove MyAddress1 member to MyFGTAddressGroup

        .EXAMPLE
        $MyFGTAddressGroup = Get-FGTFirewallAddressGroup -name MyFGTAddressGroup
        PS C:\>$MyFGTAddressGroup | Remove-FGTFirewallAddressGroupMember -member MyAddress1, MyAddress2

        Remove MyAddress1 and MyAddress2 member to MyFGTAddressGroup

    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'medium')]
    Param(
        [Parameter (Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        [ValidateScript( { Confirm-FGTAddressGroup $_ })]
        [psobject]$addrgrp,
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

        $uri = "api/v2/cmdb/firewall/addrgrp/$($addrgrp.name)"

        $_addrgrp = new-Object -TypeName PSObject

        if ( $PsBoundParameters.ContainsKey('member') ) {
            #Create a new array
            $members = @()
            foreach ($m in $addrgrp.member) {
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
                Throw "You can't remove all members. Use Remove-FGTFirewallAddressGroup to remove Address Group"
            }

            #if there is only One member force to be an array
            if ( $members.count -eq 1 ) {
                $members = @($members)
            }

            $_addrgrp | add-member -name "member" -membertype NoteProperty -Value $members
        }

        if ($PSCmdlet.ShouldProcess($addrgrp.name, 'Remove Firewall Address Group Member')) {
            Invoke-FGTRestMethod -method "PUT" -body $_addrgrp -uri $uri -connection $connection @invokeParams | Out-Null

            Get-FGTFirewallAddressGroup -connection $connection @invokeParams -name $addrgrp.name
        }
    }

    End {
    }
}


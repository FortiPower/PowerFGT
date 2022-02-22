#
# Copyright 2020, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
# Copyright 2020, Arthur Heijnen <arthur dot heijnen at live dot nl>
#
# SPDX-License-Identifier: Apache-2.0
#
function Add-FGTFirewallProxyAddressGroup {

    <#
        .SYNOPSIS
        Add a FortiGate ProxyAddress Group

        .DESCRIPTION
        Add a FortiGate ProxyAddress Group

        .EXAMPLE
        Add-FGTFirewallProxyAddressGroup -type src -name MyAddressGroup -member MyAddress1

        Add ProxyAddress Group with type source and member MyAddress1 (type host-regex or method)

        .EXAMPLE
        Add-FGTFirewallProxyAddressGroup -type src -name MyAddressGroup -member MyAddress1, MyAddress2

        Add ProxyAddress Group with type source and members MyAddress1 and MyAddress2 (type host-regex or method)

        .EXAMPLE
        Add-FGTFirewallProxyAddressGroup -type dst -name MyAddressGroup -member MyAddress1 -comment "My ProxyAddress Group"

        Add ProxyAddress Group with type destination and member MyAddress1 (type path) and a comment
    #>

    Param(
        [Parameter (Mandatory = $true)]
        [ValidateSet("dst", "src")]
        [string]$type,
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

        if ( Get-FGTFirewallProxyAddressGroup @invokeParams -name $name -connection $connection) {
            Throw "Already a ProxyAddressGroup object using the same name"
        }

        $uri = "api/v2/cmdb/firewall/proxy-addrgrp"

        $addrgrp = new-Object -TypeName PSObject

        $addrgrp | add-member -name "name" -membertype NoteProperty -Value $name

        $addrgrp | add-member -name "type" -membertype NoteProperty -Value $type

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
                Write-Warning "-visibility parameter is no longer available with FortiOS 6.4.x and after"
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

        Get-FGTFirewallProxyAddressGroup -connection $connection @invokeParams -name $name
    }

    End {
    }
}

function Add-FGTFirewallProxyAddressGroupMember {

    <#
        .SYNOPSIS
        Add a FortiGate ProxyAddress Group Member

        .DESCRIPTION
        Add a FortiGate ProxyAddress Group Member

        .EXAMPLE
        $MyFGTProxyAddressGroup = Get-FGTFirewallProxyAddressGroup -name MyFGTproxyAddressGroup
        PS C:\>$MyFGTProxyAddressGroup | Add-FGTFirewallProxyAddressGroupMember -member MyAddress1

        Add MyAddress1 member to MyFGTproxyAddressGroup

        .EXAMPLE
        $MyFGTProxyAddressGroup = Get-FGTFirewallProxyAddressGroup -name MyFGTProxyAddressGroup
        PS C:\>$MyFGTProxyAddressGroup | Add-FGTFirewallProxyAddressGroupMember -member MyAddress1, MyAddress2

        Add MyAddress1 and MyAddress2 member to MyFGTProxyAddressGroup

    #>

    Param(
        [Parameter (Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        [ValidateScript( { Confirm-FGTproxyAddressGroup $_ })]
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

        $uri = "api/v2/cmdb/firewall/proxy-addrgrp/$($addrgrp.name)"

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

        Get-FGTFirewallProxyAddressGroup -connection $connection @invokeParams -name $addrgrp.name
    }

    End {
    }
}

function Copy-FGTFirewallProxyAddressGroup {

    <#
        .SYNOPSIS
        Copy/Clone a FortiGate ProxyAddress Group

        .DESCRIPTION
        Copy/Clone a FortiGate ProxyAddress Group (name, member...)

        .EXAMPLE
        $MyFGTProxyAddressGroup = Get-FGTFirewallProxyAddressGroup -name MyFGTProxyAddressGroup
        PS C:\>$MyFGTProxyAddressGroup | Copy-FGTProxyFirewallAddressGroup -name MyFGTProxyAddressGroup_copy

        Copy / Clone MyFGTproxyAddressGroup with new name MyFGTProxyAddressGroup_copy

    #>

    Param(
        [Parameter (Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        [ValidateScript( { Confirm-FGTProxyAddressGroup $_ })]
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

        if ( Get-FGTFirewallProxyAddressGroup @invokeParams -name $name -connection $connection) {
            Throw "Already a ProxyAddress Group object using the same name"
        }

        $uri = "api/v2/cmdb/firewall/proxy-addrgrp/$($addrgrp.name)/?action=clone&nkey=$($name)"

        Invoke-FGTRestMethod -method "POST" -uri $uri -connection $connection @invokeParams | Out-Null

        Get-FGTFirewallProxyAddressGroup -connection $connection @invokeParams -name $name
    }

    End {
    }
}

function Get-FGTFirewallProxyAddressGroup {

    <#
        .SYNOPSIS
        Get proxy-addresses group configured

        .DESCRIPTION
        Show proxy-addresses group configured (Name, Member...)

        .EXAMPLE
        Get-FGTFirewallProxyAddressGroup

        Display all addresses group.

        .EXAMPLE
        Get-FGTFirewallProxyAddressGroup -name myFGTProxyAddressGroup

        Get  Address Group named myFGTProxyAddressGroup

        .EXAMPLE
        Get-FGTFirewallProxyAddressGroup -name FGT -filter_type contains

        Get  Address Group contains *FGT*

        .EXAMPLE
        Get-FGTFirewallProxyAddressGroup -uuid 9e73a10e-1772-51ea-a8d7-297686fd7702

        Get Address Group with uuid 9e73a10e-1772-51ea-a8d7-297686fd7702

        .EXAMPLE
        Get-FGTFirewallProxyAddressGroup -skip

        Display all addresses group (but only relevant attributes)

        .EXAMPLE
        Get-FGTFirewallProxyAddressGroup -vdom vdomX

        Display all addresses group on vdomX
    #>

    [CmdletBinding(DefaultParameterSetName = "default")]
    Param(
        [Parameter (Mandatory = $false, Position = 1, ParameterSetName = "name")]
        [string]$name,
        [Parameter (Mandatory = $false, ParameterSetName = "uuid")]
        [string]$uuid,
        [Parameter (Mandatory = $false, ParameterSetName = "filter_build")]
        [string]$filter_attribute,
        [Parameter (Mandatory = $false, ParameterSetName = "name")]
        [Parameter (ParameterSetName = "uuid")]
        [Parameter (ParameterSetName = "filter_build")]
        [ValidateSet('equal', 'notequal', 'contains', 'notcontains', 'less', 'lessorequal', 'greater', 'greaterorequal')]
        [string]$filter_type = "equal",
        [Parameter (Mandatory = $false, ParameterSetName = "filter_build")]
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

        $response = Invoke-FGTRestMethod -uri 'api/v2/cmdb/firewall/proxy-addrgrp' -method 'GET' -connection $connection @invokeParams

        $response.results
    }

    End {
    }
}

function Set-FGTFirewallProxyAddressGroup {

    <#
        .SYNOPSIS
        Configure a FortiGate ProxyAddress Group

        .DESCRIPTION
        Change a FortiGate ProxyAddress Group (name, member, comment...)

        .EXAMPLE
        $MyFGTProxyAddressGroup = Get-FGTFirewallProxyAddressGroup -name MyFGTProxyAddressGroup
        PS C:\>$MyFGTProxyAddressGroup | Set-FGTFirewallProxyAddressGroup -member MyAddress1

        Change MyFGTProxyAddressGroup member to MyAddress1

        .EXAMPLE
        $MyFGTProxyAddressGroup = Get-FGTFirewallProxyAddressGroup -name MyFGTProxyAddressGroup
        PS C:\>$MyFGTProxyAddressGroup | Set-FGTFirewallProxyAddressGroup -member MyAddress1, MyAddress2

        Change MyFGTProxyAddressGroup member to MyAddress1

        .EXAMPLE
        $MyFGTProxyAddressGroup = Get-FGTFirewallProxyAddressGroup -name MyFGTProxyAddressGroup
        PS C:\>$MyFGTProxyAddressGroup | Set-FGTFirewallProxyAddressGroup -name MyFGTProxyAddressGroup2

        Rename MyFGTProxyAddressGroup member to MyFGTProxyAddressGroup2

        .EXAMPLE
        $MyFGTProxyAddressGroup = Get-FGTFirewallProxyAddressGroup -name MyFGTproxyAddressGroup
        PS C:\>$MyFGTProxyAddressGroup | Set-FGTFirewallProxyAddressGroup -visibility:$false

        Change MyFGTProxyAddressGroup to set a new comment and disabled visibility

    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'medium')]
    Param(
        [Parameter (Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        [ValidateScript( { Confirm-FGTProxyAddressGroup $_ })]
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

        $uri = "api/v2/cmdb/firewall/proxy-addrgrp/$($addrgrp.name)"

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
                Write-Warning "-visibility parameter is no longer available with FortiOS 6.4.x and after"
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

        if ($PSCmdlet.ShouldProcess($addrgrp.name, 'Configure Firewall Proxy Address Group')) {
            Invoke-FGTRestMethod -method "PUT" -body $_addrgrp -uri $uri -connection $connection @invokeParams | out-Null

            Get-FGTFirewallProxyAddressGroup -connection $connection @invokeParams -name $addrgrp.name
        }
    }

    End {
    }
}

function Remove-FGTFirewallProxyAddressGroup {

    <#
        .SYNOPSIS
        Remove a FortiGate ProxyAddress Group

        .DESCRIPTION
        Remove a ProxyAddress Group object on the FortiGate

        .EXAMPLE
        $MyFGTProxyAddressGroup = Get-FGTFirewallProxyAddressGroup -name MyFGTProxyAddressGroup
        PS C:\>$MyFGTProxyAddressGroup | Remove-FGTFirewallProxyAddressGroup

        Remove ProxyAddress Group object $MyFGTProxyAddressGroup

        .EXAMPLE
        $MyFGTProxyAddressGroup = Get-FGTFirewallProxyAddressGroup -name MyFGTProxyAddressGroup
        PS C:\>$MyFGTGroxyAddressGroup | Remove-FGTFirewallProxyAddressGroup -noconfirm

        Remove address object $MyFGTProxyAddressGroup with no confirmation

    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'high')]
    Param(
        [Parameter (Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        [ValidateScript( { Confirm-FGTProxyAddressGroup $_ })]
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

        $uri = "api/v2/cmdb/firewall/proxy-addrgrp/$($addrgrp.name)"

        if ($PSCmdlet.ShouldProcess($addrgrp.name, 'Remove Firewall Proxy Address Group')) {
            $null = Invoke-FGTRestMethod -method "DELETE" -uri $uri -connection $connection @invokeParams
        }
    }

    End {
    }
}

function Remove-FGTFirewallProxyAddressGroupMember {

    <#
        .SYNOPSIS
        Remove a FortiGate ProxyAddress Group Member

        .DESCRIPTION
        Remove a FortiGate ProxyAddress Group Member

        .EXAMPLE
        $MyFGTProxyAddressGroup = Get-FGTFirewallProxyAddressGroup -name MyFGTProxyAddressGroup
        PS C:\>$MyFGTProxyAddressGroup | Remove-FGTFirewallProxyAddressGroupMember -member MyAddress1

        Remove MyAddress1 member to MyFGTproxyAddressGroup

        .EXAMPLE
        $MyFGTProxyAddressGroup = Get-FGTFirewallproxyAddressGroup -name MyFGTProxyAddressGroup
        PS C:\>$MyFGTProxyAddressGroup | Remove-FGTFirewallProxyAddressGroupMember -member MyAddress1, MyAddress2

        Remove MyAddress1 and MyAddress2 member to MyFGTProxyAddressGroup

    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'medium')]
    Param(
        [Parameter (Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        [ValidateScript( { Confirm-FGTProxyAddressGroup $_ })]
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

        $uri = "api/v2/cmdb/firewall/proxy-addrgrp/$($addrgrp.name)"

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
                Throw "You can't remove all members. Use Remove-FGTFirewallProxyAddressGroup to remove Proxy Address Group"
            }

            #if there is only One member force to be an array
            if ( $members.count -eq 1 ) {
                $members = @($members)
            }

            $_addrgrp | add-member -name "member" -membertype NoteProperty -Value $members
        }

        if ($PSCmdlet.ShouldProcess($addrgrp.name, 'Remove Firewall Proxy Address Group Member')) {
            Invoke-FGTRestMethod -method "PUT" -body $_addrgrp -uri $uri -connection $connection @invokeParams | Out-Null

            Get-FGTFirewallProxyAddressGroup -connection $connection @invokeParams -name $addrgrp.name
        }
    }

    End {
    }
}


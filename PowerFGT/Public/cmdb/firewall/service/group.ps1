#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
# Copyright 2019, Benjamin Perrier <ben dot perrier at outlook dot com>
#
# SPDX-License-Identifier: Apache-2.0
#
function Add-FGTFirewallServiceGroup {

    <#
        .SYNOPSIS
        Add a FortiGate Service Group

        .DESCRIPTION
        Add a FortiGate Service Group

        .EXAMPLE
        Add-FGTFirewallServiceGroup -name MyServiceGroup -member MyService1

        Add Service Group with member MyService1

        .EXAMPLE
        Add-FGTFirewallServiceGroup -name MyServiceGroup -member MyService1, MyService2

        Add Service Group with members MyService1 and MyService2

        .EXAMPLE
        Add-FGTFirewallServiceGroup -name MyServiceGroup -member MyService1 -comment "My Service Group"

        Add Service Group with member MyService1 and a comment

        .EXAMPLE
        $data = @{ "color" = 23 }
        PS C:\>Add-FGTFirewallServiceGroup -name MyServiceGroup -member MyService1 -comment "My Service Group" -data $data

        Add Service Group with member MyService1, a comment and color (23) via -data parameter
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
        [hashtable]$data,
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

        if ( Get-FGTFirewallServiceGroup @invokeParams -name $name -connection $connection) {
            Throw "Already a servicegroup object using the same name"
        }

        $uri = "api/v2/cmdb/firewall.service/group"

        $servgrp = new-Object -TypeName PSObject

        $servgrp | add-member -name "name" -membertype NoteProperty -Value $name

        #Add member to Member Array
        $members = @( )
        foreach ( $m in $member ) {
            $member_name = @{ }
            $member_name.add( 'name', $m)
            $members += $member_name
        }
        $servgrp | add-member -name "member" -membertype NoteProperty -Value $members

        if ( $PsBoundParameters.ContainsKey('comment') ) {
            $servgrp | add-member -name "comment" -membertype NoteProperty -Value $comment
        }

        if ( $PsBoundParameters.ContainsKey('data') ) {
            $data.GetEnumerator() | ForEach-Object {
                $servgrp | Add-member -name $_.key -membertype NoteProperty -Value $_.value
            }
        }

        Invoke-FGTRestMethod -method "POST" -body $servgrp -uri $uri -connection $connection @invokeParams | Out-Null

        Get-FGTFirewallServiceGroup -connection $connection @invokeParams -name $name
    }

    End {
    }
}

function Add-FGTFirewallServiceGroupMember {

    <#
        .SYNOPSIS
        Add a FortiGate Service Group Member

        .DESCRIPTION
        Add a FortiGate Service Group Member

        .EXAMPLE
        $MyFGTServiceGroup = Get-FGTFirewallServiceGroup -name MyFGTServiceGroup
        PS C:\>$MyFGTServiceGroup | Add-FGTFirewallServiceGroupMember -member MyService1

        Add MyService1 member to MyFGTServiceGroup

        .EXAMPLE
        $MyFGTServiceGroup = Get-FGTFirewallServiceGroup -name MyFGTServiceGroup
        PS C:\>$MyFGTServiceGroup | Add-FGTFirewallServiceGroupMember -member MyService1, MyService2

        Add MyService1 and MyService2 member to MyFGTServiceGroup

    #>

    Param(
        [Parameter (Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        [ValidateScript( { Confirm-FGTServiceGroup $_ })]
        [psobject]$servgrp,
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

        $uri = "api/v2/cmdb/firewall.service/group"

        $_servgrp = new-Object -TypeName PSObject

        if ( $PsBoundParameters.ContainsKey('member') ) {
            #Add member to existing servgrp member
            $members = $servgrp.member
            foreach ( $m in $member ) {
                $member_name = @{ }
                $member_name.add( 'name', $m)
                $members += $member_name
            }
            $_servgrp | add-member -name "member" -membertype NoteProperty -Value $members
        }

        Invoke-FGTRestMethod -method "PUT" -body $_servgrp -uri $uri -uri_escape $servgrp.name -connection $connection @invokeParams | out-Null

        Get-FGTFirewallServiceGroup -connection $connection @invokeParams -name $servgrp.name
    }

    End {
    }
}

function Copy-FGTFirewallServiceGroup {

    <#
        .SYNOPSIS
        Copy/Clone a FortiGate Service Group

        .DESCRIPTION
        Copy/Clone a FortiGate Service Group (name, member...)

        .EXAMPLE
        $MyFGTServiceGroup = Get-FGTFirewallServiceGroup -name MyFGTServiceGroup
        PS C:\>$MyFGTServiceGroup | Copy-FGTFirewallServiceGroup -name MyFGTServiceGroup_copy

        Copy / Clone MyFGTServiceGroup and name MyFGTService_copy

    #>

    Param(
        [Parameter (Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        [ValidateScript( { Confirm-FGTServiceGroup $_ })]
        [psobject]$servgrp,
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

        if ( Get-FGTFirewallServiceGroup @invokeParams -name $name -connection $connection) {
            Throw "Already a Service Group object using the same name"
        }

        $uri = "api/v2/cmdb/firewall.service/group"
        $extra = "&action=clone&nkey=$($name)"

        Invoke-FGTRestMethod -method "POST" -uri $uri -uri_escape $servgrp.name -extra $extra -connection $connection @invokeParams | Out-Null

        Get-FGTFirewallServiceGroup -connection $connection @invokeParams -name $name
    }

    End {
    }
}
function Get-FGTFirewallServiceGroup {

    <#
        .SYNOPSIS
        Get list of all "services group"

        .DESCRIPTION
        Get list of all "services group"

        .EXAMPLE
        Get-FGTFirewallServiceGroup

        Get list of all services group object

        .EXAMPLE
        Get-FGTFirewallServiceGroup -name myFirewallServiceGroup

        Get services group object named myFirewallServiceCustom

        .EXAMPLE
        Get-FGTFirewallServiceGroup -name FGT -filter_type contains

        Get services group object contains with *FGT*

        .EXAMPLE
        Get-FGTFirewallServiceGroup -meta

        Get list of all services group object with metadata (q_...) like usage (q_ref)

        .EXAMPLE
        Get-FGTFirewallServiceGroup -skip

        Get list of all services group object (but only relevant attributes)

        .EXAMPLE
        Get-FGTFirewallServiceGroup -schema

        Get schema of Service Group

        .EXAMPLE
        Get-FGTFirewallServiceGroup -vdom vdomX

        Get list of all services group object on vdomX
    #>

    [CmdletBinding(DefaultParameterSetName = "default")]
    Param(
        [Parameter (Mandatory = $false, Position = 1, ParameterSetName = "name")]
        [string]$name,
        [Parameter (Mandatory = $false)]
        [Parameter (ParameterSetName = "filter")]
        [string]$filter_attribute,
        [Parameter (Mandatory = $false)]
        [Parameter (ParameterSetName = "name")]
        [Parameter (ParameterSetName = "filter")]
        [ValidateSet('equal', 'contains')]
        [string]$filter_type = "equal",
        [Parameter (Mandatory = $false)]
        [Parameter (ParameterSetName = "filter")]
        [psobject]$filter_value,
        [Parameter(Mandatory = $false)]
        [switch]$meta,
        [Parameter(Mandatory = $false)]
        [switch]$skip,
        [Parameter(Mandatory = $false, ParameterSetName = "schema")]
        [switch]$schema,
        [Parameter(Mandatory = $false)]
        [String[]]$vdom,
        [Parameter(Mandatory = $false)]
        [psobject]$connection = $DefaultFGTConnection
    )

    Begin {
    }

    Process {

        $invokeParams = @{ }
        if ( $PsBoundParameters.ContainsKey('meta') ) {
            $invokeParams.add( 'meta', $meta )
        }
        if ( $PsBoundParameters.ContainsKey('skip') ) {
            $invokeParams.add( 'skip', $skip )
        }
        if ( $PsBoundParameters.ContainsKey('vdom') ) {
            $invokeParams.add( 'vdom', $vdom )
        }

        if ( $PsBoundParameters.ContainsKey('schema') ) {
            $invokeParams.add( 'extra', "&action=schema" )
        }

        #Filtering
        switch ( $PSCmdlet.ParameterSetName ) {
            "name" {
                $filter_value = $name
                $filter_attribute = "name"
            }
            default { }
        }

        #if filter value and filter_attribute, add filter (by default filter_type is equal)
        if ( $filter_value -and $filter_attribute ) {
            $invokeParams.add( 'filter_value', $filter_value )
            $invokeParams.add( 'filter_attribute', $filter_attribute )
            $invokeParams.add( 'filter_type', $filter_type )
        }

        $response = Invoke-FGTRestMethod -uri 'api/v2/cmdb/firewall.service/group' -method 'GET' -connection $connection @invokeParams
        $response.results
    }

    End {
    }

}

function Set-FGTFirewallServiceGroup {

    <#
        .SYNOPSIS
        Configure a FortiGate Service Group

        .DESCRIPTION
        Change a FortiGate Service Group (name, member, comment...)

        .EXAMPLE
        $MyFGTServiceGroup = Get-FGTFirewallServiceGroup -name MyFGTServiceGroup
        PS C:\>$MyFGTServiceGroup | Set-FGTFirewallServiceGroup -member MyService1

        Change MyFGTServiceGroup member to MyService1

        .EXAMPLE
        $MyFGTServiceGroup = Get-FGTFirewallServiceGroup -name MyFGTServiceGroup
        PS C:\>$MyFGTServiceGroup | Set-FGTFirewallServiceGroup -member MyService1, MyService2

        Change MyFGTServiceGroup member to MyService1

        .EXAMPLE
        $MyFGTServiceGroup = Get-FGTFirewallServiceGroup -name MyFGTServiceGroup
        PS C:\>$MyFGTServiceGroup | Set-FGTFirewallServiceGroup -name MyFGTServiceGroup2

        Rename MyFGTServiceGroup member to MyFGTServiceGroup2

        .EXAMPLE
        $data = @{ "color" = 23 }
        PS C:\>$MyFGTServiceGroup = Get-FGTFirewallServiceGroup -name MyFGTServiceGroup
        PS C:\>$MyFGTServiceGroup | Set-FGTFirewallServiceGroup -data $data

        Change MyFGTServiceGroup to set color (23) using -data
    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'medium')]
    Param(
        [Parameter (Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        [ValidateScript( { Confirm-FGTServiceGroup $_ })]
        [psobject]$servgrp,
        [Parameter (Mandatory = $false)]
        [string]$name,
        [Parameter (Mandatory = $false)]
        [string[]]$member,
        [Parameter (Mandatory = $false)]
        [ValidateLength(0, 255)]
        [string]$comment,
        [Parameter (Mandatory = $false)]
        [hashtable]$data,
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

        $uri = "api/v2/cmdb/firewall.service/group"
        $old_name = $servgrp.name
        $_servgrp = new-Object -TypeName PSObject

        if ( $PsBoundParameters.ContainsKey('name') ) {
            #TODO check if there is not already an object with this name ?
            $_servgrp | add-member -name "name" -membertype NoteProperty -Value $name
            $servgrp.name = $name
        }

        if ( $PsBoundParameters.ContainsKey('member') ) {
            #Add member to Member Array
            $members = @( )
            foreach ( $m in $member ) {
                $member_name = @{ }
                $member_name.add( 'name', $m)
                $members += $member_name
            }
            $_servgrp | add-member -name "member" -membertype NoteProperty -Value $members
        }

        if ( $PsBoundParameters.ContainsKey('comment') ) {
            $_servgrp | add-member -name "comment" -membertype NoteProperty -Value $comment
        }

        if ( $PsBoundParameters.ContainsKey('data') ) {
            $data.GetEnumerator() | ForEach-Object {
                $_servgrp | Add-member -name $_.key -membertype NoteProperty -Value $_.value
            }
        }

        if ($PSCmdlet.ShouldProcess($servgrp.name, 'Configure Firewall Service Group')) {
            Invoke-FGTRestMethod -method "PUT" -body $_servgrp -uri $uri -uri_escape $old_name -connection $connection @invokeParams | out-Null

            Get-FGTFirewallServiceGroup -connection $connection @invokeParams -name $servgrp.name
        }
    }

    End {
    }
}
function Remove-FGTFirewallServiceGroup {

    <#
        .SYNOPSIS
        Remove a FortiGate Service

        .DESCRIPTION
        Remove a Service Group object on the FortiGate

        .EXAMPLE
        $MyFGTServiceGroup = Get-FGTFirewallServiceGroup -name MyFGTServiceGroup
        PS C:\>$MyFGTServiceGroup | Remove-FGTFirewallServiceGroup

        Remove Service Group object $MyFGTServiceGroup

        .EXAMPLE
        $MyFGTServiceGroup = Get-FGTFirewallServiceGroup -name MyFGTServiceGroup
        PS C:\>$MyFGTServiceGroup | Remove-FGTFirewallServiceGroup -confirm:$false

        Remove service object $MyFGTServiceGroup with no confirmation

    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'high')]
    Param(
        [Parameter (Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        [ValidateScript( { Confirm-FGTServiceGroup $_ })]
        [psobject]$servgrp,
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

        $uri = "api/v2/cmdb/firewall.service/group"

        if ($PSCmdlet.ShouldProcess($servgrp.name, 'Remove Firewall Service Group')) {
            $null = Invoke-FGTRestMethod -method "DELETE" -uri $uri -uri_escape $servgrp.name -connection $connection @invokeParams
        }
    }

    End {
    }
}

function Remove-FGTFirewallServiceGroupMember {

    <#
        .SYNOPSIS
        Remove a FortiGate Service Group Member

        .DESCRIPTION
        Remove a FortiGate Service Group Member

        .EXAMPLE
        $MyFGTServiceGroup = Get-FGTFirewallServiceGroup -name MyFGTServiceGroup
        PS C:\>$MyFGTServiceGroup | Remove-FGTFirewallServiceGroupMember -member MyService1

        Remove MyService1 member to MyFGTServiceGroup

        .EXAMPLE
        $MyFGTServiceGroup = Get-FGTFirewallServiceGroup -name MyFGTServiceGroup
        PS C:\>$MyFGTServiceGroup | Remove-FGTFirewallServiceGroupMember -member MyService1, MyService2

        Remove MyService1 and MyService2 member to MyFGTServiceGroup

    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'medium')]
    Param(
        [Parameter (Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        [ValidateScript( { Confirm-FGTServiceGroup $_ })]
        [psobject]$servgrp,
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

        $uri = "api/v2/cmdb/firewall.service/group"

        $_servgrp = new-Object -TypeName PSObject

        if ( $PsBoundParameters.ContainsKey('member') ) {
            #Create a new array
            $members = @()
            foreach ($m in $servgrp.member) {
                $member_name = @{ }
                $member_name.add( 'name', $m.name)
                $members += $member_name
            }

            #Remove member
            foreach ($remove_member in $member) {
                #May be a better (and faster) solution...
                $members = $members | Where-Object { $_.name -ne $remove_member }
            }

            #check if there is always a member... (it is not possible don't have member on Service Group)
            if ( $members.count -eq 0 ) {
                Throw "You can't remove all members. Use Remove-FGTFirewallServiceGroup to remove Service Group"
            }

            #if there is only One member force to be an array
            if ( $members.count -eq 1 ) {
                $members = @($members)
            }

            $_servgrp | add-member -name "member" -membertype NoteProperty -Value $members
        }

        if ($PSCmdlet.ShouldProcess($servgrp.name, 'Remove Firewall Service Group Member')) {
            Invoke-FGTRestMethod -method "PUT" -body $_servgrp -uri $uri -uri_escape $servgrp.name -connection $connection @invokeParams | Out-Null

            Get-FGTFirewallServiceGroup -connection $connection @invokeParams -name $servgrp.name
        }
    }

    End {
    }
}


#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

function Add-FGTFirewallLocalInPolicy {

    <#
        .SYNOPSIS
        Add a FortiGate Local In Policy

        .DESCRIPTION
        Add a FortiGate Local In Policy (interface, source/destination ip, service, action, status...)

        .EXAMPLE
        Add-FGTFirewallLocalInPolicy -intf port1 -srcaddr all -dstaddr all

        Add a Local In Policy with source port port1 and destination port2 and source and destination all

        .EXAMPLE
        Add-FGTFirewallLocalInPolicy -intf port10 -srcaddr all -dstaddr all -status:$false

        Add a Local In Policy with status is disable

        .EXAMPLE
        Add-FGTFirewallLocalInPolicy  -intf port1 -srcaddr all -dstaddr all -service HTTP, HTTPS, SSH

        Add a Local In Policy with multiple service port

        .EXAMPLE
        Add-FGTFirewallLocalInPolicy -intf port1 -srcaddr all -dstaddr all -comments "My FGT Policy"

        Add a Local In Policy with comment "My FGT Policy"

        .EXAMPLE
        Add-FGTFirewallLocalInPolicy -intf port1 -srcaddr all -dstaddr all -policyid 23

        Add a Local In Policy with Policy ID equal 23

        .EXAMPLE
        $data = @{ "virtual-patch" = "enable" }
        Add-FGTFirewallLocalInPolicy -intf port1 -srcaddr all -dstaddr all -data $data

        Add a Local In Policy with virtual-patch using -data
    #>


    Param(
        [Parameter (Mandatory = $false)]
        [int]$policyid,
        [Parameter (Mandatory = $true)]
        [string[]]$intf,
        [Parameter (Mandatory = $true)]
        [string[]]$srcaddr,
        [Parameter (Mandatory = $true)]
        [string[]]$dstaddr,
        [Parameter (Mandatory = $false)]
        [ValidateSet("accept", "deny")]
        [string]$action = "accept",
        [Parameter (Mandatory = $false)]
        [switch]$status,
        [Parameter (Mandatory = $false)]
        [string]$schedule = "always",
        [Parameter (Mandatory = $false)]
        [string[]]$service = "ALL",
        [Parameter (Mandatory = $false)]
        [ValidateLength(0, 255)]
        [string]$comments,
        [Parameter (Mandatory = $false)]
        [switch]$skip,
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
        if ( $PsBoundParameters.ContainsKey('skip') ) {
            $invokeParams.add( 'skip', $skip )
        }
        if ( $PsBoundParameters.ContainsKey('vdom') ) {
            $invokeParams.add( 'vdom', $vdom )
        }

        $uri = "api/v2/cmdb/firewall/local-in-policy"

        # Interface
        #After 7.4.0, you can have multiple interface
        if ($connection.version -ge "7.4.0") {
            $intf_array = @()
            foreach ($i in $intf) {
                $intf_array += @{ 'name' = $i }
            }
        }
        else {
            #Add Warning ?
            $intf_array = $intf
        }

        # Source address
        $srcaddr_array = @()
        #TODO check if the address (group, vip...) is valid
        foreach ($addr in $srcaddr) {
            $srcaddr_array += @{ 'name' = $addr }
        }

        # Destination address
        $dstaddr_array = @()
        #TODO check if the address (group, vip...) is valid
        foreach ($addr in $dstaddr) {
            $dstaddr_array += @{ 'name' = $addr }
        }

        # Service
        $service_array = @()
        #TODO check if the service (group...) is valid
        foreach ($s in $service) {
            $service_array += @{ 'name' = $s }
        }

        $policy = new-Object -TypeName PSObject

        if ( $PsBoundParameters.ContainsKey('name') ) {
            $policy | add-member -name "name" -membertype NoteProperty -Value $name
        }

        if ( $PsBoundParameters.ContainsKey('policyid') ) {
            $policy | add-member -name "policyid" -membertype NoteProperty -Value $policyid
        }

        $policy | add-member -name "intf" -membertype NoteProperty -Value $intf_array

        $policy | add-member -name "srcaddr" -membertype NoteProperty -Value $srcaddr_array

        $policy | add-member -name "dstaddr" -membertype NoteProperty -Value $dstaddr_array

        $policy | add-member -name "action" -membertype NoteProperty -Value $action

        #set status enable by default (PSSA don't like to set default value for a switch parameter)
        if ( -not $PsBoundParameters.ContainsKey('status') ) {
            $status = $true
        }

        if ($status) {
            $policy | add-member -name "status" -membertype NoteProperty -Value "enable"
        }
        else {
            $policy | add-member -name "status" -membertype NoteProperty -Value "disable"
        }

        $policy | add-member -name "schedule" -membertype NoteProperty -Value $schedule

        $policy | add-member -name "service" -membertype NoteProperty -Value $service_array


        if ( $PsBoundParameters.ContainsKey('comments') ) {
            $policy | add-member -name "comments" -membertype NoteProperty -Value $comments
        }

        if ( $PsBoundParameters.ContainsKey('data') ) {
            $data.GetEnumerator() | ForEach-Object {
                $policy | Add-member -name $_.key -membertype NoteProperty -Value $_.value
            }
        }

        $post = Invoke-FGTRestMethod -method "POST" -body $policy -uri $uri -connection $connection @invokeParams

        #there is no policy name on Local In Policy, get the policy via policyid (return by POST via mkey value)
        Get-FGTFirewallLocalInPolicy -policyid $post.mkey -connection $connection @invokeParams

    }

    End {
    }
}

function Add-FGTFirewallLocalInPolicyMember {

    <#
        .SYNOPSIS
        Add a FortiGate Local In Policy Member

        .DESCRIPTION
        Add a FortiGate Local In Policy Member (source or destination address, interface)

        .EXAMPLE
        $MyFGTPolicy = Get-FGTFirewallLocalInPolicy -policyid 23
        PS C:\>$MyFGTPolicy | Add-FGTFirewallLocalInPolicyMember -srcaddr MyAddress1

        Add MyAddress1 member to source of Local In Policy 23

        .EXAMPLE
        $MyFGTPolicy = Get-FGTFirewallLocalInPolicy -policyid 23
        PS C:\>$MyFGTPolicy | Add-FGTFirewallLocalInPolicyMember -dstaddr MyAddress1, MyAddress2

        Add MyAddress1 and MyAddress2 member to destination of Local In Policy 23

        .EXAMPLE
        $MyFGTPolicy = Get-FGTFirewallLocalInPolicy -policyid 23
        PS C:\>$MyFGTPolicy | Add-FGTFirewallLocalInPolicyMember -intf port1

        Add port1 member to source interface of Local In Policy 23

    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'low')]
    Param(
        [Parameter (Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        [ValidateScript( { Confirm-FGTFirewallLocalInPolicy $_ })]
        [psobject]$policy,
        [Parameter(Mandatory = $false)]
        [string[]]$srcaddr,
        [Parameter(Mandatory = $false)]
        [string[]]$intf,
        [Parameter(Mandatory = $false)]
        [string[]]$dstaddr,
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

        $uri = "api/v2/cmdb/firewall/local-in-policy"

        $_policy = new-Object -TypeName PSObject

        if ( $PsBoundParameters.ContainsKey('srcaddr') ) {

            if ($policy.srcaddr.name -eq "all") {
                #all => create new empty array members
                $members = @()
            }
            else {
                #Add member to existing source address
                $members = $policy.srcaddr
            }

            foreach ( $member in $srcaddr ) {
                $member_name = @{ }
                $member_name.add( 'name', $member)
                $members += $member_name
            }
            $_policy | add-member -name "srcaddr" -membertype NoteProperty -Value $members
        }

        if ( $PsBoundParameters.ContainsKey('intf') ) {

            if ($policy.intf.name -eq "any") {
                #any => create new empty array members
                $members = @()
            }
            else {
                #Add member to existing source interface
                $members = $policy.intf
            }

            foreach ( $member in $intf ) {
                $member_name = @{ }
                $member_name.add( 'name', $member)
                $members += $member_name
            }
            $_policy | add-member -name "intf" -membertype NoteProperty -Value $members
        }

        if ( $PsBoundParameters.ContainsKey('dstaddr') ) {

            if ($policy.dstaddr.name -eq "all") {
                #all => create new empty array members
                $members = @()
            }
            else {
                #Add member to existing destination address
                $members = $policy.dstaddr
            }

            foreach ( $member in $dstaddr ) {
                $member_name = @{ }
                $member_name.add( 'name', $member)
                $members += $member_name
            }
            $_policy | add-member -name "dstaddr" -membertype NoteProperty -Value $members
        }

        if ($PSCmdlet.ShouldProcess($policy.policyid, 'Add Firewall Policy Group Member')) {
            Invoke-FGTRestMethod -method "PUT" -body $_policy -uri $uri -uri_escape $policy.policyid -connection $connection @invokeParams | Out-Null

            Get-FGTFirewallLocalInPolicy -connection $connection @invokeParams -policyid $policy.policyid
        }
    }

    End {
    }
}

function Get-FGTFirewallLocalInPolicy {

    <#
        .SYNOPSIS
        Get list of all policies/rules

        .DESCRIPTION
        Get list of all policies (name, interface, address (network) source/destination, service, action...)

        .EXAMPLE
        Get-FGTFirewallLocalInPolicy

        Get list of all policies

        .EXAMPLE
        Get-FGTFirewallLocalInPolicy -policyid 23

        Get policy with id 23

        .EXAMPLE
        Get-FGTFirewallLocalInPolicy -uuid 9e73a10e-1772-51ea-a8d7-297686fd7702

        Get policy with uuid 9e73a10e-1772-51ea-a8d7-297686fd7702

        .EXAMPLE
        Get-FGTFirewallLocalInPolicy -skip

        Get list of all policies (but only relevant attributes)

        .EXAMPLE
        Get-FGTFirewallLocalInPolicy -meta

        Get list of all policies with metadata (q_...) like usage (q_ref)

        .EXAMPLE
        Get-FGTFirewallLocalInPolicy -schema

        Get schema of Local In Policy

        .EXAMPLE
        Get-FGTFirewallLocalInPolicy -vdom vdomX

        Get list of all policies on vdomX
    #>

    [CmdletBinding(DefaultParameterSetName = "default")]
    Param(
        [Parameter (Mandatory = $false, ParameterSetName = "uuid")]
        [string]$uuid,
        [Parameter (Mandatory = $false, ParameterSetName = "policyid")]
        [string[]]$policyid,
        [Parameter (Mandatory = $false)]
        [Parameter (ParameterSetName = "filter")]
        [string]$filter_attribute,
        [Parameter (Mandatory = $false)]
        [Parameter (ParameterSetName = "uuid")]
        [Parameter (ParameterSetName = "policyid")]
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
            "uuid" {
                $filter_value = $uuid
                $filter_attribute = "uuid"
            }
            "policyid" {
                $filter_value = $policyid
                $filter_attribute = "policyid"
            }
            default { }
        }

        #if filter value and filter_attribute, add filter (by default filter_type is equal)
        if ( $filter_value -and $filter_attribute ) {
            $invokeParams.add( 'filter_value', $filter_value )
            $invokeParams.add( 'filter_attribute', $filter_attribute )
            $invokeParams.add( 'filter_type', $filter_type )
        }

        $reponse = Invoke-FGTRestMethod -uri 'api/v2/cmdb/firewall/local-in-policy' -method 'GET' -connection $connection @invokeParams
        $reponse.results
    }

    End {
    }
}

function Move-FGTFirewallLocalInPolicy {

    <#
        .SYNOPSIS
        Move a FortiGate Local In Policy

        .DESCRIPTION
        Move a Policy/Rule object (after or before) on the FortiGate

        .EXAMPLE
        $MyFGTPolicy = Get-FGTFirewallLocalInPolicy -policyid 23
        PS C:\>$MyFGTPolicy | Move-FGTFirewallLocalInPolicy -after -id 12

        Move Policy object id 23 after Policy id 12

    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'low')]
    Param(
        [Parameter (Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        [ValidateScript( { Confirm-FGTFirewallLocalInPolicy $_ })]
        [psobject]$policy,
        [Parameter(Mandatory = $true, ParameterSetName = "after")]
        [switch]$after,
        [Parameter(Mandatory = $true, ParameterSetName = "before")]
        [switch]$before,
        [Parameter(Mandatory = $true)]
        [ValidateScript( { ($_ -is [int]) -or (Confirm-FGTFirewallLocalInPolicy $_ ) })]
        [psobject]$id,
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

        #id is a Policy Rule (from Get-FGTFirewallLocalInPolicy) ?
        if ( $id.policyid ) {
            #Get the policyid
            [int]$id = $id.policyid
        }

        $uri = "api/v2/cmdb/firewall/local-in-policy"
        $extra = "action=move"

        switch ( $PSCmdlet.ParameterSetName ) {
            "after" {
                $extra += "&after=$($id)"
            }
            "before" {
                $extra += "&before=$($id)"
            }
            default { }
        }
        if ($PSCmdlet.ShouldProcess($policy.policyid, 'Move Firewall Policy')) {
            $null = Invoke-FGTRestMethod -method "PUT" -uri $uri -uri_escape $policy.policyid -extra $extra -connection $connection @invokeParams
        }

        Get-FGTFirewallLocalInPolicy -policyid $policy.policyid -connection $connection @invokeParams
    }

    End {
    }
}

function Set-FGTFirewallLocalInPolicy {

    <#
        .SYNOPSIS
        Configure a FortiGate Local In Policy

        .DESCRIPTION
        Change a FortiGate Local in Policy Policy/Rules (source/destination ip, interface, action, status, ...)

        .EXAMPLE
        $MyFGTPolicy = Get-FGTFirewallLocalInPolicy -policyid 23
        PS C:\>$MyFGTPolicy | Set-FGTFirewallLocalInPolicy -intf port1 -srcaddr MyFGTAddress

        Change MyFGTPolicy (Policy id 23) to intf port1 and srcaddr MyFGTAddress

        .EXAMPLE
        $MyFGTPolicy = Get-FGTFirewallLocalInPolicy -policyid 23
        PS C:\>$MyFGTPolicy | Set-FGTFirewallLocalInPolicy -service HTTP,HTTPS

        Change MyFGTPolicy (Policy id 23) to set service to HTTP and HTTPS

        .EXAMPLE
        $MyFGTPolicy = Get-FGTFirewallLocalInPolicy -policyid 23
        PS C:\>$MyFGTPolicy | Set-FGTFirewallLocalInPolicy -comments "My FGT Policy"

        Change MyFGTPolicy (Policy id 23) to set a new comments

        .EXAMPLE
        $MyFGTPolicy = Get-FGTFirewallLocalInPolicy -policyid 23
        PS C:\>$MyFGTPolicy | Set-FGTFirewallLocalInPolicy -status:$false

        Change MyFGTPolicy (Policy id 23) to set status disable

        .EXAMPLE
        $data = @{"virtual-patch"  = "enable" }
        PS C:\>$MyFGTPolicy = Get-FGTFirewallLocalInPolicy -policyid 23
        PS C:\>$MyFGTPolicy | Set-FGTFirewallLocalInPolicy -data $data

        Change MyFGTPolicy (Policy id 23) to setvirtual-patch to enabled using -data

    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'medium', DefaultParameterSetName = 'default')]
    Param(
        [Parameter (Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        [ValidateScript( { Confirm-FGTFirewallLocalInPolicy $_ })]
        [psobject]$policy,
        [Parameter (Mandatory = $false)]
        [string]$name,
        [string[]]$intf,
        [Parameter (Mandatory = $false)]
        [string[]]$srcaddr,
        [Parameter (Mandatory = $false)]
        [string[]]$dstaddr,
        [Parameter (Mandatory = $false)]
        [ValidateSet("accept", "deny")]
        [string]$action,
        [Parameter (Mandatory = $false)]
        [switch]$status,
        [Parameter (Mandatory = $false)]
        [string]$schedule,
        [Parameter (Mandatory = $false)]
        [string[]]$service,
        [Parameter (Mandatory = $false)]
        [switch]$nat,
        [Parameter (Mandatory = $false)]
        [ValidateLength(0, 255)]
        [string]$comments,
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

        $uri = "api/v2/cmdb/firewall/local-in-policy"

        $_policy = new-Object -TypeName PSObject

        if ( $PsBoundParameters.ContainsKey('intf') ) {
            # Interface
            $intf_array = @()
            #TODO check if the interface (zone ?) is valid
            foreach ($intf in $intf) {
                $intf_array += @{ 'name' = $intf }
            }
            $_policy | add-member -name "intf" -membertype NoteProperty -Value $intf_array
        }

        if ( $PsBoundParameters.ContainsKey('srcaddr') ) {
            # Source address
            $srcaddr_array = @()
            #TODO check if the address (group, vip...) is valid
            foreach ($addr in $srcaddr) {
                $srcaddr_array += @{ 'name' = $addr }
            }
            $_policy | add-member -name "srcaddr" -membertype NoteProperty -Value $srcaddr_array
        }

        if ( $PsBoundParameters.ContainsKey('dstaddr') ) {
            # Destination address
            $dstaddr_array = @()
            #TODO check if the address (group, vip...) is valid
            foreach ($addr in $dstaddr) {
                $dstaddr_array += @{ 'name' = $addr }
            }
            $_policy | add-member -name "dstaddr" -membertype NoteProperty -Value $dstaddr_array
        }

        if ( $PsBoundParameters.ContainsKey('action') ) {
            $_policy | add-member -name "action" -membertype NoteProperty -Value $action
        }

        if ( $PsBoundParameters.ContainsKey('status') ) {
            if ($status) {
                $_policy | add-member -name "status" -membertype NoteProperty -Value "enable"
            }
            else {
                $_policy | add-member -name "status" -membertype NoteProperty -Value "disable"
            }
        }

        if ( $PsBoundParameters.ContainsKey('schedule') ) {
            $_policy | add-member -name "schedule" -membertype NoteProperty -Value $schedule
        }

        if ( $PsBoundParameters.ContainsKey('service') ) {
            # Service
            $service_array = @()
            #TODO check if the service (group...) is valid
            foreach ($s in $service) {
                $service_array += @{ 'name' = $s }
            }
            $_policy | add-member -name "service" -membertype NoteProperty -Value $service_array
        }

        if ( $PsBoundParameters.ContainsKey('comments') ) {
            $_policy | add-member -name "comments" -membertype NoteProperty -Value $comments
        }

        if ( $PsBoundParameters.ContainsKey('data') ) {
            $data.GetEnumerator() | ForEach-Object {
                $_policy | Add-member -name $_.key -membertype NoteProperty -Value $_.value
            }
        }

        if ($PSCmdlet.ShouldProcess($address.name, 'Configure Firewall Policy')) {
            Invoke-FGTRestMethod -method "PUT" -body $_policy -uri $uri -uri_escape $policy.policyid -connection $connection @invokeParams | out-Null

            Get-FGTFirewallLocalInPolicy -connection $connection @invokeParams -policyid $policy.policyid
        }
    }

    End {
    }
}

function Remove-FGTFirewallLocalInPolicy {

    <#
        .SYNOPSIS
        Remove a FortiGate Local In Policy

        .DESCRIPTION
        Remove a Local In Policy object on the FortiGate

        .EXAMPLE
        $MyFGTPolicy = Get-FGTFirewallLocalInPolicy -policyid 23
        PS C:\>$MyFGTPolicy | Remove-FGTFirewallLocalInPolicy

        Remove Local in Policy id 23

        .EXAMPLE
        $MyFGTPolicy = Get-FGTFirewallLocalInPolicy -policyid 23
        PS C:\>$MyFGTPolicy | Remove-FGTFirewallLocalInPolicy -confirm:$false

        Remove Local in Policy id 23y with no confirmation

    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'high')]
    Param(
        [Parameter (Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        [ValidateScript( { Confirm-FGTFirewallLocalInPolicy $_ })]
        [psobject]$policy,
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

        $uri = "api/v2/cmdb/firewall/local-in-policy"

        if ($PSCmdlet.ShouldProcess($policy.policyid, 'Remove Firewall Policy')) {
            $null = Invoke-FGTRestMethod -method "DELETE" -uri $uri -uri_escape $policy.policyid -connection $connection @invokeParams
        }
    }

    End {
    }
}

function Remove-FGTFirewallLocalInPolicyMember {

    <#
        .SYNOPSIS
        Remove a FortiGate Local In Policy Member

        .DESCRIPTION
        Remove a FortiGate Local In Policy Member (source, destination address and interface)

        .EXAMPLE
        $MyFGTPolicy = Get-FGTFirewallLocalInPolicy -policyid 23
        PS C:\>$MyFGTPolicy | Remove-FGTFirewallLocalInPolicyMember -srcaddr MyAddress1

        Remove source MyAddress1 member to MyFGTPolicy (policy id 23)

        .EXAMPLE
        $MyFGTPolicy = Get-FGTFirewallLocalInPolicy -policyid 23
        PS C:\>$MyFGTPolicy | Remove-FGTFirewallLocalInPolicyMember -dstaddr MyAddress1, MyAddress2

        Remove destination MyAddress1 and MyAddress2 member to MyFGTPolicy (policy id 23)

        .EXAMPLE
        $MyFGTPolicy = Get-FGTFirewallLocalInPolicy -policyid 23
        PS C:\>$MyFGTPolicy | Remove-FGTFirewallLocalInPolicyMember -intf port1

        Remove port1 member to interface of MyFGTPolicy (policy id 23)


    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'medium')]
    Param(
        [Parameter (Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        [ValidateScript( { Confirm-FGTFirewallLocalInPolicy $_ })]
        [psobject]$policy,
        [Parameter(Mandatory = $false)]
        [string[]]$srcaddr,
        [Parameter(Mandatory = $false)]
        [string[]]$intf,
        [Parameter(Mandatory = $false)]
        [string[]]$dstaddr,
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

        $uri = "api/v2/cmdb/firewall/local-in-policy"

        $_policy = new-Object -TypeName PSObject

        if ( $PsBoundParameters.ContainsKey('srcaddr') ) {
            #Create a new source addr array
            $members = @()
            foreach ($m in $policy.srcaddr) {
                $member_name = @{ }
                $member_name.add( 'name', $m.name)
                $members += $member_name
            }

            #Remove member
            foreach ($remove_member in $srcaddr) {
                #May be a better (and faster) solution...
                $members = $members | Where-Object { $_.name -ne $remove_member }
            }

            #check if there is always a member... (it is not really (dependy of release...) possible don't have member on Policy)
            if ( $members.count -eq 0 ) {
                Throw "You can't remove all members. Use Set-FGTFirewallLocalInPolicy to remove Source Address"
            }

            #if there is only One or less member force to be an array
            if ( $members.count -le 1 ) {
                $members = @($members)
            }

            $_policy | add-member -name "srcaddr" -membertype NoteProperty -Value $members
        }

        if ( $PsBoundParameters.ContainsKey('dstaddr') ) {
            #Create a new destination addr array
            $members = @()
            foreach ($m in $policy.dstaddr) {
                $member_name = @{ }
                $member_name.add( 'name', $m.name)
                $members += $member_name
            }

            #Remove member
            foreach ($remove_member in $dstaddr) {
                #May be a better (and faster) solution...
                $members = $members | Where-Object { $_.name -ne $remove_member }
            }

            #check if there is always a member... (it is not really (dependy of release...) possible don't have member on Policy)
            if ( $members.count -eq 0 ) {
                Throw "You can't remove all members. Use Set-FGTFirewallLocalInPolicy to remove Destination Address"
            }

            #if there is only One or less member force to be an array
            if ( $members.count -le 1 ) {
                $members = @($members)
            }

            $_policy | add-member -name "dstaddr" -membertype NoteProperty -Value $members
        }

        if ( $PsBoundParameters.ContainsKey('intf') ) {
            #Create a new intf array
            $members = @()
            foreach ($m in $policy.intf) {
                $member_name = @{ }
                $member_name.add( 'name', $m.name)
                $members += $member_name
            }

            #Remove member
            foreach ($remove_member in $intf) {
                #May be a better (and faster) solution...
                $members = $members | Where-Object { $_.name -ne $remove_member }
            }

            #check if there is always a member... (it is not really (dependy of release...) possible don't have member on Policy)
            if ( $members.count -eq 0 ) {
                Throw "You can't remove all members. Use Set-FGTFirewallLocalInPolicy to remove interface"
            }

            #if there is only One or less member force to be an array
            if ( $members.count -le 1 ) {
                $members = @($members)
            }

            $_policy | add-member -name "intf" -membertype NoteProperty -Value $members
        }

        if ($PSCmdlet.ShouldProcess($policy.policyid, 'Remove Firewall Policy Group Member')) {
            Invoke-FGTRestMethod -method "PUT" -body $_policy -uri $uri -uri_escape $policy.policyid -connection $connection @invokeParams | Out-Null

            Get-FGTFirewallLocalInPolicy -connection $connection @invokeParams -policyid $policy.policyid
        }
    }

    End {
    }
}
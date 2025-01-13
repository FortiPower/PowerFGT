#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
# Copyright 2019, Benjamin Perrier <ben dot perrier at outlook dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

function Add-FGTFirewallPolicy {

    <#
        .SYNOPSIS
        Add a FortiGate Policy

        .DESCRIPTION
        Add a FortiGate Policy/Rules (source port/ip, destination port, ip, action, status...)

        .EXAMPLE
        Add-FGTFirewallPolicy -name MyFGTPolicy -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all

        Add a MyFGTPolicy with source port port1 and destination port2 and source and destination all

        .EXAMPLE
        Add-FGTFirewallPolicy -name MyFGTPolicy -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all -nat

        Add a MyFGTPolicy with NAT is enable

        .EXAMPLE
        Add-FGTFirewallPolicy -name MyFGTPolicy -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all -action "deny"

        Add a MyFGTPolicy with action is Deny

        .EXAMPLE
        Add-FGTFirewallPolicy -name MyFGTPolicy -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all -status:$false

        Add a MyFGTPolicy with status is disable

        .EXAMPLE
        Add-FGTFirewallPolicy -name MyFGTPolicy -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all -service "HTTP, HTTPS, SSH"

        Add a MyFGTPolicy with multiple service port

        .EXAMPLE
        Add-FGTFirewallPolicy -name MyFGTPolicy -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all -schedule workhour

        Add a MyFGTPolicy with schedule is workhour

        .EXAMPLE
        Add-FGTFirewallPolicy -name MyFGTPolicy -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all -comments "My FGT Policy"

        Add a MyFGTPolicy with comment "My FGT Policy"

        .EXAMPLE
        Add-FGTFirewallPolicy -name MyFGTPolicy -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all -logtraffic "all"

        Add a MyFGTPolicy with log traffic all

        .EXAMPLE
        Add-FGTFirewallPolicy -name MyFGTPolicy -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all -nat -ippool "MyIPPool"

        Add a MyFGTPolicy with IP Pool MyIPPool (with nat)

        .EXAMPLE
        Add-FGTFirewallPolicy -name MyFGTPolicy -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all -policyid 23

        Add a MyFGTPolicy with Policy ID equal 23

        .EXAMPLE
        Add-FGTFirewallPolicy -name MyFGTPolicy -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all -avprofile default -webfilterprofile default -dnsfilterprofile default -applicationlist default -ipssensor default

        Add a MyFGTPolicy with Security Profile (Antivirus, WebFilter, DNS Filter, Application, IPS)

        .EXAMPLE
        $data = @{ "logtraffic-start" = "enable" }
        Add-FGTFirewallPolicy -name MyFGTPolicy -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all -data $data

        Add a MyFGTPolicy with logtraffic-start using -data
    #>


    Param(
        [Parameter (Mandatory = $false)]
        [string]$name,
        [Parameter (Mandatory = $false)]
        [int]$policyid,
        [Parameter (Mandatory = $true)]
        [string[]]$srcintf,
        [Parameter (Mandatory = $true)]
        [string[]]$dstintf,
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
        [switch]$nat = $false,
        [Parameter (Mandatory = $false)]
        [ValidateLength(0, 255)]
        [string]$comments,
        [Parameter (Mandatory = $false)]
        [ValidateSet("disable", "utm", "all")]
        [string]$logtraffic,
        [Parameter (Mandatory = $false)]
        [string[]]$ippool,
        [Parameter (Mandatory = $false)]
        [ValidateSet("flow", "proxy")]
        [string]$inspectionmode,
        [Parameter (Mandatory = $false)]
        [string]$sslsshprofile,
        [Parameter (Mandatory = $false)]
        [string]$avprofile,
        [Parameter (Mandatory = $false)]
        [string]$webfilterprofile,
        [Parameter (Mandatory = $false)]
        [string]$dnsfilterprofile,
        [Parameter (Mandatory = $false)]
        [string]$ipssensor,
        [Parameter (Mandatory = $false)]
        [string]$applicationlist,
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

        if ( $PsBoundParameters.ContainsKey('name') ) {
            if ( Get-FGTFirewallPolicy -connection $connection @invokeParams -name $name ) {
                Throw "Already a Policy using the same name"
            }
        }
        else {
            #check if Allow Unnamed Policy is enable
            $settings = Get-FGTSystemSettings -connection $connection @invokeParams
            if ($settings.'gui-allow-unnamed-policy' -eq "disable") {
                throw "You need to specifiy a name"
            }
        }

        $uri = "api/v2/cmdb/firewall/policy"

        # Source interface
        $srcintf_array = @()
        #TODO check if the interface (zone ?) is valid
        foreach ($intf in $srcintf) {
            $srcintf_array += @{ 'name' = $intf }
        }

        # Destination interface
        $dstintf_array = @()
        #TODO check if the interface (zone ?) is valid
        foreach ($intf in $dstintf) {
            $dstintf_array += @{ 'name' = $intf }
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

        $policy | add-member -name "srcintf" -membertype NoteProperty -Value $srcintf_array

        $policy | add-member -name "dstintf" -membertype NoteProperty -Value $dstintf_array

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

        if ($nat) {
            $policy | add-member -name "nat" -membertype NoteProperty -Value "enable"
        }
        else {
            $policy | add-member -name "nat" -membertype NoteProperty -Value "disable"
        }

        if ( $PsBoundParameters.ContainsKey('comments') ) {
            $policy | add-member -name "comments" -membertype NoteProperty -Value $comments
        }

        if ( $PsBoundParameters.ContainsKey('logtraffic') ) {
            $policy | add-member -name "logtraffic" -membertype NoteProperty -Value $logtraffic
        }

        if ( $PsBoundParameters.ContainsKey('ippool') ) {
            if (-not $nat) {
                throw "You need to enable NAT (-nat)"
            }
            $ippool_array = @()
            #TODO check if the IP Pool is valid
            foreach ($i in $ippool) {
                $ippool_array += @{ 'name' = $i }
            }
            $policy | add-member -name "ippool" -membertype NoteProperty -Value "enable"
            $policy | add-member -name "poolname" -membertype NoteProperty -Value $ippool_array
        }

        if ( $PsBoundParameters.ContainsKey('data') ) {
            $data.GetEnumerator() | ForEach-Object {
                $policy | Add-member -name $_.key -membertype NoteProperty -Value $_.value
            }
        }

        if ( $PsBoundParameters.ContainsKey('inspectionmode') ) {
            if ($connection.version -lt "6.2.0") {
                Throw "-inspectionmode (flow/proxy is not available before FortiOS 6.2.x)"
            }
            $policy | add-member -name "inspection-mode" -membertype NoteProperty -Value $inspectionmode
        }

        if ( $PsBoundParameters.ContainsKey('sslsshprofile') ) {
            $policy | add-member -name "ssl-ssh-profile" -membertype NoteProperty -Value $sslsshprofile
        }

        if ( $PsBoundParameters.ContainsKey('avprofile') ) {
            $policy | add-member -name "av-profile" -membertype NoteProperty -Value $avprofile
        }

        if ( $PsBoundParameters.ContainsKey('webfilterprofile') ) {
            $policy | add-member -name "webfilter-profile" -membertype NoteProperty -Value $webfilterprofile
        }

        if ( $PsBoundParameters.ContainsKey('dnsfilterprofile') ) {
            $policy | add-member -name "dnsfilter-profile" -membertype NoteProperty -Value $dnsfilterprofile
        }

        if ( $PsBoundParameters.ContainsKey('ipssensor') ) {
            $policy | add-member -name "ips-sensor" -membertype NoteProperty -Value $ipssensor
        }

        if ( $PsBoundParameters.ContainsKey('applicationlist') ) {
            $policy | add-member -name "application-list" -membertype NoteProperty -Value $applicationlist
        }

        #When use Security Profile, you need to enable utm-status
        if ( $PsBoundParameters.ContainsKey('sslsshprofile') -or $PsBoundParameters.ContainsKey('avprofile') -or $PsBoundParameters.ContainsKey('webfilterprofile') -or $PsBoundParameters.ContainsKey('dnsfilterprofile') -or $PsBoundParameters.ContainsKey('ipssensor') -or $PsBoundParameters.ContainsKey('applicationlist')) {
            $policy | add-member -name "utm-status" -membertype NoteProperty -Value "enable"
        }

        $post = Invoke-FGTRestMethod -method "POST" -body $policy -uri $uri -connection $connection @invokeParams

        if ( $PsBoundParameters.ContainsKey('name') ) {
            Get-FGTFirewallPolicy -name $name -connection $connection @invokeParams
        }
        else {
            #if unnamed policy, get the policy via policyid (return by POST via mkey value)
            Get-FGTFirewallPolicy -policyid $post.mkey -connection $connection @invokeParams
        }

    }

    End {
    }
}

function Add-FGTFirewallPolicyMember {

    <#
        .SYNOPSIS
        Add a FortiGate Policy Member

        .DESCRIPTION
        Add a FortiGate Policy Member (source or destination address/interface)

        .EXAMPLE
        $MyFGTPolicy = Get-FGTFirewallPolicy -name MyFGTPolicy
        PS C:\>$MyFGTPolicy | Add-FGTFirewallPolicyMember -srcaddr MyAddress1

        Add MyAddress1 member to source of MyFGTPolicy

        .EXAMPLE
        $MyFGTPolicy = Get-FGTFirewallPolicy -name MyFGTPolicy
        PS C:\>$MyFGTPolicy | Add-FGTFirewallPolicyMember -dstaddr MyAddress1, MyAddress2

        Add MyAddress1 and MyAddress2 member to destination of MyFGTPolicy

        .EXAMPLE
        $MyFGTPolicy = Get-FGTFirewallPolicy -name MyFGTPolicy
        PS C:\>$MyFGTPolicy | Add-FGTFirewallPolicyMember -srcintf port1

        Add port1 member to source interface of MyFGTPolicy

        .EXAMPLE
        $MyFGTPolicy = Get-FGTFirewallPolicy -name MyFGTPolicy
        PS C:\>$MyFGTPolicy | Add-FGTFirewallPolicyMember -dstintf port2

        Add port2 member to destination interface of MyFGTPolicy
    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'low')]
    Param(
        [Parameter (Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        [ValidateScript( { Confirm-FGTFirewallPolicy $_ })]
        [psobject]$policy,
        [Parameter(Mandatory = $false)]
        [string[]]$srcaddr,
        [Parameter(Mandatory = $false)]
        [string[]]$srcintf,
        [Parameter(Mandatory = $false)]
        [string[]]$dstaddr,
        [Parameter(Mandatory = $false)]
        [string[]]$dstintf,
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

        $uri = "api/v2/cmdb/firewall/policy"

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

        if ( $PsBoundParameters.ContainsKey('srcintf') ) {

            if ($policy.srcintf.name -eq "any") {
                #any => create new empty array members
                $members = @()
            }
            else {
                #Add member to existing source interface
                $members = $policy.srcintf
            }

            foreach ( $member in $srcintf ) {
                $member_name = @{ }
                $member_name.add( 'name', $member)
                $members += $member_name
            }
            $_policy | add-member -name "srcintf" -membertype NoteProperty -Value $members
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

        if ( $PsBoundParameters.ContainsKey('dstintf') ) {

            if ($policy.dstintf.name -eq "any") {
                #any => create new empty array members
                $members = @()
            }
            else {
                #Add member to existing source interface
                $members = $policy.dstintf
            }

            foreach ( $member in $dstintf ) {
                $member_name = @{ }
                $member_name.add( 'name', $member)
                $members += $member_name
            }
            $_policy | add-member -name "dstintf" -membertype NoteProperty -Value $members
        }

        if ($PSCmdlet.ShouldProcess($policy.name, 'Add Firewall Policy Group Member')) {
            Invoke-FGTRestMethod -method "PUT" -body $_policy -uri $uri -uri_escape $policy.policyid -connection $connection @invokeParams | Out-Null

            Get-FGTFirewallPolicy -connection $connection @invokeParams -name $policy.name
        }
    }

    End {
    }
}

function Get-FGTFirewallPolicy {

    <#
        .SYNOPSIS
        Get list of all policies/rules

        .DESCRIPTION
        Get list of all policies (name, interface source/destination, address (network) source/destination, service, action...)

        .EXAMPLE
        Get-FGTFirewallPolicy

        Get list of all policies

        .EXAMPLE
        Get-FGTFirewallPolicy -name myPolicy

        Get Policy named myPolicy

        .EXAMPLE
        Get-FGTFirewallPolicy -policyid 23

        Get policy with id 23

        .EXAMPLE
        Get-FGTFirewallPolicy -name FGT -filter_type contains

        Get policy contains with *FGT*

        .EXAMPLE
        Get-FGTFirewallPolicy -uuid 9e73a10e-1772-51ea-a8d7-297686fd7702

        Get policy with uuid 9e73a10e-1772-51ea-a8d7-297686fd7702

        .EXAMPLE
        Get-FGTFirewallPolicy -skip

        Get list of all policies (but only relevant attributes)

        .EXAMPLE
        Get-FGTFirewallPolicy -meta

        Get list of all policies with metadata (q_...) like usage (q_ref)

        .EXAMPLE
        Get-FGTFirewallPolicy -vdom vdomX

        Get list of all policies on vdomX
    #>

    [CmdletBinding(DefaultParameterSetName = "default")]
    Param(
        [Parameter (Mandatory = $false, Position = 1, ParameterSetName = "name")]
        [string]$name,
        [Parameter (Mandatory = $false, ParameterSetName = "uuid")]
        [string]$uuid,
        [Parameter (Mandatory = $false, ParameterSetName = "policyid")]
        [string]$policyid,
        [Parameter (Mandatory = $false)]
        [Parameter (ParameterSetName = "filter")]
        [string]$filter_attribute,
        [Parameter (Mandatory = $false)]
        [Parameter (ParameterSetName = "name")]
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

        $reponse = Invoke-FGTRestMethod -uri 'api/v2/cmdb/firewall/policy' -method 'GET' -connection $connection @invokeParams
        $reponse.results
    }

    End {
    }
}

function Move-FGTFirewallPolicy {

    <#
        .SYNOPSIS
        Move a FortiGate Policy

        .DESCRIPTION
        Move a Policy/Rule object (after or before) on the FortiGate

        .EXAMPLE
        $MyFGTPolicy = Get-FGTFirewallPolicy -name MyFGTPolicy
        PS C:\>$MyFGTPolicy | Move-FGTFirewallPolicy -after -id 12

        Move Policy object $MyFGTPolicy after Policy id 12

        .EXAMPLE
        $MyFGTPolicy = Get-FGTFirewallPolicy -name MyFGTPolicy
        PS C:\>$MyFGTPolicy | Move-FGTFirewallPolicy -before -id (Get-FGTFirewallPolicy -name MyFGTPolicy23)

        Move Policy object $MyFGTPolicy before MyFGTPolicy23 (using Get-FGTFirewallPolicy)

    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'low')]
    Param(
        [Parameter (Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        [ValidateScript( { Confirm-FGTFirewallPolicy $_ })]
        [psobject]$policy,
        [Parameter(Mandatory = $true, ParameterSetName = "after")]
        [switch]$after,
        [Parameter(Mandatory = $true, ParameterSetName = "before")]
        [switch]$before,
        [Parameter(Mandatory = $true)]
        [ValidateScript( { ($_ -is [int]) -or (Confirm-FGTFirewallPolicy $_ ) })]
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

        #id is a Policy Rule (from Get-FGTFirewallPolicy) ?
        if ( $id.policyid ) {
            #Get the policyid
            [int]$id = $id.policyid
        }

        $uri = "api/v2/cmdb/firewall/policy"
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
        if ($PSCmdlet.ShouldProcess($policy.name, 'Move Firewall Policy')) {
            $null = Invoke-FGTRestMethod -method "PUT" -uri $uri -uri_escape $policy.policyid -extra $extra -connection $connection @invokeParams
        }

        Get-FGTFirewallPolicy -policyid $policy.policyid -connection $connection @invokeParams
    }

    End {
    }
}

function Set-FGTFirewallPolicy {

    <#
        .SYNOPSIS
        Configure a FortiGate Policy

        .DESCRIPTION
        Change a FortiGate Policy Policy/Rules (source port/ip, destination port, ip, action, status, security profiles...)

        .EXAMPLE
        $MyFGTPolicy = Get-FGTFirewallPolicy -name MyFGTPolicy
        PS C:\>$MyFGTPolicy | Set-FGTFirewallPolicy -srcintf port1 -srcaddr MyFGTAddress

        Change MyFGTPolicy to srcintf port1 and srcaddr MyFGTAddress

        .EXAMPLE
        $MyFGTPolicy = Get-FGTFirewallPolicy -name MyFGTPolicy
        PS C:\>$MyFGTPolicy | Set-FGTFirewallPolicy -service HTTP,HTTPS

        Change MyFGTPolicy to set service to HTTP and HTTPS

        .EXAMPLE
        $MyFGTPolicy = Get-FGTFirewallPolicy -name MyFGTPolicy
        PS C:\>$MyFGTPolicy | Set-FGTFirewallPolicy -comments "My FGT Policy"

        Change MyFGTPolicy to set a new comments

        .EXAMPLE
        $MyFGTPolicy = Get-FGTFirewallPolicy -name MyFGTPolicy
        PS C:\>$MyFGTPolicy | Set-FGTFirewallPolicy -status:$false

        Change MyFGTPolicy to set status disable

        .EXAMPLE
        $MyFGTPolicy = Get-FGTFirewallPolicy -name MyFGTPolicy
        PS C:\>$MyFGTPolicy | Set-FGTFirewallPolicy -avprofile default -webfilterprofile default -dnsfilterprofile default -applicationlist default -ipssensor default

        Change MyFGTPolicy to set Security Profile to default (AV, WebFitler, DNS Filter, App Ctrl and IPS)

        .EXAMPLE
         $data = @{"logtraffic-start"  = "enable" }
        PS C:\>$MyFGTPolicy = Get-FGTFirewallPolicy -name MyFGTPolicy
        PS C:\>$MyFGTPolicy | Set-FGTFirewallPolicy -data $color

        Change MyFGTPolicy to set logtraffic-start to enabled using -data

    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'medium', DefaultParameterSetName = 'default')]
    Param(
        [Parameter (Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        [ValidateScript( { Confirm-FGTFirewallPolicy $_ })]
        [psobject]$policy,
        [Parameter (Mandatory = $false)]
        [string]$name,
        [string[]]$srcintf,
        [Parameter (Mandatory = $false)]
        [string[]]$dstintf,
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
        [ValidateSet("disable", "utm", "all")]
        [string]$logtraffic,
        [Parameter (Mandatory = $false)]
        [string[]]$ippool,
        [Parameter (Mandatory = $false)]
        [ValidateSet("flow", "proxy")]
        [string]$inspectionmode,
        [Parameter (Mandatory = $false)]
        [string]$sslsshprofile,
        [Parameter (Mandatory = $false)]
        [string]$avprofile,
        [Parameter (Mandatory = $false)]
        [string]$webfilterprofile,
        [Parameter (Mandatory = $false)]
        [string]$dnsfilterprofile,
        [Parameter (Mandatory = $false)]
        [string]$ipssensor,
        [Parameter (Mandatory = $false)]
        [string]$applicationlist,
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

        $uri = "api/v2/cmdb/firewall/policy"

        $_policy = new-Object -TypeName PSObject

        if ( $PsBoundParameters.ContainsKey('name') ) {
            $_policy | add-member -name "name" -membertype NoteProperty -Value $name
        }

        if ( $PsBoundParameters.ContainsKey('srcintf') ) {
            # Source interface
            $srcintf_array = @()
            #TODO check if the interface (zone ?) is valid
            foreach ($intf in $srcintf) {
                $srcintf_array += @{ 'name' = $intf }
            }
            $_policy | add-member -name "srcintf" -membertype NoteProperty -Value $srcintf_array
        }

        if ( $PsBoundParameters.ContainsKey('dstintf') ) {
            # Destination interface
            $dstintf_array = @()
            #TODO check if the interface (zone ?) is valid
            foreach ($intf in $dstintf) {
                $dstintf_array += @{ 'name' = $intf }
            }
            $_policy | add-member -name "dstintf" -membertype NoteProperty -Value $dstintf_array
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

        if ( $PsBoundParameters.ContainsKey('nat') ) {
            if ($nat) {
                $_policy | add-member -name "nat" -membertype NoteProperty -Value "enable"
            }
            else {
                $_policy | add-member -name "nat" -membertype NoteProperty -Value "disable"
            }
        }
        if ( $PsBoundParameters.ContainsKey('comments') ) {
            $_policy | add-member -name "comments" -membertype NoteProperty -Value $comments
        }

        if ( $PsBoundParameters.ContainsKey('logtraffic') ) {
            $_policy | add-member -name "logtraffic" -membertype NoteProperty -Value $logtraffic
        }

        if ( $PsBoundParameters.ContainsKey('ippool') ) {
            if (-not $policy.nat -or $nat) {
                throw "You need to enable NAT (-nat)"
            }
            $ippool_array = @()
            #TODO check if the IP Pool is valid
            foreach ($i in $ippool) {
                $ippool_array += @{ 'name' = $i }
            }
            $_policy | add-member -name "ippool" -membertype NoteProperty -Value "enable"
            $_policy | add-member -name "poolname" -membertype NoteProperty -Value $ippool_array
        }

        if ( $PsBoundParameters.ContainsKey('data') ) {
            $data.GetEnumerator() | ForEach-Object {
                $_policy | Add-member -name $_.key -membertype NoteProperty -Value $_.value
            }
        }

        if ( $PsBoundParameters.ContainsKey('inspectionmode') ) {
            if ($connection.version -lt "6.2.0") {
                Throw "-inspectionmode (flow/proxy is not available before FortiOS 6.2.x)"
            }
            $_policy | add-member -name "inspection-mode" -membertype NoteProperty -Value $inspectionmode
        }

        if ( $PsBoundParameters.ContainsKey('sslsshprofile') ) {
            $_policy | add-member -name "ssl-ssh-profile" -membertype NoteProperty -Value $sslsshprofile
        }

        if ( $PsBoundParameters.ContainsKey('avprofile') ) {
            $_policy | add-member -name "av-profile" -membertype NoteProperty -Value $avprofile
        }

        if ( $PsBoundParameters.ContainsKey('webfilterprofile') ) {
            $_policy | add-member -name "webfilter-profile" -membertype NoteProperty -Value $webfilterprofile
        }

        if ( $PsBoundParameters.ContainsKey('dnsfilterprofile') ) {
            $_policy | add-member -name "dnsfilter-profile" -membertype NoteProperty -Value $dnsfilterprofile
        }

        if ( $PsBoundParameters.ContainsKey('ipssensor') ) {
            $_policy | add-member -name "ips-sensor" -membertype NoteProperty -Value $ipssensor
        }

        if ( $PsBoundParameters.ContainsKey('applicationlist') ) {
            $_policy | add-member -name "application-list" -membertype NoteProperty -Value $applicationlist
        }

        #When use Security Profile, you need to enable utm-status
        if ( $PsBoundParameters.ContainsKey('sslsshprofile') -or $PsBoundParameters.ContainsKey('avprofile') -or $PsBoundParameters.ContainsKey('webfilterprofile') -or $PsBoundParameters.ContainsKey('dnsfilterprofile') -or $PsBoundParameters.ContainsKey('ipssensor') -or $PsBoundParameters.ContainsKey('applicationlist')) {
            $_policy | add-member -name "utm-status" -membertype NoteProperty -Value "enable"
        }

        if ($PSCmdlet.ShouldProcess($address.name, 'Configure Firewall Policy')) {
            Invoke-FGTRestMethod -method "PUT" -body $_policy -uri $uri -uri_escape $policy.policyid -connection $connection @invokeParams | out-Null

            Get-FGTFirewallPolicy -connection $connection @invokeParams -policyid $policy.policyid
        }
    }

    End {
    }
}

function Remove-FGTFirewallPolicy {

    <#
        .SYNOPSIS
        Remove a FortiGate Policy

        .DESCRIPTION
        Remove a Policy/Rule object on the FortiGate

        .EXAMPLE
        $MyFGTPolicy = Get-FGTFirewallPolicy -name MyFGTPolicy
        PS C:\>$MyFGTPolicy | Remove-FGTFirewallPolicy

        Remove Policy object $MyFGTPolicy

        .EXAMPLE
        $MyFGTPolicy = Get-FGTFirewallPolicy -name MyFGTPolicy
        PS C:\>$MyFGTPolicy | Remove-FGTFirewallPolicy -confirm:$false

        Remove Policy object MyFGTPolicy with no confirmation

    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'high')]
    Param(
        [Parameter (Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        [ValidateScript( { Confirm-FGTFirewallPolicy $_ })]
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

        $uri = "api/v2/cmdb/firewall/policy"

        if ($PSCmdlet.ShouldProcess($policy.name, 'Remove Firewall Policy')) {
            $null = Invoke-FGTRestMethod -method "DELETE" -uri $uri -uri_escape $policy.policyid -connection $connection @invokeParams
        }
    }

    End {
    }
}

function Remove-FGTFirewallPolicyMember {

    <#
        .SYNOPSIS
        Remove a FortiGate Policy Member

        .DESCRIPTION
        Remove a FortiGate Policy Member (source or destination address)

        .EXAMPLE
        $MyFGTPolicy = Get-FGTFirewallPolicyGroup -name MyFGTPolicy
        PS C:\>$MyFGTPolicy | Remove-FGTFirewallPolicyGroupMember -member MyAddress1

        Remove MyAddress1 member to MyFGTPolicy

        .EXAMPLE
        $MyFGTPolicy = Get-FGTFirewallPolicyGroup -name MyFGTPolicy
        PS C:\>$MyFGTPolicy | Remove-FGTFirewallPolicyGroupMember -member MyAddress1, MyAddress2

        Remove MyAddress1 and MyAddress2 member to MyFGTPolicy

    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'medium')]
    Param(
        [Parameter (Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        [ValidateScript( { Confirm-FGTFirewallPolicy $_ })]
        [psobject]$policy,
        [Parameter(Mandatory = $false)]
        [string[]]$srcaddr,
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

        $uri = "api/v2/cmdb/firewall/policy"

        $_policy = new-Object -TypeName PSObject

        if ( $PsBoundParameters.ContainsKey('srcaddr') ) {
            #Create a new source addrarray
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
                Throw "You can't remove all members. Use Set-FGTFirewallPolicy to remove Address Group"
            }

            #if there is only One or less member force to be an array
            if ( $members.count -le 1 ) {
                $members = @($members)
            }

            $_policy | add-member -name "srcaddr" -membertype NoteProperty -Value $members
        }

        if ( $PsBoundParameters.ContainsKey('dstaddr') ) {
            #Create a new source addrarray
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
                Throw "You can't remove all members. Use Set-FGTFirewallPolicy to remove Address Group"
            }

            #if there is only One or less member force to be an array
            if ( $members.count -le 1 ) {
                $members = @($members)
            }

            $_policy | add-member -name "dstaddr" -membertype NoteProperty -Value $members
        }

        if ($PSCmdlet.ShouldProcess($policy.name, 'Remove Firewall Policy Group Member')) {
            Invoke-FGTRestMethod -method "PUT" -body $_policy -uri $uri -uri_escape $policy.policyid -connection $connection @invokeParams | Out-Null

            Get-FGTFirewallPolicy -connection $connection @invokeParams -name $addrgrp.name
        }
    }

    End {
    }
}
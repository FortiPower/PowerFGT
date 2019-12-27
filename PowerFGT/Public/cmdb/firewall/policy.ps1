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

        Add a MyFGTPolicy with source port port1 and destination port1 and source and destination all

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
    #>


    Param(
        [Parameter (Mandatory = $true)]
        [string]$name,
        [Parameter (Mandatory = $true)]
        [string[]]$srcintf,
        [Parameter (Mandatory = $true)]
        [string[]]$dstintf,
        [Parameter (Mandatory = $true)]
        [string[]]$srcaddr,
        [Parameter (Mandatory = $true)]
        [string[]]$dstaddr,
        [Parameter (Mandatory = $false)]
        [ValidateSet("accept", "deny", "learn")]
        [string]$action = "accept",
        [Parameter (Mandatory = $false)]
        [switch]$status = $true,
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

        if ( Get-FGTFirewallPolicy -connection $connection @invokeParams -name $name ) {
            Throw "Already a Policy using the same name"
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

        $policy | add-member -name "name" -membertype NoteProperty -Value $name

        $policy | add-member -name "srcintf" -membertype NoteProperty -Value $srcintf_array

        $policy | add-member -name "dstintf" -membertype NoteProperty -Value $dstintf_array

        $policy | add-member -name "srcaddr" -membertype NoteProperty -Value $srcaddr_array

        $policy | add-member -name "dstaddr" -membertype NoteProperty -Value $dstaddr_array

        $policy | add-member -name "action" -membertype NoteProperty -Value $action

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

        Invoke-FGTRestMethod -method "POST" -body $policy -uri $uri -connection $connection @invokeParams | Out-Null

        Get-FGTFirewallPolicy -name $name -connection $connection @invokeParams

    }

    End {
    }
}

function Add-FGTFirewallPolicyMember {

    <#
        .SYNOPSIS
        Add a FortiGate Policy Member

        .DESCRIPTION
        Add a FortiGate Policy Member (source or destination address)

        .EXAMPLE
        $MyFGTPolicy = Get-FGTFirewallPolicy -name MyFGTPolicy
        PS C:\>$MyFGTPolicy | Add-FGTFirewallPolicyMember -srcaddr MyAddress1

        Add MyAddress1 member to source of MyFGTPolicy

        .EXAMPLE
        $MyFGTPolicy = Get-FGTFirewallPolicy -name MyFGTPolicy
        PS C:\>$MyFGTPolicy | Add-FGTFirewallPolicyMember -dstaddr MyAddress1, MyAddress2

        Add MyAddress1 and MyAddress2 member to destination of MyFGTPolicy

    #>

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

        $uri = "api/v2/cmdb/firewall/policy/$($policy.policyid)"

        $_policy = new-Object -TypeName PSObject

        if ( $PsBoundParameters.ContainsKey('srcaddr') ) {
            #Add member to existing source address
            $members = $policy.srcaddr
            foreach ( $member in $srcaddr ) {
                $member_name = @{ }
                $member_name.add( 'name', $member)
                $members += $member_name
            }
            $_policy | add-member -name "srcaddr" -membertype NoteProperty -Value $members
        }

        if ( $PsBoundParameters.ContainsKey('dstaddr') ) {
            #Add member to existing destination address
            $members = $policy.dstaddr
            foreach ( $member in $dstaddr ) {
                $member_name = @{ }
                $member_name.add( 'name', $member)
                $members += $member_name
            }
            $_policy | add-member -name "dstaddr" -membertype NoteProperty -Value $members
        }

        Invoke-FGTRestMethod -method "PUT" -body $_policy -uri $uri -connection $connection @invokeParams | Out-Null

        Get-FGTFirewallPolicy -connection $connection @invokeParams -name $policy.name
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
        PS C:\>$MyFGTPolicy | Remove-FGTFirewallPolicy -noconfirm

        Remove Policy object MyFGTPolicy with no confirmation

    #>

    Param(
        [Parameter (Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        [ValidateScript( { Confirm-FGTFirewallPolicy $_ })]
        [psobject]$policy,
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

        $uri = "api/v2/cmdb/firewall/policy/$($policy.policyid)"

        if ( -not ( $Noconfirm )) {
            $message = "Remove Policy on Fortigate"
            $question = "Proceed with removal of Policy $($policy.name) ?"
            $choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
            $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
            $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))

            $decision = $Host.UI.PromptForChoice($message, $question, $choices, 1)
        }
        else { $decision = 0 }
        if ($decision -eq 0) {
            Write-Progress -activity "Remove Policy"
            $null = Invoke-FGTRestMethod -method "DELETE" -uri $uri -connection $connection @invokeParams
            Write-Progress -activity "Remove Policy" -completed
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
        $MyFGTPolicy = Get-FGTFirewallAddressGroup -name MyFGTPolicy
        PS C:\>$MyFGTPolicy | Remove-FGTFirewallAddressGroupMember -member MyAddress1

        Remove MyAddress1 member to MyFGTPolicy

        .EXAMPLE
        $MyFGTPolicy = Get-FGTFirewallAddressGroup -name MyFGTPolicy
        PS C:\>$MyFGTPolicy | Remove-FGTFirewallAddressGroupMember -member MyAddress1, MyAddress2

        Remove MyAddress1 and MyAddress2 member to MyFGTPolicy

    #>

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

        $uri = "api/v2/cmdb/firewall/policy/$($policy.policyid)"

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

            $_policy | add-member -name "dstaddr" -membertype NoteProperty -Value $members
        }

        Invoke-FGTRestMethod -method "PUT" -body $_policy -uri $uri -connection $connection @invokeParams | Out-Null

        Get-FGTFirewallPolicy -connection $connection @invokeParams -name $addrgrp.name
    }

    End {
    }
}
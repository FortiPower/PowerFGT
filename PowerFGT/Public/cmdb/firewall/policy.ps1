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
        Add-FGTFirewallPolicy -name test_policy -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all

        Add a Test_policy with source port port1 and destination port1 and source and destination all

        .EXAMPLE
        Add-FGTFirewallPolicy -name test_policy -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all -nat

        Add a Test_policy with NAT is enable

        .EXAMPLE
        Add-FGTFirewallPolicy -name test_policy -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all -action "deny"

        Add a Test_policy with action is Deny

        .EXAMPLE
        Add-FGTFirewallPolicy -name test_policy -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all -status:$false

        Add a Test_policy with status is disable

        .EXAMPLE
        Add-FGTFirewallPolicy -name test_policy -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all -service "HTTP, HTTPS, SSH"

        Add a Test_policy with multiple service port

        .EXAMPLE
        Add-FGTFirewallPolicy -name test_policy -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all -schedule workhour

        Add a Test_policy with schedule is workhour

    #>


    Param(
        [Parameter (Mandatory = $true)]
        [string]$name,
        [Parameter (Mandatory = $true)]
        [string]$srcintf,
        [Parameter (Mandatory = $true)]
        [string]$dstintf,
        [Parameter (Mandatory = $true)]
        [string]$srcaddr,
        [Parameter (Mandatory = $true)]
        [string]$dstaddr,
        [Parameter (Mandatory = $false)]
        [ValidateSet("accept", "deny", "learn")]
        [string]$action = "accept",
        [Parameter (Mandatory = $false)]
        [switch]$status = $true,
        [Parameter (Mandatory = $false)]
        [string]$schedule = "always",
        [Parameter (Mandatory = $false)]
        [string]$service = "ALL",
        [Parameter (Mandatory = $false)]
        [switch]$nat = $false,
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

        # SOURCE INTERFACE
        $arr = $srcintf -split ', '
        $countarr = $arr.count
        $line = 0
        while ($line -ne $countarr) {

            New-Variable -Name "srcintf_array$line" -Value $arr[$line]
            $temp = Get-Variable -Name "srcintf_array$line" -ValueOnly
            $temp = new-Object -TypeName PSObject
            $temp | add-member -name "name" -membertype NoteProperty -Value $arr[$line]
            [array]$srcintf_array_array += $temp
            $line = $line + 1

        }

        # DESTINATION INTERFACE
        $arr = $dstintf -split ', '
        $countarr = $arr.count
        $line = 0
        while ($line -ne $countarr) {

            New-Variable -Name "dstintf_array$line" -Value $arr[$line]
            $temp = Get-Variable -Name "dstintf_array$line" -ValueOnly
            $temp = new-Object -TypeName PSObject
            $temp | add-member -name "name" -membertype NoteProperty -Value $arr[$line]
            [array]$dstintf_array_array += $temp
            $line = $line + 1

        }

        # SOURCE ADDRESSE
        $arr = $srcaddr -split ', '
        $countarr = $arr.count
        $line = 0
        while ($line -ne $countarr) {

            New-Variable -Name "srcaddr_array$line" -Value $arr[$line]
            $temp = Get-Variable -Name "srcaddr_array$line" -ValueOnly
            $temp = new-Object -TypeName PSObject
            $temp | add-member -name "name" -membertype NoteProperty -Value $arr[$line]
            [array]$srcaddr_array_array += $temp
            $line = $line + 1

        }

        # DESTINATION ADDRESSE
        $arr = $dstaddr -split ', '
        $countarr = $arr.count
        $line = 0
        while ($line -ne $countarr) {

            New-Variable -Name "dstaddr_array$line" -Value $arr[$line]
            $temp = Get-Variable -Name "dstaddr_array$line" -ValueOnly
            $temp = new-Object -TypeName PSObject
            $temp | add-member -name "name" -membertype NoteProperty -Value $arr[$line]
            [array]$dstaddr_array_array += $temp
            $line = $line + 1

        }

        # SERVICE
        $arr = $service -split ', '
        $countarr = $arr.count
        $line = 0
        while ($line -ne $countarr) {

            New-Variable -Name "service_array$line" -Value $arr[$line]
            $temp = Get-Variable -Name "service_array$line" -ValueOnly
            $temp = new-Object -TypeName PSObject
            $temp | add-member -name "name" -membertype NoteProperty -Value $arr[$line]
            [array]$service_array_array += $temp
            $line = $line + 1

        }

        $policy = new-Object -TypeName PSObject

        $policy | add-member -name "name" -membertype NoteProperty -Value $name

        $policy | add-member -name "srcintf" -membertype NoteProperty -Value $srcintf_array_array

        $policy | add-member -name "dstintf" -membertype NoteProperty -Value $dstintf_array_array

        $policy | add-member -name "srcaddr" -membertype NoteProperty -Value $srcaddr_array_array

        $policy | add-member -name "dstaddr" -membertype NoteProperty -Value $dstaddr_array_array

        $policy | add-member -name "action" -membertype NoteProperty -Value $action

        if ($status) {
            $policy | add-member -name "status" -membertype NoteProperty -Value "enable"
        }
        else {
            $policy | add-member -name "status" -membertype NoteProperty -Value "disable"
        }

        $policy | add-member -name "schedule" -membertype NoteProperty -Value $schedule

        $policy | add-member -name "service" -membertype NoteProperty -Value $service_array_array

        if ($nat) {
            $policy | add-member -name "nat" -membertype NoteProperty -Value "enable"
        }
        else {

            $policy | add-member -name "nat" -membertype NoteProperty -Value "disable"
        }

        Invoke-FGTRestMethod -method "POST" -body $policy -uri $uri -connection $connection @invokeParams | out-Null

        Get-FGTFirewallPolicy -name $name -connection $connection @invokeParams

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
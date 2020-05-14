#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
# Copyright 2019, Benjamin Perrier <ben dot perrier at outlook dot com>
#
# SPDX-License-Identifier: Apache-2.0
#
function Add-FGTFirewallVip {

    <#
        .SYNOPSIS
        Add a FortiGate Virtual IP

        .DESCRIPTION
        Add a FortiGate Virtual IP (VIP) (One to One)

        .EXAMPLE
        Add-FGTFirewallVip -name myVIP1 -type static-nat -extip 192.0.2.1 -mappedip 198.51.100.1

        Add VIP objet type static-nat (One to One) with name myVIP1 with external IP 192.0.2.1 and mapped IP 198.51.100.1

        .EXAMPLE
        Add-FGTFirewallVip -name myVIP2 -type static-nat -extip 192.0.2.2 -mappedip 198.51.100.2 -interface port1 -comment "My FGT VIP"

        Add VIP objet type static-nat (One to One) with name myVIP1 with external IP 192.0.2.1, mapped IP 198.51.100.1, associated to interface port2 and a comment

        .EXAMPLE
        Add-FGTFirewallVip -name myVIP3-8080 -type static-nat -extip 192.0.2.1 -mappedip 198.51.100.1 -portforward -extport 8080

        Add VIP objet type static-nat (One to One) with name myVIP3 with external IP 192.0.2.1 and mapped IP 198.51.100.1 with Port Forward and TCP Port 8080

        .EXAMPLE
        Add-FGTFirewallVip -name myVIP4-5000-6000 -type static-nat -extip 192.0.2.1 -mappedip 198.51.100.1 -portforward -extport 5000 -mappedport 6000 -protocol udp

        Add VIP objet type static-nat (One to One) with name myVIP3 with external IP 192.0.2.1 and mapped IP 198.51.100.1 with Port Forward and UDP Port 5000 mapped to port 6000

    #>

    Param(
        [Parameter (Mandatory = $true)]
        [ValidateSet("static-nat")]
        [string]$type,
        [Parameter (Mandatory = $true)]
        [string]$name,
        [Parameter (Mandatory = $true)]
        [ipaddress]$extip,
        [Parameter (Mandatory = $true)]
        [ipaddress]$mappedip,
        [Parameter (Mandatory = $false)]
        [string]$interface = "any",
        [Parameter (Mandatory = $false)]
        [ValidateLength(0, 255)]
        [string]$comment,
        [Parameter (Mandatory = $false)]
        [switch]$portforward,
        [Parameter (Mandatory = $false)]
        [ValidateSet("TCP", "UDP", "SCTP", "ICMP")]
        [string]$protocol = "TCP",
        [Parameter (Mandatory = $false)]
        [string]$extport,
        [Parameter (Mandatory = $false)]
        [string]$mappedport,
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

        if ( Get-FGTFirewallVip -connection $connection @invokeParams -name $name ) {
            Throw "Already a VIP object using the same name"
        }

        $uri = "api/v2/cmdb/firewall/vip"

        $vip = new-Object -TypeName PSObject

        $vip | add-member -name "name" -membertype NoteProperty -Value $name

        $vip | add-member -name "type" -membertype NoteProperty -Value $type

        $vip | add-member -name "extip" -membertype NoteProperty -Value $extip.ToString()

        $range = New-Object -TypeName PSObject

        $range | Add-member -name "range" -membertype NoteProperty -value $mappedip.ToString()
        $vip | add-member -name "mappedip" -membertype NoteProperty -Value @($range)

        #TODO check if the interface (zone ?) is valid
        $vip | add-member -name "extintf" -membertype NoteProperty -Value $interface

        if ( $PsBoundParameters.ContainsKey('comment') ) {
            $vip | add-member -name "comment" -membertype NoteProperty -Value $comment
        }

        if ( $PsBoundParameters.ContainsKey('portforward') -and $portforward -eq $true) {
            #check if export is set before...
            if ( $extport -eq "") {
                throw "you need to set -extport when enable portforward parameter"
            }
            $vip | add-member -name "portforward" -membertype NoteProperty -Value "enable"
            $vip | add-member -name "protocol" -membertype NoteProperty -Value $protocol
            $vip | add-member -name "extport" -membertype NoteProperty -Value $extport
            #if no mappedport use the extport
            if ( $PsBoundParameters.ContainsKey('mappedport') ) {
                $vip | add-member -name "mappedport" -membertype NoteProperty -Value $mappedport
            }
            else {
                $vip | add-member -name "mappedport" -membertype NoteProperty -Value $extport
            }
        }

        Invoke-FGTRestMethod -method "POST" -body $vip -uri $uri -connection $connection @invokeParams | Out-Null

        Get-FGTFirewallVip -connection $connection @invokeParams -name $name
    }

    End {
    }
}
function Get-FGTFirewallVip {

    <#
        .SYNOPSIS
        Get list of all (NAT) Virtual IP

        .DESCRIPTION
        Get list of all (NAT) Virtual IP (Ext IP, mapped IP, type...)

        .EXAMPLE
        Get-FGTFirewallVip

        Get list of all nat vip object

        .EXAMPLE
        Get-FGTFirewallVip -name myFGTVip

        Get VIP named myFGTVip

        .EXAMPLE
        Get-FGTFirewallVip -name FGT -filter_type contains

        Get VIP contains *FGT*

        .EXAMPLE
        Get-FGTFirewallVip -uuid 9e73a10e-1772-51ea-a8d7-297686fd7702

        Get VIP with uuid 9e73a10e-1772-51ea-a8d7-297686fd7702

        .EXAMPLE
        Get-FGTFirewallVip -skip

        Get list of all nat vip object (but only relevant attributes)

        .EXAMPLE
        Get-FGTFirewallVip -vdom vdomX

        Get list of all nat vip object on vdomX
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

        $response = Invoke-FGTRestMethod -uri 'api/v2/cmdb/firewall/vip' -method 'GET' -connection $connection @invokeParams

        $response.results
    }

    End {
    }
}

function Remove-FGTFirewallVip {

    <#
        .SYNOPSIS
        Remove a FortiGate Virtual IP

        .DESCRIPTION
        Remove a Virtual (VIP) object on the FortiGate

        .EXAMPLE
        $MyFGTVIP = Get-FGTFirewallVip -name MyFGTVIP
        PS C:\>$MyFGTVIP | Remove-FGTFirewallVip

        Remove VIP object $MyFGTVIP

        .EXAMPLE
        $MyFGTVIP = Get-FGTFirewallVip -name MyFGTVIP
        PS C:\>$MyFGTVIP | Remove-FGTFirewallVip -noconfirm

        Remove VIP object MyFGTVIP with no confirmation

    #>

    Param(
        [Parameter (Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        [ValidateScript( { Confirm-FGTVip $_ })]
        [psobject]$vip,
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

        $uri = "api/v2/cmdb/firewall/vip/$($vip.name)"

        if ( -not ( $Noconfirm )) {
            $message = "Remove VIP on Fortigate"
            $question = "Proceed with removal of VIP $($vip.name) ?"
            $choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
            $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
            $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))

            $decision = $Host.UI.PromptForChoice($message, $question, $choices, 1)
        }
        else { $decision = 0 }
        if ($decision -eq 0) {
            Write-Progress -activity "Remove VIP"
            $null = Invoke-FGTRestMethod -method "DELETE" -uri $uri -connection $connection @invokeParams
            Write-Progress -activity "Remove VIP" -completed
        }
    }

    End {
    }
}
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
        Add-FGTFirewallVip -name myVIP1 -type static-nat -extip 192.2.0.1 -mappedip 198.51.100.1

        Add VIP objet type static-nat (One to One ) with name myVIP1 with external IP 192.2.0.1 and mapped IP 198.51.100.1

        .EXAMPLE
        Add-FGTFirewallVip -name myVIP2 -type static-nat -extip 192.2.0.2 -mappedip 198.51.100.2 -interface port1 -comment "My FGT VIP"

        Add VIP objet type static-nat (One to One ) with name myVIP1 with external IP 192.2.0.1, mapped IP 198.51.100.1, associated to interface port2 and a comment

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

        Invoke-FGTRestMethod -method "POST" -body $vip -uri $uri -connection $connection @invokeParams | out-Null

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
        Get-FGTFirewallVip -match FGT

        Get VIP match with *FGT*

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
        [Parameter (Mandatory = $false, ParameterSetName = "match")]
        [string]$match,
        [Parameter(Mandatory = $false)]
        [switch]$skip,
        [Parameter(Mandatory = $false)]
        [String[]]$vdom,
        [Parameter(Mandatory = $false)]
        [psobject]$connection=$DefaultFGTConnection
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

        $response = Invoke-FGTRestMethod -uri 'api/v2/cmdb/firewall/vip' -method 'GET' -connection $connection @invokeParams

        switch ( $PSCmdlet.ParameterSetName ) {
            "name" { $response.results | where-object { $_.name -eq $name } }
            "match" { $response.results | where-object { $_.name -match $match } }
            default { $response.results }
        }

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
        [ValidateScript( { ValidateFGTVip $_ })]
        [psobject]$vip,
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
#
# Copyright 2022, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
# Copyright 2022, Cédric Moreau <moreaucedric0 dot gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

function Add-FGTWebfilterUrlfilter {

    <#
        .SYNOPSIS
        Add a FortiGate URL Filter

        .DESCRIPTION
        Add a FortiGate URL Filter

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
        [Parameter (Mandatory = $false)]
        [string]$id,
        [Parameter (Mandatory = $false)]
        [string]$name,
        [Parameter (Mandatory = $false)]
        [string]$url_id,
        [Parameter (Mandatory = $false)]
        [string]$url_type,
        [Parameter (Mandatory = $false)]
        [string]$url,
        [Parameter (Mandatory = $false)]
        [string]$action,
        [Parameter (Mandatory = $false)]
        [switch]$status,
        [Parameter (Mandatory = $false)]
        [string]$exempt,
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

        if ( Get-FGTWebfilterUrlfilter -connection $connection @invokeParams -name $name ) {
            Throw "Already a VIP object using the same name"
        }

        $uri = "api/v2/cmdb/webfilter/urlfilter"

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

function Get-FGTWebfilterUrlfilter {

    <#
        .SYNOPSIS
        Get list of all URL Filter

        .DESCRIPTION
        Get list of all URL Filter (URL, actions, etc ...)

        .EXAMPLE
        Get-FGTWebfilterUrlfilter

        Get list of all all URL Filter

        .EXAMPLE
        Get-FGTWebfilterUrlfilter -name myFGTURLFilter

        Get URL Filter named myFGTURLFilter

        .EXAMPLE
        Get-FGTWebfilterUrlfilter -name FGT -filter_type contains

        Get URL Filter contains *FGT*

        .EXAMPLE
        Get-FGTWebfilterUrlfilter -id 1

        Get URL Filter with id 1

        .EXAMPLE
        Get-FGTWebfilterUrlfilter -skip

        Get list of all URL Filter but only the relevant attributes

        .EXAMPLE
        Get-FGTWebfilterUrlfilter -vdom vdomX

        Get list of all URL Filter object on vdomX
    #>

    [CmdletBinding(DefaultParameterSetName = "default")]
    Param(
        [Parameter (Mandatory = $false, Position = 1, ParameterSetName = "name")]
        [string]$name,
        [Parameter (Mandatory = $false, ParameterSetName = "uuid")]
        [string]$id,
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
            "id" {
                $filter_value = $id
                $filter_attribute = "id"
            }
            default { }
        }

        #if filter value and filter_attribute, add filter (by default filter_type is equal)
        if ( $filter_value -and $filter_attribute ) {
            $invokeParams.add( 'filter_value', $filter_value )
            $invokeParams.add( 'filter_attribute', $filter_attribute )
            $invokeParams.add( 'filter_type', $filter_type )
        }

        $response = Invoke-FGTRestMethod -uri 'api/v2/cmdb/webfilter/urlfilter' -method 'GET' -connection $connection @invokeParams

        $response.results
    }

    End {
    }
}

function Set-FGTWebfilterUrlfilter {

    <#
        .SYNOPSIS
        Configure a FortiGate URL Filter

        .DESCRIPTION
        Change a FortiGate Address (ip, mask, comment, associated interface... )

        .EXAMPLE
        $MyFGTAddress = Get-FGTFirewallAddress -name MyFGTAddress
        PS C:\>$MyFGTAddress | Set-FGTFirewallAddress -ip 192.0.2.0 -mask 255.255.255.0

        Change MyFGTAddress to value (ip and mask) 192.0.2.0/24

        .EXAMPLE
        $MyFGTAddress = Get-FGTFirewallAddress -name MyFGTAddress
        PS C:\>$MyFGTAddress | Set-FGTFirewallAddress -ip 192.0.2.1

        Change MyFGTAddress to value (ip) 192.0.2.1

        .EXAMPLE
        $MyFGTAddress = Get-FGTFirewallAddress -name MyFGTAddress
        PS C:\>$MyFGTAddress | Set-FGTFirewallAddress -interface port1

        Change MyFGTAddress to set associated interface to port 1

        .EXAMPLE
        $MyFGTAddress = Get-FGTFirewallAddress -name MyFGTAddress
        PS C:\>$MyFGTAddress | Set-FGTFirewallAddress -comment "My FGT Address" -visibility:$false

        Change MyFGTAddress to set a new comment and disabled visibility

        .EXAMPLE
        $MyFGTAddress = Get-FGTFirewallAddress -name MyFGTAddress
        PS C:\>$MyFGTAddress | Set-FGTFirewallAddress -fqdn fortipower.github.io

        Change MyFGTAddress to set a new fqdn fortipower.github.io

        .EXAMPLE
        $MyFGTAddress = Get-FGTFirewallAddress -name MyFGTAddress
        PS C:\>$MyFGTAddress | Set-FGTFirewallAddress -startip 192.0.2.100

        Change MyFGTAddress to set a new startip (iprange) 192.0.2.100

        .EXAMPLE
        $MyFGTAddress = Get-FGTFirewallAddress -name MyFGTAddress
        PS C:\>$MyFGTAddress | Set-FGTFirewallAddress -endip 192.0.2.200

        Change MyFGTAddress to set a new endip (iprange) 192.0.2.200

    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'medium', DefaultParameterSetName = 'default')]
    Param(
        [Parameter (Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        #[ValidateScript({ Confirm-FGTWebfilterUrlfilter $_ })]
        [psobject]$urlfilter,
        [Parameter (Mandatory = $false)]
        [ValidateLength(0, 63)]
        [string]$name,
        [Parameter (Mandatory = $false)]
        [ValidateLength(0, 255)]
        [string]$comment,
        [Parameter (Mandatory = $false)]
        [ValidateRange(0, 4294967295)]
        [string]$url_id,
        [Parameter (Mandatory = $false)]
        [ValidateSet("simple","regex","wildcard")]
        [string]$url_type,
        [Parameter (Mandatory = $false)]
        [ValidateLength(0, 511)]
        [string]$url,
        [Parameter (Mandatory = $false)]
        [ValidateSet("block","allow","monitor")]
        [string]$action,
        [Parameter (Mandatory = $false)]
        [ValidateSet("enable","disable")]
        [string]$status,
        [Parameter (Mandatory = $false)]
        [ValidateSet("av","web-content","activex-java-cookie","dlp","fortiguard","range-block","pass","antiphish","all")]
        [string]$exempt,
        [Parameter (Mandatory = $false)]
        [boolean]$visibility,
        [Parameter (Mandatory = $false)]
        [String[]]$vdom,
        [Parameter (Mandatory = $false)]
        [psobject]$connection = $DefaultFGTConnection
    )

    Begin {
    }

    Process {

        $invokeParams = @{ }
        if ( $PsBoundParameters.ContainsKey('vdom') ) {
            $invokeParams.add( 'vdom', $vdom )
        }

        $uri = "api/v2/cmdb/webfilter/urlfilter/$($urlfilter.id)"

        $_urlfilter = new-Object -TypeName PSObject

        if ( $PsBoundParameters.ContainsKey('name') ) {
            #TODO check if there is no already a object with this name ?
            $_urlfilter | add-member -name "name" -membertype NoteProperty -Value $name
            $urlfilter.name = $name
        }

        if ( $PsBoundParameters.ContainsKey('comment') ) {
            $_urlfilter | add-member -name "comment" -membertype NoteProperty -Value $comment
        }

        $_entry = new-Object -TypeName PSObject

        if ( $PsBoundParameters.ContainsKey('url_id') ) {
            $_entry | add-member -name "id" -membertype NoteProperty -Value $url_id
        }

        if ( $PsBoundParameters.ContainsKey('url_type') ) {
            $_entry | add-member -name "type" -membertype NoteProperty -Value $url_type
        }

        if ( $PsBoundParameters.ContainsKey('url') ) {
            $_entry | add-member -name "url" -membertype NoteProperty -Value $url
        }

        if ( $PsBoundParameters.ContainsKey('action') ) {
            $_entry | add-member -name "action" -membertype NoteProperty -Value $action
        }

        if ( $PsBoundParameters.ContainsKey('status') ) {
            $_entry | add-member -name "status" -membertype NoteProperty -Value $status
        }

        if ( $PsBoundParameters.ContainsKey('exempt') ) {
            $_entry | add-member -name "exempt" -membertype NoteProperty -Value $exempt
        }

        $urlfilter.entries += $_entry

        $_urlfilter | add-member -name "entries" -membertype NoteProperty -Value $urlfilter.entries

        if ( $PsBoundParameters.ContainsKey('visibility') ) {
            #with 6.4.x, there is no longer visibility parameter
            if ($connection.version -ge "6.4.0") {
                Write-Warning "-visibility parameter is no longer available with FortiOS 6.4.x and after"
            }
            else {
                if ( $visibility ) {
                    $_urlfilter | add-member -name "visibility" -membertype NoteProperty -Value "enable"
                }
                else {
                    $_urlfilter | add-member -name "visibility" -membertype NoteProperty -Value "disable"
                }
            }
        }

        if ($PSCmdlet.ShouldProcess($urlfilter.name, 'Configure URL FIlter entry')) {
            Invoke-FGTRestMethod -method "PUT" -body $_urlfilter -uri $uri -connection $connection @invokeParams | out-Null

            Get-FGTFirewallAddress -connection $connection @invokeParams -name $urlfilter.name
        }
    }

    End {
    }
}
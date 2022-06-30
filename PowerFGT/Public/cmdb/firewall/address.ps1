#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
# Copyright 2019, Benjamin Perrier <ben dot perrier at outlook dot com>
#
# SPDX-License-Identifier: Apache-2.0
#
function Add-FGTFirewallAddress {

    <#
        .SYNOPSIS
        Add a FortiGate Address

        .DESCRIPTION
        Add a FortiGate Address (ipmask, iprange, fqdn)

        .EXAMPLE
        Add-FGTFirewallAddress -Name FGT -ip 192.0.2.0 -mask 255.255.255.0

        Add Address object type ipmask with name FGT and value 192.0.2.0/24

        .EXAMPLE
        Add-FGTFirewallAddress -Name FGT -ip 192.0.2.0 -mask 255.255.255.0 -interface port2

        Add Address object type ipmask with name FGT, value 192.0.2.0/24 and associated to interface port2

        .EXAMPLE
        Add-FGTFirewallAddress -Name FGT -ip 192.0.2.0 -mask 255.255.255.0 -comment "My FGT Address"

        Add Address object type ipmask with name FGT, value 192.0.2.0/24 and a comment

        .EXAMPLE
        Add-FGTFirewallAddress -Name FGT -ip 192.0.2.0 -mask 255.255.255.0 -visibility:$false

        Add Address object type ipmask with name FGT, value 192.0.2.0/24 and disabled visibility

        .EXAMPLE
        Add-FGTFirewallAddress -Name FortiPower -fqdn fortipower.github.io

        Add Address object type fqdn with name FortiPower and value fortipower.github.io

        .EXAMPLE
        Add-FGTFirewallAddress -Name FGT-Range -startip 192.0.2.1 -endip 192.0.2.100

        Add Address object type iprange with name FGT-Range with start IP 192.0.2.1 and end ip 192.0.2.100

        .EXAMPLE
        Add-FGTFirewallAddress -Name FGT-Country-FR -country FR

        Add Address object type geo (country) with name FGT-Country-FR and value FR (France)

    #>

    Param(
        [Parameter (Mandatory = $true)]
        [string]$name,
        [Parameter (Mandatory = $false, ParameterSetName = "fqdn")]
        [string]$fqdn,
        [Parameter (Mandatory = $false, ParameterSetName = "ipmask")]
        [ipaddress]$ip,
        [Parameter (Mandatory = $false, ParameterSetName = "ipmask")]
        [ipaddress]$mask,
        [Parameter (Mandatory = $false, ParameterSetName = "iprange")]
        [ipaddress]$startip,
        [Parameter (Mandatory = $false, ParameterSetName = "iprange")]
        [ipaddress]$endip,
        [Parameter (Mandatory = $false, ParameterSetName = "geography")]
        [string]$country,
        [Parameter (Mandatory = $false)]
        [string]$interface,
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

        if ( Get-FGTFirewallAddress @invokeParams -name $name -connection $connection) {
            Throw "Already an address object using the same name"
        }

        $uri = "api/v2/cmdb/firewall/address"

        $address = new-Object -TypeName PSObject

        $address | add-member -name "name" -membertype NoteProperty -Value $name

        switch ( $PSCmdlet.ParameterSetName ) {
            "ipmask" {
                $address | add-member -name "type" -membertype NoteProperty -Value "ipmask"
                $subnet = $ip.ToString()
                $subnet += "/"
                $subnet += $mask.ToString()
                $address | add-member -name "subnet" -membertype NoteProperty -Value $subnet
            }
            "iprange" {
                $address | add-member -name "type" -membertype NoteProperty -Value "iprange"
                $address | add-member -name "start-ip" -membertype NoteProperty -Value $startip.ToString()
                $address | add-member -name "end-ip" -membertype NoteProperty -Value $endip.ToString()
            }
            "fqdn" {
                $address | add-member -name "type" -membertype NoteProperty -Value "fqdn"
                $address | add-member -name "fqdn" -membertype NoteProperty -Value $fqdn
            }
            "geography" {
                $address | add-member -name "type" -membertype NoteProperty -Value "geography"
                $address | add-member -name "country" -membertype NoteProperty -Value $country
            }
            default { }
        }

        if ( $PsBoundParameters.ContainsKey('interface') ) {
            #TODO check if the interface (zone ?) is valid
            $address | add-member -name "associated-interface" -membertype NoteProperty -Value $interface
        }

        if ( $PsBoundParameters.ContainsKey('comment') ) {
            $address | add-member -name "comment" -membertype NoteProperty -Value $comment
        }

        if ( $PsBoundParameters.ContainsKey('visibility') ) {
            #with 6.4.x, there is no longer visibility parameter
            if ($connection.version -ge "6.4.0") {
                Write-Warning "-visibility parameter is no longer available with FortiOS 6.4.x and after"
            }
            else {
                if ( $visibility ) {
                    $address | add-member -name "visibility" -membertype NoteProperty -Value "enable"
                }
                else {
                    $address | add-member -name "visibility" -membertype NoteProperty -Value "disable"
                }
            }
        }

        Invoke-FGTRestMethod -method "POST" -body $address -uri $uri -connection $connection @invokeParams | out-Null

        Get-FGTFirewallAddress -connection $connection @invokeParams -name $name
    }

    End {
    }
}

function Copy-FGTFirewallAddress {

    <#
        .SYNOPSIS
        Copy/Clone a FortiGate Address

        .DESCRIPTION
        Copy/Clone a FortiGate Address (ip, mask, comment, associated interface... )

        .EXAMPLE
        $MyFGTAddress = Get-FGTFirewallAddress -name MyFGTAddress
        PS C:\>$MyFGTAddress | Copy-FGTFirewallAddress -name MyFGTAddress_copy

        Copy / Clone MyFGTAddress and name MyFGTAddress_copy

    #>

    Param(
        [Parameter (Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        [ValidateScript( { Confirm-FGTAddress $_ })]
        [psobject]$address,
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

        $uri = "api/v2/cmdb/firewall/address/$($address.name)/?action=clone&nkey=$($name)"

        Invoke-FGTRestMethod -method "POST" -uri $uri -connection $connection @invokeParams | out-Null

        Get-FGTFirewallAddress -connection $connection @invokeParams -name $name
    }

    End {
    }
}

function Get-FGTFirewallAddress {

    <#
        .SYNOPSIS
        Get list of all "address"

        .DESCRIPTION
        Get list of all "address" (ipmask, iprange, fqdn...)

        .EXAMPLE
        Get-FGTFirewallAddress

        Get list of all address object

        .EXAMPLE
        Get-FGTFirewallAddress -name myFGTAddress

        Get address named myFGTAddress

        .EXAMPLE
        Get-FGTFirewallAddress -name FGT -filter_type contains

        Get address contains with *FGT*

        .EXAMPLE
        Get-FGTFirewallAddress -uuid 9e73a10e-1772-51ea-a8d7-297686fd7702

        Get address with uuid 9e73a10e-1772-51ea-a8d7-297686fd7702

        .EXAMPLE
        Get-FGTFirewallAddress -skip

        Get list of all address object (but only relevant attributes)

        .EXAMPLE
        Get-FGTFirewallAddress -vdom vdomX

        Get list of all address on VdomX

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

        $response = Invoke-FGTRestMethod -uri 'api/v2/cmdb/firewall/address' -method 'GET' -connection $connection @invokeParams

        $response.results

    }

    End {
    }

}

function Set-FGTFirewallAddress {

    <#
        .SYNOPSIS
        Configure a FortiGate Address

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

        .EXAMPLE
        $MyFGTAddress = Get-FGTFirewallAddress -name MyFGTAddress
        PS C:\>$MyFGTAddress | Set-FGTFirewallAddress -country FR

        Change MyFGTAddress to set a new country (geo) FR (France)

    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'medium', DefaultParameterSetName = 'default')]
    Param(
        [Parameter (Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        [ValidateScript( { Confirm-FGTAddress $_ })]
        [psobject]$address,
        [Parameter (Mandatory = $false)]
        [string]$name,
        [Parameter (Mandatory = $false, ParameterSetName = "fqdn")]
        [string]$fqdn,
        [Parameter (Mandatory = $false, ParameterSetName = "ipmask")]
        [ipaddress]$ip,
        [Parameter (Mandatory = $false, ParameterSetName = "ipmask")]
        [ipaddress]$mask,
        [Parameter (Mandatory = $false, ParameterSetName = "iprange")]
        [ipaddress]$startip,
        [Parameter (Mandatory = $false, ParameterSetName = "iprange")]
        [ipaddress]$endip,
        [Parameter (Mandatory = $false, ParameterSetName = "geography")]
        [string]$country,
        [Parameter (Mandatory = $false)]
        [string]$interface,
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

        $uri = "api/v2/cmdb/firewall/address/$($address.name)"

        $_address = new-Object -TypeName PSObject

        if ( $PsBoundParameters.ContainsKey('name') ) {
            #TODO check if there is no already a object with this name ?
            $_address | add-member -name "name" -membertype NoteProperty -Value $name
            $address.name = $name
        }

        if ( $PSCmdlet.ParameterSetName -ne "default" -and $address.type -ne $PSCmdlet.ParameterSetName ) {
            throw "Address type ($($address.type)) need to be on the same type ($($PSCmdlet.ParameterSetName))"
        }

        switch ( $PSCmdlet.ParameterSetName ) {
            "ipmask" {
                if ( $PsBoundParameters.ContainsKey('ip') -or $PsBoundParameters.ContainsKey('mask') ) {
                    if ( $PsBoundParameters.ContainsKey('ip') ) {
                        $subnet = $ip.ToString()
                    }
                    else {
                        $subnet = ($address.subnet -split ' ')[0]
                    }

                    $subnet += "/"

                    if ( $PsBoundParameters.ContainsKey('mask') ) {
                        $subnet += $mask.ToString()
                    }
                    else {
                        $subnet += ($address.subnet -split ' ')[1]
                    }

                    $_address | add-member -name "subnet" -membertype NoteProperty -Value $subnet
                }
            }
            "iprange" {
                if ( $PsBoundParameters.ContainsKey('startip') ) {
                    $_address | add-member -name "start-ip" -membertype NoteProperty -Value $startip.ToString()
                }

                if ( $PsBoundParameters.ContainsKey('endip') ) {
                    $_address | add-member -name "end-ip" -membertype NoteProperty -Value $endip.ToString()
                }
            }
            "fqdn" {
                if ( $PsBoundParameters.ContainsKey('fqdn') ) {
                    $_address | add-member -name "fqdn" -membertype NoteProperty -Value $fqdn
                }
            }
            "geography" {
                if ( $PsBoundParameters.ContainsKey('country') ) {
                    $_address | add-member -name "country" -membertype NoteProperty -Value $country
                }
            }
            default { }
        }

        if ( $PsBoundParameters.ContainsKey('interface') ) {
            #TODO check if the interface (zone ?) is valid
            $_address | add-member -name "associated-interface" -membertype NoteProperty -Value $interface
        }

        if ( $PsBoundParameters.ContainsKey('comment') ) {
            $_address | add-member -name "comment" -membertype NoteProperty -Value $comment
        }

        if ( $PsBoundParameters.ContainsKey('visibility') ) {
            #with 6.4.x, there is no longer visibility parameter
            if ($connection.version -ge "6.4.0") {
                Write-Warning "-visibility parameter is no longer available with FortiOS 6.4.x and after"
            }
            else {
                if ( $visibility ) {
                    $_address | add-member -name "visibility" -membertype NoteProperty -Value "enable"
                }
                else {
                    $_address | add-member -name "visibility" -membertype NoteProperty -Value "disable"
                }
            }
        }

        if ($PSCmdlet.ShouldProcess($address.name, 'Configure Firewall Address')) {
            Invoke-FGTRestMethod -method "PUT" -body $_address -uri $uri -connection $connection @invokeParams | out-Null

            Get-FGTFirewallAddress -connection $connection @invokeParams -name $address.name
        }
    }

    End {
    }
}

function Remove-FGTFirewallAddress {

    <#
        .SYNOPSIS
        Remove a FortiGate Address

        .DESCRIPTION
        Remove an address object on the FortiGate

        .EXAMPLE
        $MyFGTAddress = Get-FGTFirewallAddress -name MyFGTAddress
        PS C:\>$MyFGTAddress | Remove-FGTFirewallAddress

        Remove address object $MyFGTAddress

        .EXAMPLE
        $MyFGTAddress = Get-FGTFirewallAddress -name MyFGTAddress
        PS C:\>$MyFGTAddress | Remove-FGTFirewallAddress -confirm:$false

        Remove address object $MyFGTAddress with no confirmation

    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'high')]
    Param(
        [Parameter (Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        [ValidateScript( { Confirm-FGTAddress $_ })]
        [psobject]$address,
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

        $uri = "api/v2/cmdb/firewall/address/$($address.name)"

        if ($PSCmdlet.ShouldProcess($address.name, 'Remove Firewall Address')) {
            $null = Invoke-FGTRestMethod -method "DELETE" -uri $uri -connection $connection @invokeParams
        }
    }

    End {
    }
}

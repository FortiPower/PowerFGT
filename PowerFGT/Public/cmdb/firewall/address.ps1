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
        Add a FortiGate Address (ipmask, fqdn, widlcard...)

        .EXAMPLE
        Add-FGTFirewallAddress -type ipmask -Name FGT -ip 192.2.0.0 -mask 255.255.255.0

        Add Address objet type ipmask with name FGT and value 192.2.0.0/24

        .EXAMPLE
        Add-FGTFirewallAddress -type ipmask -Name FGT -ip 192.2.0.0 -mask 255.255.255.0 -interface port2

        Add Address objet type ipmask with name FGT, value 192.2.0.0/24 and associated to interface port2

        .EXAMPLE
        Add-FGTFirewallAddress -type ipmask -Name FGT -ip 192.2.0.0 -mask 255.255.255.0 -comment "My FGT Address"

        Add Address objet type ipmask with name FGT, value 192.2.0.0/24 and a comment

        .EXAMPLE
        Add-FGTFirewallAddress -type ipmask -Name FGT -ip 192.2.0.0 -mask 255.255.255.0 -visibility:$false

        Add Address objet type ipmask with name FGT, value 192.2.0.0/24 and disabled visibility

    #>

    Param(
        [Parameter (Mandatory = $true)]
        [ValidateSet("ipmask")]
        [string]$type,
        [Parameter (Mandatory = $true)]
        [string]$name,
        [Parameter (Mandatory = $false)]
        [ipaddress]$ip,
        [Parameter (Mandatory = $false)]
        [ipaddress]$mask,
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

        $address | add-member -name "type" -membertype NoteProperty -Value $type

        $address | add-member -name "name" -membertype NoteProperty -Value $name

        $subnet = $ip.ToString()
        $subnet += "/"
        $subnet += $mask.ToString()
        $address | add-member -name "subnet" -membertype NoteProperty -Value $subnet

        if ( $PsBoundParameters.ContainsKey('interface') ) {
            #TODO check if the interface (zone ?) is valid
            $address | add-member -name "associated-interface" -membertype NoteProperty -Value $interface
        }

        if ( $PsBoundParameters.ContainsKey('comment') ) {
            $address | add-member -name "comment" -membertype NoteProperty -Value $comment
        }

        if ( $PsBoundParameters.ContainsKey('visibility') ) {
            if ( $visibility ) {
                $address | add-member -name "visibility" -membertype NoteProperty -Value "enable"
            }
            else {
                $address | add-member -name "visibility" -membertype NoteProperty -Value "disable"
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

        Get-FGTFirewallAddress -connection $connection @invokeParams -name $_.name -eq $name
    }

    End {
    }
}

function Get-FGTFirewallAddress {

    <#
        .SYNOPSIS
        Get list of all "address"

        .DESCRIPTION
        Get list of all "address" (ipmask, fqdn, wildcard...)

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
        Get-FGTAddress -vdom vdomX

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
        PS C:\>$MyFGTAddress | Set-FGTFirewallAddress -ip 192.2.0.0 -mask 255.255.255.0

        Change MyFGTAddress to value (ip and mask) 192.2.0.0/24

        .EXAMPLE
        $MyFGTAddress = Get-FGTFirewallAddress -name MyFGTAddress
        PS C:\>$MyFGTAddress | Set-FGTFirewallAddress -ip 192.2.2.1

        Change MyFGTAddress to value (ip) 192.2.2.1

        .EXAMPLE
        $MyFGTAddress = Get-FGTFirewallAddress -name MyFGTAddress
        PS C:\>$MyFGTAddress | Set -interface port1

        Change MyFGTAddress to set associated interface to port 1

        .EXAMPLE
        $MyFGTAddress = Get-FGTFirewallAddress -name MyFGTAddress
        PS C:\>$MyFGTAddress | Set -comment "My FGT Address" -visibility:$false

        Change MyFGTAddress to set a new comment and disabled visibility

    #>

    Param(
        [Parameter (Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        [ValidateScript( { Confirm-FGTAddress $_ })]
        [psobject]$address,
        [Parameter (Mandatory = $false)]
        [string]$name,
        [Parameter (Mandatory = $false)]
        [ipaddress]$ip,
        [Parameter (Mandatory = $false)]
        [ipaddress]$mask,
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

        if ( $PsBoundParameters.ContainsKey('ip') -or $PsBoundParameters.ContainsKey('mask') ) {
            if ( $PsBoundParameters.ContainsKey('ip') ) {
                $subnet = $ip.ToString()
            }
            else {
                $subnet = $address.'start-ip'
            }

            $subnet += "/"

            if ( $PsBoundParameters.ContainsKey('mask') ) {
                $subnet += $mask.ToString()
            }
            else {
                $subnet += $address.'end-ip'
            }

            $_address | add-member -name "subnet" -membertype NoteProperty -Value $subnet
        }

        if ( $PsBoundParameters.ContainsKey('interface') ) {
            #TODO check if the interface (zone ?) is valid
            $_address | add-member -name "associated-interface" -membertype NoteProperty -Value $interface
        }

        if ( $PsBoundParameters.ContainsKey('comment') ) {
            $_address | add-member -name "comment" -membertype NoteProperty -Value $comment
        }

        if ( $PsBoundParameters.ContainsKey('visibility') ) {
            if ( $visibility ) {
                $_address | add-member -name "visibility" -membertype NoteProperty -Value "enable"
            }
            else {
                $_address | add-member -name "visibility" -membertype NoteProperty -Value "disable"
            }
        }

        Invoke-FGTRestMethod -method "PUT" -body $_address -uri $uri -connection $connection @invokeParams | out-Null

        Get-FGTFirewallAddress -connection $connection @invokeParams -name $address.name
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
        PS C:\>$MyFGTAddress | Remove-FGTFirewallAddress -noconfirm

        Remove address object $MyFGTAddress with no confirmation

    #>

    Param(
        [Parameter (Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        [ValidateScript( { Confirm-FGTAddress $_ })]
        [psobject]$address,
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

        $uri = "api/v2/cmdb/firewall/address/$($address.name)"

        if ( -not ( $Noconfirm )) {
            $message = "Remove address on Fortigate"
            $question = "Proceed with removal of Address $($address.name) ?"
            $choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
            $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
            $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))

            $decision = $Host.UI.PromptForChoice($message, $question, $choices, 1)
        }
        else { $decision = 0 }
        if ($decision -eq 0) {
            Write-Progress -activity "Remove Address"
            $null = Invoke-FGTRestMethod -method "DELETE" -uri $uri -connection $connection @invokeParams
            Write-Progress -activity "Remove Address" -completed
        }
    }

    End {
    }
}
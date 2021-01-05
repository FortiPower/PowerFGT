#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
# Copyright 2019, Benjamin Perrier <ben dot perrier at outlook dot com>
#
# SPDX-License-Identifier: Apache-2.0
#
function Get-FGTSystemInterface {

    <#
        .SYNOPSIS
        Get list of all interface

        .DESCRIPTION
        Get list of all interface (name, IP Address, description, mode ...)

        .EXAMPLE
        Get-FGTSystemInterface

        Get list of all interface

        .EXAMPLE
        Get-FGTSystemInterface -name port1

        Get interface named port1

        .EXAMPLE
        Get-FGTSystemInterface -name port -filter_type contains

        Get interface contains with *port*

        .EXAMPLE
        Get-FGTSystemInterface -skip

        Get list of all interface (but only relevant attributes)

        .EXAMPLE
        Get-FGTSystemInterface -vdom vdomX

        Get list of all interface on vdomX
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
            default { }
        }

        #if filter value and filter_attribute, add filter (by default filter_type is equal)
        if ( $filter_value -and $filter_attribute ) {
            $invokeParams.add( 'filter_value', $filter_value )
            $invokeParams.add( 'filter_attribute', $filter_attribute )
            $invokeParams.add( 'filter_type', $filter_type )
        }

        $response = Invoke-FGTRestMethod -uri 'api/v2/cmdb/system/interface' -method 'GET' -connection $connection @invokeParams
        $response.results
    }

    End {
    }
}

function Set-FGTSystemInterface {

    <#
        .SYNOPSIS
        Modify an interface

        .DESCRIPTION
        Modify the properties of an existing interface

        .PARAMETER dhcprelayip
        Enables DHCP relay on the interface with the supplied ip address(es). Specify $null to disable DHCP relay.

        .EXAMPLE
        Set-FGTSystemInterface -name PowerFGT -alias ALIAS_PowerFGT -role lan -mode static -address_mask 192.0.2.1/255.255.255.0  -admin_access ping,https -device_identification $false -connected $false

        This modifies the interface named PowerFGT with an alias, the LAN role, in static mode with 192.0.2.1 as IP, with ping and https administrative access, and with device identification disable and not connected

        .EXAMPLE
        Set-FGTSystemInterface -name PowerFGT -dhcprelayip "10.0.0.1","10.0.0.2"

        This enables DHCP relay and sets 2 ip addresses to relay to.

        .EXAMPLE
        Set-FGTSystemInterface -name PowerFGT -dhcprelayip $null

        This disables DCHP relay and clears the relay ip addresses
    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'medium')]
    Param(
        [Parameter (Mandatory = $true, Position = 1)]
        [ValidateLength(1, 15)]
        [string]$name,
        [Parameter (Mandatory = $false)]
        [string]$alias,
        [Parameter (Mandatory = $false)]
        [ValidateSet('lan', 'wan', 'dmz', 'undefined', IgnoreCase = $false)]
        [string]$role,
        [Parameter (Mandatory = $false)]
        [ValidateSet('https', 'ping', 'fgfm', 'capwap', 'ssh', 'snmp', 'ftm', 'radius-acct', 'ftm', IgnoreCase = $false)]
        [string[]]$admin_access,
        [Parameter (Mandatory = $false)]
        [ValidateSet('static', 'dhcp', IgnoreCase = $false)]
        [string]$mode,
        [Parameter (Mandatory = $false)]
        [string]$address_mask,
        [Parameter (Mandatory = $false)]
        [ValidateSet('up', 'down')]
        [string]$status,
        [Parameter (Mandatory = $false)]
        [string]$device_identification,
        [Parameter(Mandatory = $false)]
        [String[]]$vdom,
        [Parameter(Mandatory = $false)]
        [string[]]$dhcprelayip,
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

        $uri = "api/v2/cmdb/system/interface/$name"
        $_interface = new-Object -TypeName PSObject

        $_interface | add-member -name "name" -membertype NoteProperty -Value $name
        if ( $PsBoundParameters.ContainsKey('role') ) {
            $_interface | add-member -name "role" -membertype NoteProperty -Value $role
        }

        if ( $PsBoundParameters.ContainsKey('mode') ) {
            $_interface | add-member -name "mode" -membertype NoteProperty -Value $mode
        }

        if ( $PsBoundParameters.ContainsKey('alias') ) {
            $_interface | add-member -name "alias" -membertype NoteProperty -Value $alias
        }

        if ( $PsBoundParameters.ContainsKey('status') ) {
            $_interface | add-member -name "status" -membertype NoteProperty -Value $status.ToLower()
        }
        if ( $PsBoundParameters.ContainsKey('admin_access') ) {
            $allowaccess = $admin_access -join " "
            $_interface | add-member -name "allowaccess" -membertype NoteProperty -Value $allowaccess
        }

        if ( $PsBoundParameters.ContainsKey('address_mask') ) {
            $_interface | add-member -name "ip" -membertype NoteProperty -Value $address_mask
        }

        if ( $PsBoundParameters.ContainsKey('device_identification') ) {
            switch ($device_identification) {
                $true {
                    $device_identificationoption = "enable"
                }
                $false {
                    $device_identificationoption = "disable"
                }
            }

            $_interface | add-member -name "device-identification" -membertype NoteProperty -Value $device_identificationoption
        }

        if ( $PsBoundParameters.ContainsKey('dhcprelayip') ) {
            if ($null -eq $dhcprelayip) {
                $_interface | add-member -name "dhcp-relay-ip" -membertype NoteProperty -Value ""
                $_interface | add-member -name "dhcp-relay-service" -membertype NoteProperty -Value "disable"
            }
            else {
                $dhcprelayipoption = $dhcprelayip -join " "
                $_interface | add-member -name "dhcp-relay-ip" -membertype NoteProperty -Value $dhcprelayipoption
                $_interface | add-member -name "dhcp-relay-service" -membertype NoteProperty -Value "enable"
            }
        }

        if ($PSCmdlet.ShouldProcess($name, 'Set interface vlan')) {
            $response = Invoke-FGTRestMethod -uri $uri -method 'PUT' -body $_interface -connection $connection @invokeParams
            $response.results
        }
    }

    End {
    }
}

function Add-FGTSystemInterface {

    <#
        .SYNOPSIS
        Add an interface

        .DESCRIPTION
        Add an interface

        .EXAMPLE
        Add-FGTSystemInterface -name PowerFGT -type vlan -role lan -mode static -vdom_interface root -interface port10 -vlan_id 10

        This creates a new interface using only mandatory parameters.

        .EXAMPLE
        Add-FGTSystemInterface -name PowerFGT -type vlan -alias Alias_PowerFGT -role lan -vlan_id 10 -interface port10 -admin_access https,ping,ssh -status up $true -device_identification $true -mode static -address_mask 192.0.2.1/255.255.255.0 -vdom_interface root

        Create an interface named PowerFGT with alias Alias_PowerFGT, role lan with vlan id 10 on interface port10. Administrative access by https and ssh, ping authorize on ip 192.0.2.1 and state connected.
    #>

    Param(
        [Parameter (Mandatory = $true, Position = 1)]
        [ValidateLength(1, 15)]
        [string]$name,
        [Parameter (Mandatory = $true)]
        [ValidateSet("physical", "vlan", "aggregate", "redundant", "tunnel", "vdom-link", "loopback", "switch", "hard-switch", "vap-switch", "wl-mesh", "fext-wan", "vxlan", "hdlc", "switch-vlan", "emac-vlan")]
        [string]$type,
        [Parameter (Mandatory = $false)]
        [string]$alias,
        [Parameter (Mandatory = $true)]
        [ValidateSet('lan', 'wan', 'dmz', 'undefined', IgnoreCase = $false)]
        [string]$role,
        [Parameter (Mandatory = $true)]
        [int]$vlan_id,
        [Parameter (Mandatory = $true)]
        [string]$interface,
        [Parameter (Mandatory = $false)]
        [ValidateSet('https', 'ping', 'fgfm', 'capwap', 'ssh', 'snmp', 'ftm', 'radius-acct', 'ftm', IgnoreCase = $false)]
        [string[]]$admin_access,
        [Parameter (Mandatory = $false)]
        [ValidateSet('up', 'down')]
        [string]$status = "up",
        [Parameter (Mandatory = $false)]
        [string]$device_identification = $false,
        [Parameter (Mandatory = $true)]
        [ValidateSet('static', 'dhcp', IgnoreCase = $false)]
        [string]$mode,
        [Parameter (Mandatory = $false)]
        [string]$address_mask,
        [Parameter (Mandatory = $true)]
        [string]$vdom_interface,
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

        $uri = "api/v2/cmdb/system/interface"
        $_interface = new-Object -TypeName PSObject

        $_interface | add-member -name "name" -membertype NoteProperty -Value $name
        $_interface | add-member -name "type" -membertype NoteProperty -Value $type
        $_interface | add-member -name "role" -membertype NoteProperty -Value $role
        $_interface | add-member -name "interface" -membertype NoteProperty -Value $interface
        $_interface | add-member -name "mode" -membertype NoteProperty -Value $mode
        $_interface | add-member -name "vdom" -membertype NoteProperty -Value $vdom_interface

        if ( $PsBoundParameters.ContainsKey('alias') ) {
            $_interface | add-member -name "alias" -membertype NoteProperty -Value $alias
        }

        if ( $PsBoundParameters.ContainsKey('vlan_id') ) {
            $_interface | add-member -name "vlanid" -membertype NoteProperty -Value $vlan_id
        }

        if ( $PsBoundParameters.ContainsKey('admin_access') ) {
            $allowaccess = $admin_access -join " "
            $_interface | add-member -name "allowaccess" -membertype NoteProperty -Value $allowaccess
        }

        if ( $PsBoundParameters.ContainsKey('address_mask') ) {
            $_interface | add-member -name "ip" -membertype NoteProperty -Value $address_mask
        }

        if ( $PsBoundParameters.ContainsKey('status') ) {
            $_interface | add-member -name "status" -membertype NoteProperty -Value $status
        }

        switch ($device_identification) {
            $true {
                $device_identification = "enable"
            }
            $false {
                $device_identification = "disable"
            }
        }

        $_interface | add-member -name "device-identification" -membertype NoteProperty -Value $device_identification

        $response = Invoke-FGTRestMethod -uri $uri -method 'POST' -body $_interface -connection $connection @invokeParams
        $response.results
        Get-FGTSystemInterface -name $name -connection $connection @invokeParams
    }

    End {
    }
}

function Remove-FGTSystemInterface {

    <#
        .SYNOPSIS
        Remove an interface

        .DESCRIPTION
        Remove an interface

        .EXAMPLE
        Get-FGTSystemInterface -name PowerFGT | Remove-FGTSystemInterface

        Removes the interface PowerFGT which was retrieved with Get-FGTSystemInterface

        .EXAMPLE
        Get-FGTSystemInterface -name PowerFGT | Remove-FGTSystemInterface -Confirm:$false

        Removes the interface PowerFGT and suppresses the confirmation question
    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    Param(
        [Parameter (Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        [psobject]$interface,
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

        $uri = "api/v2/cmdb/system/interface/$($interface.name)"

        if ($PSCmdlet.ShouldProcess($interface.name, 'Remove interface vlan')) {
            $null = Invoke-FGTRestMethod -uri $uri -method 'DELETE' -connection $connection @invokeParams
        }
    }

    End {
    }
}
#
# Copyright 2021, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

function Add-FGTSystemInterface {

    <#
        .SYNOPSIS
        Add an interface

        .DESCRIPTION
        Add an interface (Type, Role, Vlan, Address IP... )

        .EXAMPLE
        Add-FGTSystemInterface -name PowerFGT -interface port10 -vlan_id 10

        This creates a new interface using only mandatory parameters.

        .EXAMPLE
        Add-FGTSystemInterface -name PowerFGT_lacp -atype lacp -member port9, port10

        This creates a new interface LACP (aggregate) with port9 and port 10

        .EXAMPLE
        Add-FGTSystemInterface -name PowerFGT_static -atype static -member port9, port10

        This creates a new interface Redundant (static) with port9 and port 10

        .EXAMPLE
        Add-FGTSystemInterface -name PowerFGT -alias Alias_PowerFGT -role lan -vlan_id 10 -interface port10 -allowaccess https,ping,ssh -status up -device_identification $true -mode static -ip 192.0.2.1 -netmask 255.255.255.0 -vdom_interface root

        Create an interface named PowerFGT with alias Alias_PowerFGT, role lan with vlan id 10 on interface port10. Administrative access by https and ssh, ping authorize on ip 192.0.2.1 and state connected.
    #>
    Param(
        [Parameter (Mandatory = $true, Position = 1)]
        [ValidateLength(1, 15)]
        [string]$name,
        [Parameter (Mandatory = $false)]
        [string]$alias,
        [Parameter (Mandatory = $false)]
        [ValidateSet('lan', 'wan', 'dmz', 'undefined', IgnoreCase = $false)]
        [string]$role = "lan",
        [Parameter (Mandatory = $true, ParameterSetName = "vlan")]
        [int]$vlan_id,
        [Parameter (Mandatory = $true, ParameterSetName = "vlan")]
        [string]$interface,
        [Parameter (Mandatory = $true, ParameterSetName = "aggregate")]
        [string[]]$member,
        [Parameter (Mandatory = $true, ParameterSetName = "aggregate")]
        [ValidateSet('lacp', 'static')]
        [string]$atype,
        [Parameter (Mandatory = $true, ParameterSetName = "loopback")]
        [switch]$loopback,
        [Parameter (Mandatory = $false)]
        [ValidateSet('https', 'ping', 'fgfm', 'capwap', 'ssh', 'snmp', 'ftm', 'radius-acct', 'ftm', IgnoreCase = $false)]
        [string[]]$allowaccess,
        [Parameter (Mandatory = $false)]
        [ValidateSet('up', 'down')]
        [string]$status = "up",
        [Parameter (Mandatory = $false)]
        [string]$device_identification,
        [Parameter (Mandatory = $false)]
        [ValidateSet('static', 'dhcp', IgnoreCase = $false)]
        [string]$mode = 'static',
        [Parameter (Mandatory = $false)]
        [ValidateScript( { $_ -match [IPAddress]$_ })]
        [string]$ip,
        [Parameter (Mandatory = $false)]
        [string]$netmask,
        [Parameter (Mandatory = $false)]
        [string]$vdom_interface = "root",
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

        switch ( $PSCmdlet.ParameterSetName ) {
            "loopback" {
                $_interface | add-member -name "type" -membertype NoteProperty -Value "loopback"
            }
            "vlan" {
                $_interface | add-member -name "type" -membertype NoteProperty -Value "vlan"
                $_interface | add-member -name "interface" -membertype NoteProperty -Value $interface
            }
            "aggregate" {
                #following atype (aggregate type), you select lacp (aggregate) or static (redundant)
                switch ( $atype ) {
                    "lacp" {
                        $_interface | add-member -name "type" -membertype NoteProperty -Value "aggregate"
                    }
                    "static" {
                        $_interface | add-member -name "type" -membertype NoteProperty -Value "redundant"
                    }
                }
            }
            default { }
        }

        $_interface | add-member -name "role" -membertype NoteProperty -Value $role
        $_interface | add-member -name "mode" -membertype NoteProperty -Value $mode
        $_interface | add-member -name "vdom" -membertype NoteProperty -Value $vdom_interface

        if ( $PsBoundParameters.ContainsKey('alias') ) {
            $_interface | add-member -name "alias" -membertype NoteProperty -Value $alias
        }

        if ( $PsBoundParameters.ContainsKey('vlan_id') ) {
            $_interface | add-member -name "vlanid" -membertype NoteProperty -Value $vlan_id
        }

        if ( $PsBoundParameters.ContainsKey('member') ) {
            $members = @()
            foreach ($m in $member) {
                $members += @{"interface-name" = $m }
            }
            $_interface | add-member -name "member" -membertype NoteProperty -Value $members
        }

        if ( $PsBoundParameters.ContainsKey('allowaccess') ) {
            [string]$allowaccess = $allowaccess -join " "
            $_interface | add-member -name "allowaccess" -membertype NoteProperty -Value $allowaccess
        }

        if ( $PsBoundParameters.ContainsKey('ip') -and $PsBoundParameters.ContainsKey('netmask')) {
            $_interface | add-member -name "ip" -membertype NoteProperty -Value "$ip/$netmask"
        }

        if ( $PsBoundParameters.ContainsKey('status') ) {
            $_interface | add-member -name "status" -membertype NoteProperty -Value $status
        }

        if ( $PsBoundParameters.ContainsKey('device_identification') ) {
            switch ($device_identification) {
                $true {
                    $device_identification = "enable"
                }
                $false {
                    $device_identification = "disable"
                }
            }

            $_interface | add-member -name "device-identification" -membertype NoteProperty -Value $device_identification
        }

        $null = Invoke-FGTRestMethod -uri $uri -method 'POST' -body $_interface -connection $connection @invokeParams

        Get-FGTSystemInterface -name $name -connection $connection @invokeParams
    }

    End {
    }
}

function Add-FGTSystemInterfaceMember {

    <#
        .SYNOPSIS
        Add a FortiGate Interface Member

        .DESCRIPTION
        Add a FortiGate Interface Member (allowaccess)

        .EXAMPLE
        $MyFGTInterface = Get-FGTSystemInterface -name PowerFGT
        PS C:\>$MyFGTInterface | Add-FGTSystemInterfaceMember -allowaccess ssh

        Add ssh to allowaccess for MyFGTInterface

        .EXAMPLE
        $MyFGTInterface = Get-FGTSystemInterface -name PowerFGT
        PS C:\>$MyFGTInterface | Add-FGTSystemInterfaceMember -allowaccess ssh, https

        Add ssh and https to allowaccess for MyFGTInterface


    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'low')]
    Param(
        [Parameter (Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        [ValidateScript( { Confirm-FGTInterface $_ })]
        [psobject]$interface,
        [Parameter (Mandatory = $false)]
        [ValidateSet('https', 'ping', 'fgfm', 'capwap', 'ssh', 'snmp', 'ftm', 'radius-acct', 'ftm', IgnoreCase = $false)]
        [string[]]$allowaccess,
        [Parameter(Mandatory = $false)]
        [string[]]$vdom,
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

        $_interface = new-Object -TypeName PSObject

        if ( $PsBoundParameters.ContainsKey('allowaccess') ) {
            #split allowacces to get array
            $aa = @{ }
            $aa = $interface.allowaccess -split " "
            #Add allow acces to list
            foreach ( $v in $allowaccess ) {
                $aa += $v
            }
            $_interface | add-member -name "allowaccess" -membertype NoteProperty -Value ($aa -join " ")
        }

        if ($PSCmdlet.ShouldProcess($interface.name, 'Add System Interface Member')) {
            Invoke-FGTRestMethod -method "PUT" -body $_interface -uri $uri -connection $connection @invokeParams | Out-Null

            Get-FGTSystemInterface -connection $connection @invokeParams -name $interface.name
        }
    }

    End {
    }
}

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
        Modify the properties of an existing interface (admin acces, alias, status...)

        .EXAMPLE
        Get-FGTSystemInterface -name PowerFGT | Set-FGTSystemInterface -alias ALIAS_PowerFGT -role lan -mode static -ip 192.0.2.1 -netmask 255.255.255.0 -allowaccess ping,https -device_identification $false -status up

        This modifies the interface named PowerFGT with an alias, the LAN role, in static mode with 192.0.2.1 as IP, with ping and https allow access, and with device identification disable and not connected

        .EXAMPLE
        Get-FGTSystemInterface -name PowerFGT | Set-FGTSystemInterface -dhcprelayip "10.0.0.1","10.0.0.2"

        This enables DHCP relay and sets 2 ip addresses to relay to.

        .EXAMPLE
        Get-FGTSystemInterface -name PowerFGT | Set-FGTSystemInterface -dhcprelayip $null

        This disables DCHP relay and clears the relay ip addresses
    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'medium')]
    Param(
        [Parameter (Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        [ValidateScript( { Confirm-FGTInterface $_ })]
        [psobject]$interface,
        [Parameter (Mandatory = $false)]
        [string]$alias,
        [Parameter (Mandatory = $false)]
        [ValidateSet('lan', 'wan', 'dmz', 'undefined', IgnoreCase = $false)]
        [string]$role,
        [Parameter (Mandatory = $false)]
        [ValidateSet('https', 'ping', 'fgfm', 'capwap', 'ssh', 'snmp', 'ftm', 'radius-acct', 'ftm', IgnoreCase = $false)]
        [string[]]$allowaccess,
        [Parameter (Mandatory = $false)]
        [ValidateSet('static', 'dhcp', IgnoreCase = $false)]
        [string]$mode,
        [Parameter (Mandatory = $false)]
        [ValidateScript( { $_ -match [IPAddress]$_ })]
        [string]$ip,
        [Parameter (Mandatory = $false)]
        [string]$netmask,
        [Parameter (Mandatory = $false)]
        [ValidateSet('up', 'down', IgnoreCase = $false)]
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

        $uri = "api/v2/cmdb/system/interface/$($interface.name)"

        $_interface = new-Object -TypeName PSObject

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
            $_interface | add-member -name "status" -membertype NoteProperty -Value $status
        }
        if ( $PsBoundParameters.ContainsKey('allowaccess') ) {
            [string]$allowaccess = $allowaccess -join " "
            $_interface | add-member -name "allowaccess" -membertype NoteProperty -Value $allowaccess
        }

        if ( $PsBoundParameters.ContainsKey('ip') -and $PsBoundParameters.ContainsKey('netmask') ) {
            $_interface | add-member -name "ip" -membertype NoteProperty -Value "$ip/$netmask"
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

        if ($PSCmdlet.ShouldProcess($interface.name, 'Set interface')) {
            $null = Invoke-FGTRestMethod -uri $uri -method 'PUT' -body $_interface -connection $connection @invokeParams
            Get-FGTSystemInterface -name $interface.name -connection $connection @invokeParams
        }
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
        [ValidateScript( { Confirm-FGTInterface $_ })]
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

        if ($PSCmdlet.ShouldProcess($interface.name, 'Remove interface')) {
            $null = Invoke-FGTRestMethod -uri $uri -method 'DELETE' -connection $connection @invokeParams
        }
    }

    End {
    }
}

function Remove-FGTSystemInterfaceMember {

    <#
        .SYNOPSIS
        Remove a FortiGate Interface Member

        .DESCRIPTION
        Remove a FortiGate Interface Member (allowaccess)

        .EXAMPLE
        $MyFGTInterface = Get-FGTSystemInterface -name PowerFGT
        PS C:\>$MyFGTInterface | Remove-FGTSystemInterfaceMember -allowaccess ssh

        Remove ssh to allowaccess for MyFGTInterface

        .EXAMPLE
        $MyFGTInterface = Get-FGTSystemInterface -name PowerFGT
        PS C:\>$MyFGTInterface | Remove-FGTSystemInterfaceMember -allowaccess ssh, https

        Remove ssh and https to allowaccess for MyFGTInterface


    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'low')]
    Param(
        [Parameter (Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        [ValidateScript( { Confirm-FGTInterface $_ })]
        [psobject]$interface,
        [Parameter (Mandatory = $false)]
        [ValidateSet('https', 'ping', 'fgfm', 'capwap', 'ssh', 'snmp', 'ftm', 'radius-acct', 'ftm', IgnoreCase = $false)]
        [string[]]$allowaccess,
        [Parameter(Mandatory = $false)]
        [string[]]$vdom,
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

        $_interface = new-Object -TypeName PSObject

        if ( $PsBoundParameters.ContainsKey('allowaccess') ) {
            #split allowaccess to get array
            $aarray = $interface.allowaccess -split " "
            $aa = @()
            foreach ($a in $aarray) {
                $aa += $a
            }

            #Remove allow access to list
            foreach ( $v in $allowaccess ) {
                $aa = $aa | Where-Object { $_ -ne $v }
            }

            #if there is empty/null
            if ( $null -eq $aa ) {
                $_interface | add-member -name "allowaccess" -membertype NoteProperty -Value $null
            }
            else {
                $_interface | add-member -name "allowaccess" -membertype NoteProperty -Value ($aa -join " ")
            }
        }

        if ($PSCmdlet.ShouldProcess($interface.name, 'Remove System Interface Member')) {
            Invoke-FGTRestMethod -method "PUT" -body $_interface -uri $uri -connection $connection @invokeParams | Out-Null

            Get-FGTSystemInterface -connection $connection @invokeParams -name $interface.name
        }
    }

    End {
    }
}

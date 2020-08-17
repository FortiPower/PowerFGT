﻿#
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
        Set a vlan interface

        .DESCRIPTION
        Set a vlan interface

        .EXAMPLE
        Set-FGTSystemInterface -name PowerFGT -alias ALIAS_PowerFGT -role lan -mode static -ip 192.0.2.1/255.255.255.0  -admin_access ping,https -device_identification $false -connected $false

        This set the interface vlan named PowerFGT with an alias, the LAN role, in static mode with 192.0.2.1 as IP, with ping and https administrative access, and with device identification disable and not connected 
    #>

    Param(
        [Parameter (Mandatory = $true, Position = 1)]
        [string]$name,
        [Parameter (Mandatory = $false)]
        [string]$alias,
        [Parameter (Mandatory = $true)]
        [ValidateSet('lan','wan','dmz','undefined')]
        [string]$role,
        [Parameter (Mandatory = $false)]
        [ValidateSet('https','ping','fgfm','capwap','ssh','snmp','ftm','radius-acct','ftm')]
        [string[]]$admin_access,
        [Parameter (Mandatory = $true)]
        [ValidateSet('static','dhcp')]
        [string]$mode,
        [Parameter (Mandatory = $false)]
        [string]$ip,
        [Parameter (Mandatory = $false)]
        [string]$connected = $false,
        [Parameter (Mandatory = $false)]
        [string]$device_identification = $false,
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

        $uri = "api/v2/cmdb/system/interface/$name"
        $_interface = new-Object -TypeName PSObject

        $_interface | add-member -name "name" -membertype NoteProperty -Value $name
        $_interface | add-member -name "role" -membertype NoteProperty -Value $role
        $_interface | add-member -name "mode" -membertype NoteProperty -Value $mode

        if ( $PsBoundParameters.ContainsKey('alias') ) {
            $_interface | add-member -name "alias" -membertype NoteProperty -Value $alias
        }

        if ( $PsBoundParameters.ContainsKey('admin_access') ) {
            $allowaccess = [string]$admin_access
            $_interface | add-member -name "allowaccess" -membertype NoteProperty -Value $allowaccess
        }

        if ( $PsBoundParameters.ContainsKey('ip') ) {
            $_interface | add-member -name "ip" -membertype NoteProperty -Value $ip
        }

        switch ($connected)
        {
            $true
            {
                $connected = "up"
            }
            $false
            {
                $connected = "down"
            }
        }

        $_interface | add-member -name "status" -membertype NoteProperty -Value $connected

        switch ($device_identification)
        {
            $true
            {
                $device_identification = "enable"
            }
            $false
            {
                $device_identification = "disable"
            }
        }

        $_interface | add-member -name "device-identification" -membertype NoteProperty -Value $device_identification

        $response = Invoke-FGTRestMethod -uri $uri -method 'PUT' -body $_interface -connection $connection @invokeParams
        $response.results
    }

    End {
    }
}

function Add-FGTSystemInterface {

    <#
        .SYNOPSIS
        Add a vlan interface

        .DESCRIPTION
        Add a vlan interface

        .EXAMPLE
        Add-FGTSystemInterface

        
    #>

    Param(
        [Parameter (Mandatory = $true, Position = 1)]
        [string]$name,
        [Parameter (Mandatory = $true)]
        [ValidateSet('vlan')]
        [string]$type,
        [Parameter (Mandatory = $false)]
        [string]$alias,
        [Parameter (Mandatory = $true)]
        [ValidateSet('lan','wan','dmz','undefined')]
        [string]$role,
        [Parameter (Mandatory = $false)]
        [int]$vlan_id,
        [Parameter (Mandatory = $true)]
        [ValidateSet('port1','port2','port3','port4','port5','port6','port7','port8','port9','port10')]
        [string]$interface,
        [Parameter (Mandatory = $false)]
        [ValidateSet('https','ping','fgfm','capwap','ssh','snmp','ftm','radius-acct','ftm')]
        [string[]]$admin_access,
        [Parameter (Mandatory = $false)]
        [string]$connected = $false,
        [Parameter (Mandatory = $false)]
        [string]$device_identification = $false,
        [Parameter (Mandatory = $true)]
        [ValidateSet('static','dhcp')]
        [string]$mode,
        [Parameter (Mandatory = $false)]
        [string]$ip,
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

        if ( $PsBoundParameters.ContainsKey('alias') ) {
            $_interface | add-member -name "alias" -membertype NoteProperty -Value $alias
        }

        if ( $PsBoundParameters.ContainsKey('vlan_id') ) {
            $_interface | add-member -name "vlanid" -membertype NoteProperty -Value $vlan_id
        }

        if ( $PsBoundParameters.ContainsKey('admin_access') ) {
            $allowaccess = [string]$admin_access
            $_interface | add-member -name "allowaccess" -membertype NoteProperty -Value $allowaccess
        }

        <#switch ($connected)
        {
            $true
            {
                $connected = "up"
            }
            $false
            {
                $connected = "down"
            }
        }

        $_interface | add-member -name "status" -membertype NoteProperty -Value $connected

        switch ($device_identification)
        {
            $true
            {
                $device_identification = "enable"
            }
            $false
            {
                $device_identification = "disable"
            }
        }

        $_interface | add-member -name "device-identification" -membertype NoteProperty -Value $device_identification
#>
        if ( $PsBoundParameters.ContainsKey('ip') ) {
            $_interface | add-member -name "ip" -membertype NoteProperty -Value $ip
        }

        $response = Invoke-FGTRestMethod -uri $uri -method 'POST' -body $_interface -connection $connection @invokeParams
        $response.results
    }

    End {
    }
}
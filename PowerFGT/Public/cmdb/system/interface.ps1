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

function Add-FGTSystemInterface {

    <#
        .SYNOPSIS
        Add an interface

        .DESCRIPTION
        Add an interface (name, IP Address, description, mode ...)

        .EXAMPLE
        Add-FGTSystemInterface -name PowerFGT -ip 192.0.2.1/255.255.255.0 -mode static -description "PowerFGT interface"

        Add an interface named PowerFGT with ip 192.0.2.1/24 
    #>

    [CmdletBinding(DefaultParameterSetName = "default")]
    Param(
        [Parameter (Mandatory = $false, Position = 1, ParameterSetName = "name")]
        [string]$name,
        [Parameter(Mandatory = $false)]
        [string]$port,
        [Parameter(Mandatory = $false)]
        [string]$ip,
        [Parameter(Mandatory = $false)]
        [string]$mode,
        [Parameter(Mandatory = $false)]
        [int]$vlan,
        [Parameter(Mandatory = $false)]
        [string]$type,
        [Parameter(Mandatory = $false)]
        [string]$description,
        [Parameter(Mandatory = $false)]
        [String[]]$vdom,
        [Parameter(Mandatory = $false)]
        [psobject]$connection = $DefaultFGTConnection
    )

    Begin {
    }

    Process {

        $interface = new-Object -TypeName PSObject

        $interface | add-member -name "name" -membertype NoteProperty -Value $name
        #$interface | add-member -name "q_origin_key" -membertype NoteProperty -Value $name
        #$interface | add-member -name "type" -membertype NoteProperty -Value $type
        #$interface | add-member -name "mode" -membertype NoteProperty -Value $mode
        $interface | add-member -name "description" -membertype NoteProperty -Value $description
        #$interface | add-member -name "interface" -membertype NoteProperty -Value $port

        if ( $PsBoundParameters.ContainsKey('vdom') ) {
            $interface | add-member -name "vdom" -membertype NoteProperty -Value $vdom
        }

        if ( $PsBoundParameters.ContainsKey('ip') ) {
            $interface | add-member -name "ip" -membertype NoteProperty -Value $ip
        }

        if ( $PsBoundParameters.ContainsKey('vlan') ) {
            $interface | add-member -name "vlanid" -membertype NoteProperty -Value $vlan
        }

        Invoke-FGTRestMethod -uri 'api/v2/cmdb/system/interface' -method 'POST' -body $interface -connection $connection
    }

    End {
    }
}

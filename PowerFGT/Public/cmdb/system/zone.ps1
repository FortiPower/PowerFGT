#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
# Copyright 2019, Benjamin Perrier <ben dot perrier at outlook dot com>
#
# SPDX-License-Identifier: Apache-2.0
#
function Get-FGTSystemZone {

    <#
        .SYNOPSIS
        Get list of all "zone"

        .DESCRIPTION
        Get list of all "zone"

        .EXAMPLE
        Get-FGTSystemZone

        Get list of all zone object

        .EXAMPLE
        Get-FGTSystemZone -name myZone

        Get Zone named MyZone

        .EXAMPLE
        Get-FGTSystemZone -name FGT -filter_type contains

        Get vdom contains with *FGT*

        .EXAMPLE
        Get-FGTSystemZone -skip

        Get list of all zone object (but only relevant attributes)

        .EXAMPLE
        Get-FGTSystemZone -vdom vdomX

        Get list of all zone object on vdomX
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

        $response = Invoke-FGTRestMethod -uri 'api/v2/cmdb/system/zone' -method 'GET' -connection $connection @invokeParams
        $response.results
    }

    End {
    }
}

function Add-FGTSystemZone {

    <#
        .SYNOPSIS
        Add a zone

        .DESCRIPTION
        Add a zone

        .EXAMPLE
        Add-FGTSystemZone -name PowerFGT -intrazone deny -interfaces port5,port6

        Add a zone named PowerFGT with intra-zone traffic blocked and with port5 and port6 in this zone
    #>

    Param(
        [Parameter (Mandatory = $true, Position = 1)]
        [string]$name,
        [Parameter(Mandatory = $false)]
        [ValidateSet('allow','deny')]
        [string]$intrazone,
        [Parameter(Mandatory = $false)]
        [string[]]$interfaces,
        [Parameter(Mandatory = $false)]
        [psobject]$connection = $DefaultFGTConnection
    )

    Begin {
    }

    Process {

        $zone = new-Object -TypeName PSObject

        $zone | add-member -name "name" -membertype NoteProperty -Value $name

        $get_zone_name = Get-FGTSystemZone -name $name -connection $connection

        If($null -ne $get_zone_name)
        {
            Throw "Already a zone using the same name"
        }

        if ( $PsBoundParameters.ContainsKey('interfaces') ) {
            $ports = @()
            foreach ( $member in $interfaces ) {
                $get_interface = Get-FGTSystemInterface -name $member -connection $connection

                If($null -eq $get_interface)
                {
                    Throw "The interface specified does not exist"
                }
                $member_attributes = @{}
                $member_attributes.add( 'interface-name', $member)
                $ports += $member_attributes
            }
            $zone | add-member -name "interface" -membertype NoteProperty -Value $ports
        }

        if ( $PsBoundParameters.ContainsKey('intrazone') ) {
            $zone | add-member -name "intrazone" -membertype NoteProperty -Value $intrazone
        }

        Invoke-FGTRestMethod -uri 'api/v2/cmdb/system/zone' -method 'POST' -body $zone -connection $connection | Out-Null
        Get-FGTSystemZone -name $name -connection $connection

    }

    End {
    }
}

function Set-FGTSystemZone {

    <#
        .SYNOPSIS
        Set a zone

        .DESCRIPTION
        Set a zone

        .EXAMPLE
        Set-FGTSystemZone -name PowerFGT -intrazone deny -interfaces port5,port6

        Set the zone named PowerFGT with intra-zone traffic authorized, and with port 5 and port 6 bound to it
    #>

    Param(
        [Parameter (Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        [string]$name,
        [Parameter (Mandatory = $false)]
        [string]$zone_name,
        [Parameter(Mandatory = $false)]
        [ValidateSet('allow','deny')]
        [string]$intrazone,
        [Parameter(Mandatory = $false)]
        [string[]]$interfaces,
        [Parameter(Mandatory = $false)]
        [psobject]$connection = $DefaultFGTConnection
    )

    Begin {
    }

    Process {

        $zone = new-Object -TypeName PSObject

        if ( $PsBoundParameters.ContainsKey('interfaces') ) {
            $ports = @()
            foreach ( $member in $interfaces ) {
                $get_interface = Get-FGTSystemInterface -name $member

                If($null -eq $get_interface)
                {
                    Throw "The interface $member does not exist"
                }

                $member_attributes = @{}
                $member_attributes.add( 'interface-name', $member)
                $ports += $member_attributes
            }
            $zone | add-member -name "interface" -membertype NoteProperty -Value $ports
        }

        if ( $PsBoundParameters.ContainsKey('intrazone') ) {
            $zone | add-member -name "intrazone" -membertype NoteProperty -Value $intrazone
        }

        if ( $PsBoundParameters.ContainsKey('zone_name') ) {
            $zone | add-member -name "name" -membertype NoteProperty -Value $zone_name
        }

        Invoke-FGTRestMethod -uri "api/v2/cmdb/system/zone/${name}" -method 'PUT' -body $zone -connection $connection | Out-Null
        Get-FGTSystemZone -name $name -connection $connection

    }

    End {
    }
}

function Remove-FGTSystemZone {

    <#
        .SYNOPSIS
        Remove a zone

        .DESCRIPTION
        Remove a zone

        .EXAMPLE
        Remove-FGTSystemZone -name PowerFGT

        Remove the zone named PowerFGT
    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'medium')]
    Param(
        [Parameter (Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        [string]$name,
        [Parameter(Mandatory = $false)]
        [psobject]$connection = $DefaultFGTConnection
    )

    Begin {
    }

    Process {

        if ($PSCmdlet.ShouldProcess($zone.name, 'Remove zone')) {
            $null = Invoke-FGTRestMethod -method "DELETE" -uri "api/v2/cmdb/system/zone/${name}" -connection $connection
        }

    }

    End {
    }
}
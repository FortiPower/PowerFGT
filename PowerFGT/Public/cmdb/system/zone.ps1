#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
# Copyright 2020, Cédric Moreau <moreaucedric0 at gmail dot com>
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

        Get zone contains with *FGT*

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
        Add a zone (name, intrazone, member...)

        .EXAMPLE
        Add-FGTSystemZone -name myPowerFGTZone -intrazone allow -interfaces port5

        Add a zone named myPowerFGTZone with intra-zone traffic Allow and with port5

        .EXAMPLE
        Add-FGTSystemZone -name myPowerFGTZone -intrazone deny -interfaces port5,port6

        Add a zone named myPowerFGTZone with intra-zone traffic blocked and with port5 and port6 in this zone
    #>

    Param(
        [Parameter (Mandatory = $true, Position = 1)]
        [string]$name,
        [Parameter(Mandatory = $false)]
        [ValidateSet('allow', 'deny')]
        [string]$intrazone,
        [Parameter(Mandatory = $false)]
        [string[]]$interfaces,
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

        $zone = new-Object -TypeName PSObject

        $zone | add-member -name "name" -membertype NoteProperty -Value $name

        If (Get-FGTSystemZone -name $name -connection $connection @invokeParams) {
            Throw "Already a zone using the same name"
        }

        if ( $PsBoundParameters.ContainsKey('interfaces') ) {
            #TODO check if interfaces exists
            $ports = @()
            foreach ( $member in $interfaces ) {
                $member_attributes = @{}
                $member_attributes.add( 'interface-name', $member)
                $ports += $member_attributes
            }
            $zone | add-member -name "interface" -membertype NoteProperty -Value $ports
        }

        if ( $PsBoundParameters.ContainsKey('intrazone') ) {
            $zone | add-member -name "intrazone" -membertype NoteProperty -Value $intrazone
        }

        Invoke-FGTRestMethod -uri 'api/v2/cmdb/system/zone' -method 'POST' -body $zone -connection $connection @invokeParams | Out-Null
        Get-FGTSystemZone -name $name -connection $connection @invokeParams

    }

    End {
    }
}

function Set-FGTSystemZone {

    <#
        .SYNOPSIS
        Set a zone

        .DESCRIPTION
        Configure a zone (name, intrazone, member...)

        .EXAMPLE
        Get-FGTSystemZone -name myPowerFGTZone | Set-FGTSystemZone -intrazone deny

        Set the zone named myPowerFGTZone with intra-zone traffic deny

        .EXAMPLE
        Get-FGTSystemZone -name myPowerFGTZone | Set-FGTSystemZone -interfaces port5, port6

        Set the zone named myPowerFGTZone with port 5 and port 6 bound to it

        .EXAMPLE
        Get-FGTSystemZone -name myPowerFGTZone | Set-FGTSystemZone -name new_myPowerFGTZone

        Set the zone named myPowerFGTZone with new name new_myPowerFGTZone
    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'medium')]
    Param(
        [Parameter (Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        [ValidateScript( { Confirm-FGTZone $_ })]
        [psobject]$zone,
        [Parameter (Mandatory = $false)]
        [string]$name,
        [Parameter(Mandatory = $false)]
        [ValidateSet('allow', 'deny')]
        [string]$intrazone,
        [Parameter(Mandatory = $false)]
        [string[]]$interfaces,
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

        $zone_body = new-Object -TypeName PSObject

        if ( $PsBoundParameters.ContainsKey('interfaces') ) {
            $ports = @()
            if ($interfaces -eq "none") {
                $zone_body | add-member -name "interface" -membertype NoteProperty -Value $ports
            }
            else {
                foreach ( $member in $interfaces ) {
                    $member_attributes = @{}
                    $member_attributes.add( 'interface-name', $member)
                    $ports += $member_attributes
                }
                $zone_body | add-member -name "interface" -membertype NoteProperty -Value $ports
            }
        }

        if ( $PsBoundParameters.ContainsKey('intrazone') ) {
            $zone_body | add-member -name "intrazone" -membertype NoteProperty -Value $intrazone
        }

        if ( $PsBoundParameters.ContainsKey('name') ) {
            $zone_body | add-member -name "name" -membertype NoteProperty -Value $name
        }
        else {
            # kept name for get system zone after...
            $name = $zone.name
        }

        if ($PSCmdlet.ShouldProcess($zone.name, 'Set zone')) {
            Invoke-FGTRestMethod -uri "api/v2/cmdb/system/zone/$($zone.name)" -method 'PUT' -body $zone_body -connection $connection @invokeParams | Out-Null
            Get-FGTSystemZone -name $name -connection $connection @invokeParams
        }

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
        Get-FGTSystemZone myPowerFGTZone | Remove-FGTSystemZone

        Remove the zone named myPowerFGTZone

        .EXAMPLE
        Get-FGTSystemZone myPowerFGTZone | Remove-FGTSystemZone -confirm:$false

        Remove the zone named myPowerFGTZone without confirmation
    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'high')]
    Param(
        [Parameter (Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        [ValidateScript( { Confirm-FGTZone $_ })]
        [psobject]$zone,
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

        if ($PSCmdlet.ShouldProcess($zone.name, 'Remove zone')) {
            $null = Invoke-FGTRestMethod -method "DELETE" -uri "api/v2/cmdb/system/zone/$($zone.name)" -connection $connection @invokeParams
        }

    }

    End {
    }
}

function Remove-FGTSystemZoneMember {

    <#
        .SYNOPSIS
        Remove a zone member

        .DESCRIPTION
        Remove a zone member interface

        .EXAMPLE
        Get-FGTSystemZone myPowerFGTZone | Remove-FGTSystemZoneMember -name PowerFGT -interface port9

        Remove the zone named myPowerFGTZone member interface port9

        .EXAMPLE
        Get-FGTSystemZone myPowerFGTZone | Remove-FGTSystemZoneMember -name PowerFGT -interface port8, port9

        Remove the zone named myPowerFGTZone member interface port8 and port9
    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'medium')]
    Param(
        [Parameter (Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        [ValidateScript( { Confirm-FGTZone $_ })]
        [psobject]$zone,
        [Parameter(Mandatory = $true)]
        [string[]]$interfaces,
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

        $zone_body = new-Object -TypeName PSObject
        $get_zone = Get-FGTSystemZone -name $zone.name @invokeParams

        $members = @()
        foreach ($member in $get_zone.interface) {
            $member_name = @{ }
            $member_name.add( 'interface-name', $member."interface-name")
            $members += $member_name
        }

        foreach ($remove_member in $interfaces) {
            $members = $members | Where-Object { $_."interface-name" -ne $remove_member }
        }

        if ( $members.count -le 1 ) {
            $members = @($members)
        }

        $zone_body | add-member -name "interface" -membertype NoteProperty -Value $members

        if ($PSCmdlet.ShouldProcess($zone.name, 'Remove zone member')) {
            Invoke-FGTRestMethod -uri "api/v2/cmdb/system/zone/$($zone.name)" -method 'PUT' -body $zone_body -connection $connection @invokeParams | Out-Null
            Get-FGTSystemZone -name $zone.name -connection $connection @invokeParams
        }

    }

    End {
    }
}

function Add-FGTSystemZoneMember {

    <#
        .SYNOPSIS
        Add a zone member

        .DESCRIPTION
        Add a zone member interface

        .EXAMPLE
        Get-FGTSystemZone myPowerFGTZone | Add-FGTSystemZoneMember -interface port9

        Add the zone named myPowerFGTZone member interface port9

        .EXAMPLE
        Get-FGTSystemZone myPowerFGTZone | Add-FGTSystemZoneMember -interface port8, port9

        Add the zone named myPowerFGTZone member interface port8 and port9

    #>

    Param(
        [Parameter (Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        [ValidateScript( { Confirm-FGTZone $_ })]
        [psobject]$zone,
        [Parameter(Mandatory = $true)]
        [string[]]$interfaces,
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

        $zone_body = new-Object -TypeName PSObject
        $get_zone = Get-FGTSystemZone -name $zone.name @invokeParams

        $members = $get_zone.interface

        foreach ($add_member in $interfaces) {
            $member_name = @{ }
            $member_name.add( 'interface-name', $add_member)
            $members += $member_name
        }

        if ( $members.count -le 1 ) {
            $members = @($members)
        }

        $zone_body | add-member -name "interface" -membertype NoteProperty -Value $members

        Invoke-FGTRestMethod -uri "api/v2/cmdb/system/zone/$($zone.name)" -method 'PUT' -body $zone_body -connection $connection @invokeParams | Out-Null
        Get-FGTSystemZone -name $zone.name -connection $connection @invokeParams

    }

    End {
    }
}
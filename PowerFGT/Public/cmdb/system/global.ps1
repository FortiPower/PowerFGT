#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

function Get-FGTSystemGlobal {

    <#
        .SYNOPSIS
        Get list of System Global Settings

        .DESCRIPTION
        Get list of System Global Settings (hostname, alias....)

        .EXAMPLE
        Get-FGTSystemGlobal

        Get list of all System Global Settings

        .EXAMPLE
        Get-FGTSystemGlobal -filter_attribute admintimeout -filter_value 5

        Get System Global with admin timeout equal 5

        .EXAMPLE
        Get-FGTSystemGlobal -filter_attribute hostname -filter_value Fortinet -filter_type contains

        Get System Global with hostname contains Fortinet

        .EXAMPLE
        Get-FGTSystemGlobal -skip

        Get list of all System Global Settings (but only relevant attributes)

        .EXAMPLE
        Get-FGTSystemGlobal -vdom vdomX

        Get list of all System Global Settings on vdomX
    #>

    [CmdletBinding(DefaultParameterSetName = "default")]
    Param(
        [Parameter (Mandatory = $false)]
        [Parameter (ParameterSetName = "filter")]
        [string]$filter_attribute,
        [Parameter (Mandatory = $false)]
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
        #if filter value and filter_attribute, add filter (by default filter_type is equal)
        if ( $filter_value -and $filter_attribute ) {
            $invokeParams.add( 'filter_value', $filter_value )
            $invokeParams.add( 'filter_attribute', $filter_attribute )
            $invokeParams.add( 'filter_type', $filter_type )
        }

        $reponse = Invoke-FGTRestMethod -uri 'api/v2/cmdb/system/global' -method 'GET' -connection $connection @invokeParams
        $reponse.results
    }

    End {
    }
}

function Set-FGTSystemGlobal {

    <#
        .SYNOPSIS
        Configure a FortiGate System Global

        .DESCRIPTION
        Change a FortiGate System Global Settings (hostname, alias....)

        .EXAMPLE
        Set-FGTSystemGlobal -hostname MyFGT

        Change hostname to value MyFGT

        .EXAMPLE
        Set-FGTSystemGlobal -alias MyFGT

        Change alias to value MyFGT

        .EXAMPLE
        Set-FGTSystemGlobal -timezone 28

        Change timezone to 28 (GMT+1:00) Brussels, Copenhagen, Madrid, Paris
    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'medium')]
    Param(
        [Parameter (Mandatory = $false)]
        [string]$hostname,
        [Parameter (Mandatory = $false)]
        [string]$alias,
        [Parameter (Mandatory = $false)]
        [ValidateRange("00", "86")]
        [int]$timezone,
        [Parameter (Mandatory = $false)]
        [switch]$dst,
        [Parameter (Mandatory = $false)]
        [ValidateRange("1", "480")]
        [int]$admintimeout,
        [Parameter (Mandatory = $false)]
        [switch]$lldp_transmission,
        [Parameter (Mandatory = $false)]
        [switch]$lldp_reception,
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

        $uri = "api/v2/cmdb/system/global"

        $_sg = new-Object -TypeName PSObject

        if ( $PsBoundParameters.ContainsKey('hostname') ) {
            $_sg | add-member -name "hostname" -membertype NoteProperty -Value $hostname
        }

        if ( $PsBoundParameters.ContainsKey('alias') ) {
            $_sg | add-member -name "alias" -membertype NoteProperty -Value $alias
        }

        if ( $PsBoundParameters.ContainsKey('timezone') ) {
            $_sg | add-member -name "timezone" -membertype NoteProperty -Value $timezone
        }

        if ( $PsBoundParameters.ContainsKey('dst') ) {
            if ($dst) {
                $_sg | Add-member -name "dst" -membertype NoteProperty -Value $true
            }
            else {
                $_sg | Add-member -name "dst" -membertype NoteProperty -Value $false
            }
        }

        if ($PSCmdlet.ShouldProcess("Global", 'Configure Settings')) {
            Invoke-FGTRestMethod -method "PUT" -body $_sg -uri $uri -connection $connection @invokeParams
        }

        Get-FGTSystemGlobal
    }

    End {
    }
}
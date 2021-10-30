#
# Copyright 2020, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

function Get-FGTSystemSettings {

    <#
        .SYNOPSIS
        Get list of System Settings

        .DESCRIPTION
        Get list of System Settings (opmode, bfd, gui...)

        .EXAMPLE
        Get-FGTSystemSettings

        Get list of all System Settings

        .EXAMPLE
        Get-FGTSystemSettings -filter_attribute opmode -filter_value nat

        Get System with op mode equal nat

        .EXAMPLE
        Get-FGTSystemSettings -filter_attribute comments -filter_value Fortinet -filter_type contains

        Get System with comment contains Fortinet

        .EXAMPLE
        Get-FGTSystemSettings -skip

        Get list of all System Settings (but only relevant attributes)

        .EXAMPLE
        Get-FGTSystemSettings -vdom vdomX

        Get list of all System Settings on vdomX
    #>

    [CmdletBinding(DefaultParameterSetName = "default")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseSingularNouns", "")]
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

        $reponse = Invoke-FGTRestMethod -uri 'api/v2/cmdb/system/settings' -method 'GET' -connection $connection @invokeParams
        $reponse.results
    }

    End {
    }
}

function Set-FGTSystemSettings {

    <#
        .SYNOPSIS
        Configure a FortiGate System Settings

        .DESCRIPTION
        Change a FortiGate System Settings (lldp, gui....)

        .EXAMPLE
        Set-FGTSystemSettings -gui_allow_unnamed_policy

        Enable unnamed Policy

        .EXAMPLE
        $data = @{ "ike-port" = 1500 }
        PS C> Set-FGTSystemSettings -data $data

        Change ike-port settings using -data parameter (ike-port is available on parameter)

        $data = @{ "ike-port" = 1500 ; "ike-policy-route" = "enable"}
        PS C> Set-FGTSystemSettings -data $data

        Change ike-port and ike-policy-route settings using -data parameter
    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'medium')]
    Param(
        [Parameter (Mandatory = $false)]
        [string]$comments,
        [Parameter (Mandatory = $false)]
        [switch]$gui_allow_unnamed_policy,
        [Parameter (Mandatory = $false)]
        [switch]$lldp_transmission,
        [Parameter (Mandatory = $false)]
        [switch]$lldp_reception,
        [Parameter (Mandatory = $false)]
        [hashtable]$data,
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

        $uri = "api/v2/cmdb/system/settings"

        $_ss = new-Object -TypeName PSObject

        if ( $PsBoundParameters.ContainsKey('comments') ) {
            $_ss | add-member -name "comments" -membertype NoteProperty -Value $comments
        }

        if ( $PsBoundParameters.ContainsKey('gui_allow_unnamed_policy') ) {
            if ($gui_allow_unnamed_policy) {
                $_ss | Add-member -name "gui-allow-unnamed-policy" -membertype NoteProperty -Value "enable"
            }
            else {
                $_ss | Add-member -name "gui-allow-unnamed-policy" -membertype NoteProperty -Value "disable"
            }
        }

        if ( $PsBoundParameters.ContainsKey('data') ) {
            $data.GetEnumerator() | ForEach-Object{
                $_ss | Add-member -name $_.key -membertype NoteProperty -Value $_.value
            }
        }

        if ($PSCmdlet.ShouldProcess("System", 'Configure Settings')) {
            Invoke-FGTRestMethod -method "PUT" -body $_ss -uri $uri -connection $connection @invokeParams
        }

        Get-FGTSystemSettings
    }

    End {
    }
}
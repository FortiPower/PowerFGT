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
        Get-FGTSystemSettings -skip

        Get list of all System Settings (but only relevant attributes)

        .EXAMPLE
        Get-FGTSystemSettings -name "ike-port"

        Get value of ike-port settings

        .EXAMPLE
        Get-FGTSystemSettings -name "ike-port", "ike-policy-route"

        Get value of ike-port and ike-policy-route settings

        .EXAMPLE
        Get-FGTSystemSettings -vdom vdomX

        Get list of all System Settings on vdomX
    #>

    [CmdletBinding(DefaultParameterSetName = "default")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseSingularNouns", "")]
    Param(
        [Parameter (Mandatory = $false)]
        [string[]]$name,
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
        if ( $PsBoundParameters.ContainsKey('name') ) {
            $ss = new-Object -TypeName PSObject
            #display value to PSObject (with name and value)
            foreach ($n in $name) {
                if ($reponse.results.$n) {
                    $ss | Add-member -name $n -membertype NoteProperty -Value $reponse.results.$n
                }
            }
            $ss
        }
        else {
            $reponse.results
        }

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

        .EXAMPLE
        $data = @{ "ike-port" = 1500 ; "ike-policy-route" = "enable"}
        PS C> Set-FGTSystemSettings -data $data

        Change ike-port and ike-policy-route settings using -data parameter
    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'medium')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseSingularNouns", "")]
    Param(
        [Parameter (Mandatory = $false)]
        [switch]$gui_allow_unnamed_policy,
        [Parameter (Mandatory = $false)]
        [ValidateSet('proxy', 'flow', IgnoreCase = $false)]
        [string]$inspection_mode,
        [Parameter (Mandatory = $false)]
        [switch]$gui_dns_database,
        [Parameter (Mandatory = $false)]
        [switch]$gui_explicit_proxy,
        [Parameter (Mandatory = $false)]
        [switch]$gui_sslvpn_personal_bookmarks,
        [Parameter (Mandatory = $false)]
        [switch]$gui_ztna,
        [Parameter (Mandatory = $false)]
        [ValidateSet('enable', 'disable', 'global', IgnoreCase = $false)]
        [string]$lldp_transmission,
        [Parameter (Mandatory = $false)]
        [ValidateSet('enable', 'disable', 'global', IgnoreCase = $false)]
        [string]$lldp_reception,
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

        if ( $PsBoundParameters.ContainsKey('inspection_mode') ) {
            #with 6.2.x, there is no longer visibility parameter
            if ($connection.version -ge "6.2.0") {
                Write-Warning "inspection_mode (proxy/flow) parameter is no longer available with FortiOS 6.2.x and after"
            } else {
                $_ss | Add-member -name "inspection-mode" -membertype NoteProperty -Value $inspection_mode
            }
        }

        if ( $PsBoundParameters.ContainsKey('gui_allow_unnamed_policy') ) {
            if ($gui_allow_unnamed_policy) {
                $_ss | Add-member -name "gui-allow-unnamed-policy" -membertype NoteProperty -Value "enable"
            }
            else {
                $_ss | Add-member -name "gui-allow-unnamed-policy" -membertype NoteProperty -Value "disable"
            }
        }

        if ( $PsBoundParameters.ContainsKey('gui_dns_database') ) {
            if ($gui_dns_database) {
                $_ss | Add-member -name "gui-dns-database" -membertype NoteProperty -Value "enable"
            }
            else {
                $_ss | Add-member -name "gui-dns-database" -membertype NoteProperty -Value "disable"
            }
        }

        if ( $PsBoundParameters.ContainsKey('gui_explicit_proxy') ) {
            if ($gui_explicit_proxy) {
                $_ss | Add-member -name "gui-explicit-proxy" -membertype NoteProperty -Value "enable"
            }
            else {
                $_ss | Add-member -name "gui-explicit-proxy" -membertype NoteProperty -Value "disable"
            }
        }

        if ( $PsBoundParameters.ContainsKey('gui_sslvpn_personal_bookmarks') ) {
            if ($gui_sslvpn_personal_bookmarks) {
                $_ss | Add-member -name "gui-sslvpn-personal-bookmarks" -membertype NoteProperty -Value "enable"
            }
            else {
                $_ss | Add-member -name "gui-sslvpn-personal-bookmarks" -membertype NoteProperty -Value "disable"
            }
        }

        if ( $PsBoundParameters.ContainsKey('gui_ztna') ) {
            #before 7.0.x, there is not ZTNA
            if ($connection.version -lt "7.0.0") {
                Write-Warning "gui_ztna parameter is (yet) not available"
            }
            else {
                if ($gui_ztna) {
                    $_ss | Add-member -name "gui-ztna" -membertype NoteProperty -Value "enable"
                }
                else {
                    $_ss | Add-member -name "gui-ztna" -membertype NoteProperty -Value "disable"
                }
            }
        }

        if ( $PsBoundParameters.ContainsKey('lldp_transmission') ) {
            $_ss | Add-member -name "lldp-transmission" -membertype NoteProperty -Value $lldp_transmission
        }

        if ( $PsBoundParameters.ContainsKey('lldp_reception') ) {
            #before 6.2.x, there is not lldp_recetion
            if ($connection.version -lt "6.2.0") {
                Write-Warning "lldp_reception parameter is (yet) not available"
            }  else {
                $_ss | Add-member -name "lldp-reception" -membertype NoteProperty -Value $lldp_reception
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

        Get-FGTSystemSettings -connection $connection @invokeParams
    }

    End {
    }
}
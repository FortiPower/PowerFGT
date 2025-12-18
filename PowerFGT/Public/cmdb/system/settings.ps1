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
        Get-FGTSystemSettings -schema

        Get schema of System Settings

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
        [Parameter(Mandatory = $false, ParameterSetName = "schema")]
        [switch]$schema,
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

        if ( $PsBoundParameters.ContainsKey('schema') ) {
            $invokeParams.add( 'extra', "&action=schema" )
        }

        #Filtering
        #if filter value and filter_attribute, add filter (by default filter_type is equal)
        if ( $filter_value -and $filter_attribute ) {
            $invokeParams.add( 'filter_value', $filter_value )
            $invokeParams.add( 'filter_attribute', $filter_attribute )
            $invokeParams.add( 'filter_type', $filter_type )
        }

        $response = Invoke-FGTRestMethod -uri 'api/v2/cmdb/system/settings' -method 'GET' -connection $connection @invokeParams
        if ( $PsBoundParameters.ContainsKey('name') ) {
            $ss = new-Object -TypeName PSObject
            #display value to PSObject (with name and value)
            foreach ($n in $name) {
                $n = $n -replace "_", "-" # replace _ by - can be useful for search setting name
                if ($response.results.$n) {
                    $ss | Add-member -name $n -membertype NoteProperty -Value $response.results.$n
                }
            }
            $ss
        }
        else {
            $response.results
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
        [switch]$allow_subnet_overlap,
        [Parameter (Mandatory = $false)]
        [switch]$central_nat,
        [Parameter (Mandatory = $false)]
        [ValidateSet('proxy', 'flow', IgnoreCase = $false)]
        [string]$inspection_mode,
        [Parameter (Mandatory = $false)]
        [switch]$gui_allow_unnamed_policy,
        [Parameter (Mandatory = $false)]
        [switch]$gui_dns_database,
        [Parameter (Mandatory = $false)]
        [switch]$gui_dynamic_routing,
        [Parameter (Mandatory = $false)]
        [switch]$gui_explicit_proxy,
        [Parameter (Mandatory = $false)]
        [switch]$gui_ips,
        [Parameter (Mandatory = $false)]
        [switch]$gui_load_balance,
        [Parameter (Mandatory = $false)]
        [switch]$gui_local_in_policy,
        [Parameter (Mandatory = $false)]
        [switch]$gui_proxy_inspection,
        [Parameter (Mandatory = $false)]
        [switch]$gui_multiple_interface_policy,
        [Parameter (Mandatory = $false)]
        [switch]$gui_multiple_utm_profiles,
        [Parameter (Mandatory = $false)]
        [switch]$gui_spamfilter,
        [Parameter (Mandatory = $false)]
        [switch]$gui_sslvpn,
        [Parameter (Mandatory = $false)]
        [switch]$gui_sslvpn_personal_bookmarks,
        [Parameter (Mandatory = $false)]
        [switch]$gui_sslvpn_realms,
        [Parameter (Mandatory = $false)]
        [switch]$gui_voip_profile,
        [Parameter (Mandatory = $false)]
        [switch]$gui_waf_profile,
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

        if ( $PsBoundParameters.ContainsKey('allow_subnet_overlap') ) {
            if ($allow_subnet_overlap) {
                $_ss | Add-member -name "allow-subnet-overlap" -membertype NoteProperty -Value "enable"
            }
            else {
                $_ss | Add-member -name "allow-subnet-overlap" -membertype NoteProperty -Value "disable"
            }
        }

        if ( $PsBoundParameters.ContainsKey('central_nat') ) {
            if ($central_nat) {
                $_ss | Add-member -name "central-nat" -membertype NoteProperty -Value "enable"
            }
            else {
                $_ss | Add-member -name "central-nat" -membertype NoteProperty -Value "disable"
            }
        }

        if ( $PsBoundParameters.ContainsKey('inspection_mode') ) {
            #with 6.2.x, there is no longer inspection-mode parameter
            if ($connection.version -ge "6.2.0") {
                Write-Warning "inspection_mode (proxy/flow) parameter is no longer available with FortiOS 6.2.x and after"
            }
            else {
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

        if ( $PsBoundParameters.ContainsKey('gui_dynamic_routing') ) {
            if ($gui_dynamic_routing) {
                $_ss | Add-member -name "gui-dynamic-routing" -membertype NoteProperty -Value "enable"
            }
            else {
                $_ss | Add-member -name "gui-dynamic-routing" -membertype NoteProperty -Value "disable"
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

        if ( $PsBoundParameters.ContainsKey('gui_ips') ) {
            if ($gui_ips) {
                $_ss | Add-member -name "gui-ips" -membertype NoteProperty -Value "enable"
            }
            else {
                $_ss | Add-member -name "gui-ips" -membertype NoteProperty -Value "disable"
            }
        }

        if ( $PsBoundParameters.ContainsKey('gui_load_balance') ) {
            if ($gui_load_balance) {
                $_ss | Add-member -name "gui-load-balance" -membertype NoteProperty -Value "enable"
            }
            else {
                $_ss | Add-member -name "gui-load-balance" -membertype NoteProperty -Value "disable"
            }
        }

        if ( $PsBoundParameters.ContainsKey('gui_local_in_policy') ) {
            if ($gui_local_in_policy) {
                $_ss | Add-member -name "gui-local-in-policy" -membertype NoteProperty -Value "enable"
            }
            else {
                $_ss | Add-member -name "gui-local-in-policy" -membertype NoteProperty -Value "disable"
            }
        }

        if ( $PsBoundParameters.ContainsKey('gui_proxy_inspection') ) {
            if ($gui_proxy_inspection) {
                $_ss | Add-member -name "gui-proxy-inspection" -membertype NoteProperty -Value "enable"
            }
            else {
                $_ss | Add-member -name "gui-proxy-inspection" -membertype NoteProperty -Value "disable"
            }
        }

        if ( $PsBoundParameters.ContainsKey('gui_multiple_interface_policy') ) {
            if ($gui_multiple_interface_policy) {
                $_ss | Add-member -name "gui-multiple-interface-policy" -membertype NoteProperty -Value "enable"
            }
            else {
                $_ss | Add-member -name "gui-multiple-interface-policy" -membertype NoteProperty -Value "disable"
            }
        }

        if ( $PsBoundParameters.ContainsKey('gui_multiple_utm_profiles') ) {
            #with 6.4.x, there is no longer gui-multiple-utm-profiles parameter
            if ($connection.version -ge "6.4.0") {
                Write-Warning "gui_multiple_interface_policy  parameter is no longer available with FortiOS 6.4.x and after"
            }
            else {
                if ($gui_multiple_utm_profiles) {
                    $_ss | Add-member -name "gui-multiple-utm-profiles" -membertype NoteProperty -Value "enable"
                }
                else {
                    $_ss | Add-member -name "gui-multiple-utm-profiles" -membertype NoteProperty -Value "disable"
                }
            }
        }

        if ( $PsBoundParameters.ContainsKey('gui_spamfilter') ) {
            if ($gui_spamfilter) {
                $_ss | Add-member -name "gui-spamfilter" -membertype NoteProperty -Value "enable"
            }
            else {
                $_ss | Add-member -name "gui-spamfilter" -membertype NoteProperty -Value "disable"
            }
        }

        #Coming with FortiOS 7.4.x, you can enable gui SSLVPN...
        if ( $PsBoundParameters.ContainsKey('gui_sslvpn') ) {
            if ($gui_sslvpn) {
                $_ss | Add-member -name "gui-sslvpn" -membertype NoteProperty -Value "enable"
            }
            else {
                $_ss | Add-member -name "gui-sslvpn" -membertype NoteProperty -Value "disable"
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

        if ( $PsBoundParameters.ContainsKey('gui_sslvpn_realms') ) {
            if ($gui_sslvpn_realms) {
                $_ss | Add-member -name "gui-sslvpn-realms" -membertype NoteProperty -Value "enable"
            }
            else {
                $_ss | Add-member -name "gui-sslvpn-realms" -membertype NoteProperty -Value "disable"
            }
        }

        if ( $PsBoundParameters.ContainsKey('gui_voip_profile') ) {
            if ($gui_voip_profile) {
                $_ss | Add-member -name "gui-voip-profile" -membertype NoteProperty -Value "enable"
            }
            else {
                $_ss | Add-member -name "gui-voip-profile" -membertype NoteProperty -Value "disable"
            }
        }

        if ( $PsBoundParameters.ContainsKey('gui_waf_profile') ) {
            if ($gui_waf_profile) {
                $_ss | Add-member -name "gui-waf-profile" -membertype NoteProperty -Value "enable"
            }
            else {
                $_ss | Add-member -name "gui-waf-profile" -membertype NoteProperty -Value "disable"
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
            }
            else {
                $_ss | Add-member -name "lldp-reception" -membertype NoteProperty -Value $lldp_reception
            }
        }

        if ( $PsBoundParameters.ContainsKey('data') ) {
            $data.GetEnumerator() | ForEach-Object {
                $_ss | Add-member -name $_.key -membertype NoteProperty -Value $_.value
            }
        }

        if ($PSCmdlet.ShouldProcess("System", 'Configure Settings')) {
            Invoke-FGTRestMethod -method "PUT" -body $_ss -uri $uri -connection $connection @invokeParams | Out-Null
        }

        Get-FGTSystemSettings -connection $connection @invokeParams
    }

    End {
    }
}
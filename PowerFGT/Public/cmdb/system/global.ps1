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

        $reponse = Invoke-FGTRestMethod -uri 'api/v2/cmdb/system/global' -method 'GET' -connection $connection @invokeParams
        if ( $PsBoundParameters.ContainsKey('name') ) {
            $sg = new-Object -TypeName PSObject
            #display value to PSObject (with name and value)
            foreach ($n in $name) {
                $n = $n -replace "_", "-" # replace _ by - can be useful for search 'global' setting name
                if ($reponse.results.$n) {
                    $sg | Add-member -name $n -membertype NoteProperty -Value $reponse.results.$n
                }
            }
            $sg
        }
        else {
            $reponse.results
        }
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
        [ValidateRange("1", "480")]
        [int]$admintimeout,
        [Parameter (Mandatory = $false)]
        [ValidateRange(1, 65535)]
        [int]$admin_port,
        [Parameter (Mandatory = $false)]
        [ValidateRange(1, 65535)]
        [int]$admin_sport,
        [Parameter (Mandatory = $false)]
        [ValidateRange(1, 65535)]
        [int]$admin_ssh_port,
        [Parameter (Mandatory = $false)]
        [string]$alias,
        [Parameter (Mandatory = $false)]
        [switch]$dst,
        [Parameter (Mandatory = $false)]
        [switch]$fortiextender,
        [Parameter (Mandatory = $false)]
        [string]$hostname,
        [Parameter (Mandatory = $false)]
        [switch]$gui_certificates,
        [Parameter (Mandatory = $false)]
        [switch]$gui_wireless_opensecurity,
        [Parameter (Mandatory = $false)]
        [switch]$lldp_reception,
        [Parameter (Mandatory = $false)]
        [switch]$lldp_transmission,
        [Parameter (Mandatory = $false)]
        [switch]$switch_controller,
        [Parameter (Mandatory = $false)]
        [ValidateRange(00, 86)]
        [int]$timezone,
        [Parameter (Mandatory = $false)]
        [switch]$wireless_controller,
        [Parameter (Mandatory = $false)]
        [hashtable]$data,
        [Parameter(Mandatory = $false)]
        [String[]]$vdom,
        [Parameter(Mandatory = $false)]
        [psobject]$connection = $DefaultFGTConnection
    )

    <#
    gui-certificates                         : enable
    gui-wireless-opensecurity                : enable
    admin-port                               : 80
admin-sport                              : 443
admin-ssh-port                           : 22
wireless-controller                      : enable
fortiextender                            : disable
switch-controller                        : enable
    #>
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
                $_sg | Add-member -name "dst" -membertype NoteProperty -Value "enable"
            }
            else {
                $_sg | Add-member -name "dst" -membertype NoteProperty -Value "disable"
            }
        }

        if ( $PsBoundParameters.ContainsKey('admintimeout') ) {
            $_sg | add-member -name "admintimeout" -membertype NoteProperty -Value $admintimeout
        }

        if ( $PsBoundParameters.ContainsKey('admin_port') ) {
            $_sg | add-member -name "admin-port" -membertype NoteProperty -Value $admin_port
        }

        if ( $PsBoundParameters.ContainsKey('admin_sport') ) {
            $_sg | add-member -name "admin-sport" -membertype NoteProperty -Value $admin_sport
        }

        if ( $PsBoundParameters.ContainsKey('admin_ssh_port') ) {
            $_sg | add-member -name "admin-ssh-port" -membertype NoteProperty -Value $admin_ssh_port
        }

        if ( $PsBoundParameters.ContainsKey('gui_certificates') ) {
            if ($gui_certificates) {
                $_sg | Add-member -name "gui-certificates" -membertype NoteProperty -Value "enable"
            }
            else {
                $_sg | Add-member -name "gui-certificates" -membertype NoteProperty -Value "disable"
            }
        }

        if ( $PsBoundParameters.ContainsKey('gui_wireless_opensecurity') ) {
            if ($gui_wireless_opensecurity) {
                $_sg | Add-member -name "gui-wireless-opensecurity" -membertype NoteProperty -Value "enable"
            }
            else {
                $_sg | Add-member -name "gui-wireless-opensecurity" -membertype NoteProperty -Value "disable"
            }
        }

        if ( $PsBoundParameters.ContainsKey('fortiextender') ) {
            if ($fortiextender) {
                $_sg | Add-member -name "fortiextender" -membertype NoteProperty -Value "enable"
            }
            else {
                $_sg | Add-member -name "fortiextender" -membertype NoteProperty -Value "disable"
            }
        }

        if ( $PsBoundParameters.ContainsKey('lldp_reception') ) {
            #before 6.2.x, there is not lldp_recetion
            if ($connection.version -lt "6.2.0") {
                Write-Warning "lldp_reception parameter is (yet) not available"
            }  else {
                if ($lldp_reception) {
                    $_sg | Add-member -name "lldp-reception" -membertype NoteProperty -Value "enable"
                }
                else {
                    $_sg | Add-member -name "lldp-reception" -membertype NoteProperty -Value "disable"
                }
            }
        }

        if ( $PsBoundParameters.ContainsKey('lldp_transmission') ) {
            if ($lldp_transmission) {
                $_sg | Add-member -name "lldp-transmission" -membertype NoteProperty -Value "enable"
            }
            else {
                $_sg | Add-member -name "lldp-transmission" -membertype NoteProperty -Value "disable"
            }
        }

        if ( $PsBoundParameters.ContainsKey('switch_controller') ) {
            if ($switch_controller) {
                $_sg | Add-member -name "switch-controller" -membertype NoteProperty -Value "enable"
            }
            else {
                $_sg | Add-member -name "switch-controller" -membertype NoteProperty -Value "disable"
            }
        }

        if ( $PsBoundParameters.ContainsKey('wireless_controller') ) {
            if ($wireless_controller) {
                $_sg | Add-member -name "wireless-controller" -membertype NoteProperty -Value "enable"
            }
            else {
                $_sg | Add-member -name "wireless-controller" -membertype NoteProperty -Value "disable"
            }
        }

        if ( $PsBoundParameters.ContainsKey('data') ) {
            $data.GetEnumerator() | ForEach-Object {
                $_sg | Add-member -name $_.key -membertype NoteProperty -Value $_.value
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
#
# Copyright, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#
function Get-FGTAntivirusProfile {

    <#
        .SYNOPSIS
        Get list of all Antivirus Profile settings

        .DESCRIPTION
        Get list of all Antivirus Profile (name, feature-set, protocol (http, ftp, imap...) ...)

        .EXAMPLE
        Get-FGTAntivirusProfile

        Get list of all settings of Antivirus Profile

        .EXAMPLE
        Get-FGTAntivirusProfile -name myAntivirusProfile

        Get Antivirus Profile named myAntivirusProfile

        .EXAMPLE
        Get-FGTAntivirusProfile -name FGT -filter_type contains

        Get Antivirus Profile contains with *FGT*

        .EXAMPLE
        Get-FGTAntivirusProfile -meta

        Get list of all settings of Antivirus Profile with metadata (q_...) like usage (q_ref)

        .EXAMPLE
        Get-FGTAntivirusProfile -skip

        Get list of all settings of Antivirus Profile (but only relevant attributes)

        .EXAMPLE
        Get-FGTAntivirusProfile -schema

        Get schema of Antivirus Profile

        .EXAMPLE
        Get-FGTAntivirusProfile -vdom vdomX

        Get list of all settings of Antivirus Profile on vdomX
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
        [switch]$meta,
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

        $uri = 'api/v2/cmdb/antivirus/profile'

        $invokeParams = @{ }
        if ( $PsBoundParameters.ContainsKey('meta') ) {
            $invokeParams.add( 'meta', $meta )
        }
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

        $response = Invoke-FGTRestMethod -uri $uri -method 'GET' -connection $connection @invokeParams
        $response.results
    }

    End {
    }
}

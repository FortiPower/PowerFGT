#
# Copyright 2022, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#
function Get-FGTMonitorWebfilterCategories {

    <#
        .SYNOPSIS
        GetFortiGuard web filter categories

        .DESCRIPTION
        Get FortiGuard web filter categories (and unrated)

        .EXAMPLE
        Get-FGTMonitorWebfilterCategories

        Get FortiGuard web filter categorie (name, group_id, group, rating)

        .EXAMPLE
        Get-FGTMonitorWebfilterCategories -include_unrated

        Get FortiGuard web filter categories with unrated
    #>

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseSingularNouns", "")]
    Param(
        [Parameter(Mandatory = $false)]
        [switch]$include_unrated,
        [Parameter(Mandatory = $false)]
        [switch]$convert_unrated_id,
        [Parameter (Mandatory = $false)]
        [switch]$skip,
        [Parameter(Mandatory = $false)]
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
        if ( $PsBoundParameters.ContainsKey('schema') ) {
            $invokeParams.add( 'schema', $schema )
        }
        if ( $PsBoundParameters.ContainsKey('vdom') ) {
            $invokeParams.add( 'vdom', $vdom )
        }

        $uri = 'api/v2/monitor/webfilter/fortiguard-categories?'

        if ($include_unrated) {
            $uri += "&include_unrated=true"
        }

        if ($convert_unrated_id) {
            $uri += "&convert_unrated_id=true"
        }

        $response = Invoke-FGTRestMethod -uri $uri -method 'GET' -connection $connection @invokeParams
        $response.results
    }

    End {
    }
}

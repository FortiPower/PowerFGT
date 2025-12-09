#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#
function Get-FGTFirewallAccessProxy {

    <#
        .SYNOPSIS
        Get list of all (ZTNA) Access Proxy

        .DESCRIPTION
        Get list of all (ZTNA) Access Proxy (vip, auth-portal, api-gateway...)

        .EXAMPLE
        Get-FGTFirewallAccessProxy

        Get list of all Access Proxy object

        .EXAMPLE
        Get-FGTFirewallAccessProxy -name myAccessProxy

        Get Access Proxy named myAccessProxy

        .EXAMPLE
        Get-FGTFirewallAccessProxy -name FGT -filter_type contains

        Get Access Proxy contains with *FGT*

        .EXAMPLE
        Get-FGTFirewallAccessProxy -meta

        Get list of all Access Proxy object with metadata (q_...) like usage (q_ref)

        .EXAMPLE
        Get-FGTFirewallAccessProxy -skip

        Get list of all Access Proxy  object (but only relevant attributes)

       .EXAMPLE
        Get-FGTFirewallAccessProxy -vdom vdomX

        Get list of all Access Proxy object on vdomX
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
        [Parameter(Mandatory = $false)]
        [String[]]$vdom,
        [Parameter(Mandatory = $false)]
        [psobject]$connection = $DefaultFGTConnection
    )

    Begin {
    }

    Process {

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

        $response = Invoke-FGTRestMethod -uri 'api/v2/cmdb/firewall/access-proxy' -method 'GET' -connection $connection @invokeParams
        $response.results

    }

    End {
    }
}
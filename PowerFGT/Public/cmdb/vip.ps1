#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
# Copyright 2019, Benjamin Perrier <ben dot perrier at outlook dot com>
#
# SPDX-License-Identifier: Apache-2.0
#
function Get-FGTVip {

    <#
        .SYNOPSIS
        Get list of all (NAT) Virtual IP

        .DESCRIPTION
        Get list of all (NAT) Virtual IP (Ext IP, mapped IP, type...)

        .EXAMPLE
        Get-FGTVip

        Get list of all nat vip object

    #>

    Begin {
    }

    Process {

        $invokeParams = @{ }
        if ( $PsBoundParameters.ContainsKey('skip') ) {
            $invokeParams.add( 'skip', $skip )
        }

        $response = Invoke-FGTRestMethod -uri 'api/v2/cmdb/firewall/vip' -method 'GET' @invokeParams
        $response.results
    }

    End {
    }
}
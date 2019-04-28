#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
# Copyright 2019, Benjamin Perrier <ben dot perrier at outlook dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

function Get-FGTLocaluser {

    <#
        .SYNOPSIS
        Get list of all "local users"

        .DESCRIPTION
        Get list of all "local users" (name, type, status... )

        .EXAMPLE
        Get-FGTLocaluser
        Display all local users
    #>

    Begin {
    }

    Process {
        $reponse = Invoke-FGTRestMethod -uri 'api/v2/cmdb/user/local' -method 'GET'
        $reponse.results
    }

    End {
    }
}
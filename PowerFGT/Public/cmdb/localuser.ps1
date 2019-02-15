#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
# Copyright 2019, Benjamin Perrier <ben dot perrier at outlook dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

function Get-FGTLocalUser {

     <#
        .SYNOPSIS
        Get list of all "local users"
        .DESCRIPTION
        Get list of all "local users"
        .EXAMPLE
        Get-FGTLocalUser
        Display all local users
    #>
    
        $reponse = Invoke-FGTRestMethod -uri 'api/v2/cmdb/user/local' -method 'GET'
        $reponse.results

    }
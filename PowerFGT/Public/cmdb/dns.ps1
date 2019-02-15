#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
# Copyright 2019, Benjamin Perrier <ben dot perrier at outlook dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

function Get-FGTDns {
  
       <#
        .SYNOPSIS
        Get dns addresses configured.
        .DESCRIPTION
        Show dns addresses configured.
        .EXAMPLE
        Get-FGTDns
        Display all dns addresses.
        
    #>  


        $reponse = Invoke-FGTRestMethod -uri 'api/v2/cmdb/system/dns' -method 'GET'
        $reponse.results

    }
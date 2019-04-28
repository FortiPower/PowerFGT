#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
# Copyright 2019, Benjamin Perrier <ben dot perrier at outlook dot com>
#
# SPDX-License-Identifier: Apache-2.0
#
function Get-FGTInterface {

    <#
      .SYNOPSIS
      Get list of all interface

      .DESCRIPTION
      Get list of all interface (name, IP Address, description, mode ...)

      .EXAMPLE
      Get-FGTInterface

      Get list of all interface

    #>

    Begin {
    }

    Process {
        $response = Invoke-FGTRestMethod -uri 'api/v2/cmdb/system/interface' -method 'GET'
        $response.results
    }

    End {
    }
}

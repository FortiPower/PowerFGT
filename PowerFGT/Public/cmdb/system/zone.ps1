#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
# Copyright 2019, Benjamin Perrier <ben dot perrier at outlook dot com>
#
# SPDX-License-Identifier: Apache-2.0
#
function Get-FGTSystemZone {

    <#
      .SYNOPSIS
      Get list of all "zone"

      .DESCRIPTION
      Get list of all "zone"

      .EXAMPLE
      Get-FGTSystemZone

      Get list of all zone object

      .EXAMPLE
      Get-FGTSystemZone -skip

      Get list of all zone object (but only relevant attributes)
    #>

    Begin {
    }

    Process {

      $invokeParams = @{ }
      if ( $PsBoundParameters.ContainsKey('skip') ) {
          $invokeParams.add( 'skip', $skip )
      }

        $response = Invoke-FGTRestMethod -uri 'api/v2/cmdb/system/zone' -method 'GET' @invokeParams
        $response.results
    }

    End {
    }
}
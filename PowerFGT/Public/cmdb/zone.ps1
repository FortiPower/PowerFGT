#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
# Copyright 2019, Benjamin Perrier <ben dot perrier at outlook dot com>
#
# SPDX-License-Identifier: Apache-2.0
#
function Get-FGTZone {

    <#
      .SYNOPSIS
      Get list of all "zone"

      .DESCRIPTION
      Get list of all "zone"

      .EXAMPLE
      Get-FGTZone

      Get list of all zone object
  #>

    $response = Invoke-FGTRestMethod -uri 'api/v2/cmdb/system/zone' -method 'GET'
    $response.results

}
#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
# Copyright 2019, Benjamin Perrier <ben dot perrier at outlook dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

function Get-FGTRoutePolicy{

  <#
      .SYNOPSIS
      Get list of all "route policy"

      .DESCRIPTION
      Get list of all "route policy"

      .EXAMPLE
      Get-FGTRoutePolicy

      Get list of all route policy object
  #>

$reponse = Invoke-FGTRestMethod -uri 'api/v2/cmdb/router/policy' -method 'GET'
$reponse.results

}

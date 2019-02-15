#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
# Copyright 2019, Benjamin Perrier <ben dot perrier at outlook dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

function Get-FGTStaticRoute{

  <#
      .SYNOPSIS
      Get list of all "static routes"

      .DESCRIPTION
      Get list of all "static routes"

      .EXAMPLE
      Get-FGTStaticRoute

      Get list of all static route object
  #>

        $reponse = Invoke-FGTRestMethod -uri 'api/v2/cmdb/router/static' -method 'GET'
        $reponse.results



}

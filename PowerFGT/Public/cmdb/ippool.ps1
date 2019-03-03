#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
# Copyright 2019, Benjamin Perrier <ben dot perrier at outlook dot com>
#
# SPDX-License-Identifier: Apache-2.0
#
function Get-FGTNatIpPool {

  <#
      .SYNOPSIS
      Get list of all "nat ip pool"

      .DESCRIPTION
      Get list of all "nat ip pool" 

      .EXAMPLE
      Get-FGTNatIpPool

      Get list of all nat ip pool object
  #>

$reponse = Invoke-FGTRestMethod -uri 'api/v2/cmdb/firewall/ippool' -method 'GET'
$reponse.results

        }
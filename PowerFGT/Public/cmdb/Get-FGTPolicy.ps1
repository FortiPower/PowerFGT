#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
# Copyright 2019, Benjamin Perrier <ben dot perrier at outlook dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

function Get-FGTPolicy {
    
  <#
      .SYNOPSIS
      Get list of all policies

      .DESCRIPTION
      Get list of all policies (name, source, destination...)

      .EXAMPLE
      Get-FGTPolicy

      Get list of all policies

      Get-FGTPolicy | select name, srcintf, dstintf, srcaddr, dstaddr, action, status, schedule, service, nat

      Get list of all policies with a selection of attributes

  #>

$reponse = Invoke-FGTRestMethod -uri 'api/v2/cmdb/firewall/policy' -method 'GET'
$reponse.results

   }
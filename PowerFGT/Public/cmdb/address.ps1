#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
# Copyright 2019, Benjamin Perrier <ben dot perrier at outlook dot com>
#
# SPDX-License-Identifier: Apache-2.0
#
function Get-FGTAddress {


    $reponse = Invoke-FGTRestMethod -uri 'api/v2/cmdb/firewall/address' -method 'GET'
    $reponse.results

}
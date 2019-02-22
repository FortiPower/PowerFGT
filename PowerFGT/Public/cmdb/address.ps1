#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
# Copyright 2019, Benjamin Perrier <ben dot perrier at outlook dot com>
#
# SPDX-License-Identifier: Apache-2.0
#
function Add-FGTAddress {

    <#
        .SYNOPSIS
        Add a FortiGate Address

        .DESCRIPTION
        Add a FortiGate Address (ipmask, fqdn, widlcard...)

        .EXAMPLE
        Add-FGTAddress -type ipmask -Name FGT -ip 192.2.0.0 -mask 255.255.255.0

        Add Address objet type ipmask with name FGT and value 192.2.0.0/24

    #>

    Param(
        [Parameter (Mandatory = $true)]
        [string]$type,
        [Parameter (Mandatory = $true)]
        [string]$name,
        [Parameter (Mandatory = $false)]
        [ipaddress]$ip,
        [Parameter (Mandatory = $false)]
        [ipaddress]$mask
    )

    Begin {
    }

    Process {

        $uri = "api/v2/cmdb/firewall/address"

        $address = new-Object -TypeName PSObject

        $address | add-member -name "type" -membertype NoteProperty -Value $type

        $address | add-member -name "name" -membertype NoteProperty -Value $name

        $subnet = $ip.ToString()
        $subnet += "/"
        $subnet += $mask.ToString()
        $address | add-member -name "subnet" -membertype NoteProperty -Value $subnet

        Invoke-FGTRestMethod -method "POST" -body $address -uri $uri | out-Null

        Get-FGTAddress | Where-Object {$_.name -eq $name}
    }

    End {
    }
}


function Get-FGTAddress {

    <#
      .SYNOPSIS
      Get list of all "address"

      .DESCRIPTION
      Get list of all "address" (ipmask, fqdn, wildcard...)

      .EXAMPLE
      Get-FGTAddress

      Get list of all address object
  #>

    $reponse = Invoke-FGTRestMethod -uri 'api/v2/cmdb/firewall/address' -method 'GET'
    $reponse.results

}
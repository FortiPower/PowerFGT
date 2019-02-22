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
        [ValidateSet("ipmask")]
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

function Remove-FGTAddress {

    <#
        .SYNOPSIS
        Remove a FortiGate Address

        .DESCRIPTION
        Remove a address object on the FortiGate

        .EXAMPLE
        $MyFGTAddress = Get-FGTAddress -name MyFGTAddress
        PS C:\>$MyFGTAddress | Remove-FGTAddress

        Remove address object $MyFGTAddress

                .EXAMPLE
        $MyFGTAddress = Get-FGTAddress -name MyFGTAddress
        PS C:\>$MyFGTAddress | Remove-FGTAddress -noconfirm

        Remove address object $MyFGTAddress with no confirmation
    #>

    Param(
        [Parameter (Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        #ValidateScript({ ValidateFGTAddress $_ })]
        [psobject]$address,
        [Parameter(Mandatory = $false)]
        [switch]$noconfirm
    )

    Begin {
    }

    Process {

        $url = "api/v2/cmdb/firewall/address/$($address.name)"
        $url
        if ( -not ( $Noconfirm )) {
            $message = "Remove address on Fortigate"
            $question = "Proceed with removal of Address $($address.name) ?"
            $choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
            $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
            $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))

            $decision = $Host.UI.PromptForChoice($message, $question, $choices, 1)
        }
        else { $decision = 0 }
        if ($decision -eq 0) {
            Write-Progress -activity "Remove Address"
            $null = Invoke-FGTRestMethod -method "DELETE" -uri $url
            Write-Progress -activity "Remove Address" -completed
        }
    }

    End {
    }
}
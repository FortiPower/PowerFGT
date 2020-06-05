#
# Copyright 2020, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
# Copyright 2020, Arthur Heijnen <arthur dot heijnen at live dot nl>
#
# SPDX-License-Identifier: Apache-2.0
#
function Add-FGTFirewallProxyAddress {

    <#
        .SYNOPSIS
        Add a FortiGate ProxyAddress

        .DESCRIPTION
        Add a FortiGate ProxyAddress (host-regex, url ...)

        .EXAMPLE
        Add-FGTFirewallProxyAddress -name FGT -hostregex '.*\.fortinet\.com'

        Add ProxyAddress object type host-regex with name FGT and value '.*\.fortinet\.com'

        .EXAMPLE
        Add-FGTFirewallProxyAddress -Name FGT -method get -hostObjectName MyFGTAddress -comment "Get-only allowed to MyFGTAddress"

        Add ProxyAddress object type method with name FGT, only allow method GET to MyHost and a comment

        .EXAMPLE
        Add-FGTFirewallProxyAddress -name FGT -hostObjectName fortipower.github.io -path '/PowerFGT' -visibility:$false

        Add ProxyAddress object type url with name FGT, only allow path '/PowerFGT' to fortipower.github.io and disabled visibility

        Todo: add the Category, UA and Header types
    #>
    [CmdletBinding(DefaultParameterSetName = "default")]
    Param(
        [Parameter (Mandatory = $true)]
        [ValidateLength(0, 35)]
        [string]$name,
        [Parameter (Mandatory = $false, ParameterSetName = "host-regex")]
        [string]$hostregex,
        [Parameter (Mandatory = $false, ParameterSetName = "url")]
        [string]$path,
        [Parameter (Mandatory = $false, ParameterSetName = "method")]
        [ValidateSet("connect", "delete", "get", "head", "options", "post", "put", "trace", IgnoreCase = $false)]
        [string]$method,
        [Parameter (Mandatory = $false, ParameterSetName = "url")]
        [Parameter (ParameterSetName = "method")]
        [string]$hostObjectName,
        [Parameter (Mandatory = $false)]
        [ValidateLength(0, 255)]
        [string]$comment,
        [Parameter (Mandatory = $false)]
        [boolean]$visibility,
        [Parameter(Mandatory = $false)]
        [String[]]$vdom,
        [Parameter(Mandatory = $false)]
        [psobject]$connection = $DefaultFGTConnection
    )

    Begin {
    }

    Process {

        $invokeParams = @{ }
        if ( $PsBoundParameters.ContainsKey('vdom') ) {
            $invokeParams.add( 'vdom', $vdom )
        }

        if ( Get-FGTFirewallProxyAddress @invokeParams -name $name -connection $connection) {
            Throw "Already a ProxyAddress object using the same name"
        }

        $uri = "api/v2/cmdb/firewall/proxy-address"

        $proxyaddress = new-Object -TypeName PSObject

        $proxyaddress | add-member -name "type" -membertype NoteProperty -Value $PSCmdlet.ParameterSetName

        $proxyaddress | add-member -name "name" -membertype NoteProperty -Value $name


        if ( $PSCmdlet.ParameterSetName -eq 'host-regex' ) {
            $proxyaddress | add-member "host-regex" -membertype NoteProperty -Value $hostregex
        }

        if ( $PSCmdlet.ParameterSetName -eq 'url' ) {
            if (!(Get-FGTFirewallAddress @invokeParams -name $hostObjectName -connection $connection) -and `
                    !(Get-FGTFirewallProxyAddress @invokeParams -name $hostObjectName -connection $connection) `
            ) {
                Throw "FirewallAddress or FirewallProxyAddress $hostObjectName not Found"
            }
            $proxyaddress | add-member -name "host" -membertype NoteProperty -Value $hostObjectName
            $proxyaddress | add-member -name "path" -membertype NoteProperty -Value $path
        }


        if ( $PSCmdlet.ParameterSetName -eq 'method' ) {
            if (!(Get-FGTFirewallAddress @invokeParams -name $hostObjectName -connection $connection) `
            ) {
                Throw "FirewallAddress $hostObjectName not Found"
            }
            $proxyaddress | add-member -name "host" -membertype NoteProperty -Value $hostObjectName
            $proxyaddress | add-member -name "method" -membertype NoteProperty -Value $method
        }


        if ( $PsBoundParameters.ContainsKey('comment') ) {
            $proxyaddress | add-member -name "comment" -membertype NoteProperty -Value $comment
        }

        if ( $PsBoundParameters.ContainsKey('visibility') ) {
            if ( $visibility ) {
                $proxyaddress | add-member -name "visibility" -membertype NoteProperty -Value "enable"
            }
            else {
                $proxyaddress | add-member -name "visibility" -membertype NoteProperty -Value "disable"
            }
        }

        Invoke-FGTRestMethod -method "POST" -body $proxyaddress -uri $uri -connection $connection @invokeParams | out-Null

        Get-FGTFirewallProxyAddress -connection $connection @invokeParams -name $name
    }

    End {
    }
}

function Copy-FGTFirewallProxyAddress {

    <#
        .SYNOPSIS
        Copy/Clone a FortiGate ProxyAddress

        .DESCRIPTION
        Copy/Clone a FortiGate ProxyAddress (host-regex, url ...)

        .EXAMPLE
        $MyFGTProxyAddress = Get-FGTFirewallProxyAddress -name MyFGTProxyAddress
        $MyFGTProxyAddress | Copy-FGTFirewallProxyAddress -name MyFGTProxyAddress_copy

        Copy / Clone MyFGTProxyAddress and name MyFGTProxyAddress_copy

    #>

    Param(
        [Parameter (Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        [ValidateScript( { Confirm-FGTProxyAddress $_ })]
        [psobject]$address,
        [Parameter (Mandatory = $true)]
        [ValidateLength(0, 35)]
        [string]$name,
        [Parameter(Mandatory = $false)]
        [String[]]$vdom,
        [Parameter(Mandatory = $false)]
        [psobject]$connection = $DefaultFGTConnection
    )

    Begin {
    }

    Process {

        $invokeParams = @{ }
        if ( $PsBoundParameters.ContainsKey('vdom') ) {
            $invokeParams.add( 'vdom', $vdom )
        }

        $uri = "api/v2/cmdb/firewall/proxy-address/$($address.name)/?action=clone&nkey=$($name)"

        Invoke-FGTRestMethod -method "POST" -uri $uri -connection $connection @invokeParams | out-Null

        Get-FGTFirewallproxyAddress -connection $connection @invokeParams -name $name
    }

    End {
    }
}

function Get-FGTFirewallProxyAddress {

    <#
        .SYNOPSIS
        Get list of all "proxy-address"

        .DESCRIPTION
        Get list of all "proxy-address" (host-regex, url ...)

        .EXAMPLE
        Get-FGTFirewallProxyAddress

        Get list of all proxy-address object

        .EXAMPLE
        Get-FGTFirewallProxyAddress -name myFGTPoxyAddress

        Get proxy-address named myFGTProxyAddress

        .EXAMPLE
        Get-FGTFirewallProxyAddress -name FGT -filter_type contains

        Get proxy-address contains with *FGT*

        .EXAMPLE
        Get-FGTFirewallProxyAddress -uuid 9e73a10e-1772-51ea-a8d7-297686fd7702

        Get proxy-address with uuid 9e73a10e-1772-51ea-a8d7-297686fd7702

        .EXAMPLE
        Get-FGTFirewallProxyAddress -skip

        Get list of all proxy-address object (but only relevant attributes)

        .EXAMPLE
        Get-FGTFirewallProxyAddress -vdom vdomX

        Get list of all proxy-address on VdomX

  #>

    [CmdletBinding(DefaultParameterSetName = "default")]
    Param(
        [Parameter (Mandatory = $false, Position = 1, ParameterSetName = "name")]
        [string]$name,
        [Parameter (Mandatory = $false, ParameterSetName = "uuid")]
        [string]$uuid,
        [Parameter (Mandatory = $false, ParameterSetName = "filter_build")]
        [string]$filter_attribute,
        [Parameter (Mandatory = $false, ParameterSetName = "name")]
        [Parameter (ParameterSetName = "uuid")]
        [Parameter (ParameterSetName = "filter_build")]
        [ValidateSet('equal', 'notequal', 'contains', 'notcontains', 'less', 'lessorequal', 'greater', 'greaterorequal')]
        [string]$filter_type = "equal",
        [Parameter (Mandatory = $false, ParameterSetName = "filter_build")]
        [psobject]$filter_value,
        [Parameter(Mandatory = $false)]
        [switch]$skip,
        [Parameter(Mandatory = $false)]
        [String[]]$vdom,
        [Parameter(Mandatory = $false)]
        [psobject]$connection = $DefaultFGTConnection
    )

    Begin {
    }

    Process {

        $invokeParams = @{ }
        if ( $PsBoundParameters.ContainsKey('skip') ) {
            $invokeParams.add( 'skip', $skip )
        }
        if ( $PsBoundParameters.ContainsKey('vdom') ) {
            $invokeParams.add( 'vdom', $vdom )
        }

        switch ( $PSCmdlet.ParameterSetName ) {
            "name" {
                $filter_value = $name
                $filter_attribute = "name"
            }
            "uuid" {
                $filter_value = $uuid
                $filter_attribute = "uuid"
            }
            default { }
        }

        #if filter value and filter_attribute, add filter (by default filter_type is equal)
        if ( $filter_value -and $filter_attribute ) {
            $invokeParams.add( 'filter_value', $filter_value )
            $invokeParams.add( 'filter_attribute', $filter_attribute )
            $invokeParams.add( 'filter_type', $filter_type )
        }

        $response = Invoke-FGTRestMethod -uri 'api/v2/cmdb/firewall/proxy-address' -method 'GET' -connection $connection @invokeParams

        $response.results

    }

    End {
    }

}

function Remove-FGTFirewallProxyAddress {

    <#
        .SYNOPSIS
        Remove a FortiGate ProxyAddress

        .DESCRIPTION
        Remove a Proxyaddress object on the FortiGate

        .EXAMPLE
        $MyFGTProxyAddress = Get-FGTFirewallProxyAddress -name MyFGTProxyAddress
        PS C:\>$MyFGTproxyAddress | Remove-FGTFirewallProxyAddress

        Remove address object $MyFGTProxyAddress

        .EXAMPLE
        $MyFGTproxyAddress = Get-FGTFirewallProxyAddress -name MyFGTProxyAddress
        PS C:\>$MyFGTproxyAddress | Remove-FGTFirewallProxyAddress -confirm:$false

        Remove address object $MyFGTProxyAddress with no confirmation

    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'high')]
    Param(
        [Parameter (Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        [ValidateScript( { Confirm-FGTProxyAddress $_ })]
        [psobject]$address,
        [Parameter(Mandatory = $false)]
        [switch]$noconfirm,
        [Parameter(Mandatory = $false)]
        [String[]]$vdom,
        [Parameter(Mandatory = $false)]
        [psobject]$connection = $DefaultFGTConnection
    )

    Begin {
    }

    Process {

        $invokeParams = @{ }
        if ( $PsBoundParameters.ContainsKey('vdom') ) {
            $invokeParams.add( 'vdom', $vdom )
        }

        $uri = "api/v2/cmdb/firewall/proxy-address/$($address.name)"

        if ($PSCmdlet.ShouldProcess($address.name, 'Remove Firewall Proxy Address')) {
            $null = Invoke-FGTRestMethod -method "DELETE" -uri $uri -connection $connection @invokeParams
        }

    }

    End {
    }
}

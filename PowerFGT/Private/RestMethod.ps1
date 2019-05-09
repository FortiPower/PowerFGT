#
# Copyright 2018, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

function Invoke-FGTRestMethod {

    <#
      .SYNOPSIS
      Invoke RestMethod with FGT connection (internal) variable

      .DESCRIPTION
      Invoke RestMethod with FGT connection variable (token, csrf..)

      .EXAMPLE
      Invoke-FGTRestMethod -method "get" -uri "api/v2/cmdb/firewall/address"

      Invoke-RestMethod with FGT connection for get api/v2/cmdb/firewall/address uri

      .EXAMPLE
      Invoke-FGTRestMethod "api/v2/cmdb/firewall/address"

      Invoke-RestMethod with FGT connection for get api/v2/cmdb/firewall/address uri with default parameter

      .EXAMPLE
      Invoke-FGTRestMethod "-method "get" -uri api/v2/cmdb/firewall/address" -vdom vdomX

      Invoke-RestMethod with FGT connection for get api/v2/cmdb/firewall/address uri on vdomX

      .EXAMPLE
      Invoke-FGTRestMethod --method "post" -uri "api/v2/cmdb/firewall/address" -body $body

      Invoke-RestMethod with FGT connection for post api/v2/cmdb/firewall/address uri with $body payload

      .EXAMPLE
      Invoke-FGTRestMethod -method "get" -uri "api/v2/cmdb/firewall/address" -connection $fw2

      Invoke-RestMethod with $fw2 connection for get api/v2/cmdb/firewall/address uri
    #>

    Param(
        [Parameter(Mandatory = $true, position = 1)]
        [String]$uri,
        [Parameter(Mandatory = $false)]
        [ValidateSet("GET", "PUT", "POST", "DELETE")]
        [String]$method = "GET",
        [Parameter(Mandatory = $false)]
        [psobject]$body,
        [Parameter(Mandatory = $false)]
        [switch]$skip,
        [Parameter(Mandatory = $false)]
        [String[]]$vdom,
        [Parameter(Mandatory = $false)]
        [psobject]$connection
    )

    Begin {
    }

    Process {

        if ($null -eq $connection ) {
            if ($null -eq $DefaultFGTConnection){
                Throw "Not Connected. Connect to the Fortigate with Connect-FGT"
            }
            $connection = $DefaultFGTConnection
        }

        $Server = $connection.Server
        $httpOnly = $connection.httpOnly
        $port = $connection.port
        $headers = $connection.headers
        $invokeParams = $connection.invokeParams
        $sessionvariable = $connection.session

        if ($httpOnly) {
            $fullurl = "http://${Server}:${port}/${uri}"
        }
        else {
            $fullurl = "https://${Server}:${port}/${uri}"
        }

        #Extra parameter...
        if($fullurl -NotMatch "\?"){
            $fullurl += "?"
        }

        if ( $PsBoundParameters.ContainsKey('skip') ) {
            $fullurl += "&skip=1"
        }
        if ( $PsBoundParameters.ContainsKey('vdom') ) {
            $vdom = $vdom -Join ','
            $fullurl += "&vdom=$vdom"
        } elseif (${DefaultFGTConnection}.vdom) {
            $vdom = ${DefaultFGTConnection}.vdom -Join ','
            $fullurl += "&vdom=$vdom"
        }

        try {
            if ($body) {
                $response = Invoke-RestMethod $fullurl -Method $method -body ($body | ConvertTo-Json) -Headers $headers -WebSession $sessionvariable @invokeParams
            }
            else {
                $response = Invoke-RestMethod $fullurl -Method $method -Headers $headers -WebSession $sessionvariable @invokeParams
            }
        }

        catch {
            Show-FGTException $_
            throw "Unable to use FortiGate API"
        }
        $response

    }

}
#
# Copyright 2018, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

function Invoke-FGTRestMethod{

    Param(
        [Parameter(Mandatory = $true)]
        [String]$uri,
        [Parameter(Mandatory = $true)]
        [ValidateSet("GET", "PUT", "POST", "DELETE")]
        [String]$method,
        [Parameter(Mandatory = $false)]
        [psobject]$body
    )

    Begin {
    }

    Process {

        $Server = ${DefaultFGTConnection}.Server
        $httpOnly = ${DefaultFGTConnection}.httpOnly
        $port = ${DefaultFGTConnection}.port
        $headers = ${DefaultFGTConnection}.headers
        $invokeParams = ${DefaultFGTConnection}.invokeParams

        if($httpOnly) {
            $fullurl = "http://${Server}:${port}/${uri}"
        } else {
            $fullurl = "https://${Server}:${port}/${uri}"
        }

        $sessionvariable = $DefaultFGTConnection.session

        try {
            if($body){
                $response = Invoke-RestMethod $fullurl -Method $method -body ($body | ConvertTo-Json) -Headers $headers -WebSession $sessionvariable @invokeParams
            } else {
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
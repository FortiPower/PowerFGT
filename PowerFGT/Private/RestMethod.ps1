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
        $fullurl = "https://${Server}/${uri}"

        $sessionvariable = $DefaultFGTConnection.session

        try {
            if($body){
                $response = Invoke-RestMethod $fullurl -Method $method -body ($body | ConvertTo-Json) -Headers $headers -WebSession $sessionvariable
            } else {
                $response = Invoke-RestMethod $fullurl -Method $method -Headers $headers -WebSession $sessionvariable
            }
        }

        catch {
            Show-FGTException $_
            throw "Unable to use FortiGate API"
        }
        $response

    }

}
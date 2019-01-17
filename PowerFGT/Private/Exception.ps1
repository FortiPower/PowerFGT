
#
# Copyright 2018, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#
function Show-FGTException() {
    Param(
        [parameter(Mandatory = $true)]
        $Exception
    )

    If ($Exception.Exception.Response) {
        $result = $Exception.Exception.Response.GetResponseStream()
        $reader = New-Object System.IO.StreamReader($result)
        $responseBody = $reader.ReadToEnd()

        #$responseJson =  $responseBody | ConvertFrom-Json

        Write-Warning "The FortiGate API sends an error message:"
        Write-Warning "Error description (code): $($Exception.Exception.Response.StatusDescription) ($($Exception.Exception.Response.StatusCode.Value__))"
        if($responseBody) {
            if($responseJson.message) {
                Write-Warning "Error details: $($responseJson.message)"
            } else {
                Write-Warning "Error details: $($responseBody)"
            }
        } elseif($Exception.ErrorDetails.Message) {
            Write-Warning "Error details: $($Exception.ErrorDetails.Message)"
        }
    }
}
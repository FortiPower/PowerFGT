#
# Copyright 2022, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

function Connect-FGT {

    <#
      .SYNOPSIS
      Connect to a FortiGate

      .DESCRIPTION
      Connect to a FortiGate

      .EXAMPLE
      Connect-FGT -Server 192.0.2.1

      Connect to a FortiGate with IP 192.0.2.1

      .EXAMPLE
      Connect-FGT -Server 192.0.2.1 -SkipCertificateCheck

      Connect to a FortiGate with IP 192.0.2.1 and disable Certificate (chain) check

      .EXAMPLE
      Connect-FGT -Server 192.0.2.1 -httpOnly

      Connect to a FortiGate using HTTP (unsecure !) with IP 192.0.2.1 using (Get-)credential

      .EXAMPLE
      Connect-FGT -Server 192.0.2.1 -port 4443

      Connect to a FortiGate using HTTPS (with port 4443) with IP 192.0.2.1 using (Get-)credential

      .EXAMPLE
      $cred = get-credential
      PS > Connect-FGT -Server 192.0.2.1 -credential $cred

      Connect to a FortiGate with IP 192.0.2.1 and passing (Get-)credential

      .EXAMPLE
      $mysecpassword = ConvertTo-SecureString mypassword -AsPlainText -Force
      PS > Connect-FGT -Server 192.0.2.1 -Username manager -Password $mysecpassword

      Connect to a FortiGate with IP 192.0.2.1 using Username and Password

      .EXAMPLE
      $fw1 = Connect-FGT -Server 192.0.2.1

      Connect to a FortiGate with IP 192.0.2.1 and store connection info to $fw1 variable

      .EXAMPLE
      $fw2 = Connect-FGT -Server 192.0.2.1 -DefaultConnection:$false

      Connect to a FortiGate with IP 192.0.2.1 and store connection info to $fw2 variable
      and don't store connection on global ($DefaultFGTConnection) variable

      .EXAMPLE
      Connect-FGT -Server 192.0.2.1 -Timeout 15

      Connect to a Fortigate with IP 192.0.2.1 and timeout the operation if it takes longer
      than 15 seconds to form a connection. The Default value "0" will cause the connection to never timeout.

      .EXAMPLE
      $apiToken = Get-Content fortigate_api_token.txt
      PS > Connect-FGT -Server -192.0.2.1 -ApiToken $apiToken

      Connect to a FortiGate with IP 192.0.2.1 and passing api token

      .EXAMPLE
      $mynewpassword = ConvertTo-SecureString mypassword -AsPlainText -Force
      PS > Connect-FGT -Server 192.0.2.1 -new_password $mysecpassword

      Connect to a FortiGate with IP 192.0.2.1 and change the password

      .EXAMPLE
      $mysecpassword = ConvertTo-SecureString mypassword -AsPlainText -Force
      Connect-FGT -Server 192.0.2.1 -Username admin -Password $mysecpassword -token_code XXXXX

      Connect to a FortiGate with IP 192.0.2.1 using Username, Password and (Forti)token code XXXXXX

     .EXAMPLE
      Connect-FGT -Server 192.0.2.1 -token_prompt

      Connect to a FortiGate with IP 192.0.2.1 and it will ask to get (Forti)Token code when connect

     .EXAMPLE
      $lic = Get-Content -Raw license.lic
      $Credential = New-Object System.Management.Automation.PSCredential("admin", (new-object System.Security.SecureString))
      $mynewpassword = ConvertTo-SecureString mypassword -AsPlainText -Force
      Connect-FGT -Server 192.0.2.1 -credentials $credential -New_Password $mynewsecpassword -license $lic -SkipCertificateCheck

      Connect to a FortiGate with IP 192.0.2.1 and upload the new license and change the password
  #>
    [CmdletBinding(DefaultParameterSetName = 'default')]
    [OutputType([System.Collections.Hashtable])]
    Param(
        [Parameter(Mandatory = $true, position = 1)]
        [String]$Server,
        [Parameter(ParameterSetName = "default")]
        [Parameter(Mandatory = $false)]
        [String]$Username,
        [Parameter(ParameterSetName = "default")]
        [Parameter(Mandatory = $false)]
        [SecureString]$Password,
        [Parameter(ParameterSetName = "token")]
        [Parameter(Mandatory = $false)]
        [string]$ApiToken,
        [Parameter(ParameterSetName = "default")]
        [Parameter(Mandatory = $false)]
        [SecureString]$New_Password,
        [Parameter(ParameterSetName = "default")]
        [Parameter(Mandatory = $false)]
        [PSCredential]$Credentials,
        [switch]$httpOnly = $false,
        [Parameter(Mandatory = $false)]
        [switch]$SkipCertificateCheck = $false,
        [Parameter(Mandatory = $false)]
        [ValidateRange(1, 65535)]
        [int]$port,
        [Parameter(Mandatory = $false)]
        [int]$Timeout = 0,
        [Parameter(Mandatory = $false)]
        [string]$token_code,
        [Parameter(Mandatory = $false)]
        [switch]$token_prompt,
        [Parameter(Mandatory = $false)]
        [string]$license,
        [Parameter(Mandatory = $false)]
        [switch]$oldauth = $false,
        [Parameter(Mandatory = $false)]
        [string[]]$vdom,
        [Parameter(Mandatory = $false)]
        [boolean]$DefaultConnection = $true
    )

    Begin {
    }

    Process {

        $connection = @{server = ""; session = ""; httpOnly = $false; port = ""; headers = ""; invokeParams = ""; vdom = ""; version = ""; serial = "" }

        $invokeParams = @{DisableKeepAlive = $false; UseBasicParsing = $true; SkipCertificateCheck = $SkipCertificateCheck; TimeoutSec = $Timeout }

        if (("Desktop" -eq $PSVersionTable.PsEdition) -or ($null -eq $PSVersionTable.PsEdition)) {
            #Remove -SkipCertificateCheck from Invoke Parameter (not supported <= PS 5)
            $invokeParams.remove("SkipCertificateCheck")
        }
        else {
            #Core Edition
            #Remove -UseBasicParsing (Enable by default with PowerShell 6/Core)
            $invokeParams.remove("UseBasicParsing")
        }

        if ($null -eq $PSVersionTable.PsEdition) {
            #Remove -UseBasicParsing from Invoke Parameter (not available on Invoke-RestMethod PS < 5)
            $invokeParams.remove("UseBasicParsing")
        }

        if ($httpOnly) {
            if (!$port) {
                $port = 80
            }
            $connection.httpOnly = $true
            $url = "http://${Server}:${port}/"

        }
        else {
            if (!$port) {
                $port = 443
            }

            #for PowerShell (<=) 5 (Desktop), Enable TLS 1.1, 1.2 and Disable SSL chain trust (needed/recommanded by FortiGate)
            if (("Desktop" -eq $PSVersionTable.PsEdition) -or ($null -eq $PSVersionTable.PsEdition)) {
                #Enable TLS 1.1 and 1.2
                Set-FGTCipherSSL
                if ($SkipCertificateCheck) {
                    #Disable SSL chain trust...
                    Set-FGTuntrustedSSL
                }
            }

            $url = "https://${Server}:${port}/"
        }

        $headers = @{ "content-type" = "application/json" }
        if ($ApiToken) {
            $headers += @{ "Authorization" = "Bearer $ApiToken" }
        }
        elseif ( $oldauth -ne $true ) {
            #If there is a password (and a user), create a credentials
            if ($Password) {
                $Credentials = New-Object System.Management.Automation.PSCredential($Username, $Password)
            }
            #Not Credentials (and no password)
            if ($null -eq $Credentials) {
                $Credentials = Get-Credential -Message 'Please enter administrative credentials for your FortiGate'
            }
            # new api auth method (Seen FortiOS 6.4+)
            $postParams = @{
                username  = $Credentials.username;
                password  = $Credentials.GetNetworkCredential().Password;
                secretkey = $Credentials.GetNetworkCredential().Password;
            }

            $uri = $url + "api/v2/authentication"
            Write-Verbose $uri

            try {
                $irmResponse = Invoke-RestMethod $uri -Method POST -Body ($postParams | ConvertTo-Json) -SessionVariable FGT @invokeParams
            }
            catch {
                if ($_.Exception.Response.StatusCode.Value__ -eq "401" ) {
                    throw "Not supported API Authentication method on this FortiGate (try use -oldauth parameter)"
                }
                else {
                    Show-FGTException $_
                    throw "Unable to connect to FortiGate"
                }

            }

            Write-verbose $irmResponse
            #Following FortiOS version it is status_code or status...
            if ($irmResponse.status_code) {
                $status = $irmResponse.status_code
            }
            else {
                $status = $irmResponse.status
            }

            switch ($status) {
                '-1' {
                    throw "Log in failure. Most likely an incorrect username/password combo"
                }
                '-4' {
                    #with FortiOS 7.6.3+, no longer warning when locked account...
                    throw "Admin is now locked out (Please retry in 60 seconds)"
                }
                '5' {
                    #no thing, it is good ! continue
                }
                '6' {
                    #no thing, it is good ! continue (with FortiOS 7.6.3+)
                }
                default {
                    throw "Authentication failure. Status code: $status $($irmResponse.status_message)"
                }
            }

            #Search crsf cookie and to X-CSRFTOKEN
            $cookies = $FGT.Cookies.GetCookies($uri)
            foreach ($cookie in $cookies) {
                if ($cookie.name -like "ccsrf*" ) {
                    #before 7.6 it was ccsrftoken_port_xxxx, from 7.6.3+ it is ccsrf_token_port_xxxx
                    $cookie_csrf = $cookie.value
                }
            }

            # throw if don't found csrf cookie...
            if ($null -eq $cookie_csrf) {
                throw "Unable to found CSRF Cookie"
            }

            #Remove extra "quote"
            $cookie_csrf = $cookie_csrf -replace '["]', ''
            #Add csrf cookie to header (X-CSRFTOKEN)
            $headers += @{"X-CSRFTOKEN" = $cookie_csrf }
        }
        else {
            #If there is a password (and a user), create a credentials
            if ($Password) {
                $Credentials = New-Object System.Management.Automation.PSCredential($Username, $Password)
            }
            #Not Credentials (and no password)
            if ($null -eq $Credentials) {
                $Credentials = Get-Credential -Message 'Please enter administrative credentials for your FortiGate'
            }
            $postParams = @{username = $Credentials.username; secretkey = $Credentials.GetNetworkCredential().Password; ajax = 1 }
            $uri = $url + "logincheck"
            $iwrResponse = $null
            try {
                $iwrResponse = Invoke-WebRequest $uri -Method POST -Body $postParams -SessionVariable FGT @invokeParams
            }
            catch {
                Show-FGTException $_
                throw "Unable to connect to FortiGate"
            }

            #With from FortiOS 7.6(.3), the status is now return with json {....
            if ( $iwrResponse.Content[0] -eq "{") {
                $json = $iwrResponse.Content | ConvertFrom-Json
                $status = $json.status
            }
            else {
                $status = $iwrResponse.Content[0]
            }

            #check if need token...
            if ( $status -eq "3") {
                if ( $PsBoundParameters.ContainsKey('token_code') -or $PsBoundParameters.ContainsKey('token_prompt') ) {
                    if ( $PsBoundParameters.ContainsKey('token_prompt')) {
                        $token_code = Read-Host "Token"
                    }
                    $postParams += @{token_code = $token_code }
                    try {
                        $iwrResponse = Invoke-WebRequest $uri -Method POST -Body $postParams -WebSession $FGT @invokeParams
                    }
                    catch {
                        Show-FGTException $_
                        throw "Unable to connect to FortiGate with a token"
                    }
                }
            }

            #first byte return is a status code
            switch ($status) {
                '0' {
                    throw "Log in failure. Most likely an incorrect username/password combo"
                }
                '1' {
                    #no thing, it is good ! continue
                }
                '2' {
                    throw "Admin is now locked out (Please retry in 60 seconds)"
                }
                '3' {
                    throw "Two-factor Authentication is needed (use -token_code XXXXXX or -token_prompt)"
                }
                '4' {
                    if (-not $PsBoundParameters.ContainsKey('new_password')) {
                        #throw if you don't have specify new_password
                        throw "Need to change the password (use -new_password parameter)"
                    }
                }
            }

            #Search crsf cookie and to X-CSRFTOKEN
            $cookies = $FGT.Cookies.GetCookies($uri)
            foreach ($cookie in $cookies) {
                if ($cookie.name -like "ccsrftoken*") {
                    $cookie_csrf = $cookie.value
                }
            }

            # throw if don't found csrf cookie...
            if ($null -eq $cookie_csrf) {
                throw "Unable to found CSRF Cookie"
            }

            #Remove extra "quote"
            $cookie_csrf = $cookie_csrf -replace '["]', ''
            #Add csrf cookie to header (X-CSRFTOKEN)
            $headers += @{"X-CSRFTOKEN" = $cookie_csrf }

            $uri = $url + "logindisclaimer"
            if ($iwrResponse.Content -match '/logindisclaimer') {
                try {
                    Invoke-WebRequest $uri -Method "POST" -WebSession $FGT -Body @{ confirm = 1 ; ajax = 1 } @invokeParams | Out-Null
                }
                catch {
                    throw "Unable to confirm disclaimer"
                }
            }

            if ($PsBoundParameters.ContainsKey('new_password')) {
                $uri = $url + "loginpwd_change"
                $new_pwd = ConvertFrom-SecureString -SecureString $new_password -AsPlainText;
                $postParams = @{
                    CSRF_TOKEN = $cookie_csrf
                    old_pwd    = $Credentials.GetNetworkCredential().Password;
                    pwd1       = $new_pwd
                    pwd2       = $new_pwd
                    ajax       = 1;
                    confirm    = 1
                }
                try {
                    Invoke-WebRequest $uri -Method "POST" -WebSession $FGT -Body $postParams @invokeParams | Out-Null
                }
                catch {
                    throw "Unable to change password"
                }

                #Reconnect...
                Connect-FGT -server $server -port $port -httpOnly:$httpOnly -vdom $vdom -Username $Credentials.username -Password $new_password -license $license -SkipCertificateCheck:$SkipCertificateCheck -DefaultConnection $DefaultConnection
                return
            }

            if ($iwrResponse.Content -match '/system/vm/license') {
                if (-not $PsBoundParameters.ContainsKey('license')) {
                    #throw if you don't have specify license
                    throw "Need to install a license (use -license parameter)"
                }
                $uri = $url + "api/v2/monitor/system/vmlicense/upload"

                #Convert the license to base64 and POST to vmlicense/upload
                $Bytes = [System.Text.Encoding]::UTF8.GetBytes($license)
                $license_b64 = [Convert]::ToBase64String($Bytes)
                $postParams = @{
                    file_content = $license_b64
                }
                try {
                    Invoke-RestMethod $uri -Method "POST" -Header $headers -WebSession $FGT -Body ($postParams | ConvertTo-Json) @invokeParams | Out-Null
                }
                catch {
                    Show-FGTException $_
                    throw "Unable to upload license"
                }
                Write-Warning "Fortigate restart (installing license...)"
                return
            }
        }

        $uri = $url + "api/v2/monitor/system/firmware"
        try {
            $version = Invoke-RestMethod $uri -Method "get" -Header $headers -WebSession $FGT @invokeParams
        }
        catch {
            if ($ApiToken) {
                Show-FGTException $_
                throw "Authentication failure. Wrong token or not a Trusted Host."
            }
            else {
                throw "Unable to find FGT version"
            }
        }

        $connection.server = $server
        $connection.session = $FGT
        $connection.headers = $headers
        $connection.port = $port
        $connection.invokeParams = $invokeParams
        $connection.vdom = $vdom
        $connection.serial = $version.serial
        $connection.oldauth = $oldauth
        if ($version.results.current.major) {
            $connection.version = [version]"$($version.results.current.major).$($version.results.current.minor).$($version.results.current.patch)"
        }
        else {
            #Old release like 5.x with no major/minor/patch
            $connection.version = [version]"$($version.results.current.version -replace 'v','')"
            Write-Warning "Old and no longer supported FortiOS with limited API (no filtering...)"
        }

        if ( $DefaultConnection ) {
            set-variable -name DefaultFGTConnection -value $connection -scope Global
        }

        $connection
    }

    End {
    }
}


function Set-FGTConnection {

    <#
        .SYNOPSIS
        Configure FGT connection Setting

        .DESCRIPTION
        Configure FGT connection Setting (Vdom...)

        .EXAMPLE
        Set-FGTConnection -vdom vdomY

        Configure default connection vdom to vdomY

        .EXAMPLE
        Set-FGTConnection -vdom $null

        Restore vdom configuration to default (by default root)
    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    Param(
        [Parameter(Mandatory = $false)]
        [string[]]$vdom,
        [Parameter(Mandatory = $false)]
        [psobject]$connection = $DefaultFGTConnection
    )

    Begin {
    }

    Process {

        if ($PSCmdlet.ShouldProcess($connection.server, 'Set default vdom on connection')) {
            $connection.vdom = $vdom
        }

    }

    End {
    }
}

function Disconnect-FGT {

    <#
        .SYNOPSIS
        Disconnect a FortiGate

        .DESCRIPTION
        Disconnect the connection of FortiGate

        .EXAMPLE
        Disconnect-FGT

        Disconnect the connection

        .EXAMPLE
        Disconnect-FGT -confirm:$false

        Disconnect the connection with no confirmation

    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    Param(
        [Parameter(Mandatory = $false)]
        [psobject]$connection = $DefaultFGTConnection
    )

    Begin {
    }

    Process {

        $method = "DELETE"
        $url = "api/v2/authentication"

        #old auth use logout url
        if ($connection.oldauth) {
            $url = "logout"
            $method = "POST"
        }

        if ($PSCmdlet.ShouldProcess($connection.server, 'Proceed with removal of FortiGate connection ?')) {
            $null = invoke-FGTRestMethod -method $method -uri $url -connection $connection
            if (Test-Path variable:global:DefaultFGTConnection) {
                Remove-Variable -name DefaultFGTConnection -scope global
            }
        }
    }

    End {
    }
}

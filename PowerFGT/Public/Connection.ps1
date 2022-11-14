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
      Connect-FGT -Server 192.0.2.1 -credential $cred

      Connect to a FortiGate with IP 192.0.2.1 and passing (Get-)credential

      .EXAMPLE
      $mysecpassword = ConvertTo-SecureString mypassword -AsPlainText -Force
      Connect-FGT -Server 192.0.2.1 -Username manager -Password $mysecpassword

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
      Connect-FGT -Server -192.0.2.1 -ApiToken $apiToken

      Connect to a FortiGate with IP 192.0.2.1 and passing api token

      .EXAMPLE
      $mynewpassword = ConvertTo-SecureString mypassword -AsPlainText -Force
      Connect-FGT -Server 192.0.2.1 -new_password $mysecpassword

      Connect to a FortiGate with IP 192.0.2.1 and change the password
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

        $headers = @{}
        if ($ApiToken) {
            $headers = @{ "Authorization" = "Bearer $ApiToken" }
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
            Write-Verbose ($postParams | Convertto-json)
            try {
                $iwrResponse = Invoke-WebRequest $uri -Method POST -Body $postParams -SessionVariable FGT @invokeParams
            }
            catch {
                Show-FGTException $_
                throw "Unable to connect to FortiGate"
            }

            #first byte return is a status code
            switch ($iwrResponse.Content[0]) {
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
                    if ( $PsBoundParameters.ContainsKey('token_code') ) {
                        $postParams += @{token_code = $token_code }
                        Write-Verbose ($postParams | Convertto-json)
                        try {
                            $iwrResponse = Invoke-WebRequest $uri -Method POST -Body $postParams -WebSession $FGT @invokeParams
                        }
                        catch {
                            Show-FGTException $_
                            throw "Unable to connect to FortiGate"
                        }
                    }
                    else {
                        throw "Two-factor Authentication is needed (not yet supported with PowerFGT)"
                    }

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
                if ($cookie.name -eq "ccsrftoken") {
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
            $headers = @{"X-CSRFTOKEN" = $cookie_csrf }

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
                Connect-FGT -server $server -port $port -httpOnly:$httpOnly -vdom $vdom -Username $Credentials.username -Password $new_password -DefaultConnection $DefaultConnection
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

        $url = "logout"

        if ($PSCmdlet.ShouldProcess($connection.server, 'Proceed with removal of FortiGate connection ?')) {
            $null = invoke-FGTRestMethod -method "POST" -uri $url -connection $connection
            if (Test-Path variable:global:DefaultFGTConnection) {
                Remove-Variable -name DefaultFGTConnection -scope global
            }
        }
    }

    End {
    }
}

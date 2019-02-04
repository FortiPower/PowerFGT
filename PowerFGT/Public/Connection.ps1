#
# Copyright 2018, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
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
  #>

    Param(
        [Parameter(Mandatory = $true, position=1)]
        [String]$Server,
        [Parameter(Mandatory = $false)]
        [String]$Username,
        [Parameter(Mandatory = $false)]
        [SecureString]$Password,
        [Parameter(Mandatory = $false)]
        [PSCredential]$Credentials,
        [switch]$httpOnly=$false,
        [Parameter(Mandatory = $false)]
        [switch]$SkipCertificateCheck=$false,
        [Parameter(Mandatory = $false)]
        [ValidateRange(1, 65535)]
        [int]$port
    )

    Begin {
    }

    Process {

        $connection = @{server="";session="";httpOnly=$false;port="";headers="";invokeParams=""}

        #If there is a password (and a user), create a credentials
        if ($Password) {
            $Credentials = New-Object System.Management.Automation.PSCredential($Username, $Password)
        }
        #Not Credentials (and no password)
        if ($null -eq $Credentials)
        {
            $Credentials = Get-Credential -Message 'Please enter administrative credentials for your FortiGate'
        }

        $postParams = @{username=$Credentials.username;secretkey=$Credentials.GetNetworkCredential().Password;ajax=1}
        $invokeParams = @{DisableKeepAlive = $false; UseBasicParsing = $true; SkipCertificateCheck = $SkipCertificateCheck}

        if($httpOnly) {
            if(!$port){
                $port = 80
            }
            $connection.httpOnly = $true
            $url = "http://${Server}:${port}/logincheck"
        } else {
            if(!$port){
                $port = 443
            }

            #for PowerShell (<=) 5 (Desktop), Enable TLS 1.1, 1.2 and Disable SSL chain trust (needed/recommanded by FortiGate)
            if ("Desktop" -eq $PSVersionTable.PsEdition) {
                #Enable TLS 1.1 and 1.2
                Set-FGTCipherSSL
                if ($SkipCertificateCheck) {
                    #Disable SSL chain trust...
                    Set-FGTuntrustedSSL
                }
                #Remove -SkipCertificateCheck from Invoke Parameter (not supported <= PS 5)
                $invokeParams.remove("SkipCertificateCheck")
            }

            $url = "https://${Server}:${port}/logincheck"
        }

        try {
            Invoke-WebRequest $url -Method POST -Body $postParams -SessionVariable FGT @invokeParams | Out-Null
        }
        catch {
            Show-FGTException $_
            throw "Unable to connect to FortiGate"
        }

        #Search crsf cookie and to X-CSRFTOKEN
        $cookies = $FGT.Cookies.GetCookies($url)
        foreach($cookie in $cookies) {
            if($cookie.name -eq "ccsrftoken") {
                $cookie_csrf = $cookie.value
            }
        }

        # throw if don't found csrf cookie...
        if($null -eq $cookie_csrf) {
            throw "Unable to found CSRF Cookie"
        }

        #Remove extra "quote"
        $cookie_csrf = $cookie_csrf -replace '["]',''
        #Add csrf cookie to header (X-CSRFTOKEN)
        $headers = @{"X-CSRFTOKEN" = $cookie_csrf}

        $connection.server = $server
        $connection.session = $FGT
        $connection.headers = $headers
        $connection.invokeParams = $invokeParams

        set-variable -name DefaultFGTConnection -value $connection -scope Global

    }

    End {
    }
}

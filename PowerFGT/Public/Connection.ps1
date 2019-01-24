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
        [ValidateRange(1, 65535)]
        [int]$port
    )

    Begin {
    }

    Process {

        $connection = @{server="";session="";httpOnly=$false;port="";headers=""}

        #If there is a password (and a user), create a credentials
        if ($Password) {
            $Credentials = New-Object System.Management.Automation.PSCredential($Username, $Password)
        }
        #Not Credentials (and no password)
        if ($null -eq $Credentials)
        {
            $Credentials = Get-Credential -Message 'Please enter administrative credentials for your FortiGate'
        }

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

            #Allow untrusted SSL certificat and enable TLS 1.2 (needed/recommanded by FortiGate)
            Set-FGTUntrustedSSL
            Set-FGTCipherSSL
            $url = "https://${Server}:${port}/logincheck"
        }

        $postParams = @{username=$Credentials.username;secretkey=$Credentials.GetNetworkCredential().Password;ajax=1}

        try {
            Invoke-WebRequest $url -Method POST -Body $postParams -SessionVariable FGT | Out-Null
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

        set-variable -name DefaultFGTConnection -value $connection -scope Global

    }

    End {
    }
}

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

      .EXAMPLE
      $fw1 = Connect-ArubaFGT -Server 192.0.2.1
      Connect to an FortiGate with IP 192.0.2.1 and store connection info to $fw1 variable

      .EXAMPLE
      $fw2 = Connect-ArubaFGT -Server 192.0.2.1 -DefaultConnection:$false

      Connect to an FortiGate with IP 192.0.2.1 and store connection info to $fw2 variable
      and don't store connection on global ($DefaultFGTConnection) variable

      .EXAMPLE
      Connect-FGT -Server 192.0.2.1 -Timeout 15

      Connect to a Fortigate with IP 192.0.2.1 and timeout the operation if it takes longer
      than 15 seconds to form a connection. The Default value "0" will cause the connection to never timeout.

  #>

    Param(
        [Parameter(Mandatory = $true, position = 1)]
        [String]$Server,
        [Parameter(Mandatory = $false)]
        [String]$Username,
        [Parameter(Mandatory = $false)]
        [SecureString]$Password,
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
        [string[]]$vdom,
        [Parameter(Mandatory = $false)]
        [boolean]$DefaultConnection = $true
    )

    Begin {
    }

    Process {

        $connection = @{server = ""; session = ""; httpOnly = $false; port = ""; headers = ""; invokeParams = ""; vdom = "" }

        #If there is a password (and a user), create a credentials
        if ($Password) {
            $Credentials = New-Object System.Management.Automation.PSCredential($Username, $Password)
        }
        #Not Credentials (and no password)
        if ($null -eq $Credentials) {
            $Credentials = Get-Credential -Message 'Please enter administrative credentials for your FortiGate'
        }

        $postParams = @{username = $Credentials.username; secretkey = $Credentials.GetNetworkCredential().Password; ajax = 1 }
        $invokeParams = @{DisableKeepAlive = $false; UseBasicParsing = $true; SkipCertificateCheck = $SkipCertificateCheck; TimeoutSec = $Timeout }

        if ("Desktop" -eq $PSVersionTable.PsEdition) {
            #Remove -SkipCertificateCheck from Invoke Parameter (not supported <= PS 5)
            $invokeParams.remove("SkipCertificateCheck")
        }
        else {
            #Core Edition
            #Remove -UseBasicParsing (Enable by default with PowerShell 6/Core)
            $invokeParams.remove("UseBasicParsing")
        }

        if ($httpOnly) {
            if (!$port) {
                $port = 80
            }
            $connection.httpOnly = $true
            $url = "http://${Server}:${port}/logincheck"
        }
        else {
            if (!$port) {
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

        $connection.server = $server
        $connection.session = $FGT
        $connection.headers = $headers
        $connection.port = $port
        $connection.invokeParams = $invokeParams
        $connection.vdom = $vdom

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

    Param(
        [Parameter(Mandatory = $false)]
        [string[]]$vdom,
        [Parameter(Mandatory = $false)]
        [psobject]$connection = $DefaultFGTConnection
    )

    Begin {
    }

    Process {

        $connection.vdom = $vdom

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
        Disconnect-FGT -noconfirm

        Disconnect the connection with no confirmation

    #>

    Param(
        [Parameter(Mandatory = $false)]
        [switch]$noconfirm,
        [Parameter(Mandatory = $false)]
        [psobject]$connection = $DefaultFGTConnection
    )

    Begin {
    }

    Process {

        $url = "/logout"

        if ( -not ( $Noconfirm )) {
            $message = "Remove FortiGate connection."
            $question = "Proceed with removal of FortiGate connection ?"
            $choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
            $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
            $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))

            $decision = $Host.UI.PromptForChoice($message, $question, $choices, 1)
        }
        else { $decision = 0 }
        if ($decision -eq 0) {
            Write-Progress -activity "Remove FortiGate connection"
            $null = invoke-FGTRestMethod -method "POST" -uri $url -connection $connection
            write-progress -activity "Remove FortiGate connection" -completed
            if (Test-Path variable:global:DefaultFGTConnection) {
                Remove-Variable -name DefaultFGTConnection -scope global
            }
        }

    }

    End {
    }
}

#
# Copyright 2022, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#
function Set-FGTMonitorUserLocalChangePassword {

    <#
        .SYNOPSIS
        Set User Local Change Password

        .DESCRIPTION
        Set User Local Change Password (For > FortiOS 7.4.X)

        .EXAMPLE
        $mynewpassword = ConvertTo-SecureString mypassword -AsPlainText -Force
        PS > Get-FGTUserLocal MyFGTUserLocal | Set-FGTMonitorUserLocalChangePassword -new_password $mynewpassword

        Change password for MyFGTUserLocal

    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'medium')]
    Param(
        [Parameter (Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        [ValidateScript( { Confirm-FGTUserLocal $_ })]
        [psobject]$userlocal,
        [Parameter (Mandatory = $true)]
        [SecureString]$new_password,
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

        $uri = 'api/v2/monitor/user/local/change-password'

        #before 7.4.x, you need to use Set-FGTLocalUser -passwd cmdlet
        if ($connection.version -lt "7.4.0") {
            Throw "You need to use Set-FGTLocalUser -passwd..."
        }
        else {
            if (("Desktop" -eq $PSVersionTable.PsEdition) -or ($null -eq $PSVersionTable.PsEdition)) {
                $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($new_password);
                $password = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr);
            }
            else {
                $password = ConvertFrom-SecureString -SecureString $new_password -AsPlainText
            }

            $body = @{
                "username"     = $userlocal.name
                "new_password" = $password
            }
        }

        if ($PSCmdlet.ShouldProcess($userlocal.name, 'Configure User Local Password')) {

            Invoke-FGTRestMethod -uri $uri -method "POST" -body $body -connection $connection @invokeParams | Out-Null

            Get-FGTUserLocal -connection $connection @invokeParams -name $userlocal.name
        }

    }

    End {
    }
}

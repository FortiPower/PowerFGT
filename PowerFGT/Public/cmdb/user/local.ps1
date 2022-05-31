#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
# Copyright 2019, Benjamin Perrier <ben dot perrier at outlook dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

function Add-FGTUserLocal {

    <#
        .SYNOPSIS
        Add a FortiGate Local User

        .DESCRIPTION
        Add a FortiGate Local User (Name, Password, MFA)

        .EXAMPLE
        Add-FGTUserLocal -Name FGT -password MyFGT -status

        Add Local User object name FGT, password MyFGT and enable it

        .EXAMPLE
        Add-FGTUserLocal -Name FGT -password MyFGT -status -two_factor email -two_factor_authentication email -email_to powerfgt@fgt.power

        Add Local User object name FGT, password MyFGT and enable it, with two factor authentication by email
    #>

    Param(
        [Parameter (Mandatory = $true)]
        [string]$name,
        [Parameter (Mandatory = $false)]
        [switch]$status,
        [Parameter (Mandatory = $false, ParameterSetName = "local")]
        [SecureString]$password,
        [Parameter (Mandatory = $false, ParameterSetName = "radius")]
        [string]$radius_server,
        [Parameter (Mandatory = $false, ParameterSetName = "tacacs")]
        [string]$tacacs_server,
        [Parameter (Mandatory = $false)]
        [ValidateSet("fortitoken", "email", "sms", "disable", "fortitoken-cloud")]
        [string]$two_factor,
        [Parameter (Mandatory = $false)]
        [ValidateSet("fortitoken", "email", "sms")]
        [string]$two_factor_authentication,
        [Parameter (Mandatory = $false)]
        [string]$two_factor_notification,
        [Parameter (Mandatory = $false)]
        [string]$fortitoken,
        [Parameter (Mandatory = $false)]
        [string]$email_to,
        [Parameter (Mandatory = $false)]
        [string]$sms_server,
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

        if ( Get-FGTUserLocal @invokeParams -name $name -connection $connection) {
            Throw "Already an Local User object using the same name"
        }

        $uri = "api/v2/cmdb/user/local"

        $Local_User = new-Object -TypeName PSObject

        $Local_User | add-member -name "name" -membertype NoteProperty -Value $name

        if ($status) {
            $Local_User | add-member -name "status" -membertype NoteProperty -Value "enable"
        }
        else {
            $Local_User | add-member -name "status" -membertype NoteProperty -Value "disable"
        }

        switch ( $PSCmdlet.ParameterSetName ) {
            "local" {
                $Local_User | add-member -name "type" -membertype NoteProperty -Value "password"
                $Local_User | add-member -name "passwd" -membertype NoteProperty -Value $password
            }
            "radius" {
                $Local_User | add-member -name "type" -membertype NoteProperty -Value "radius"
                $Local_User | add-member -name "radius-server" -membertype NoteProperty -Value $radius_server
            }
            "tacacs" {
                $Local_User | add-member -name "type" -membertype NoteProperty -Value "tacacs"
                $Local_User | add-member -name "tacacs+-server" -membertype NoteProperty -Value $tacacs_server
            }
            default { }
        }

        if ( $PsBoundParameters.ContainsKey('two_factor') ) {
            $Local_User | add-member -name "two-factor" -membertype NoteProperty -Value $two_factor
        }

        if ( $PsBoundParameters.ContainsKey('two_factor_authentication') ) {
            $Local_User | add-member -name "two-factor-authentication" -membertype NoteProperty -Value $two_factor_authentication
        }

        if ( $PsBoundParameters.ContainsKey('fortitoken') ) {
            $Local_User | add-member -name "fortitoken" -membertype NoteProperty -Value $fortitoken
        }

        if ( $PsBoundParameters.ContainsKey('email_to') ) {
            $Local_User | add-member -name "email-to" -membertype NoteProperty -Value $email_to
        }

        if ( $PsBoundParameters.ContainsKey('sms_server') ) {
            $Local_User | add-member -name "sms-server" -membertype NoteProperty -Value $sms_server
        }

        Invoke-FGTRestMethod -method "POST" -body $Local_User -uri $uri -connection $connection @invokeParams | out-Null

        Get-FGTUserLocal -connection $connection @invokeParams -name $name
    }

    End {
    }
}

function Get-FGTUserLocal {

    <#
        .SYNOPSIS
        Get list of all "local users"

        .DESCRIPTION
        Get list of all "local users" (name, type, status... )

        .EXAMPLE
        Get-FGTUserLocal

        Display all local users

        .EXAMPLE
        Get-FGTUserLocal -id 23

        Get local user with id 23

        .EXAMPLE
        Get-FGTUserLocal -name FGT -filter_type contains

        Get local user contains with *FGT*

        .EXAMPLE
        Get-FGTUserLocal -meta

        Display all local users with metadata (q_...) like usage (q_ref)

        .EXAMPLE
        Get-FGTUserLocal -skip

        Display all local users (but only relevant attributes)

        .EXAMPLE
        Get-FGTUserLocal -vdom vdomX

        Display all local users on vdomX
    #>

    [CmdletBinding(DefaultParameterSetName = "default")]
    Param(
        [Parameter (Mandatory = $false, Position = 1, ParameterSetName = "name")]
        [string]$name,
        [Parameter (Mandatory = $false, ParameterSetName = "id")]
        [string]$id,
        [Parameter (Mandatory = $false)]
        [Parameter (ParameterSetName = "filter")]
        [string]$filter_attribute,
        [Parameter (Mandatory = $false)]
        [Parameter (ParameterSetName = "name")]
        [Parameter (ParameterSetName = "id")]
        [Parameter (ParameterSetName = "filter")]
        [ValidateSet('equal', 'contains')]
        [string]$filter_type = "equal",
        [Parameter (Mandatory = $false)]
        [Parameter (ParameterSetName = "filter")]
        [psobject]$filter_value,
        [Parameter(Mandatory = $false)]
        [switch]$meta,
        [Parameter(Mandatory = $false)]
        [switch]$skip,
        [Parameter(Mandatory = $false)]
        [String[]]$vdom,
        [Parameter(Mandatory = $false)]
        [psobject]$connection = $DefaultFGTConnection
    )

    Begin {
    }

    Process {

        $invokeParams = @{ }
        if ( $PsBoundParameters.ContainsKey('meta') ) {
            $invokeParams.add( 'meta', $meta )
        }
        if ( $PsBoundParameters.ContainsKey('skip') ) {
            $invokeParams.add( 'skip', $skip )
        }
        if ( $PsBoundParameters.ContainsKey('vdom') ) {
            $invokeParams.add( 'vdom', $vdom )
        }

        #Filtering
        switch ( $PSCmdlet.ParameterSetName ) {
            "name" {
                $filter_value = $name
                $filter_attribute = "name"
            }
            "id" {
                $filter_value = $id
                $filter_attribute = "id"
            }
            default { }
        }

        #if filter value and filter_attribute, add filter (by default filter_type is equal)
        if ( $filter_value -and $filter_attribute ) {
            $invokeParams.add( 'filter_value', $filter_value )
            $invokeParams.add( 'filter_attribute', $filter_attribute )
            $invokeParams.add( 'filter_type', $filter_type )
        }

        $reponse = Invoke-FGTRestMethod -uri 'api/v2/cmdb/user/local' -method 'GET' -connection $connection @invokeParams
        $reponse.results
    }

    End {
    }
}

function Set-FGTUserLocal {

    <#
        .SYNOPSIS
        Configure a FortiGate Local User

        .DESCRIPTION
        Change a FortiGate Local User (ip, mask, comment, associated interface... )

        .EXAMPLE
        $MyFGTUserLocal = Get-FGTUserLocal -name MyFGTUserLocal
        PS C:\>$MyFGTUserLocal | Set-FGTUserLocal -status $false

        Change MyFGTUserLocal to status disable

        .EXAMPLE
        $MyFGTUserLocal = Get-FGTUserLocal -name MyFGTUserLocal
        PS C:\>$MyFGTUserLocal | Set-FGTUserLocal -password MyFGTUserLocalPassword

        Change MyFGTUserLocal to value (Password) MyFGTUserLocalPassword

        .EXAMPLE
        $MyFGTUserLocal = Get-FGTUserLocal -name MyFGTUserLocal
        PS C:\>$MyFGTUserLocal | Set-FGTUserLocal -email_to newpowerfgt@fgt.power

        Change MyFGTUserLocal to set email to newpowerfgt@fgt.power

    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'medium', DefaultParameterSetName = 'default')]
    Param(
        [Parameter (Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        [ValidateScript( { Confirm-FGTAddress $_ })]
        [psobject]$userlocal,
        [Parameter (Mandatory = $false)]
        [string]$name,
        [Parameter (Mandatory = $false)]
        [switch]$status,
        [Parameter (Mandatory = $false, ParameterSetName = "local")]
        [SecureString]$password,
        [Parameter (Mandatory = $false, ParameterSetName = "radius")]
        [string]$radius_server,
        [Parameter (Mandatory = $false, ParameterSetName = "tacacs")]
        [string]$tacacs_server,
        [Parameter (Mandatory = $false)]
        [ValidateSet("fortitoken", "email", "sms", "disable", "fortitoken-cloud")]
        [string]$two_factor,
        [Parameter (Mandatory = $false)]
        [ValidateSet("fortitoken", "email", "sms")]
        [string]$two_factor_authentication,
        [Parameter (Mandatory = $false)]
        [string]$two_factor_notification,
        [Parameter (Mandatory = $false)]
        [string]$fortitoken,
        [Parameter (Mandatory = $false)]
        [string]$email_to,
        [Parameter (Mandatory = $false)]
        [string]$sms_server,
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

        $uri = "api/v2/cmdb/user/local/$($userlocal.name)"

        $_userlocal = new-Object -TypeName PSObject

        if ( $PsBoundParameters.ContainsKey('name') ) {
            #TODO check if there is no already a object with this name ?
            $_userlocal | add-member -name "name" -membertype NoteProperty -Value $name
            $userlocal.name = $name
        }

        if ( $PSCmdlet.ParameterSetName -ne "default" -and $userlocal.type -ne $PSCmdlet.ParameterSetName ) {
            throw "Address type ($($userlocal.type)) need to be on the same type ($($PSCmdlet.ParameterSetName))"
        }

        if ($status) {
            $_userlocal  | add-member -name "status" -membertype NoteProperty -Value "enable"
        }
        else {
            $_userlocal  | add-member -name "status" -membertype NoteProperty -Value "disable"
        }

        switch ( $PSCmdlet.ParameterSetName ) {
            "local" {
                    $_userlocal | add-member -name "passwd" -membertype NoteProperty -Value $password
            }
            "radius" {
                $_userlocal | add-member -name "radius-server" -membertype NoteProperty -Value $radius_server
            }
            "tacacs" {
                $_userlocal | add-member -name "tacacs+-server" -membertype NoteProperty -Value $tacacs_server
            }
            default { }
        }

         if ( $PsBoundParameters.ContainsKey('two_factor') ) {
            $_userlocal | add-member -name "two-factor" -membertype NoteProperty -Value $two_factor
        }

        if ( $PsBoundParameters.ContainsKey('two_factor_authentication') ) {
            $_userlocal | add-member -name "two-factor-authentication" -membertype NoteProperty -Value $two_factor_authentication
        }

        if ( $PsBoundParameters.ContainsKey('fortitoken') ) {
            $_userlocal | add-member -name "fortitoken" -membertype NoteProperty -Value $fortitoken
        }

        if ( $PsBoundParameters.ContainsKey('email_to') ) {
            $_userlocal | add-member -name "email-to" -membertype NoteProperty -Value $email_to
        }

        if ( $PsBoundParameters.ContainsKey('sms_server') ) {
            $_userlocal | add-member -name "sms-server" -membertype NoteProperty -Value $sms_server
        }

        if ($PSCmdlet.ShouldProcess($userlocal.name, 'Configure User Local')) {
            Invoke-FGTRestMethod -method "PUT" -body $_userlocal -uri $uri -connection $connection @invokeParams | out-Null

            Get-FGTUserLocal -connection $connection @invokeParams -name $userlocal.name
        }
    }

    End {
    }
}

function Remove-FGTUserLocal {

    <#
        .SYNOPSIS
        Remove a FortiGate Local User

        .DESCRIPTION
        Remove a local user object on the FortiGate

        .EXAMPLE
        $MyFGTUserLocal = Get-FGTUserLocal -name FGT
        PS C:\>$MyFGTUserLocal | Remove-FGTUserLocal

        Remove user object $MyFGTUserLocal

        .EXAMPLE
        $MyFGTUserLocal = Get-FGTUserLocal -name MyFGTUserLocal
        PS C:\>$MyFGTUserLocal | Remove-FGTUserLocal -confirm:$false

        Remove UserLocal object $MyFGTUserLocal with no confirmation

    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'high')]
    Param(
        [Parameter (Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        [ValidateScript( { Confirm-FGTUserLocal $_ })]
        [psobject]$userlocal,
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

        $uri = "api/v2/cmdb/user/local/$($userlocal.name)"

        if ($PSCmdlet.ShouldProcess($userlocal.name, 'Remove User Local')) {
            $null = Invoke-FGTRestMethod -method "DELETE" -uri $uri -connection $connection @invokeParams
        }
    }

    End {
    }
}
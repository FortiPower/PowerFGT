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
        $mypassword = ConvertTo-SecureString mypassword -AsPlainText -Force
        PS > Add-FGTUserLocal -Name MyFGTUserLocal -passwd $mypassword -status:$false

        Add Local User object name MyFGTUserLocal, password MyFGT and disabled it

        .EXAMPLE
        $mypassword = ConvertTo-SecureString mypassword -AsPlainText -Force
        PS > Add-FGTUserLocal -Name MyFGTUserLocal -passwd $mypassword -status -two_factor email -email_to powerfgt@fgt.power

        Add Local User object name MyFGTUserLocal, password mypassword with two factor authentication by email

        .EXAMPLE
        $mypassword = ConvertTo-SecureString mypassword -AsPlainText -Force
        PS > Add-FGTUserLocal -Name MyFGTUserLocal -passwd $mypassword -status -two_factor fortitoken -fortitoken XXXXXXXXXXXXXXXX -email_to powerfgt@fgt.power

        Add Local User object name MyFGTUserLocal, password mypassword, with two factor authentication by fortitoken

        .EXAMPLE
        $data = @{ "sms-phone" = "XXXXXXXXXX" }
        PS > $mypassword = ConvertTo-SecureString mypassword -AsPlainText -Force
        PS > Add-FGTUserLocal -Name MyFGTUserLocal -passwd $mypassword -status -two_factor sms -data $data -email_to powerfgt@fgt.power

        Add Local User object name MyFGTUserLocal, password mypassword, with email and two factor via SMS and SMS Phone via -data parameter
    #>

    Param(
        [Parameter (Mandatory = $true)]
        [string]$name,
        [Parameter (Mandatory = $false)]
        [switch]$status,
        [Parameter (Mandatory = $false, ParameterSetName = "password")]
        [SecureString]$passwd,
        [Parameter (Mandatory = $false, ParameterSetName = "radius")]
        [ValidateLength(1, 35)]
        [string]$radius_server,
        [Parameter (Mandatory = $false, ParameterSetName = "tacacs")]
        [ValidateLength(1, 35)]
        [string]$tacacs_server,
        [Parameter (Mandatory = $false, ParameterSetName = "ldap")]
        [ValidateLength(1, 35)]
        [string]$ldap_server,
        [Parameter (Mandatory = $false)]
        [ValidateSet("fortitoken", "email", "sms", "disable", "fortitoken-cloud")]
        [string]$two_factor,
        [Parameter (Mandatory = $false)]
        [string]$two_factor_notification,
        [Parameter (Mandatory = $false)]
        [string]$fortitoken,
        [Parameter (Mandatory = $false)]
        [string]$email_to,
        [Parameter (Mandatory = $false)]
        [string]$sms_phone,
        [Parameter (Mandatory = $false)]
        [hashtable]$data,
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

        if ($PsBoundParameters.ContainsKey('passwd')) {
            if (("Desktop" -eq $PSVersionTable.PsEdition) -or ($null -eq $PSVersionTable.PsEdition)) {
                $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($passwd);
                $password = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr);
            }
            else {
                $password = ConvertFrom-SecureString -SecureString $passwd -AsPlainText
            }
        }

        if ( Get-FGTUserLocal @invokeParams -name $name -connection $connection) {
            Throw "Already a Local User object using the same name"
        }

        if ( $PsBoundParameters.ContainsKey('radius_server') ) {
            if ( -Not (Get-FGTUserRADIUS @invokeParams -name $radius_server -connection $connection)) {
                Throw "There is no RADIUS Server existing using this name"
            }
        }

        if ( $PsBoundParameters.ContainsKey('tacacs_server') ) {
            if ( -Not (Get-FGTUserTACACS @invokeParams -name $tacacs_server -connection $connection)) {
                Throw "There is no TACACS Server existing using this name"
            }
        }

        if ( $PsBoundParameters.ContainsKey('ldap_server') ) {
            if ( -Not (Get-FGTUserLDAP @invokeParams -name $ldap_server -connection $connection)) {
                Throw "There is no LDAP Server existing using this name"
            }
        }

        $uri = "api/v2/cmdb/user/local"

        $local = New-Object -TypeName PSObject

        $local | add-member -name "name" -membertype NoteProperty -Value $name

        if ($status) {
            $local | add-member -name "status" -membertype NoteProperty -Value "enable"
        }
        else {
            $local | add-member -name "status" -membertype NoteProperty -Value "disable"
        }

        switch ( $PSCmdlet.ParameterSetName ) {
            "password" {
                $local | add-member -name "type" -membertype NoteProperty -Value "password"
                $local | add-member -name "passwd" -membertype NoteProperty -Value $password
            }
            "radius" {
                $local | add-member -name "type" -membertype NoteProperty -Value "radius"
                $local | add-member -name "radius-server" -membertype NoteProperty -Value $radius_server
            }
            "tacacs" {
                $local | add-member -name "type" -membertype NoteProperty -Value "tacacs+"
                $local | add-member -name "tacacs+-server" -membertype NoteProperty -Value $tacacs_server
            }
            "ldap" {
                $local | add-member -name "type" -membertype NoteProperty -Value "ldap"
                $local | add-member -name "ldap-server" -membertype NoteProperty -Value $ldap_server
            }
            default { }
        }

        if ( $PsBoundParameters.ContainsKey('two_factor') ) {
            if ( $two_factor -eq "fortitoken" -or $two_factor -eq "fortitoken-cloud" ) {
                $local | add-member -name "two-factor" -membertype NoteProperty -Value $two_factor
                $local | add-member -name "two-factor-authentication" -membertype NoteProperty -Value "fortitoken"
                $local | add-member -name "fortitoken" -membertype NoteProperty -Value $fortitoken
            }
            if ( $two_factor -eq "email" ) {
                $local | add-member -name "two-factor" -membertype NoteProperty -Value $two_factor
                $local | add-member -name "two-factor-authentication" -membertype NoteProperty -Value "email"
            }
            if ( $two_factor -eq "sms" ) {
                $local | add-member -name "two-factor" -membertype NoteProperty -Value $two_factor
                $local | add-member -name "two-factor-authentication" -membertype NoteProperty -Value "sms"
            }
        }

        if ( $PsBoundParameters.ContainsKey('email_to') ) {
            $local | add-member -name "email-to" -membertype NoteProperty -Value $email_to
        }

        if ( $PsBoundParameters.ContainsKey('sms_phone') ) {
            $local | add-member -name "sms-phone" -membertype NoteProperty -Value $sms_phone
        }

        if ( $PsBoundParameters.ContainsKey('data') ) {
            $data.GetEnumerator() | ForEach-Object {
                $local | Add-member -name $_.key -membertype NoteProperty -Value $_.value
            }
        }

        Invoke-FGTRestMethod -method "POST" -body $local -uri $uri -connection $connection @invokeParams | out-Null

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
        Change a FortiGate Local User

        .EXAMPLE
        $MyFGTUserLocal = Get-FGTUserLocal -name MyFGTUserLocal
        PS > $MyFGTUserLocal | Set-FGTUserLocal -status:$false

        Change MyFGTUserLocal to status disable

        .EXAMPLE
        $MyFGTUserLocal = Get-FGTUserLocal -name MyFGTUserLocal
        $mypassword = ConvertTo-SecureString mypassword -AsPlainText -Force
        PS > $MyFGTUserLocal | Set-FGTUserLocal -passwd $mypassword

        Change Password for MyFGTUserLocal local user

        .EXAMPLE
        $MyFGTUserLocal = Get-FGTUserLocal -name MyFGTUserLocal
        PS > $MyFGTUserLocal | Set-FGTUserLocal -email_to newpowerfgt@fgt.power

        Change MyFGTUserLocal to set email to newpowerfgt@fgt.power

        .EXAMPLE
        $data = @{ "sms-phone" = "XXXXXXXXXX" }
        PS > $MyFGTUserLocal = Get-FGTUserLocal -name MyFGTUserLocal
        PS > $MyFGTUserLocal | Set-FGTUserLocal -data $data

        Change MyFGTUserLocal to set SMS Phone

    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'medium', DefaultParameterSetName = 'default')]
    Param(
        [Parameter (Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        [ValidateScript( { Confirm-FGTUserLocal $_ })]
        [psobject]$userlocal,
        [Parameter (Mandatory = $false)]
        [string]$name,
        [Parameter (Mandatory = $false)]
        [switch]$status,
        [Parameter (Mandatory = $false, ParameterSetName = "password")]
        [SecureString]$passwd,
        [Parameter (Mandatory = $false, ParameterSetName = "radius")]
        [ValidateLength(1, 35)]
        [string]$radius_server,
        [Parameter (Mandatory = $false, ParameterSetName = "tacacs")]
        [ValidateLength(1, 35)]
        [string]$tacacs_server,
        [Parameter (Mandatory = $false, ParameterSetName = "ldap")]
        [ValidateLength(1, 35)]
        [string]$ldap_server,
        [Parameter (Mandatory = $false)]
        [ValidateSet("fortitoken", "email", "sms", "disable", "fortitoken-cloud")]
        [string]$two_factor,
        [Parameter (Mandatory = $false)]
        [string]$two_factor_notification,
        [Parameter (Mandatory = $false)]
        [string]$fortitoken,
        [Parameter (Mandatory = $false)]
        [string]$email_to,
        [Parameter (Mandatory = $false)]
        [string]$sms_phone,
        [Parameter (Mandatory = $false)]
        [hashtable]$data,
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

        if ( $PsBoundParameters.ContainsKey('radius_server') ) {
            if ( -Not (Get-FGTUserRADIUS @invokeParams -name $radius_server -connection $connection)) {
                Throw "There is no RADIUS Server existing using this name"
            }
        }

        if ( $PsBoundParameters.ContainsKey('tacacs_server') ) {
            if ( -Not (Get-FGTUserTACACS @invokeParams -name $tacacs_server -connection $connection)) {
                Throw "There is no TACACS Server existing using this name"
            }
        }

        if ( $PsBoundParameters.ContainsKey('ldap_server') ) {
            if ( -Not (Get-FGTUserLDAP @invokeParams -name $ldap_server -connection $connection)) {
                Throw "There is no LDAP Server existing using this name"
            }
        }

        $uri = "api/v2/cmdb/user/local/$($userlocal.name)"

        $_local = New-Object -TypeName PSObject

        if ( $PsBoundParameters.ContainsKey('name') ) {
            #TODO check if there is no already an object with this name ?
            $_local | add-member -name "name" -membertype NoteProperty -Value $name
            $userlocal.name = $name
        }

        if ($PsBoundParameters.ContainsKey('passwd')) {
            if ($connection.version -ge "7.4.0") {
                Throw "Can't change passwd with FortiOS > 7.4.0 (Need to use Set-FGTMonitorUserLocalChangePassword)"
            }
            if (("Desktop" -eq $PSVersionTable.PsEdition) -or ($null -eq $PSVersionTable.PsEdition)) {
                $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($passwd);
                $password = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr);
            }
            else {
                $password = ConvertFrom-SecureString -SecureString $passwd -AsPlainText
            }
        }

        if ($PsBoundParameters.ContainsKey('status')) {
            if ($status) {
                $_local  | add-member -name "status" -membertype NoteProperty -Value "enable"
            }
            else {
                $_local  | add-member -name "status" -membertype NoteProperty -Value "disable"
            }
        }

        switch ( $PSCmdlet.ParameterSetName ) {
            "password" {
                $_local | add-member -name "type" -membertype NoteProperty -Value "password"
                $_local | add-member -name "passwd" -membertype NoteProperty -Value $password
            }
            "radius" {
                $_local | add-member -name "type" -membertype NoteProperty -Value "radius"
                $_local | add-member -name "radius-server" -membertype NoteProperty -Value $radius_server
            }
            "tacacs" {
                $_local | add-member -name "type" -membertype NoteProperty -Value "tacacs+"
                $_local | add-member -name "tacacs+-server" -membertype NoteProperty -Value $tacacs_server
            }
            "ldap" {
                $_local | add-member -name "type" -membertype NoteProperty -Value "ldap"
                $_local | add-member -name "ldap-server" -membertype NoteProperty -Value $ldap_server
            }
            default { }
        }

        if ( $PsBoundParameters.ContainsKey('two_factor') ) {
            if ( $two_factor -eq "fortitoken" -or $two_factor -eq "fortitoken-cloud" ) {
                $_local | add-member -name "two-factor" -membertype NoteProperty -Value $two_factor
                $_local | add-member -name "two-factor-authentication" -membertype NoteProperty -Value "fortitoken"
                $_local | add-member -name "fortitoken" -membertype NoteProperty -Value $fortitoken
            }
            elseif ( $two_factor -eq "email" ) {
                $_local | add-member -name "two-factor" -membertype NoteProperty -Value $two_factor
                $_local | add-member -name "two-factor-authentication" -membertype NoteProperty -Value $two_factor
            }
            elseif ( $two_factor -eq "sms" ) {
                $_local | add-member -name "two-factor" -membertype NoteProperty -Value $two_factor
                $_local | add-member -name "two-factor-authentication" -membertype NoteProperty -Value $two_factor
            }
        }

        if ( $PsBoundParameters.ContainsKey('email_to') ) {
            $_local | add-member -name "email-to" -membertype NoteProperty -Value $email_to
        }

        if ( $PsBoundParameters.ContainsKey('sms_phone') ) {
            $_local | add-member -name "sms-phone" -membertype NoteProperty -Value $sms_phone
        }

        if ( $PsBoundParameters.ContainsKey('data') ) {
            $data.GetEnumerator() | ForEach-Object {
                $_local | Add-member -name $_.key -membertype NoteProperty -Value $_.value
            }
        }

        if ($PSCmdlet.ShouldProcess($userlocal.name, 'Configure User Local')) {
            Invoke-FGTRestMethod -method "PUT" -body $_local -uri $uri -connection $connection @invokeParams | out-Null

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
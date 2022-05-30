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
        Add-FGTUserLocal -Name FGT -ip 192.0.2.0 -mask 255.255.255.0

        Add Local User object type ipmask with name FGT and value 192.0.2.0/24

        .EXAMPLE
        Add-FGTUserLocal -Name FGT -ip 192.0.2.0 -mask 255.255.255.0 -interface port2

        Add Local User object type ipmask with name FGT, value 192.0.2.0/24 and associated to interface port2

        .EXAMPLE
        Add-FGTUserLocal -Name FGT -ip 192.0.2.0 -mask 255.255.255.0 -comment "My FGT Local User"

        Add Local User object type ipmask with name FGT, value 192.0.2.0/24 and a comment

        .EXAMPLE
        Add-FGTUserLocal -Name FGT -ip 192.0.2.0 -mask 255.255.255.0 -visibility:$false

        Add Local User object type ipmask with name FGT, value 192.0.2.0/24 and disabled visibility

        .EXAMPLE
        Add-FGTUserLocal -Name FortiPower -fqdn fortipower.github.io

        Add Local User object type fqdn with name FortiPower and value fortipower.github.io

        .EXAMPLE
        Add-FGTUserLocal -Name FGT-Range -startip 192.0.2.1 -endip 192.0.2.100

        Add Local User object type iprange with name FGT-Range with start IP 192.0.2.1 and end ip 192.0.2.100
    #>

    Param(
        [Parameter (Mandatory = $true)]
        [string]$name,
        [Parameter (Mandatory = $false)]
        [switch]$status,
        [Parameter (Mandatory = $false, ParameterSetName = "local")]
        [string]$password,
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
            $Local_User | add-member -name "two-factor" -membertype NoteProperty -Value $two_factor_authentication
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
#
# Copyright 20219, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

function Add-FGTSystemSDNConnector {

    <#
        .SYNOPSIS
        Add a SDN Connector

        .DESCRIPTION
        Add a SDN Connector (Status, server, type ... )

        .EXAMPLE
        $mypassword = ConvertTo-SecureString mysecret -AsPlainText -Force
        PS C:\>Add-FGTSystemSDNConnector -name MySDNConnector -server MyVcenter -username powerfgt@vsphere.local -password $mypassword

        Create a new SDN Connector type vCenter/ESX with username and password

        .EXAMPLE
        $mypassword = ConvertTo-SecureString mysecret -AsPlainText -Force
        PS C:\>Add-FGTSystemSDNConnector -name MySDNConnector -server MyVcenter -username powerfgt@vsphere.local -password $mypassword -status:$false -verify_certificate:false

        Create a new SDN Connector type vCenter/ESX with username and password with disable status and verify-certificate

        .EXAMPLE
        $data = @{ 'server-port' = "8443" }
        PS C:\>$mypassword = ConvertTo-SecureString mysecret -AsPlainText -Force
        PS C:\>Add-FGTSystemSDNConnector -name MySDNConnector -server MyVcenter -username powerfgt@vsphere.local -password $mypassword -data $data

        This creates a new SDN Connector with server-port enable using -data parameter
    #>

    Param(
        [Parameter (Mandatory = $true, Position = 1)]
        [ValidateLength(1, 35)]
        [string]$name,
        [Parameter (Mandatory = $true, ParameterSetName = "vmware")]
        [string]$server,
        [Parameter (Mandatory = $true, ParameterSetName = "vmware")]
        [string]$username,
        [Parameter (Mandatory = $true, ParameterSetName = "vmware")]
        [SecureString]$password,
        [Parameter (Mandatory = $false)]
        [switch]$status,
        [Parameter (Mandatory = $false)]
        [switch]$verify_certificate,
        [Parameter (Mandatory = $false)]
        [int]$update_interval,
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

        $uri = "api/v2/cmdb/system/sdn-connector"
        $_sdnconnector = new-Object -TypeName PSObject

        $_sdnconnector | add-member -name "name" -membertype NoteProperty -Value $name

        switch ( $PSCmdlet.ParameterSetName ) {
            "vmware" {

                $_sdnconnector | add-member -name "server" -membertype NoteProperty -Value $server

                $_sdnconnector | add-member -name "username" -membertype NoteProperty -Value $username

                if (("Desktop" -eq $PSVersionTable.PsEdition) -or ($null -eq $PSVersionTable.PsEdition)) {
                    $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secret);
                    $sec = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr);
                    $_sdnconnector | add-member -name "password" -membertype NoteProperty -Value $sec
                }
                else {
                    $sec = ConvertFrom-SecureString -SecureString $secret -AsPlainText
                    $_sdnconnector | add-member -name "password" -membertype NoteProperty -Value $sec
                }

                $_sdnconnector | add-member -name "type" -membertype NoteProperty -Value "vmware"
            }
            default { }
        }

        if ($PsBoundParameters.ContainsKey('status')) {
            if ($status) {
                $_sdnconnector  | add-member -name "status" -membertype NoteProperty -Value "enable"
            }
            else {
                $_sdnconnector  | add-member -name "status" -membertype NoteProperty -Value "disable"
            }
        }

        if ($PsBoundParameters.ContainsKey('verify_certificate')) {
            if ($verify_certificate) {
                $_sdnconnector  | add-member -name "verify-certificate" -membertype NoteProperty -Value "enable"
            }
            else {
                $_sdnconnector  | add-member -name "verify-certificate" -membertype NoteProperty -Value "disable"
            }
        }

        if ($PsBoundParameters.ContainsKey('update_interval')) {
            $_sdnconnector  | add-member -name "update-interval" -membertype NoteProperty -Value $update_interval
        }

        if ( $PsBoundParameters.ContainsKey('data') ) {
            $data.GetEnumerator() | ForEach-Object {
                $_sdnconnector | Add-member -name $_.key -membertype NoteProperty -Value $_.value
            }
        }

        $null = Invoke-FGTRestMethod -uri $uri -method 'POST' -body $_sdnconnector -connection $connection @invokeParams

        Get-FGTSystemSDNConnector -name $name -connection $connection @invokeParams
    }

    End {
    }
}

function Get-FGTSystemSDNConnector {

    <#
        .SYNOPSIS
        Get list of all SDN Connector

        .DESCRIPTION
        Get list of all SDN Connector (status, server, type ...)

        .EXAMPLE
        Get-FGTSystemSDNConnector

        Get list of all SDN Connector

        .EXAMPLE
        Get-FGTSystemSDNConnector -name MySDNConnector

        Get SDN Connector named MySDNConnector

        .EXAMPLE
        Get-FGTSystemSDNConnector -name SDN -filter_type contains

        Get SDN Connector contains with *SDN*

        .EXAMPLE
        Get-FGTSystemSDNConnector -meta

        Get list of all SDN Connector with metadata (q_...) like usage (q_ref)

        .EXAMPLE
        Get-FGTSystemSDNConnector -skip

        Get list of all SDN Connector (but only relevant attributes)

        .EXAMPLE
        Get-FGTSystemSDNConnector -vdom vdomX

        Get list of all SDN Connector on vdomX
    #>

    [CmdletBinding(DefaultParameterSetName = "default")]
    Param(
        [Parameter (Mandatory = $false, Position = 1, ParameterSetName = "name")]
        [string]$name,
        [Parameter (Mandatory = $false)]
        [Parameter (ParameterSetName = "filter")]
        [string]$filter_attribute,
        [Parameter (Mandatory = $false)]
        [Parameter (ParameterSetName = "name")]
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
            default { }
        }

        #if filter value and filter_attribute, add filter (by default filter_type is equal)
        if ( $filter_value -and $filter_attribute ) {
            $invokeParams.add( 'filter_value', $filter_value )
            $invokeParams.add( 'filter_attribute', $filter_attribute )
            $invokeParams.add( 'filter_type', $filter_type )
        }

        $response = Invoke-FGTRestMethod -uri 'api/v2/cmdb/system/sdn-connector' -method 'GET' -connection $connection @invokeParams
        $response.results
    }

    End {
    }
}

function Set-FGTSystemSDNConnector {

    <#
        .SYNOPSIS
        Modify a SDN Connector

        .DESCRIPTION
        Modify the properties of an existing SDN Connector (status, update-interval...,)

        .EXAMPLE
        Get-FGTSystemSDNConnector -name MySDNConnector | Set-FGTSystemSDNConnector -update_interval 120 -status

        Configure status, update_interval on SDN Connector MySDNConnector

        .EXAMPLE
        $data = @{ "ha-status" = "enable" }
        PS C:\>Get-FGTSystemSDNConnector -name PowerFGT | Set-FGTSystemSDNConnector -data $data

        Configure ha-status setting using -data parameter on SDN Connector MySDNConnector
    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'medium')]
    Param(
        [Parameter (Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        [ValidateScript( { Confirm-FGTSDNConnector $_ })]
        [psobject]$sdnconnector,
        [Parameter (Mandatory = $false)]
        [switch]$status,
        [Parameter (Mandatory = $false)]
        [switch]$verify_certificate,
        [Parameter (Mandatory = $false)]
        [int]$update_interval,
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

        $uri = "api/v2/cmdb/system/sdn-connector/$($sdnconnector.name)"

        $_sdnconnector = new-Object -TypeName PSObject

        if ($PsBoundParameters.ContainsKey('status')) {
            if ($status) {
                $_sdnconnector  | add-member -name "status" -membertype NoteProperty -Value "enable"
            }
            else {
                $_sdnconnector  | add-member -name "status" -membertype NoteProperty -Value "disable"
            }
        }

        if ($PsBoundParameters.ContainsKey('verify_certificate')) {
            if ($verify_certificate) {
                $_sdnconnector  | add-member -name "verify-certificate" -membertype NoteProperty -Value "enable"
            }
            else {
                $_sdnconnector  | add-member -name "verify-certificate" -membertype NoteProperty -Value "disable"
            }
        }

        if ($PsBoundParameters.ContainsKey('update_interval')) {
            $_sdnconnector  | add-member -name "update-interval" -membertype NoteProperty -Value $update_interval
        }

        if ( $PsBoundParameters.ContainsKey('data') ) {
            $data.GetEnumerator() | ForEach-Object {
                $_sdnconnector | Add-member -name $_.key -membertype NoteProperty -Value $_.value
            }
        }

        if ($PSCmdlet.ShouldProcess($sdnconnector.name, 'Set SDN Connector')) {
            $null = Invoke-FGTRestMethod -uri $uri -method 'PUT' -body $_sdnconnector -connection $connection @invokeParams
            Get-FGTSystemSDNConnector -name $sdnconnector.name -connection $connection @invokeParams
        }
    }

    End {
    }
}

function Remove-FGTSystemSDNConnector {

    <#
        .SYNOPSIS
        Remove a SDN Connector

        .DESCRIPTION
        Remove a SDN Connector

        .EXAMPLE
        Get-FGTSystemSDNConnector -name MySDNConnector | Remove-FGTSystemSDNConnector

        Removes the SDN Connector MySDNConnector which was retrieved with Get-FGTSystemSDNConnector

        .EXAMPLE
        Get-FGTSystemSDNConnector -name MySDNConnector | Remove-FGTSystemSDNConnector -Confirm:$false

        Removes the SDN Connector MySDNConnector and suppresses the confirmation question
    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    Param(
        [Parameter (Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        [ValidateScript( { Confirm-FGTSDNConnector $_ })]
        [psobject]$sdnconnector,
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

        $uri = "api/v2/cmdb/system/sdn-connector/$($sdnconnector.name)"

        if ($PSCmdlet.ShouldProcess($sdnconnector.name, 'Remove SDN Connector')) {
            $null = Invoke-FGTRestMethod -uri $uri -method 'DELETE' -connection $connection @invokeParams
        }
    }

    End {
    }
}

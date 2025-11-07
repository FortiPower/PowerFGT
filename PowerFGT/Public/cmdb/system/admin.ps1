#
# Copyright 2022, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

function Add-FGTSystemAdmin {

    <#
        .SYNOPSIS
        Add a (System) Administrator

        .DESCRIPTION
        Add a System Administrator (name, password, accprofile, ...)

        .EXAMPLE
        $mypassword = ConvertTo-SecureString mypassword -AsPlainText -Force
        PS > Add-FGTSystemAdmin -name MyAdmin -accprofile super_admin -password $mypassword

        Add a System Admin named myAdmin with acces Profile super_admin and password

        .EXAMPLE
        $mypassword = ConvertTo-SecureString mypassword -AsPlainText -Force
        PS > Add-FGTSystemAdmin -name MyAdmin -accprofile super_admin -password $mypassword -comments "Added By PowerFGT"

        Add a System Admin named myAdmin with a comments

        .EXAMPLE
        $mypassword = ConvertTo-SecureString mypassword -AsPlainText -Force
        PS > Add-FGTSystemAdmin -name MyAdmin -accprofile super_admin -password $mypassword -comments "Add By PowerFGT" -trusthost1 192.0.2.1/32 -trusthost2 198.51.100.0/24

        Add a System Admin named myAdmin with trusthost1 (only host 192.0.2.1) and trusthost2 (network 198.51.100.0/24).
        You can add up to 10 trusthost (trusthost1 to trusthost10)
    #>

    Param(
        [Parameter (Mandatory = $true, Position = 1)]
        [string]$name,
        [Parameter (Mandatory = $true)]
        [SecureString]$password,
        [Parameter (Mandatory = $true)]
        [string]$accprofile,
        [Parameter (Mandatory = $false)]
        [string]$comments,
        [Parameter (Mandatory = $false)]
        [string]$trusthost1,
        [Parameter (Mandatory = $false)]
        [string]$trusthost2,
        [Parameter (Mandatory = $false)]
        [string]$trusthost3,
        [Parameter (Mandatory = $false)]
        [string]$trusthost4,
        [Parameter (Mandatory = $false)]
        [string]$trusthost5,
        [Parameter (Mandatory = $false)]
        [string]$trusthost6,
        [Parameter (Mandatory = $false)]
        [string]$trusthost7,
        [Parameter (Mandatory = $false)]
        [string]$trusthost8,
        [Parameter (Mandatory = $false)]
        [string]$trusthost9,
        [Parameter (Mandatory = $false)]
        [string]$trusthost10,
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

        $admin = New-Object -TypeName PSObject

        $admin | Add-Member -name "name" -membertype NoteProperty -Value $name

        if (("Desktop" -eq $PSVersionTable.PsEdition) -or ($null -eq $PSVersionTable.PsEdition)) {
            $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($password);
            $pass = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr);
        }
        else {
            $pass = ConvertFrom-SecureString -SecureString $password -AsPlainText
        }
        $admin | Add-Member -name "password" -membertype NoteProperty -Value $pass

        $admin | Add-Member -name "accprofile" -membertype NoteProperty -Value $accprofile

        if ( $PsBoundParameters.ContainsKey('comments') ) {
            $admin | Add-Member -name "comments" -membertype NoteProperty -Value $comments
        }

        if ( $PsBoundParameters.ContainsKey('trusthost1') ) {
            $admin | Add-Member -name "trusthost1" -membertype NoteProperty -Value $trusthost1
        }

        if ( $PsBoundParameters.ContainsKey('trusthost2') ) {
            $admin | Add-Member -name "trusthost2" -membertype NoteProperty -Value $trusthost2
        }

        if ( $PsBoundParameters.ContainsKey('trusthost3') ) {
            $admin | Add-Member -name "trusthost3" -membertype NoteProperty -Value $trusthost3
        }

        if ( $PsBoundParameters.ContainsKey('trusthost4') ) {
            $admin | Add-Member -name "trusthost4" -membertype NoteProperty -Value $trusthost4
        }

        if ( $PsBoundParameters.ContainsKey('trusthost5') ) {
            $admin | Add-Member -name "trusthost5" -membertype NoteProperty -Value $trusthost5
        }

        if ( $PsBoundParameters.ContainsKey('trusthost6') ) {
            $admin | Add-Member -name "trusthost6" -membertype NoteProperty -Value $trusthost6
        }

        if ( $PsBoundParameters.ContainsKey('trusthost7') ) {
            $admin | Add-Member -name "trusthost7" -membertype NoteProperty -Value $trusthost7
        }

        if ( $PsBoundParameters.ContainsKey('trusthost8') ) {
            $admin | Add-Member -name "trusthost8" -membertype NoteProperty -Value $trusthost8
        }

        if ( $PsBoundParameters.ContainsKey('trusthost9') ) {
            $admin | Add-Member -name "trusthost9" -membertype NoteProperty -Value $trusthost9
        }

        if ( $PsBoundParameters.ContainsKey('trusthost10') ) {
            $admin | Add-Member -name "trusthost10" -membertype NoteProperty -Value $trusthost10
        }

        if ( $PsBoundParameters.ContainsKey('data') ) {
            $data.GetEnumerator() | ForEach-Object {
                $admin | Add-Member -name $_.key -membertype NoteProperty -Value $_.value
            }
        }

        Invoke-FGTRestMethod -uri 'api/v2/cmdb/system/admin' -method 'POST' -body $admin -connection $connection @invokeParams | Out-Null
        Get-FGTSystemAdmin -name $name -connection $connection @invokeParams

    }

    End {
    }
}

function Get-FGTSystemAdmin {

    <#
        .SYNOPSIS
        Get list of all system administrators

        .DESCRIPTION
        Get list of all system administrators

        .EXAMPLE
        Get-FGTSystemAdmin

        Display all system administrators

        .EXAMPLE
        Get-FGTSystemAdmin -name FGT -filter_type contains

        Get system administrators contains with *FGT*

        .EXAMPLE
        Get-FGTSystemAdmin -meta

        Display all system administrators with metadata (q_...) like usage (q_ref)

        .EXAMPLE
        Get-FGTSystemAdmin -skip

        Display all system administrators (but only relevant attributes)

        .EXAMPLE
        Get-FGTSystemAdmin -vdom vdomX

        Display all system administrators on vdomX
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

        $reponse = Invoke-FGTRestMethod -uri 'api/v2/cmdb/system/admin' -method 'GET' -connection $connection @invokeParams
        $reponse.results
    }

    End {
    }
}

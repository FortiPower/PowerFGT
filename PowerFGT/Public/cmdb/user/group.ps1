#
# Copyright 2022, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

function Add-FGTUserGroup {

    <#
        .SYNOPSIS
        Add a FortiGate User Group

        .DESCRIPTION
        Add a FortiGate User Group

        .EXAMPLE
        Add-FGTUserGroup -name MyUserGroup -member MyUser1

        Add User Group with member MyUser1

        .EXAMPLE
        Add-FGTUserGroup -name MyUserGroup -member MyUser1, MyUser2

        Add User Group with members MyUser1 and MyUser2

        .EXAMPLE
        $data = @{ "authtimeout" = 23 }
        PS C:\>Add-FGTUserGroup -name MyUserGroup -member MyUser1 -data $data

        Add User Group with member MyUser1and authtimeout (23) via -data parameter
    #>

    Param(
        [Parameter (Mandatory = $true)]
        [string]$name,
        [Parameter (Mandatory = $true)]
        [string[]]$member,
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

        if ( Get-FGTUserGroup @invokeParams -name $name -connection $connection) {
            Throw "Already an User Group object using the same name"
        }

        $uri = "api/v2/cmdb/user/group"

        $usergroup = new-Object -TypeName PSObject

        $usergroup | add-member -name "name" -membertype NoteProperty -Value $name

        #Add member to members Array
        $members = @( )
        foreach ( $m in $member ) {
            $member_name = @{ }
            $member_name.add( 'name', $m)
            $members += $member_name
        }
        $usergroup | add-member -name "member" -membertype NoteProperty -Value $members

        if ( $PsBoundParameters.ContainsKey('data') ) {
            $data.GetEnumerator() | ForEach-Object {
                $usergroup | Add-member -name $_.key -membertype NoteProperty -Value $_.value
            }
        }

        Invoke-FGTRestMethod -method "POST" -body $usergroup -uri $uri -connection $connection @invokeParams | Out-Null

        Get-FGTUserGroup -connection $connection @invokeParams -name $name
    }

    End {
    }
}

function Get-FGTUserGroup {

    <#
        .SYNOPSIS
        Get list of all local group

        .DESCRIPTION
        Get list of all local group (name, members, type... )

        .EXAMPLE
        Get-FGTUserGroup

        Display all local groups

        .EXAMPLE
        Get-FGTUserGroup -id 23

        Get local group with id 23

        .EXAMPLE
        Get-FGTUserGroup -name FGT -filter_type contains

        Get local group contains with *FGT*

        .EXAMPLE
        Get-FGTUserGroup -meta

        Display all local group with metadata (q_...) like usage (q_ref)

        .EXAMPLE
        Get-FGTUserGroup -skip

        Display all local group (but only relevant attributes)

        .EXAMPLE
        Get-FGTUserGroup -vdom vdomX

        Display all local group on vdomX
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

        $reponse = Invoke-FGTRestMethod -uri 'api/v2/cmdb/user/group' -method 'GET' -connection $connection @invokeParams
        $reponse.results
    }

    End {
    }
}

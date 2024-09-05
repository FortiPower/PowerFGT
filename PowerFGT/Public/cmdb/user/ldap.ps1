#
# Copyright 2022, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

function Add-FGTUserLDAP {

    <#
        .SYNOPSIS
        Add a FortiGate LDAP Server

        .DESCRIPTION
        Add a FortiGate LDAP Server

        .EXAMPLE
        Add-FGTUserLDAP -Name PowerFGT -server ldap.powerfgt -dn "dc=fgt,dc=power,dc=powerfgt"

        Add a LDAP Server named PowerFGT using ldap.powerfgt with Base DN dc=fgt,dc=power,dc=powerfgt

        .EXAMPLE
        Add-FGTUserLDAP -Name PowerFGT -server ldap.powerfgt -dn "dc=fgt,dc=power,dc=powerfgt" -cnid sAMAccountName

        Add a LDAP Server named PowerFGT using ldap.powerfgt with Base DN dc=fgt,dc=power,dc=powerfgt and sAMAccountName as CNID

        .EXAMPLE
        $mypassword = ConvertTo-SecureString mypassword -AsPlainText -Force
        PS C:\>Add-FGTUserLDAP -Name PowerFGT -server ldap.powerfgt -dn "dc=fgt,dc=power,dc=powerfgt" -type regular -username svc_powerfgt -password $mypassword

        Add a LDAP Server named PowerFGT using ldap.powerfgt with Base DN dc=fgt,dc=power,dc=powerfgt of type regular with speciefied username and password for binding

        .EXAMPLE
        Add-FGTUserLDAP -Name PowerFGT -server ldap.powerfgt -dn "dc=fgt,dc=power,dc=powerfgt" -visibility:$false

        Add a LDAP Server named PowerFGT using ldap.powerfgt with Base DN dc=fgt,dc=power,dc=powerfgt and disabled visibility

        .EXAMPLE
        Add-FGTUserLDAP -Name PowerFGT -server ldap.powerfgt -dn "dc=fgt,dc=power,dc=powerfgt" -secure ldaps

        Add a LDAP Server named PowerFGT using ldap.powerfgt with Base DN dc=fgt,dc=power,dc=powerfgt, and secure connection (LDAPS)

        .EXAMPLE
        Add-FGTUserLDAP -Name PowerFGT -server ldap.powerfgt -dn "dc=fgt,dc=power,dc=powerfgt" -secondary_server ldap2.powerfgt -tertiary_server ldap3.powerfgt -cnid SAMAccountName -type simple -username svc_powerfgt -password $mypassword -secure ldaps

        Add a LDAP Server named PowerFGT using ldap.powerfgt as primary server, ldap2.powerfgt as secondary server and ldap3.powerfgt as tertiary server with Base DN dc=fgt,dc=power,dc=powerfgt, SAMAccountName as CNID, a regular account and secure connection (LDAPS)

        .EXAMPLE
        $data = @{ "port" = 10389 }
        PS C:\>Add-FGTUserLDAP -Name PowerFGT -server ldap.powerfgt -dn "dc=fgt,dc=power,dc=powerfgt" -data $data

        Add a LDAP Server named PowerFGT using ldap.powerfgt with Base DN dc=fgt,dc=power,dc=powerfgt and port 10389 via -data parameter
    #>

    Param(
        [Parameter (Mandatory = $true)]
        [ValidateLength(1, 35)]
        [string]$name,
        [Parameter (Mandatory = $true)]
        [ValidateLength(1, 63)]
        [string]$server,
        [Parameter (Mandatory = $false)]
        [ValidateLength(1, 63)]
        [string]$secondary_server,
        [Parameter (Mandatory = $false)]
        [ValidateLength(1, 63)]
        [string]$tertiary_server,
        [Parameter (Mandatory = $false)]
        [ValidateLength(0, 20)]
        [string]$cnid,
        [Parameter (Mandatory = $true)]
        [ValidateLength(0, 511)]
        [string]$dn,
        [Parameter (Mandatory = $false)]
        [ValidateSet("simple", "regular", "anonymous")]
        [string]$type,
        [Parameter (Mandatory = $false)]
        [ValidateLength(0, 511)]
        [string]$username,
        [Parameter (Mandatory = $false)]
        [SecureString]$password,
        [Parameter (Mandatory = $false)]
        [ValidateSet("disable", "starttls", "ldaps")]
        [string]$secure,
        [Parameter (Mandatory = $false)]
        [boolean]$visibility,
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

        if ( Get-FGTUserLDAP @invokeParams -name $name -connection $connection) {
            Throw "Already a LDAP Server using the same name"
        }

        $uri = "api/v2/cmdb/user/ldap"

        $ldap = new-Object -TypeName PSObject

        $ldap | add-member -name "name" -membertype NoteProperty -Value $name

        $ldap | add-member -name "server" -membertype NoteProperty -Value $server

        if ( $PsBoundParameters.ContainsKey('secondary_server') ) {
            $ldap | add-member -name "secondary-server" -membertype NoteProperty -Value $secondary_server
        }

        if ( $PsBoundParameters.ContainsKey('tertiary_server') ) {
            $ldap | add-member -name "tertiary-server" -membertype NoteProperty -Value $tertiary_server
        }

        if ( $PsBoundParameters.ContainsKey('cnid') ) {
            $ldap | add-member -name "cnid" -membertype NoteProperty -Value $cnid
        }

        if ( $PsBoundParameters.ContainsKey('dn') ) {
            $ldap | add-member -name "dn" -membertype NoteProperty -Value $dn
        }

        if ( $PsBoundParameters.ContainsKey('type') ) {
            if ($type -eq "regular" -and ($Null -eq $username -or $Null -eq $password)) {
                Throw "You need to specify an username and a passord !"
            }
            elseif ($type -eq "regular") {
                $ldap | add-member -name "type" -membertype NoteProperty -Value $type
                $ldap | add-member -name "username" -membertype NoteProperty -Value $username
                if (("Desktop" -eq $PSVersionTable.PsEdition) -or ($null -eq $PSVersionTable.PsEdition)) {
                    $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($password);
                    $passwd = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr);
                    $ldap | add-member -name "password" -membertype NoteProperty -Value $passwd
                }
                else {
                    $passwd = ConvertFrom-SecureString -SecureString $password -AsPlainText
                    $ldap | add-member -name "password" -membertype NoteProperty -Value $passwd
                }
            }
            else {
                #$type is equal to simple or anonymous (Doesn't need username and password)
                $ldap | add-member -name "type" -membertype NoteProperty -Value $type
            }
        }

        if ( $PsBoundParameters.ContainsKey('secure') ) {
            $ldap | add-member -name "secure" -membertype NoteProperty -Value $secure
        }

        if ( $PsBoundParameters.ContainsKey('visibility') ) {
            #with 6.4.x, there is no longer visibility parameter
            if ($connection.version -ge "6.4.0") {
                Write-Warning "-visibility parameter is no longer available with FortiOS 6.4.x and after"
            }
            else {
                if ( $visibility ) {
                    $ldap | add-member -name "visibility" -membertype NoteProperty -Value "enable"
                }
                else {
                    $ldap | add-member -name "visibility" -membertype NoteProperty -Value "disable"
                }
            }
        }

        if ( $PsBoundParameters.ContainsKey('data') ) {
            $data.GetEnumerator() | ForEach-Object {
                $ldap | Add-member -name $_.key -membertype NoteProperty -Value $_.value
            }
        }

        Invoke-FGTRestMethod -method "POST" -body $ldap -uri $uri -connection $connection @invokeParams | out-Null

        Get-FGTUserLDAP -connection $connection @invokeParams -name $name
    }

    End {
    }
}

function Get-FGTUserLDAP {

    <#
        .SYNOPSIS
        Get list of all LDAP servers

        .DESCRIPTION
        Get list of all LDAP servers

        .EXAMPLE
        Get-FGTUserLDAP

        Display all LDAP servers

        .EXAMPLE
        Get-FGTUserLDAP -name FGT -filter_type contains

        Get LDAP servers contains with *FGT*

        .EXAMPLE
        Get-FGTUserLDAP -meta

        Display all LDAP servers with metadata (q_...) like usage (q_ref)

        .EXAMPLE
        Get-FGTUserLDAP -skip

        Display all LDAP servers (but only relevant attributes)

        .EXAMPLE
        Get-FGTUserLDAP -vdom vdomX

        Display all LDAP servers on vdomX
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

        $reponse = Invoke-FGTRestMethod -uri 'api/v2/cmdb/user/ldap' -method 'GET' -connection $connection @invokeParams
        $reponse.results
    }

    End {
    }
}

function Remove-FGTUserLDAP {

    <#
        .SYNOPSIS
        Remove a FortiGate LDAP Server

        .DESCRIPTION
        Remove a LDAP Server on the FortiGate

        .EXAMPLE
        $MyFGTUserLDAP = Get-FGTUserLDAP -name PowerFGT
        PS C:\>$MyFGTUserLDAP | Remove-FGTUserLDAP

        Remove user object $MyFGTUserLDAP

        .EXAMPLE
        $MyFGTUserLDAP = Get-FGTUserLDAP -name MyFGTUserLDAP
        PS C:\>$MyFGTUserLDAP | Remove-FGTUserLDAP -confirm:$false

        Remove UserLDAP object $MyFGTUserLDAP with no confirmation

    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'high')]
    Param(
        [Parameter (Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        [ValidateScript( { Confirm-FGTUserLDAP $_ })]
        [psobject]$userldap,
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

        $uri = "api/v2/cmdb/user/ldap/$($userldap.name)"

        if ($PSCmdlet.ShouldProcess($userldap.name, 'Remove User Ldap')) {
            $null = Invoke-FGTRestMethod -method "DELETE" -uri $uri -connection $connection @invokeParams
        }
    }

    End {
    }
}
#Get-FGTUserTACACS
# Copyright 2024, Cédric Moreau <moreaucedric0 at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

function Add-FGTUserTACACS {

    <#
        .SYNOPSIS
        Add a FortiGate TACACS+ Server

        .DESCRIPTION
        Add a FortiGate TACACS+ Server

        .EXAMPLE
        $mykey = ConvertTo-SecureString mykey -AsPlainText -Force
        PS C:\>Add-FGTUserTACACS -Name PowerFGT -server tacacs.powerfgt -key $mykey

        Add a TACACS+ Server with tacacs.powerfgt as server and key

        .EXAMPLE
        $mykey = ConvertTo-SecureString mykey -AsPlainText -Force
        PS C:\>Add-FGTUserTACACS -Name PowerFGT -server tacacs.powerfgt -key $mykey -secondary_server tacacs2.powerfgt -secondary_key $mykey -tertiary_server tacacs3.powerfgt -tertiary_key $mykey

        Add a TACACS+ Server with tacacs.powerfgt as server and key, and secondary and tertiary servers

        .EXAMPLE
        $mykey = ConvertTo-SecureString mykey -AsPlainText -Force
        PS C:\>Add-FGTUserTACACS -Name PowerFGT -server tacacs.powerfgt -key $mykey -port 49

        Add a TACACS+ Server with tacacs.powerfgt as server and key and port set to 49

        .EXAMPLE
        $mykey = ConvertTo-SecureString mykey -AsPlainText -Force
        PS C:\>Add-FGTUserTACACS -Name PowerFGT -server tacacs.powerfgt -key $mykey -authen_type chap

        Add a TACACS+ Server with tacacs.powerfgt as server and key and CHAP as authentication type

        .EXAMPLE
        $mykey = ConvertTo-SecureString mykey -AsPlainText -Force
        PS C:\>Add-FGTUserTACACS -Name PowerFGT -server tacacs.powerfgt -key $mykey -authen_type auto

        Add a TACACS+ Server with tacacs.powerfgt as server and key and PAP, MSCHAP and CHAP as authentication type in that order

        .EXAMPLE
        $mykey = ConvertTo-SecureString mykey -AsPlainText -Force
        PS C:\>Add-FGTUserTACACS -Name PowerFGT -server tacacs.powerfgt -key $mykey -authorization

        Add a TACACS+ Server with tacacs.powerfgt as server and key and authorization enable
    #>

    Param(
        [Parameter (Mandatory = $true)]
        [ValidateLength(1, 35)]
        [string]$name,
        [Parameter (Mandatory = $true)]
        [ValidateLength(1, 63)]
        [string]$server,
        [Parameter (Mandatory = $true)]
        [SecureString]$key,
        [Parameter (Mandatory = $false)]
        [ValidateLength(1, 63)]
        [string]$secondary_server,
        [Parameter (Mandatory = $false)]
        [SecureString]$secondary_key,
        [Parameter (Mandatory = $false)]
        [ValidateLength(1, 63)]
        [string]$tertiary_server,
        [Parameter (Mandatory = $false)]
        [SecureString]$tertiary_key,
        [Parameter (Mandatory = $false)]
        [ValidateRange(1, 65535)]
        [int]$port,
        [Parameter (Mandatory = $false)]
        [ValidateSet("mschap", "chap", "pap", "ascii", "auto")]
        [string]$authen_type,
        [Parameter (Mandatory = $false)]
        [switch]$authorization,
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

        if ( Get-FGTUserTACACS @invokeParams -name $name -connection $connection) {
            Throw "Already a TACACS+ Server using the same name"
        }

        $uri = "api/v2/cmdb/user/tacacs+"

        $tacacs = new-Object -TypeName PSObject

        $tacacs | add-member -name "name" -membertype NoteProperty -Value $name

        $tacacs | add-member -name "server" -membertype NoteProperty -Value $server

        if (("Desktop" -eq $PSVersionTable.PsEdition) -or ($null -eq $PSVersionTable.PsEdition)) {
            $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($key);
            $key_secure = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr);
            $tacacs | add-member -name "key" -membertype NoteProperty -Value $key_secure
        }
        else {
            $key_secure = ConvertFrom-SecureString -SecureString $key -AsPlainText
            $tacacs | add-member -name "key" -membertype NoteProperty -Value $key_secure
        }

        if ( $PsBoundParameters.ContainsKey('secondary_server') -xor $PsBoundParameters.ContainsKey('secondary_key') ) {
            Throw "You must specify secondary server and secondary key !"
        }
        elseif ($PsBoundParameters.ContainsKey('secondary_server') -and $PsBoundParameters.ContainsKey('secondary_key')) {
            $tacacs | add-member -name "secondary-server" -membertype NoteProperty -Value $secondary_server
            if (("Desktop" -eq $PSVersionTable.PsEdition) -or ($null -eq $PSVersionTable.PsEdition)) {
                $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secondary_key);
                $secondary_key_secure = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr);
                $tacacs | add-member -name "secondary-key" -membertype NoteProperty -Value $secondary_key_secure
            }
            else {
                $secondary_key_secure = ConvertFrom-SecureString -SecureString $secondary_key -AsPlainText
                $tacacs | add-member -name "secondary-key" -membertype NoteProperty -Value $secondary_key_secure
            }
        }

        if ( $PsBoundParameters.ContainsKey('tertiary_server') -xor $PsBoundParameters.ContainsKey('tertiary_key') ) {
            Throw "You must specify tertiary server and tertiary key !"
        }
        elseif ($PsBoundParameters.ContainsKey('tertiary_server') -and $PsBoundParameters.ContainsKey('tertiary_key')) {
            $tacacs | add-member -name "tertiary-server" -membertype NoteProperty -Value $tertiary_server
            if (("Desktop" -eq $PSVersionTable.PsEdition) -or ($null -eq $PSVersionTable.PsEdition)) {
                $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($tertiary_key);
                $tertiary_key_secure = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr);
                $tacacs | add-member -name "tertiary-key" -membertype NoteProperty -Value $tertiary_key_secure
            }
            else {
                $tertiary_key_secure = ConvertFrom-SecureString -SecureString $tertiary_key -AsPlainText
                $tacacs | add-member -name "tertiary-key" -membertype NoteProperty -Value $tertiary_key_secure
            }
        }

        if ( $PsBoundParameters.ContainsKey('port') ) {
            $tacacs | add-member -name "port" -membertype NoteProperty -Value $port
        }

        if ( $PsBoundParameters.ContainsKey('authen_type') ) {
            $tacacs | add-member -name "authen-type" -membertype NoteProperty -Value $authen_type
        }

        if ( $PsBoundParameters.ContainsKey('authorization') ) {
            $tacacs | add-member -name "authorization" -membertype NoteProperty -Value "enable"
        }
        else {
            $tacacs | add-member -name "authorization" -membertype NoteProperty -Value "disable"
        }

        if ( $PsBoundParameters.ContainsKey('visibility') ) {
            #with 6.4.x, there is no longer visibility parameter
            if ($connection.version -ge "6.4.0") {
                Write-Warning "-visibility parameter is no longer available with FortiOS 6.4.x and after"
            }
            else {
                if ( $visibility ) {
                    $tacacs | add-member -name "visibility" -membertype NoteProperty -Value "enable"
                }
                else {
                    $tacacs | add-member -name "visibility" -membertype NoteProperty -Value "disable"
                }
            }
        }

        if ( $PsBoundParameters.ContainsKey('data') ) {
            $data.GetEnumerator() | ForEach-Object {
                $tacacs | Add-member -name $_.key -membertype NoteProperty -Value $_.value
            }
        }

        Invoke-FGTRestMethod -method "POST" -body $tacacs -uri $uri -connection $connection @invokeParams | out-Null

        Get-FGTUserTACACS -connection $connection @invokeParams -name $name
    }

    End {
    }
}

function Get-FGTUserTACACS {

    <#
        .SYNOPSIS
        Get list of all TACACS servers

        .DESCRIPTION
        Get list of all TACACS servers

        .EXAMPLE
        Get-FGTUserTACACS

        Display all TACACS servers

        .EXAMPLE
        Get-FGTUserTACACS -name FGT -filter_type contains

        Get TACACS servers that contains *FGT*

        .EXAMPLE
        Get-FGTUserTACACS -meta

        Display all TACACS servers with metadata (q_...) like usage (q_ref)

        .EXAMPLE
        Get-FGTUserTACACS -skip

        Display all TACACS servers (but only relevant attributes)

        .EXAMPLE
        Get-FGTUserTACACS -schema

        Get schema of User TACACS

        .EXAMPLE
        Get-FGTUserTACACS -vdom vdomX

        Display all TACACS servers on vdomX
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
        [Parameter(Mandatory = $false, ParameterSetName = "schema")]
        [switch]$schema,
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

        if ( $PsBoundParameters.ContainsKey('schema') ) {
            $invokeParams.add( 'extra', "&action=schema" )
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

        $reponse = Invoke-FGTRestMethod -uri 'api/v2/cmdb/user/tacacs+' -method 'GET' -connection $connection @invokeParams
        $reponse.results
    }

    End {
    }
}

function Set-FGTUserTACACS {

    <#
        .SYNOPSIS
        Change a FortiGate TACACS Server

        .DESCRIPTION
        Change a FortiGate TACACS Server

        .EXAMPLE
        $MyFGTUserTACACS = Get-FGTUserTACACS -name MyFGTUserTACACS
        PS C:\>$MyFGTUserTACACS | Set-FGTUserTACACS -server mynewTACACSserver

        Change server name from MyFGTUserTACACS to mynewTACACSserver

        .EXAMPLE
        $MyFGTUserTACACS = Get-FGTUserTACACS -name MyFGTUserTACACS
        PS C:\>$mykey = ConvertTo-SecureString mykey -AsPlainText -Force
        PS C:\>$MyFGTUserTACACS | Set-FGTUserTACACS -secondary_server tacacs2.powerfgt -secondary_key $mykey

        Change secondary server and key

        .EXAMPLE
        $MyFGTUserTACACS = Get-FGTUserTACACS -name MyFGTUserTACACS
        PS C:\>$mykey = ConvertTo-SecureString mykey -AsPlainText -Force
        PS C:\>$MyFGTUserTACACS | Set-FGTUserTACACS -tertiary_server tacacs3.powerfgt -tertiary_key $mykey

        Change tertiary server and key

        .EXAMPLE
        $MyFGTUserTACACS = Get-FGTUserTACACS -name MyFGTUserTACACS
        PS C:\>$MyFGTUserTACACS | Set-FGTUserTACACS -authorization disable

        Change authorization to disable

        .EXAMPLE
        $data = @{ "port" = "10049" }
        PS C:\>$MyFGTUserTACACS = Get-FGTUserTACACS -name MyFGTUserTACACS
        PS C:\>$MyFGTUserTACACS | Set-FGTUserTACACS -data $data

        Change port to 10049
    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'medium', DefaultParameterSetName = 'default')]
    Param(
        [Parameter (Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        [ValidateScript( { Confirm-FGTUserTACACS $_ })]
        [psobject]$usertacacs,
        [Parameter (Mandatory = $false)]
        [ValidateLength(1, 35)]
        [string]$name,
        [Parameter (Mandatory = $false)]
        [ValidateLength(1, 63)]
        [string]$server,
        [Parameter (Mandatory = $false)]
        [SecureString]$key,
        [Parameter (Mandatory = $false)]
        [ValidateLength(1, 63)]
        [string]$secondary_server,
        [Parameter (Mandatory = $false)]
        [SecureString]$secondary_key,
        [Parameter (Mandatory = $false)]
        [ValidateLength(1, 63)]
        [string]$tertiary_server,
        [Parameter (Mandatory = $false)]
        [SecureString]$tertiary_key,
        [Parameter (Mandatory = $false)]
        [ValidateRange(1, 65535)]
        [int]$port,
        [Parameter (Mandatory = $false)]
        [ValidateSet("mschap", "chap", "pap", "ascii", "auto")]
        [string]$authen_type,
        [Parameter (Mandatory = $false)]
        [ValidateSet("enable", "disable")]
        [string]$authorization,
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

        $uri = "api/v2/cmdb/user/tacacs+/$($usertacacs.name)"

        $_tacacs = New-Object -TypeName PSObject

        if ( $PsBoundParameters.ContainsKey('name') ) {
            #TODO check if there is no already an object with this name ?
            $_tacacs | add-member -name "name" -membertype NoteProperty -Value $name
            $usertacacs.name = $name
        }

        if ( $PsBoundParameters.ContainsKey('server') ) {
            $_tacacs | add-member -name "server" -membertype NoteProperty -Value $server
        }

        if ( $PsBoundParameters.ContainsKey('key') ) {
            if (("Desktop" -eq $PSVersionTable.PsEdition) -or ($null -eq $PSVersionTable.PsEdition)) {
                $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($key);
                $key_secure = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr);
                $_tacacs | add-member -name "key" -membertype NoteProperty -Value $key_secure
            }
            else {
                $key_secure = ConvertFrom-SecureString -SecureString $key -AsPlainText
                $_tacacs | add-member -name "key" -membertype NoteProperty -Value $key_secure
            }
        }

        if ( $PsBoundParameters.ContainsKey('secondary_server') ) {
            $_tacacs | add-member -name "secondary-server" -membertype NoteProperty -Value $secondary_server
        }

        if ( $PsBoundParameters.ContainsKey('secondary_key') ) {
            if (("Desktop" -eq $PSVersionTable.PsEdition) -or ($null -eq $PSVersionTable.PsEdition)) {
                $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secondary_key);
                $secondary_key_secure = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr);
                $_tacacs | add-member -name "secondary-key" -membertype NoteProperty -Value $secondary_key_secure
            }
            else {
                $secondary_key_secure = ConvertFrom-SecureString -SecureString $secondary_key -AsPlainText
                $_tacacs | add-member -name "secondary-key" -membertype NoteProperty -Value $secondary_key_secure
            }
        }

        if ( $PsBoundParameters.ContainsKey('tertiary_server') ) {
            $_tacacs | add-member -name "tertiary-server" -membertype NoteProperty -Value $tertiary_server
        }

        if ( $PsBoundParameters.ContainsKey('tertiary_key') ) {
            if (("Desktop" -eq $PSVersionTable.PsEdition) -or ($null -eq $PSVersionTable.PsEdition)) {
                $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($tertiary_key);
                $tertiary_key_secure = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr);
                $_tacacs | add-member -name "tertiary-key" -membertype NoteProperty -Value $tertiary_key_secure
            }
            else {
                $tertiary_key_secure = ConvertFrom-SecureString -SecureString $tertiary_key -AsPlainText
                $_tacacs | add-member -name "tertiary-key" -membertype NoteProperty -Value $tertiary_key_secure
            }
        }

        if ( $PsBoundParameters.ContainsKey('port') ) {
            $_tacacs | add-member -name "port" -membertype NoteProperty -Value $port
        }

        if ( $PsBoundParameters.ContainsKey('authen_type') ) {
            $_tacacs | add-member -name "authen-type" -membertype NoteProperty -Value $authen_type
        }

        if ( $PsBoundParameters.ContainsKey('authorization') ) {
            $_tacacs | add-member -name "authorization" -membertype NoteProperty -Value $authorization
        }

        if ( $PsBoundParameters.ContainsKey('data') ) {
            $data.GetEnumerator() | ForEach-Object {
                $_tacacs | Add-member -name $_.key -membertype NoteProperty -Value $_.value
            }
        }

        if ($PSCmdlet.ShouldProcess($usertacacs.name, 'Configure User TACACS')) {
            Invoke-FGTRestMethod -method "PUT" -body $_tacacs -uri $uri -connection $connection @invokeParams | out-Null

            Get-FGTUserTACACS -connection $connection @invokeParams -name $usertacacs.name
        }
    }

    End {
    }
}

function Remove-FGTUserTACACS {

    <#
        .SYNOPSIS
        Remove a FortiGate TACACS Server

        .DESCRIPTION
        Remove a TACACS Server on the FortiGate

        .EXAMPLE
        $MyFGTUserTACACS = Get-FGTUserTACACS -name PowerFGT
        PS C:\>$MyFGTUserTACACS | Remove-FGTUserTACACS

        Remove user object $MyFGTUserTACACS

        .EXAMPLE
        $MyFGTUserTACACS = Get-FGTUserTACACS -name MyFGTUserTACACS
        PS C:\>$MyFGTUserTACACS | Remove-FGTUserTACACS -confirm:$false

        Remove UserTACACS object $MyFGTUserTACACS with no confirmation
    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'high')]
    Param(
        [Parameter (Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        [ValidateScript( { Confirm-FGTUserTACACS $_ })]
        [psobject]$usertacacs,
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

        $uri = "api/v2/cmdb/user/tacacs+/$($usertacacs.name)"

        if ($PSCmdlet.ShouldProcess($usertacacs.name, 'Remove User Tacacs')) {
            $null = Invoke-FGTRestMethod -method "DELETE" -uri $uri -connection $connection @invokeParams
        }
    }

    End {
    }
}
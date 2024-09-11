#
# Copyright 2022, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

function Add-FGTUserRADIUS {

    <#
        .SYNOPSIS
        Add a FortiGate RADIUS Server

        .DESCRIPTION
        Add a FortiGate RADIUS Server

        .EXAMPLE
        $mysecret = ConvertTo-SecureString mysecret -AsPlainText -Force
        PS C:\>Add-FGTUserRADIUS -Name PowerFGT -server radius.powerfgt -secret $mysecret

        Add a RADIUS Server with radius.powerfgt as server and secret

        .EXAMPLE
        $mysecret = ConvertTo-SecureString mysecret -AsPlainText -Force
        PS C:\>Add-FGTUserRADIUS -Name PowerFGT -server radius.powerfgt -secret $mysecret -secondary_server radius2.powerfgt -secondary_secret $mysecret -tertiary_server radius3.powerfgt -tertiary_secret $mysecret

        Add a RADIUS Server with radius.powerfgt as server and secret, and secondary and tertiary servers

        .EXAMPLE
        $mysecret = ConvertTo-SecureString mysecret -AsPlainText -Force
        PS C:\>Add-FGTUserRADIUS -Name PowerFGT -server radius.powerfgt -secret $mysecret -timeout 5

        Add a RADIUS Server with radius.powerfgt as server and secret and timeout to 5 seconds

        .EXAMPLE
        $mysecret = ConvertTo-SecureString mysecret -AsPlainText -Force
        PS C:\>Add-FGTUserRADIUS -Name PowerFGT -server radius.powerfgt -secret $mysecret -nas_ip 192.0.2.1

        Add a RADIUS Server with radius.powerfgt as server and secret and NAS IP as 192.0.2.1

        .EXAMPLE
        $mysecret = ConvertTo-SecureString mysecret -AsPlainText -Force
        PS C:\>Add-FGTUserRADIUS -Name PowerFGT -server radius.powerfgt -secret $mysecret -nas_id PowerFGT_RADIUS

        Add a RADIUS Server with radius.powerfgt as server and secret and NAS ID as PowerFGT_RADIUS

        .EXAMPLE
        $mysecret = ConvertTo-SecureString mysecret -AsPlainText -Force
        PS C:\>Add-FGTUserRADIUS -Name PowerFGT -server radius.powerfgt -secret $mysecret -auth_type ms_chap_v2

        Add a RADIUS Server with radius.powerfgt as server and secret and auth_type as ms_chap_v2

        .EXAMPLE
        $data = @{ "password-renewal" = "enable" }
        PS C:\>Add-FGTUserRADIUS -Name PowerFGT -server radius.powerfgt -secret $mysecret -data $data

        Add a RADIUS Server with radius.powerfgt as server and secret and password renewal enabled
    #>

    Param(
        [Parameter (Mandatory = $true)]
        [ValidateLength(1, 35)]
        [string]$name,
        [Parameter (Mandatory = $true)]
        [ValidateLength(1, 63)]
        [string]$server,
        [Parameter (Mandatory = $true)]
        [SecureString]$secret,
        [Parameter (Mandatory = $false)]
        [ValidateLength(1, 63)]
        [string]$secondary_server,
        [Parameter (Mandatory = $false)]
        [SecureString]$secondary_secret,
        [Parameter (Mandatory = $false)]
        [ValidateLength(1, 63)]
        [string]$tertiary_server,
        [Parameter (Mandatory = $false)]
        [SecureString]$tertiary_secret,
        [Parameter (Mandatory = $false)]
        [ValidateRange(0, 300)]
        [int]$timeout,
        [Parameter (Mandatory = $false)]
        [string]$nas_ip,
        [Parameter (Mandatory = $false)]
        [ValidateSet("ms_chap_v2", "ms_chap", "chap", "pap", "auto")]
        [string]$auth_type,
        [Parameter (Mandatory = $false)]
        [ValidateLength(0, 255)]
        [string]$nas_id,
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

        if ( Get-FGTUserRADIUS @invokeParams -name $name -connection $connection) {
            Throw "Already a RADIUS Server using the same name"
        }

        $uri = "api/v2/cmdb/user/radius"

        $radius = new-Object -TypeName PSObject

        $radius | add-member -name "name" -membertype NoteProperty -Value $name

        $radius | add-member -name "server" -membertype NoteProperty -Value $server

        if (("Desktop" -eq $PSVersionTable.PsEdition) -or ($null -eq $PSVersionTable.PsEdition)) {
            $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secret);
            $sec = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr);
            $radius | add-member -name "secret" -membertype NoteProperty -Value $sec
        }
        else {
            $sec = ConvertFrom-SecureString -SecureString $secret -AsPlainText
            $radius | add-member -name "secret" -membertype NoteProperty -Value $sec
        }

        if ( $PsBoundParameters.ContainsKey('secondary_server') -xor $PsBoundParameters.ContainsKey('secondary_secret') ) {
            Throw "You must specify secondary server and secondary secret !"
        }
        elseif ($PsBoundParameters.ContainsKey('secondary_server') -and $PsBoundParameters.ContainsKey('secondary_secret')) {
            $radius | add-member -name "secondary-server" -membertype NoteProperty -Value $secondary_server
            if (("Desktop" -eq $PSVersionTable.PsEdition) -or ($null -eq $PSVersionTable.PsEdition)) {
                $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secondary_secret);
                $sec = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr);
                $radius | add-member -name "secondary-secret" -membertype NoteProperty -Value $sec
            }
            else {
                $sec = ConvertFrom-SecureString -SecureString $secondary_secret -AsPlainText
                $radius | add-member -name "secondary-secret" -membertype NoteProperty -Value $sec
            }
        }

        if ( $PsBoundParameters.ContainsKey('tertiary_server') -xor $PsBoundParameters.ContainsKey('tertiary_secret') ) {
            Throw "You must specify tertiary server and tertiary secret !"
        }
        elseif ($PsBoundParameters.ContainsKey('tertiary_server') -and $PsBoundParameters.ContainsKey('tertiary_secret')) {
            $radius | add-member -name "tertiary-server" -membertype NoteProperty -Value $tertiary_server
            if (("Desktop" -eq $PSVersionTable.PsEdition) -or ($null -eq $PSVersionTable.PsEdition)) {
                $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($tertiary_secret);
                $sec = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr);
                $radius | add-member -name "tertiary-secret" -membertype NoteProperty -Value $sec
            }
            else {
                $sec = ConvertFrom-SecureString -SecureString $tertiary_secret -AsPlainText
                $radius | add-member -name "tertiary-secret" -membertype NoteProperty -Value $sec
            }
        }

        if ( $PsBoundParameters.ContainsKey('timeout') ) {
            $radius | add-member -name "timeout" -membertype NoteProperty -Value $timeout
        }

        if ( $PsBoundParameters.ContainsKey('nas_ip') ) {
            $radius | add-member -name "switch-controller-nas-ip-dynamic" -membertype NoteProperty -Value $true
            $radius | add-member -name "nas-ip" -membertype NoteProperty -Value $nas_ip
        }

        if ( $PsBoundParameters.ContainsKey('auth_type') ) {
            $radius | add-member -name "auth-type" -membertype NoteProperty -Value $auth_type
        }

        if ( $PsBoundParameters.ContainsKey('nas_id') ) {
            $radius | add-member -name "nas-id-type" -membertype NoteProperty -Value "custom"
            $radius | add-member -name "nas-id" -membertype NoteProperty -Value $nas_id
        }

        if ( $PsBoundParameters.ContainsKey('visibility') ) {
            #with 6.4.x, there is no longer visibility parameter
            if ($connection.version -ge "6.4.0") {
                Write-Warning "-visibility parameter is no longer available with FortiOS 6.4.x and after"
            }
            else {
                if ( $visibility ) {
                    $radius | add-member -name "visibility" -membertype NoteProperty -Value "enable"
                }
                else {
                    $radius | add-member -name "visibility" -membertype NoteProperty -Value "disable"
                }
            }
        }

        if ( $PsBoundParameters.ContainsKey('data') ) {
            $data.GetEnumerator() | ForEach-Object {
                $radius | Add-member -name $_.key -membertype NoteProperty -Value $_.value
            }
        }

        Invoke-FGTRestMethod -method "POST" -body $radius -uri $uri -connection $connection @invokeParams | out-Null

        Get-FGTUserRADIUS -name $name -connection $connection @invokeParams
    }

    End {
    }
}

function Get-FGTUserRADIUS {

    <#
        .SYNOPSIS
        Get list of all RADIUS servers

        .DESCRIPTION
        Get list of all RADIUS servers

        .EXAMPLE
        Get-FGTUserRADIUS

        Display all RADIUS servers

        .EXAMPLE
        Get-FGTUserRADIUS -name FGT -filter_type contains

        Get RADIUS servers contains with *FGT*

        .EXAMPLE
        Get-FGTUserRADIUS -meta

        Display all RADIUS servers with metadata (q_...) like usage (q_ref)

        .EXAMPLE
        Get-FGTUserRADIUS -skip

        Display all RADIUS servers (but only relevant attributes)

        .EXAMPLE
        Get-FGTUserRADIUS -vdom vdomX

        Display all RADIUS servers on vdomX
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

        $reponse = Invoke-FGTRestMethod -uri 'api/v2/cmdb/user/radius' -method 'GET' -connection $connection @invokeParams
        $reponse.results
    }

    End {
    }
}

function Set-FGTUserRADIUS {

    <#
        .SYNOPSIS
        Change a FortiGate RADIUS Server

        .DESCRIPTION
        Change a FortiGate RADIUS Server

        .EXAMPLE
        $MyFGTUserRADIUS = Get-FGTUserRADIUS -name MyFGTUserRADIUS
        PS C:\>$MyFGTUserRADIUS | Set-FGTUserRADIUS -server mynewRADIUSserver

        Change server name from MyFGTUserRADIUS to mynewRADIUSserver

        .EXAMPLE
        $MyFGTUserRADIUS = Get-FGTUserRADIUS -name MyFGTUserRADIUS
        PS C:\>$mysecret = ConvertTo-SecureString mysecret -AsPlainText -Force
        PS C:\>$MyFGTUserRADIUS | Set-FGTUserRADIUS -secondary_server radius2.powerfgt -secondary_secret $mysecret

        Change secondary server and secret

        .EXAMPLE
        $MyFGTUserRADIUS = Get-FGTUserRADIUS -name MyFGTUserRADIUS
        PS C:\>$mysecret = ConvertTo-SecureString mysecret -AsPlainText -Force
        PS C:\>$MyFGTUserRADIUS | Set-FGTUserRADIUS -tertiary_server radius2.powerfgt -tertiary_secret $mysecret

        Change tertiary server and secret

        .EXAMPLE
        $data = @{ "timeout" = "200" }
        PS C:\>$MyFGTUserRADIUS = Get-FGTUserRADIUS -name MyFGTUserRADIUS
        PS C:\>$MyFGTUserRADIUS | Set-FGTUserRADIUS -data $data

        Change timeout to 200sec
    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'medium', DefaultParameterSetName = 'default')]
    Param(
        [Parameter (Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        [ValidateScript( { Confirm-FGTUserRADIUS $_ })]
        [psobject]$userradius,
        [Parameter (Mandatory = $false)]
        [ValidateLength(1, 35)]
        [string]$name,
        [Parameter (Mandatory = $false)]
        [ValidateLength(1, 63)]
        [string]$server,
        [Parameter (Mandatory = $false)]
        [SecureString]$secret,
        [Parameter (Mandatory = $false)]
        [ValidateLength(1, 63)]
        [string]$secondary_server,
        [Parameter (Mandatory = $false)]
        [SecureString]$secondary_secret,
        [Parameter (Mandatory = $false)]
        [ValidateLength(1, 63)]
        [string]$tertiary_server,
        [Parameter (Mandatory = $false)]
        [SecureString]$tertiary_secret,
        [Parameter (Mandatory = $false)]
        [ValidateRange(0, 300)]
        [int]$timeout,
        [Parameter (Mandatory = $false)]
        [string]$nas_ip,
        [Parameter (Mandatory = $false)]
        [ValidateSet("ms_chap_v2", "ms_chap", "chap", "pap", "auto")]
        [string]$auth_type,
        [Parameter (Mandatory = $false)]
        [ValidateLength(0, 255)]
        [string]$nas_id,
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

        $uri = "api/v2/cmdb/user/radius/$($userradius.name)"

        $_radius = New-Object -TypeName PSObject

        if ( $PsBoundParameters.ContainsKey('name') ) {
            #TODO check if there is no already an object with this name ?
            $_radius | add-member -name "name" -membertype NoteProperty -Value $name
            $userradius.name = $name
        }

        if ( $PsBoundParameters.ContainsKey('server') ) {
            $_radius | add-member -name "server" -membertype NoteProperty -Value $server
        }

        if ( $PsBoundParameters.ContainsKey('secret') ) {
            if (("Desktop" -eq $PSVersionTable.PsEdition) -or ($null -eq $PSVersionTable.PsEdition)) {
                $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secret);
                $sec = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr);
                $_radius | add-member -name "secret" -membertype NoteProperty -Value $sec
            }
            else {
                $sec = ConvertFrom-SecureString -SecureString $secret -AsPlainText
                $_radius | add-member -name "secret" -membertype NoteProperty -Value $sec
            }
        }

        if ( $PsBoundParameters.ContainsKey('secondary_server') ) {
            $_radius | add-member -name "secondary-server" -membertype NoteProperty -Value $secondary_server
        }

        if ( $PsBoundParameters.ContainsKey('secondary_secret') ) {
            if (("Desktop" -eq $PSVersionTable.PsEdition) -or ($null -eq $PSVersionTable.PsEdition)) {
                $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secondary_secret);
                $secondary_sec = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr);
                $_radius | add-member -name "secondary-secret" -membertype NoteProperty -Value $secondary_sec
            }
            else {
                $secondary_sec = ConvertFrom-SecureString -SecureString $secondary_secret -AsPlainText
                $_radius | add-member -name "secondary-secret" -membertype NoteProperty -Value $secondary_sec
            }
        }

        if ( $PsBoundParameters.ContainsKey('tertiary_server') ) {
            $_radius | add-member -name "tertiary-server" -membertype NoteProperty -Value $tertiary_server
        }

        if ( $PsBoundParameters.ContainsKey('tertiary_secret') ) {
            if (("Desktop" -eq $PSVersionTable.PsEdition) -or ($null -eq $PSVersionTable.PsEdition)) {
                $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($tertiary_secret);
                $tertiary_sec = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr);
                $_radius | add-member -name "tertiary-secret" -membertype NoteProperty -Value $tertiary_sec
            }
            else {
                $tertiary_sec = ConvertFrom-SecureString -SecureString $tertiary_secret -AsPlainText
                $_radius | add-member -name "tertiary-secret" -membertype NoteProperty -Value $tertiary_sec
            }
        }

        if ( $PsBoundParameters.ContainsKey('timeout') ) {
            $_radius | add-member -name "timeout" -membertype NoteProperty -Value $timeout
        }

        if ( $PsBoundParameters.ContainsKey('nas_ip') ) {
            $_radius | add-member -name "switch-controller-nas-ip-dynamic" -membertype NoteProperty -Value $true
            $_radius | add-member -name "nas-ip" -membertype NoteProperty -Value $nas_ip
        }

        if ( $PsBoundParameters.ContainsKey('nas_id') ) {
            $_radius | add-member -name "nas-id-type" -membertype NoteProperty -Value "custom"
            $_radius | add-member -name "nas-id" -membertype NoteProperty -Value $nas_id
        }

        if ( $PsBoundParameters.ContainsKey('auth_type') ) {
            $_radius | add-member -name "auth-type" -membertype NoteProperty -Value $auth_type
        }

        if ( $PsBoundParameters.ContainsKey('data') ) {
            $data.GetEnumerator() | ForEach-Object {
                $_radius | Add-member -name $_.key -membertype NoteProperty -Value $_.value
            }
        }

        if ($PSCmdlet.ShouldProcess($userradius.name, 'Configure User Radius')) {
            Invoke-FGTRestMethod -method "PUT" -body $_radius -uri $uri -connection $connection @invokeParams | out-Null

            Get-FGTUserRADIUS -name $userradius.name -connection $connection @invokeParams
        }
    }

    End {
    }
}

function Remove-FGTUserRADIUS {

    <#
        .SYNOPSIS
        Remove a FortiGate RADIUS Server

        .DESCRIPTION
        Remove a RADIUS Server on the FortiGate

        .EXAMPLE
        $MyFGTUserRADIUS = Get-FGTUserRADIUS -name PowerFGT
        PS C:\>$MyFGTUserRADIUS | Remove-FGTUserRADIUS

        Remove user object $MyFGTUserRADIUS

        .EXAMPLE
        $MyFGTUserRADIUS = Get-FGTUserRADIUS -name MyFGTUserRADIUS
        PS C:\>$MyFGTUserRADIUS | Remove-FGTUserRADIUS -confirm:$false

        Remove UserRADIUS object $MyFGTUserRADIUS with no confirmation
    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'high')]
    Param(
        [Parameter (Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        [ValidateScript( { Confirm-FGTUserRADIUS $_ })]
        [psobject]$userradius,
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

        $uri = "api/v2/cmdb/user/radius/$($userradius.name)"

        if ($PSCmdlet.ShouldProcess($userradius.name, 'Remove User Radius')) {
            $null = Invoke-FGTRestMethod -method "DELETE" -uri $uri -connection $connection @invokeParams
        }
    }

    End {
    }
}
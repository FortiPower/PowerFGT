#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

function Add-FGTVpnIpsecPhase2Interface {

    <#
        .SYNOPSIS
        Add a Vpn IPsec Phase 2 Interface

        .DESCRIPTION
        Add a Vpn IPsec Phase 2 Interface (proposal, dhgrp, source, destination )

        .EXAMPLE
        Get-FGTVpnIpsecPhase1Interface -name PowerFGT_VPN | Add-FGTVpnIpsecPhase2Interface -name ph2_PowerFGT_VPN

        Create a VPN IPsec Phase 2 Interface named ph2_PowerFGT_VPN

        .EXAMPLE
        Get-FGTVpnIpsecPhase1Interface -name PowerFGT_VPN | Add-FGTVpnIpsecPhase2Interface -name ph2_PowerFGT_VPN -proposal aes256-sha256, aes256-sha512 -dhgrp 14,15

        Create a VPN IPsec Phase 2 Interface named ph2_PowerFGT_VPN with multiple proposal aes256-sha256, aes256-sha512 and DH Group 14 & 15

        .EXAMPLE
        Get-FGTVpnIpsecPhase1Interface -name PowerFGT_VPN | Add-FGTVpnIpsecPhase2Interface -name ph2_PowerFGT_VPN -src 192.0.2.0/24 -dst 192.0.51.0/24

        Create a VPN IPsec Phase 2 Interface named ph2_PowerFGT_VPN with source 192.0.2.0/24 and destination 192.0.51.0/24

        .EXAMPLE
        $data = @{ "protocol" = "23" ; "encapsulation" = "transport-mode" }
        PS C> Get-FGTVpnIpsecPhase1Interface -name PowerFGT_VPN | Add-FGTVpnIpsecPhase2Interface -name ph2_PowerFGT_VPN -data $data

        Create a VPN IPsec Phase 2 Interface named ph2_PowerFGT_VPN with protocol and encapsulation using -data parameter

    #>

    [CmdletBinding(DefaultParameterSetName = "default")]
    Param(
        [Parameter (Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        [ValidateScript( { Confirm-FGTVpnIpsecPhase1Interface $_ })]
        [psobject]$vpn,
        [Parameter (Mandatory = $true, Position = 2)]
        [string]$name,
        [Parameter (Mandatory = $false)]
        [string[]]$proposal,
        [Parameter (Mandatory = $false)]
        [switch]$pfs,
        [Parameter (Mandatory = $false)]
        [ValidateSet(1, 2, 5, 14, 15, 16, 17, 18, 19, 20, 21, 27, 28, 29, 30, 31, 32)]
        [int[]]$dhgrp,
        [Parameter (Mandatory = $false)]
        [switch]$replay,
        [Parameter (Mandatory = $false)]
        [switch]$keepalive,
        [Parameter (Mandatory = $false)]
        [switch]$autonegotiate,
        [Parameter (Mandatory = $false)]
        [int]$keylifeseconds,
        [Parameter (Mandatory = $false)]
        [string]$comments,
        [Parameter (Mandatory = $false)]
        [string]$srcname,
        [Parameter (Mandatory = $false)]
        [string]$dstname,
        [Parameter (Mandatory = $false)]
        [ValidateScript( { $_ -match [IPAddress]$_ })]
        [string]$srcip,
        [Parameter (Mandatory = $false)]
        [string]$srcnetmask,
        [Parameter (Mandatory = $false)]
        [ValidateScript( { $_ -match [IPAddress]$_ })]
        [string]$srcrange,
        [Parameter (Mandatory = $false)]
        [ValidateScript( { $_ -match [IPAddress]$_ })]
        [string]$dstip,
        [Parameter (Mandatory = $false)]
        [string]$dstnetmask,
        [Parameter (Mandatory = $false)]
        [ValidateScript( { $_ -match [IPAddress]$_ })]
        [string]$dstrange,
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

        $uri = "api/v2/cmdb/vpn.ipsec/phase2-interface"
        $_interface = new-Object -TypeName PSObject

        $_interface | add-member -name "name" -membertype NoteProperty -Value $name

        $_interface | add-member -name "phase1name" -membertype NoteProperty -Value $vpn.name

        if ( $PsBoundParameters.ContainsKey('proposal') ) {
            $_interface | add-member -name "proposal" -membertype NoteProperty -Value ($proposal -join " ")
        }

        if ( $PsBoundParameters.ContainsKey('pfs') ) {
            if ($pfs) {
                $_interface | Add-member -name "pfs" -membertype NoteProperty -Value "enable"
            }
            else {
                $_interface | Add-member -name "pfs" -membertype NoteProperty -Value "disable"
            }
        }

        if ( $PsBoundParameters.ContainsKey('dhgrp') ) {
            $_interface | add-member -name "dhgrp" -membertype NoteProperty -Value ($dhgrp -join " ")
        }

        if ( $PsBoundParameters.ContainsKey('replay') ) {
            if ($replay) {
                $_interface | Add-member -name "replay" -membertype NoteProperty -Value "enable"
            }
            else {
                $_interface | Add-member -name "replay" -membertype NoteProperty -Value "disable"
            }
        }

        if ( $PsBoundParameters.ContainsKey('keepalive') ) {
            if ($keepalive) {
                $_interface | Add-member -name "keepalive" -membertype NoteProperty -Value "enable"
            }
            else {
                $_interface | Add-member -name "keepalive" -membertype NoteProperty -Value "disable"
            }
        }

        if ( $PsBoundParameters.ContainsKey('autonegotiate') ) {
            if ($autonegotiate) {
                $_interface | Add-member -name "auto-negotiate" -membertype NoteProperty -Value "enable"
            }
            else {
                $_interface | Add-member -name "auto-negotiate" -membertype NoteProperty -Value "disable"
            }
        }

        if ( $PsBoundParameters.ContainsKey('keylifeseconds') ) {
            $_interface | Add-member -name "keylife-type" -membertype NoteProperty -Value "seconds"
            $_interface | Add-member -name "keylifeseconds" -membertype NoteProperty -Value $keylifeseconds
        }

        if ( $PsBoundParameters.ContainsKey('comments') ) {
            $_interface | Add-member -name "comments" -membertype NoteProperty -Value $comments
        }

        #Throw if you want to use -srcname/dstname with -srcip/dstip
        if ( ($PsBoundParameters.ContainsKey('srcname') -or $PsBoundParameters.ContainsKey('dstname')) -and ( $PsBoundParameters.ContainsKey('srcip') -or $PsBoundParameters.ContainsKey('dstip'))  ) {
            Throw "You can't use -srcname/dstname with -srcip/dstip"
        }

        #When use src or dst object, it need to be on source and destination (use all if not defined)
        if ( $PsBoundParameters.ContainsKey('srcname') -or $PsBoundParameters.ContainsKey('dstname') ) {

            #Source
            $_interface | Add-member -name "src-addr-type" -membertype NoteProperty -Value "name"
            if ( $PsBoundParameters.ContainsKey('srcname') ) {
                $_interface | Add-member -name "src-name" -membertype NoteProperty -Value $srcname
            }
            else {
                $_interface | Add-member -name "src-name" -membertype NoteProperty -Value "all"
            }

            #Destination
            $_interface | Add-member -name "dst-addr-type" -membertype NoteProperty -Value "name"
            if ( $PsBoundParameters.ContainsKey('dstname') ) {
                $_interface | Add-member -name "dst-name" -membertype NoteProperty -Value $dstname
            }
            else {
                $_interface | Add-member -name "dst-name" -membertype NoteProperty -Value "all"
            }
        }

        #src (IP/Subnet/Range)
        if ( $PsBoundParameters.ContainsKey('srcip') ) {
            $srctype = "ip"
            $ip = $srcip
            $type = "src-start-ip"

            if ( $PsBoundParameters.ContainsKey('srcnetmask') -and $PsBoundParameters.ContainsKey('srcrange')) {
                Throw "You can't use -srcnetmask and -srcrange on the sametime"
            }
            #Source Subnet
            if ( $PsBoundParameters.ContainsKey('srcnetmask') ) {
                $srctype = "subnet"
                $ip += " " + $srcnetmask
                $type = "src-subnet"
            }
            #Source Range
            if ( $PsBoundParameters.ContainsKey('srcrange') ) {
                $srctype = "range"
                $type = "src-start-ip"
                $_interface | Add-member -name "src-end-ip" -membertype NoteProperty -Value $srcrange
            }
            $_interface | Add-member -name "src-addr-type" -membertype NoteProperty -Value $srctype
            $_interface | Add-member -name $type -membertype NoteProperty -Value $ip
        }

        #dst (IP/Subnet/Range)
        if ( $PsBoundParameters.ContainsKey('dstip') ) {
            $dsttype = "ip"
            $ip = $dstip
            $type = "dst-start-ip"

            if ( $PsBoundParameters.ContainsKey('dstnetmask') -and $PsBoundParameters.ContainsKey('dstrange')) {
                Throw "You can't use -dstnetmask and -dstrange on the sametime"
            }

            #Destination Subnet
            if ( $PsBoundParameters.ContainsKey('dstnetmask') ) {
                $dsttype = "subnet"
                $ip += " " + $dstnetmask
                $type = "dst-subnet"
            }
            #Destination Range
            if ( $PsBoundParameters.ContainsKey('dstrange') ) {
                $dsttype = "range"
                $type = "dst-start-ip"
                $_interface | Add-member -name "dst-end-ip" -membertype NoteProperty -Value $dstrange
            }
            $_interface | Add-member -name "dst-addr-type" -membertype NoteProperty -Value $dsttype
            $_interface | Add-member -name $type -membertype NoteProperty -Value $ip
        }

        if ( $PsBoundParameters.ContainsKey('data') ) {
            $data.GetEnumerator() | ForEach-Object {
                $_interface | Add-member -name $_.key -membertype NoteProperty -Value $_.value
            }
        }

        $null = Invoke-FGTRestMethod -uri $uri -method 'POST' -body $_interface -connection $connection @invokeParams

        Get-FGTVpnIpsecPhase2Interface -name $name -connection $connection @invokeParams
    }

    End {
    }
}

function Get-FGTVpnIpsecPhase2Interface {

    <#
        .SYNOPSIS
        Get list of all VPN IPsec phase 2 (IKE) settings

        .DESCRIPTION
        Get list of all VPN IPsec phase 2 (Local / Remote Network PFS, Cipher, Hash...)

        .EXAMPLE
        Get-FGTVpnIPsecPhase2Interface

        Get list of all settings of VPN IPsec Phase 2 interface

        .EXAMPLE
        Get-FGTVpnIPsecPhase2Interface -name myVPNIPsecPhase2interface

        Get VPN IPsec Phase 2 interface named myVPNIPsecPhase2interface

        .EXAMPLE
        Get-FGTVpnIPsecPhase2Interface -name FGT -filter_type contains

        Get VPN IPsec Phase 2 interface contains with *FGT*

        .EXAMPLE
        Get-FGTVpnIPsecPhase2Interface -skip

        Get list of all settings of VPN IPsec Phase 2 interface (but only relevant attributes)

        .EXAMPLE
        Get-FGTVpnIPsecPhase2Interface -vdom vdomX

        Get list of all settings of VPN IPsec Phase 2 interface on vdomX
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

        $response = Invoke-FGTRestMethod -uri 'api/v2/cmdb/vpn.ipsec/phase2-interface' -method 'GET' -connection $connection @invokeParams
        $response.results
    }

    End {
    }
}

function Set-FGTVpnIpsecPhase2Interface {

    <#
        .SYNOPSIS
        Configure a Vpn IPsec Phase 2 Interface

        .DESCRIPTION
        Configure a Vpn IPsec Phase 2 Interface (proposal, dhgrp, source, destination )

        .EXAMPLE
        Get-FGTVpnIpsecPhase2Interface -name ph2_PowerFGT_VPN | Set-FGTVpnIpsecPhase2Interface -name ph2_PowerFGT_VPN

        Create a VPN IPsec Phase 2 Interface named ph2_PowerFGT_VPN

        .EXAMPLE
        $data = @{ "protocol" = "23" ; "encapsulation" = "transport-mode" }
        PS C> Get-FGTVpnIpsecPhase1Interface -name PowerFGT_VPN | Set-FGTVpnIpsecPhase2Interface -name ph2_PowerFGT_VPN -data $data

        Create a VPN IPsec Phase 2 Interface named ph2_PowerFGT_VPN with protocol and encapsulation using -data parameter

    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'medium')]
    Param(
        [Parameter (Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        [ValidateScript( { Confirm-FGTVpnIpsecPhase2Interface $_ })]
        [psobject]$vpn,
        [Parameter (Mandatory = $false)]
        [string]$name,
        [Parameter (Mandatory = $false)]
        [string[]]$proposal,
        [Parameter (Mandatory = $false)]
        [switch]$pfs,
        [Parameter (Mandatory = $false)]
        [ValidateSet(1, 2, 5, 14, 15, 16, 17, 18, 19, 20, 21, 27, 28, 29, 30, 31, 32)]
        [int[]]$dhgrp,
        [Parameter (Mandatory = $false)]
        [switch]$replay,
        [Parameter (Mandatory = $false)]
        [switch]$keepalive,
        [Parameter (Mandatory = $false)]
        [switch]$autonegotiate,
        [Parameter (Mandatory = $false)]
        [int]$keylifeseconds,
        [Parameter (Mandatory = $false)]
        [string]$comments,
        [Parameter (Mandatory = $false)]
        [string]$srcname,
        [Parameter (Mandatory = $false)]
        [string]$dstname,
        [Parameter (Mandatory = $false)]
        [ValidateScript( { $_ -match [IPAddress]$_ })]
        [string]$srcip,
        [Parameter (Mandatory = $false)]
        [string]$srcnetmask,
        [Parameter (Mandatory = $false)]
        [ValidateScript( { $_ -match [IPAddress]$_ })]
        [string]$srcrange,
        [Parameter (Mandatory = $false)]
        [ValidateScript( { $_ -match [IPAddress]$_ })]
        [string]$dstip,
        [Parameter (Mandatory = $false)]
        [string]$dstnetmask,
        [Parameter (Mandatory = $false)]
        [ValidateScript( { $_ -match [IPAddress]$_ })]
        [string]$dstrange,
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

        $uri = "api/v2/cmdb/vpn.ipsec/phase2-interface/$($vpn.name)"
        $_interface = new-Object -TypeName PSObject

        if ( $PsBoundParameters.ContainsKey('name') ) {
            $_interface | add-member -name "proposal" -membertype NoteProperty -Value $name
        }

        if ( $PsBoundParameters.ContainsKey('proposal') ) {
            $_interface | add-member -name "proposal" -membertype NoteProperty -Value ($proposal -join " ")
        }

        if ( $PsBoundParameters.ContainsKey('pfs') ) {
            if ($pfs) {
                $_interface | Add-member -name "pfs" -membertype NoteProperty -Value "enable"
            }
            else {
                $_interface | Add-member -name "pfs" -membertype NoteProperty -Value "disable"
            }
        }

        if ( $PsBoundParameters.ContainsKey('dhgrp') ) {
            $_interface | add-member -name "dhgrp" -membertype NoteProperty -Value ($dhgrp -join " ")
        }

        if ( $PsBoundParameters.ContainsKey('replay') ) {
            if ($replay) {
                $_interface | Add-member -name "replay" -membertype NoteProperty -Value "enable"
            }
            else {
                $_interface | Add-member -name "replay" -membertype NoteProperty -Value "disable"
            }
        }

        if ( $PsBoundParameters.ContainsKey('keepalive') ) {
            if ($keepalive) {
                $_interface | Add-member -name "keepalive" -membertype NoteProperty -Value "enable"
            }
            else {
                $_interface | Add-member -name "keepalive" -membertype NoteProperty -Value "disable"
            }
        }

        if ( $PsBoundParameters.ContainsKey('autonegotiate') ) {
            $vpn_ph1 = Get-FGTVpnIpsecPhase1Interface $vpn.phase1name
            if ($vpn_ph1.type -eq "dynamic") {
                Throw "You can't configure auto-negotiate when use type dynamic"
            }
            if ($autonegotiate) {
                $_interface | Add-member -name "auto-negotiate" -membertype NoteProperty -Value "enable"
            }
            else {
                $_interface | Add-member -name "auto-negotiate" -membertype NoteProperty -Value "disable"
            }
        }

        if ( $PsBoundParameters.ContainsKey('keylifeseconds') ) {
            $_interface | Add-member -name "keylife-type" -membertype NoteProperty -Value "seconds"
            $_interface | Add-member -name "keylifeseconds" -membertype NoteProperty -Value $keylifeseconds
        }

        if ( $PsBoundParameters.ContainsKey('comments') ) {
            $_interface | Add-member -name "comments" -membertype NoteProperty -Value $comments
        }

        #Throw if you want to use -srcname/dstname with -srcip/dstip
        if ( ($PsBoundParameters.ContainsKey('srcname') -or $PsBoundParameters.ContainsKey('dstname')) -and ( $PsBoundParameters.ContainsKey('srcip') -or $PsBoundParameters.ContainsKey('dstip'))  ) {
            Throw "You can't use -srcname/dstname with -srcip/dstip"
        }

        #Source Name
        if ($PsBoundParameters.ContainsKey('srcname')) {
            if ( $vpn.'dst-addr-type' -ne 'name' -and (-not $PsBoundParameters.ContainsKey('dstname'))) {
                Throw "You can't use -srcname when destination is not name object (-dstname)"
            }
            $_interface | Add-member -name "src-addr-type" -membertype NoteProperty -Value "name"
            $_interface | Add-member -name "src-name" -membertype NoteProperty -Value $srcname
        }

        #Destination Name
        if ($PsBoundParameters.ContainsKey('dstname')) {
            if ( $vpn.'src-addr-type' -ne 'name' -and (-not $PsBoundParameters.ContainsKey('srcname'))) {
                Throw "You can't use -dstname when source is not name object (-srcname)"
            }
            $_interface | Add-member -name "dst-addr-type" -membertype NoteProperty -Value "name"
            $_interface | Add-member -name "dst-name" -membertype NoteProperty -Value $dstname
        }

        #src (IP/Subnet/Range)
        if ( $PsBoundParameters.ContainsKey('srcip') ) {
            $srctype = "ip"
            $ip = $srcip
            $type = "src-start-ip"

            if ( $vpn.'dst-addr-type' -eq 'name' -and (-not $PsBoundParameters.ContainsKey('dstip'))) {
                Throw "You can't use -srcip when destination is not ip (-dstip)"
            }
            if ( $PsBoundParameters.ContainsKey('srcnetmask') -and $PsBoundParameters.ContainsKey('srcrange')) {
                Throw "You can't use -srcnetmask and -srcrange on the sametime"
            }
            #Source Subnet
            if ( $PsBoundParameters.ContainsKey('srcnetmask') ) {
                $srctype = "subnet"
                $ip += " " + $srcnetmask
                $type = "src-subnet"
            }
            #Source Range
            if ( $PsBoundParameters.ContainsKey('srcrange') ) {
                $srctype = "range"
                $type = "src-start-ip"
                $_interface | Add-member -name "src-end-ip" -membertype NoteProperty -Value $srcrange
            }
            $_interface | Add-member -name "src-addr-type" -membertype NoteProperty -Value $srctype
            $_interface | Add-member -name $type -membertype NoteProperty -Value $ip
        }

        #dst (IP/Subnet/Range)
        if ( $PsBoundParameters.ContainsKey('dstip') ) {
            $dsttype = "ip"
            $ip = $dstip
            $type = "dst-start-ip"

            if ( $vpn.'src-addr-type' -eq 'name' -and (-not $PsBoundParameters.ContainsKey('srcip'))) {
                Throw "You can't use -dstip when source is not ip (-srcip)"
            }
            if ( $PsBoundParameters.ContainsKey('dstnetmask') -and $PsBoundParameters.ContainsKey('dstrange')) {
                Throw "You can't use -dstnetmask and -dstrange on the sametime"
            }
            #Destination Subnet
            if ( $PsBoundParameters.ContainsKey('dstnetmask') ) {
                $dsttype = "subnet"
                $ip += " " + $dstnetmask
                $type = "dst-subnet"
            }
            #Destination Range
            if ( $PsBoundParameters.ContainsKey('dstrange') ) {
                $dsttype = "range"
                $type = "dst-start-ip"
                $_interface | Add-member -name "dst-end-ip" -membertype NoteProperty -Value $dstrange
            }
            $_interface | Add-member -name "dst-addr-type" -membertype NoteProperty -Value $dsttype
            $_interface | Add-member -name $type -membertype NoteProperty -Value $ip
        }

        if ( $PsBoundParameters.ContainsKey('data') ) {
            $data.GetEnumerator() | ForEach-Object {
                $_interface | Add-member -name $_.key -membertype NoteProperty -Value $_.value
            }
        }

        if ($PSCmdlet.ShouldProcess($vpn.name, 'Vpn IPsec Phase 2 Interface')) {
            $null = Invoke-FGTRestMethod -uri $uri -method 'PUT' -body $_interface -connection $connection @invokeParams
            Get-FGTVpnIpsecPhase2Interface -name $vpn.name -connection $connection @invokeParams
        }
    }

    End {
    }
}

function Remove-FGTVpnIpsecPhase2Interface {

    <#
        .SYNOPSIS
        Remove a Vpn IPsec Phase 2 Interface

        .DESCRIPTION
        Remove a Vpn IPsec Phase 2 Interface

        .EXAMPLE
        Get-FGTVpnIpsecPhase2Interface -name ph2_PowerFGT_VPN | Remove-FGTVpnIpsecPhase2Interface

        Removes the Vpn IPsec Phase 2 Interface ph2_PowerFGT_VPN which was retrieved with Get-FGTVpnIpsecPhase2Interface

        .EXAMPLE
        Get-FGTVpnIpsecPhase2Interfacee -name ph2_PowerFGT_VPN | Remove-FGTVpnIpsecPhase2Interfacee -Confirm:$false

        Removes the Vpn IPsec Phase 2 Interface ph2_PowerFGT_VPN and suppresses the confirmation question
    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    Param(
        [Parameter (Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        [ValidateScript( { Confirm-FGTVpnIpsecPhase2Interface $_ })]
        [psobject]$interface,
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

        $uri = "api/v2/cmdb/vpn.ipsec/phase2-interface/$($interface.name)"

        if ($PSCmdlet.ShouldProcess($interface.name, 'Remove Vpn IPsec Phase 2 Interface')) {
            $null = Invoke-FGTRestMethod -uri $uri -method 'DELETE' -connection $connection @invokeParams
        }
    }

    End {
    }
}
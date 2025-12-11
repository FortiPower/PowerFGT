#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
# Copyright 2021, Jelmer Jaarsma <jelmerjaarsma at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

function Get-FGTSystemDnsDatabase {

    <#
        .SYNOPSIS
        Get DNS database entries

        .DESCRIPTION
        Show DNS datbase entries configured on the FortiGate

        .EXAMPLE
        Get-FGTSystemDnsDatabase

        Display DNS configured on the FortiGate

        .EXAMPLE
        Get-FGTSystemDnsDatabase -filter_attribute primary -filter_value 192.0.2.1

        Get System DNS datbase entries with primary (DNS) equal 192.0.2.1

        .EXAMPLE
        Get-FGTSystemDnsDatabase -filter_attribute domain -filter_value Fortinet -filter_type contains

        Get System DNS database with domain contains Fortinet

        .EXAMPLE
        Get-FGTSystemDnsDatabase -skip

        Display DNS configured on the FortiGate (but only relevant attributes)

        .EXAMPLE
        Get-FGTSystemDnsDatabase -vdom vdomX

        Display DNS database entries configured on the FortiGate on vdomX
    #>

    [CmdletBinding(DefaultParameterSetName = "default")]
    Param(
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

        $response = Invoke-FGTRestMethod -uri 'api/v2/cmdb/system/dns-database' -method 'GET' -connection $connection @invokeParams
        $response.results
    }

    End {
    }
}

function Add-FGTSystemDnsZone {
    [CmdletBinding(SupportsShouldProcess)]
    Param(
        [Parameter(Mandatory = $true)]
        [ValidateLength(1, 35)]
        [String]$name,
        [Parameter(Mandatory = $false)]
        [ValidateSet('enabled', 'disabled')]
        [string]$status = "enabled",
        [Parameter(Mandatory = $true)]
        [ValidateLength(1, 255)]
        [string]$domainname,
        [Parameter(Mandatory = $false)]
        [ValidateScript( { $_ -match [IPAddress]$_ })]
        [string[]]$allowtransfer,
        [Parameter(Mandatory = $false)]
        [ValidateSet('master', 'slave')]
        [string]$type = "master",
        [Parameter(Mandatory = $false)]
        [ValidateSet('shadow', 'public')]
        [string]$view,
        [Parameter(Mandatory = $false)]
        [ValidateScript( { $_ -match [IPAddress]$_ })]
        [string]$ipmaster,
        [Parameter(Mandatory = $false)]
        [ValidateLength(1, 255)]
        [string]$primaryname,
        [Parameter(Mandatory = $false)]
        [ValidateLength(1, 255)]
        [string]$contact,
        [Parameter(Mandatory = $false)]
        [ValidateRange(0, 2147483647)]
        [int]$ttl,
        [Parameter(Mandatory = $false)]
        [ValidateSet('enabled', 'disabled')]
        [string]$authoritative,
        [Parameter(Mandatory = $false)]
        [ValidateScript( { $_ -match [IPAddress]$_ })]
        [string[]]$forwarder,
        [Parameter(Mandatory = $false)]
        [ValidateScript( { $_ -match [IPAddress]$_ })]
        [string]$sourceip,
        [Parameter(Mandatory = $false)]
        [psobject[]]$dnsentry,
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

        $uri = "api/v2/cmdb/system/dns-database"
        $dnszone = new-Object -TypeName PSObject

        $dnszone | add-member -name "name" -membertype NoteProperty -Value $name
        $dnszone | add-member -name "status" -membertype NoteProperty -Value $status
        $dnszone | add-member -name "type" -membertype NoteProperty -Value $type
        $dnszone | add-member -name "domainname" -membertype NoteProperty -Value $domainname

        if ( $PsBoundParameters.ContainsKey('allowtransfer') ) {
            $dnszone | add-member -name "allow-transfer" -membertype NoteProperty -Value ($allowtransfer -join " ")
        }

        if ( $PsBoundParameters.ContainsKey('view') ) {
            $dnszone | add-member -name "view" -membertype NoteProperty -Value $view
        }

        if ( $PsBoundParameters.ContainsKey('ipmaster') ) {
            $dnszone | add-member -name "ip-master" -membertype NoteProperty -Value $ipmaster
        }

        if ( $PsBoundParameters.ContainsKey('primaryname') ) {
            $dnszone | add-member -name "primary-name" -membertype NoteProperty -Value $primaryname
        }

        if ( $PsBoundParameters.ContainsKey('contact') ) {
            $dnszone | add-member -name "contact" -membertype NoteProperty -Value $contact
        }

        if ( $PsBoundParameters.ContainsKey('ttl') ) {
            $dnszone | add-member -name "ttl" -membertype NoteProperty -Value $ttl
        }

        if ( $PsBoundParameters.ContainsKey('authoritative') ) {
            $dnszone | add-member -name "authoritative" -membertype NoteProperty -Value $authoritative
        }

        if ( $PsBoundParameters.ContainsKey('forwarder') ) {
            $dnszone | add-member -name "forwarder" -membertype NoteProperty -Value ($forwarder -join " ")
        }

        if ( $PsBoundParameters.ContainsKey('sourceip') ) {
            $dnszone | add-member -name "source-ip" -membertype NoteProperty -Value $sourceip
        }

        $response = Invoke-FGTRestMethod -uri $uri -method 'POST' -body $dnszone -connection $connection @invokeParams
        $response.results

    }

    End {
    }
}


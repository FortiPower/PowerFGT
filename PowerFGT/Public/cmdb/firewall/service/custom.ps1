#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
# Copyright 2019, Benjamin Perrier <ben dot perrier at outlook dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

function Add-FGTFirewallServiceCustom {

    <#
        .SYNOPSIS
        Add a FortiGate service object

        .DESCRIPTION
        Add a Fortigate service object (TCP/UDP/SCTP, IP, ICMP)

        .EXAMPLE
        Add-FGTFirewallServiceCustom -Name MyServiceCustomTCP8080 -tcp_port 8080 -comment "Service Custom using TCP 8080"

        Add service object MyServiceCustomTCP8080 using TCP Port 8080 and a comment

        .EXAMPLE
        Add-FGTFirewallServiceCustom -Name MyServiceCustomUDP5353 -udp_port 5353 -comment "Service Custom using UDP 5353"

        Add service object MyServiceCustomUDP5353 using TCP Port 5353 and a comment

        .EXAMPLE
        Add-FGTFirewallServiceCustom -Name MyServiceCustomTCPRange8000_9000 -tcp_port "8000-9000"

        Add service object MyServiceCustomTCPRange8000_9000 using TCP Port Range 8000-9000

        .EXAMPLE
        Add-FGTFirewallServiceCustom -Name MyServiceCustomTCP8000_TCP8090 -tcp_port 8080,8090

        Add service object MyServiceCustomTCP8000_TCP8090 using TCP Port 8080 and 8090

        .EXAMPLE
        Add-FGTFirewallServiceCustom -Name MyServiceCustomTCP_UDP_8080 -tcp_port 8080 -udp_port 8080


        Add service object MyServiceCustomTCP_UDP_8080 using TCP Port 8080 and UDP Port 8080

        .EXAMPLE
        Add-FGTFirewallServiceCustom -Name MyServiceCustomICMP -icmpType 8 -icmpCode 0 -comment "service object for ping"

        Add service object MyServiceCustomICMP with protocol type ICMP and ICMP type 8 (echo request), ICMP code 0

        .EXAMPLE
        Add-FGTFirewallServiceCustom -Name MyServiceCustomTCP -protocolNumber 6 -comment "default protocol number for tcp"

        Add service object MyServiceCustomTCP with protocol type ip, protocol number 6 (tcp) and a comment
   #>

    param (
        [Parameter (Mandatory = $true, Position = 0)]
        [string]$name,
        [Parameter(Mandatory = $false, ParameterSetName = "tcp/udp/sctp")]
        [string[]]$tcp_port,
        [Parameter(Mandatory = $false, ParameterSetName = "tcp/udp/sctp")]
        [string[]]$udp_port,
        [Parameter(Mandatory = $false, ParameterSetName = "tcp/udp/sctp")]
        [string[]]$sctp_port,
        [Parameter(ParameterSetName = "ip", Mandatory = $true)]
        [int]$protocolNumber,
        [Parameter(ParameterSetName = "icmp", Mandatory = $true)]
        [ValidateRange(0, 255)]
        [int]$icmpType,
        [Parameter(ParameterSetName = "icmp", Mandatory = $true)]
        [ValidateRange(0, 16)]
        [int]$icmpCode,
        [Parameter(Mandatory = $false)]
        [ValidateLength(0, 255)]
        [string]$comment,
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

        $uri = "api/v2/cmdb/firewall.service/custom"

        $_customervice = New-Object -TypeName PSObject

        $_customervice | Add-Member -Name "name" -MemberType NoteProperty -Value $name

        switch ( $PSCmdlet.ParameterSetName ) {
            "tcp/udp/sctp" {
                if ( $PsBoundParameters.ContainsKey('tcp_port') ) {
                    $_customervice | add-member -name "tcp-portrange" -membertype NoteProperty -Value ($tcp_port -join " ")
                }

                if ( $PsBoundParameters.ContainsKey('udp_port') ) {
                    $_customervice | add-member -name "udp-portrange" -membertype NoteProperty -Value ($udp_port -join " ")
                }

                if ( $PsBoundParameters.ContainsKey('sctp_port') ) {
                    $_customervice | add-member -name "sctp-portrange" -membertype NoteProperty -Value ($udp_port -join " ")
                }
            }
            "ip" {
                $_customervice | Add-Member -Name "protocol" -MemberType NoteProperty -Value $protocol

                $_customervice | Add-Member -Name "protocol-number" -MemberType NoteProperty -Value $protocolNumber

            }
            "icmp" {

                $_customervice | Add-Member -Name "icmpcode" -MemberType NoteProperty -Value $icmpCode

                $_customervice | Add-Member -Name "icmptype" -MemberType NoteProperty -Value $icmpType

            }
        }

        if ( $PsBoundParameters.ContainsKey('comment') ) {
            $_customervice | add-member -name "comment" -membertype NoteProperty -Value $comment
        }

        if ( $PsBoundParameters.ContainsKey('data') ) {
            $data.GetEnumerator() | ForEach-Object {
                $address | Add-member -name $_.key -membertype NoteProperty -Value $_.value
            }
        }

        Invoke-FGTRestMethod -method "POST" -body $_customervice -uri $uri -connection $connection @invokeParams | Out-Null

        Get-FGTFirewallServiceCustom -connection $connection @invokeParams -name $name
    }

    End {
    }
}

function Set-FGTFirewallServiceCustom {

    <#
        .SYNOPSIS
        Configure a FortiGate Service Custom

        .DESCRIPTION
        Change a FortiGate Service Custom (Name, TCP / UDP / SCTP Port, coments... )

        .EXAMPLE
        $MyFGTServiceCustom = Get-FGTFirewallServiceCustom -name MyFGTServiceCustom
        PS C:\>$MyFGTServiceCustom | Set-FGTFirewallServiceCustom -tcp_port 8080

        Change MyFGTServiceCustom tcp-port to 8080

        .EXAMPLE
        $MyFGTServiceCustom = Get-FGTFirewallServiceCustom -name MyFGTServiceCustom
        PS C:\>$MyFGTServiceCustom | Set-FGTFirewallServiceCustom -tcp_port 8080-8090

        Change MyFGTServiceCustom tcp-port (range) to 8080-8090

        .EXAMPLE
        $MyFGTServiceCustom = Get-FGTFirewallServiceCustom -name MyFGTServiceCustom
        PS C:\>$MyFGTServiceCustom | Set-FGTFirewallServiceCustom -tcp_port 8080, 9090

        Change MyFGTServiceCustom tcp-port to 8080 and 9090

        .EXAMPLE
        $MyFGTServiceCustom = Get-FGTFirewallServiceCustom -name MyFGTServiceCustom
        PS C:\>$MyFGTServiceCustom | Set-FGTFirewallServiceCustom -udp_port 5353

        Change MyFGTServiceCustom udp-port to 5353

        .EXAMPLE
        $MyFGTServiceCustom = Get-FGTFirewallServiceCustom -name MyFGTServiceCustom
        PS C:\>$MyFGTServiceCustom | Set-FGTFirewallServiceCustom -name MyFGTServiceCustom2

        Change MyFGTServiceCustom name to MyFGTServiceCustom2

        .EXAMPLE
        $MyFGTServiceCustom = Get-FGTFirewallServiceCustom -name MyFGTServiceCustom
        PS C:\>$MyFGTServiceCustom | Set-FGTFirewallServiceCustom -comment "My New comment"

        Change MyFGTServiceCustom commment "My New Comment"

        .EXAMPLE
        $data = @{ "color" = 23 }
        PS C:\>$MyFGTServiceCustom = Get-FGTFirewallServiceCustom -name MyFGTServiceCustom
        PS C:\>$MyFGTServiceCustom | Set-FGTFirewallServiceCustom -data $color

        Change MyFGTServiceCustom to set a color (23) using -data


    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'medium', DefaultParameterSetName = 'default')]
    Param(
        [Parameter (Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        [ValidateScript( { Confirm-FGTServiceCustom $_ })]
        [psobject]$servicecustom,
        [Parameter (Mandatory = $false)]
        [string]$name,
        [Parameter(Mandatory = $false, ParameterSetName = "tcp/udp/sctp")]
        [string[]]$tcp_port,
        [Parameter(Mandatory = $false, ParameterSetName = "tcp/udp/sctp")]
        [string[]]$udp_port,
        [Parameter(Mandatory = $false, ParameterSetName = "tcp/udp/sctp")]
        [string[]]$sctp_port,
        [Parameter(ParameterSetName = "ip", Mandatory = $true)]
        [int]$protocolNumber,
        [Parameter(ParameterSetName = "icmp", Mandatory = $true)]
        [ValidateRange(0, 255)]
        [int]$icmpType,
        [Parameter(ParameterSetName = "icmp", Mandatory = $true)]
        [ValidateRange(0, 16)]
        [int]$icmpCode,
        [Parameter (Mandatory = $false)]
        [ValidateLength(0, 255)]
        [string]$comment,
        [Parameter (Mandatory = $false)]
        [boolean]$visibility,
        [Parameter (Mandatory = $false)]
        [switch]$allowrouting,
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

        $uri = "api/v2/cmdb/firewall.service/custom"
        $old_name = $servicecustom.name

        $_servicecustom = new-Object -TypeName PSObject

        if ( $PsBoundParameters.ContainsKey('name') ) {
            #TODO check if there is no already a object with this name ?
            $_servicecustom | add-member -name "name" -membertype NoteProperty -Value $name
            $servicecustom.name = $name
        }

        if ( $PSCmdlet.ParameterSetName -ne "default" -and $servicecustom.protocol -ne $PSCmdlet.ParameterSetName ) {
            throw "Service Custom type ($($servicecustom.protocol)) need to be on the same protocol ($($PSCmdlet.ParameterSetName))"
        }

        switch ( $PSCmdlet.ParameterSetName ) {
            "tcp/udp/sctp" {
                if ( $PsBoundParameters.ContainsKey('tcp_port') ) {
                    $_servicecustom | add-member -name "tcp-portrange" -membertype NoteProperty -Value ($tcp_port -join " ")
                }

                if ( $PsBoundParameters.ContainsKey('udp_port') ) {
                    $_servicecustom | add-member -name "udp-portrange" -membertype NoteProperty -Value ($udp_port -join " ")
                }

                if ( $PsBoundParameters.ContainsKey('sctp_port') ) {
                    $_servicecustom | add-member -name "sctp-portrange" -membertype NoteProperty -Value ($udp_port -join " ")
                }
            }
            "ip" {
                $_servicecustom | Add-Member -Name "protocol" -MemberType NoteProperty -Value $protocol

                $_servicecustom | Add-Member -Name "protocol-number" -MemberType NoteProperty -Value $protocolNumber

            }
            "icmp" {

                $_servicecustom | Add-Member -Name "icmpcode" -MemberType NoteProperty -Value $icmpCode

                $_servicecustom | Add-Member -Name "icmptype" -MemberType NoteProperty -Value $icmpType

            }
        }

        if ( $PsBoundParameters.ContainsKey('comment') ) {
            $_servicecustom | add-member -name "comment" -membertype NoteProperty -Value $comment
        }


        if ( $PsBoundParameters.ContainsKey('data') ) {
            $data.GetEnumerator() | ForEach-Object {
                $_servicecustom | Add-member -name $_.key -membertype NoteProperty -Value $_.value
            }
        }

        if ($PSCmdlet.ShouldProcess($servicecustom.name, 'Configure Firewall Service Custom')) {
            Invoke-FGTRestMethod -method "PUT" -body $_servicecustom -uri $uri -uri_escape $old_name -connection $connection @invokeParams | out-Null

            Get-FGTFirewallServiceCustom -connection $connection @invokeParams -name $servicecustom.name
        }
    }

    End {
    }
}

function Get-FGTFirewallServiceCustom {

    <#
        .SYNOPSIS
        Get list of all "services"

        .DESCRIPTION
        Get list of all "services" (SMTP, HTTP, HTTPS, DNS...)

        .EXAMPLE
        Get-FGTFirewallServiceCustom

        Get list of all services object

        .EXAMPLE
        Get-FGTFirewallServiceCustom -name myFirewallServiceCustom

        Get services object named myFirewallServiceCustom

        .EXAMPLE
        Get-FGTFirewallServiceCustom -name FGT -filter_type contains

        Get services object contains with *FGT*

        .EXAMPLE
        Get-FGTFirewallServiceCustom -meta

        Get list of all services object with metadata (q_...) like usage (q_ref)

        .EXAMPLE
        Get-FGTFirewallServiceCustom -skip

        Get list of all services object (but only relevant attributes)

        .EXAMPLE
        Get-FGTFirewallServiceCustom -vdom vdomX

        Get list of all services object on vdomX

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

        $response = Invoke-FGTRestMethod -uri 'api/v2/cmdb/firewall.service/custom' -method 'GET' -connection $connection @invokeParams
        $response.results
    }

    End {
    }
}


function Remove-FGTFirewallServiceCustom {

    <#
        .SYNOPSIS
        Remove a FortiGate ServiceCustom

        .DESCRIPTION
        Remove a Service Custom object on the FortiGate

        .EXAMPLE
        $MyServiceCustom = Get-FGTFirewallServiceCustom -name MyServiceCustom
        PS C:\>$MyServiceCustom | Remove-FGTFirewallServiceCustom

        Remove Service Custom $MyServiceCustom

        .EXAMPLE
        $MyServiceCustom = Get-FGTFirewallServiceCustom -name MyServiceCustom
        PS C:\>$MyServiceCustom | Remove-FGTFirewallServiceCustom -confirm:$false

        Remove Service Custom $MyServiceCustom with no confirmation

    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'high')]
    Param(
        [Parameter (Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        [ValidateScript( { Confirm-FGTServiceCustom $_ })]
        [psobject]$servicecustom,
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

        $uri = "api/v2/cmdb/firewall.service/custom"

        if ($PSCmdlet.ShouldProcess($servicecustom.name, 'Remove Firewall Service Custom')) {
            $null = Invoke-FGTRestMethod -method "DELETE" -uri $uri -uri_escape $servicecustom.name -connection $connection @invokeParams
        }
    }

    End {
    }
}
#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
# Copyright 2019, Benjamin Perrier <ben dot perrier at outlook dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

function Get-FGTRouterStatic {

    <#
        .SYNOPSIS
        Get list of all "static routes"

        .DESCRIPTION
        Get list of all "static routes" (destination network, gateway, port, distance, weight...)

        .EXAMPLE
        Get-FGTRouterStatic

        Get list of all static route object

        .EXAMPLE
        Get-FGTRouterStatic -filter_attribute gateway -filter_value 192.0.2.1

        Get static route object with gateway equal 192.0.2.1

        .EXAMPL
        Get-FGTRouterStatic -filter_attribute device -filter_value port -filter_type contains

        Get static route object with device contains port

        .EXAMPLE
        Get-FGTRouterStatic -skip

        Get list of all static route object (but only relevant attributes)

        .EXAMPLE
        Get-FGTRouterStatic -vdom vdomX

        Get list of all static route object on vdomX
    #>

    [CmdletBinding(DefaultParameterSetName = "default")]
    Param(
        [Parameter (Mandatory = $false)]
        [Parameter (ParameterSetName = "filter")]
        [string]$filter_attribute,
        [Parameter (Mandatory = $false)]
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
        #if filter value and filter_attribute, add filter (by default filter_type is equal)
        if ( $filter_value -and $filter_attribute ) {
            $invokeParams.add( 'filter_value', $filter_value )
            $invokeParams.add( 'filter_attribute', $filter_attribute )
            $invokeParams.add( 'filter_type', $filter_type )
        }

        $response = Invoke-FGTRestMethod -uri 'api/v2/cmdb/router/static' -method 'GET' -connection $connection @invokeParams
        $response.results
    }

    End {
    }
}

function Add-FGTRouterStatic {

    <#
        .SYNOPSIS
        Add a FortiGate static route

        .DESCRIPTION
        Add a FortiGate static route

        .EXAMPLE
        Add-FGTRouterStatic -status -dst 198.51.100.0/24 -gateway 192.0.2.254 -device internal1 -comment "Example_PowerFGT" -distance 10

        Add a route to 198.51.100.0/24 with gateway 192.2.0.254 by the interface named internal1, with Example_PowerFGT as the description, with an administrative distance of 10

        .EXAMPLE
        Add-FGTRouterStatic -status:$false -dst 198.51.100.0/24 -gateway 192.0.2.254 -device internal1

        Add a route with status disabled
    #>

    [CmdletBinding(DefaultParameterSetName = "default")]
    Param(
        [Parameter (Mandatory = $false)]
        [ValidateRange(1,4294967295)]
        [int]$seq_num,
        [Parameter (Mandatory = $false)]
        [switch]$status,
        [Parameter (Mandatory = $true, ParameterSetName = "dst_device")]
        [Parameter (Mandatory = $true, ParameterSetName = "dst_blackhole")]
        [string]$dst,
        [Parameter (Mandatory = $false)]
        [string]$src,
        [Parameter (Mandatory = $false)]
        [string]$gateway,
        [Parameter (Mandatory = $false)]
        [ValidateRange(1,255)]
        [int]$distance,
        [Parameter (Mandatory = $false)]
        [ValidateRange(0,255)]
        [int]$weight,
        [Parameter (Mandatory = $false)]
        [ValidateRange(0,65535)]
        [int]$priority,
        [Parameter (Mandatory = $true, ParameterSetName = "dst_device")]
        [Parameter (Mandatory = $true, ParameterSetName = "isdb_device")]
        [string]$device,
        [Parameter (Mandatory = $false)]
        [ValidateLength(0, 255)]
        [string]$comment,
        [Parameter (Mandatory = $false, ParameterSetName = "dst_blackhole")]
        [Parameter (Mandatory = $false, ParameterSetName = "isdb_blackhole")]
        [switch]$blackhole,
        [Parameter (Mandatory = $false)]
        [switch]$dynamic_gateway = $false,
        [Parameter (Mandatory = $false)]
        [switch]$sdwan = $false,
        [Parameter (Mandatory = $false)]
        [ValidateLength(0, 79)]
        [string]$dstaddr,
        [Parameter (Mandatory = $true, ParameterSetName = "isdb_device")]
        [Parameter (Mandatory = $true, ParameterSetName = "isdb_blackhole")]
        [ValidateRange(0,4294967295)]
        [int]$internet_service,
        [Parameter(Mandatory = $false)]
        [ValidateLength(0, 64)]
        [String]$internet_service_custom,
        [Parameter (Mandatory = $false)]
        [switch]$link_monitor_exempt = $false,
        [Parameter (Mandatory = $false)]
        [ValidateRange(0,31)]
        [int]$vrf,
        [Parameter (Mandatory = $false)]
        [switch]$bfd = $false,
        [Parameter (Mandatory = $false)]
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

        if ( $PsBoundParameters.ContainsKey('seq_num') ) {
            if ( Get-FGTRouterStatic -filter_attribute seq-num -filter_value $seq_num ) {
                Throw "Already a static route with this sequence number"
            }
        }

        if ( $PsBoundParameters.ContainsKey('device') ) {
            if ( -Not (Get-FGTSystemInterface  -filter_attribute name -filter_value $device) ) {
                Throw "The device interface does not exist"
            }
        }

        $uri = "api/v2/cmdb/router/static"

        $static = new-Object -TypeName PSObject

        if ( $PsBoundParameters.ContainsKey('seq_num') ) {
            $static | add-member -name "seq-num" -membertype NoteProperty -Value $seq_num
        }

        if ( $PsBoundParameters.ContainsKey('status') ) {
            if ($status) {
                $static | add-member -name "status" -membertype NoteProperty -Value "enable"
            }
            else {
                $static | add-member -name "status" -membertype NoteProperty -Value "disable"
            }
        }

        if ( $PsBoundParameters.ContainsKey('dst') ) {
            $static | add-member -name "dst" -membertype NoteProperty -Value $dst
        }

        if ( $PsBoundParameters.ContainsKey('src') ) {
            $static | add-member -name "src" -membertype NoteProperty -Value $src
        }

        if ( $PsBoundParameters.ContainsKey('gateway') ) {
            $static | add-member -name "gateway" -membertype NoteProperty -Value $gateway
        }

        if ( $PsBoundParameters.ContainsKey('distance') ) {
            $static | add-member -name "distance" -membertype NoteProperty -Value $distance
        }

        if ( $PsBoundParameters.ContainsKey('weight') ) {
            $static | add-member -name "weight" -membertype NoteProperty -Value $weight
        }

        if ( $PsBoundParameters.ContainsKey('priority') ) {
            $static | add-member -name "priority" -membertype NoteProperty -Value $priority
        }

        if ( $PsBoundParameters.ContainsKey('device') ) {
            $static | add-member -name "device" -membertype NoteProperty -Value $device
        }

        if ( $PsBoundParameters.ContainsKey('comment') ) {
            $static | add-member -name "comment" -membertype NoteProperty -Value $comment
        }

        if ( $PsBoundParameters.ContainsKey('blackhole') ) {
            if ($blackhole) {
                $static | add-member -name "blackhole" -membertype NoteProperty -Value "enable"
            }
            else {
                $static | add-member -name "blackhole" -membertype NoteProperty -Value "disable"
            }
        }

        if ( $PsBoundParameters.ContainsKey('dynamic_gateway') ) {
            if ($dynamic_gateway) {
                $static | add-member -name "dynamic-gateway" -membertype NoteProperty -Value "enable"
            }
            else {
                $static | add-member -name "dynamic-gateway" -membertype NoteProperty -Value "disable"
            }
        }

        if ( $PsBoundParameters.ContainsKey('sdwan') ) {
            if ($sdwan) {
                $static | add-member -name "sdwan" -membertype NoteProperty -Value "enable"
            }
            else {
                $static | add-member -name "sdwan" -membertype NoteProperty -Value "disable"
            }
        }

        if ( $PsBoundParameters.ContainsKey('dstaddr') ) {
            $static | add-member -name "dstaddr" -membertype NoteProperty -Value $dstaddr
        }

        if ( $PsBoundParameters.ContainsKey('internet_service') ) {
            $static | add-member -name "internet-service" -membertype NoteProperty -Value $internet_service
        }

        if ( $PsBoundParameters.ContainsKey('internet_service_custom') ) {
            $static | add-member -name "internet-service-custom" -membertype NoteProperty -Value $internet_service_custom
        }

        if ( $PsBoundParameters.ContainsKey('link_monitor_exempt') ) {
            if ($link_monitor_exempt) {
                $static | add-member -name "link-monitor-exempt" -membertype NoteProperty -Value "enable"
            }
            else {
                $static | add-member -name "link-monitor-exempt" -membertype NoteProperty -Value "disable"
            }
        }

        if ( $PsBoundParameters.ContainsKey('vrf') ) {
            $static | add-member -name "vrf" -membertype NoteProperty -Value $vrf
        }

        if ( $PsBoundParameters.ContainsKey('bfd') ) {
            if ($bfd) {
                $static | add-member -name "bfd" -membertype NoteProperty -Value "enable"
            }
            else {
                $static | add-member -name "bfd" -membertype NoteProperty -Value "disable"
            }
        }

        $post = Invoke-FGTRestMethod -method "POST" -body $static -uri $uri -connection $connection @invokeParams

        #if you don't have seq-num get the number with the POST
        if ( -Not $PsBoundParameters.ContainsKey('seq_num') ) {
            $seq_num = $post.mkey

        }
        Get-FGTRouterStatic -filter_attribute seq-num -filter_value $seq_num -connection $connection @invokeParams

    }
    End {
    }
}

function Remove-FGTRouterStatic {

    <#
        .SYNOPSIS
        Remove a FortiGate static route

        .DESCRIPTION
        Remove a static route on the FortiGate

        .EXAMPLE
        $MyFGTRoute = Get-FGTRouterStatic -filter_attribute gateway -filter_value 192.0.2.1
        PS C:\>$MyFGTRoute | Remove-FGTRouterStatic

        Remove static route with gateway 192.0.2.1

        .EXAMPLE
        $MyFGTRoute = Get-FGTRouterStatic -filter_attribute gateway -filter_value 192.0.2.1
        PS C:\>$MyFGTRoute | Remove-FGTRouterStatic -confirm:$false

        Remove static route with gateway 192.0.2.1 with no confirmation

    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'high')]
    Param(
        [Parameter (Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        [ValidateScript( { Confirm-FGTRouterStatic $_ })]
        [psobject]$route,
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

        $uri = "api/v2/cmdb/router/static/$($route."seq-num")"

        if ($PSCmdlet.ShouldProcess($route.name, 'Remove Firewall route')) {
            $null = Invoke-FGTRestMethod -method "DELETE" -uri $uri -connection $connection @invokeParams
        }
    }

    End {
    }
}
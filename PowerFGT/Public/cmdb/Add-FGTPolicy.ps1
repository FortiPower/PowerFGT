#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
# Copyright 2019, Benjamin Perrier <ben dot perrier at outlook dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

function Add-FGTPolicy {

    <#
        .SYNOPSIS
        Add a FortiGate Policy

        .DESCRIPTION
        Add a FortiGate Policy

        .EXAMPLE
        Add-FGTPolicy -name "test_policy" -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all -action "accept" -status "enable" -schedule "always" -service ALL -nat "disable"
        Add a new policy with mandatory args.

        .EXAMPLE
        Add-FGTPolicy -name "test_policy" -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all -action "accept" -status "enable" -schedule "always" -service "HTTP, HTTPS, SSH" -nat "disable"
        Add a new policy with multi services

    #>


  Param(
        [Parameter (Mandatory=$true)]
        [string]$name,
        [Parameter (Mandatory=$true)]
        [string]$srcintf,
        [Parameter (Mandatory=$true)]
        [string]$dstintf,
        [Parameter (Mandatory=$true)]
        [string]$srcaddr,
        [Parameter (Mandatory=$true)]
        [string]$dstaddr,
        [Parameter (Mandatory=$true)]
        [ValidateSet("accept","deny","learn")] 
        [string]$action,
        [ValidateSet("enable","disable")]
        [Parameter (Mandatory=$true)]
        [string]$status,
        [Parameter (Mandatory=$true)]
        [string]$schedule,
        [Parameter (Mandatory=$true)]
        [string]$service,
        [ValidateSet("enable","disable")] 
        [Parameter (Mandatory=$true)]
        [string]$nat,
        [Parameter (Mandatory=$false)]
        [string]$policyid
    ) 

    Begin {
    }

    Process {

        $uri = "api/v2/cmdb/firewall/policy"

# SOURCE INTERFACE

        $arr = $srcintf -split ', '
        $line=1
        foreach ($a in $arr){
            New-Variable -Name "srcintf_array$line" -Value $a
            $temp = Get-Variable -Name "srcintf_array$line" -ValueOnly
            $temp = new-Object -TypeName PSObject
            $temp | add-member -name "name" -membertype NoteProperty -Value $a
            [array]$srcintf_array_array += $temp
            $line++
            }

# DESTINATION INTERFACE
        $arr = $dstintf -split ', '
        $line = 0
        foreach ($a in $arr){
            New-Variable -Name "dstintf_array$line" -Value $a
            $temp = Get-Variable -Name "dstintf_array$line" -ValueOnly
            $temp = new-Object -TypeName PSObject
            $temp | add-member -name "name" -membertype NoteProperty -Value $a
            [array]$dstintf_array_array += $temp
            $line++
            }

# SOURCE ADDRESSE
        $arr = $srcaddr -split ', '
        $line = 0
        foreach ($a in $arr){
            New-Variable -Name "srcaddr_array$line" -Value $a
            $temp = Get-Variable -Name "srcaddr_array$line" -ValueOnly
            $temp = new-Object -TypeName PSObject
            $temp | add-member -name "name" -membertype NoteProperty -Value $a
            [array]$srcaddr_array_array += $temp
            $line++
            }

# DESTINATION ADDRESSE
        $arr = $dstaddr -split ', '
        $line = 0
        foreach ($a in $arr){
            New-Variable -Name "dstaddr_array$line" -Value $a
            $temp = Get-Variable -Name "dstaddr_array$line" -ValueOnly
            $temp = new-Object -TypeName PSObject
            $temp | add-member -name "name" -membertype NoteProperty -Value $a
            [array]$dstaddr_array_array += $temp
            $line++
            }

# SERVICE       
        $arr = $service -split ', '
        $line = 0
        foreach ($a in $arr){
            New-Variable -Name "service_array$line" -Value $a
            $temp = Get-Variable -Name "service_array$line" -ValueOnly
            $temp = new-Object -TypeName PSObject
            $temp | add-member -name "name" -membertype NoteProperty -Value $a
            [array]$service_array_array += $temp
            $line++
            }

        $policy = new-Object -TypeName PSObject

        $policy | add-member -name "name" -membertype NoteProperty -Value $name
        $policy | add-member -name "srcintf" -membertype NoteProperty -Value $srcintf_array_array
        $policy | add-member -name "dstintf" -membertype NoteProperty -Value $dstintf_array_array
        $policy | add-member -name "srcaddr" -membertype NoteProperty -Value $srcaddr_array_array
        $policy | add-member -name "dstaddr" -membertype NoteProperty -Value $dstaddr_array_array
        $policy | add-member -name "action" -membertype NoteProperty -Value $action
        $policy | add-member -name "status" -membertype NoteProperty -Value $status
        $policy | add-member -name "schedule" -membertype NoteProperty -Value $schedule
        $policy | add-member -name "service" -membertype NoteProperty -Value $service_array_array
        $policy | add-member -name "nat" -membertype NoteProperty -Value $nat
        $policy | add-member -name "policyid" -membertype NoteProperty -Value $policyid

        $policy

        Invoke-FGTRestMethod -method "POST" -body $policy -uri $uri | out-Null

        Get-FGTPolicy | Where-Object {$_.name -eq $name}
    }

    End {
    }
}


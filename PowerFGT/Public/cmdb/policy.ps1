#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
# Copyright 2019, Benjamin Perrier <ben dot perrier at outlook dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

function Get-FGTPolicy {
    
  <#
      .SYNOPSIS
      Get list of all policies

      .DESCRIPTION
      Get list of all policies (name, source, destination...)

      .EXAMPLE
      Get-FGTPolicy

      Get list of all policies

      Get-FGTPolicy | select name, srcintf, dstintf, srcaddr, dstaddr, action, status, schedule, service, nat

      Get list of all policies with a selection of attributes

  #>


        $reponse = Invoke-FGTRestMethod -uri 'api/v2/cmdb/firewall/policy' -method 'GET'
        $reponse.results
   }



#Add-FGTPolicy -name "test_policy" -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all -action "accept" -status "enable" -schedule "always" -service ALL -nat "disable"




function Add-FGTPolicy {

    <#
        .SYNOPSIS
        Add a FortiGate Policy

        .DESCRIPTION
        Add a FortiGate Policy

        .EXAMPLE
        Add-FGTPolicy -name "test_policy" -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all -action "accept" -status "enable" -schedule "always" -service ALL -nat "disable"
        
        Add-FGTPolicy -name "test_policy" -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all -action "accept" -status "enable" -schedule "always" -service "HTTP, HTTPS, SSH" -nat "disable"
        MULTI SERVICE

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
        $countarr = $arr.count
        $line = 0
        while($line -ne $countarr){

            New-Variable -Name "srcintf_array$line" -Value $arr[$line]
            $temp = Get-Variable -Name "srcintf_array$line" -ValueOnly
            $temp = new-Object -TypeName PSObject
            $temp | add-member -name "name" -membertype NoteProperty -Value $arr[$line]
            [array]$srcintf_array_array += $temp
            $line = $line + 1

            }

# DESTINATION INTERFACE
        $arr = $dstintf -split ', '
        $countarr = $arr.count
        $line = 0
        while($line -ne $countarr){

            New-Variable -Name "dstintf_array$line" -Value $arr[$line]
            $temp = Get-Variable -Name "dstintf_array$line" -ValueOnly
            $temp = new-Object -TypeName PSObject
            $temp | add-member -name "name" -membertype NoteProperty -Value $arr[$line]
            [array]$dstintf_array_array += $temp
            $line = $line + 1

            }

# SOURCE ADDRESSE
        $arr = $srcaddr -split ', '
        $countarr = $arr.count
        $line = 0
        while($line -ne $countarr){

            New-Variable -Name "srcaddr_array$line" -Value $arr[$line]
            $temp = Get-Variable -Name "srcaddr_array$line" -ValueOnly
            $temp = new-Object -TypeName PSObject
            $temp | add-member -name "name" -membertype NoteProperty -Value $arr[$line]
            [array]$srcaddr_array_array += $temp
            $line = $line + 1

            }

# DESTINATION ADDRESSE
        $arr = $dstaddr -split ', '
        $countarr = $arr.count
        $line = 0
        while($line -ne $countarr){

            New-Variable -Name "dstaddr_array$line" -Value $arr[$line]
            $temp = Get-Variable -Name "dstaddr_array$line" -ValueOnly
            $temp = new-Object -TypeName PSObject
            $temp | add-member -name "name" -membertype NoteProperty -Value $arr[$line]
            [array]$dstaddr_array_array += $temp
            $line = $line + 1

            }

# SERVICE       
        $arr = $service -split ', '
        $countarr = $arr.count
        $line = 0
        while($line -ne $countarr){

            New-Variable -Name "service_array$line" -Value $arr[$line]
            $temp = Get-Variable -Name "service_array$line" -ValueOnly
            $temp = new-Object -TypeName PSObject
            $temp | add-member -name "name" -membertype NoteProperty -Value $arr[$line]
            [array]$service_array_array += $temp
            $line = $line + 1

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


function Remove-FGTPolicy {
    
  <#
      .SYNOPSIS
      Remove policy or policies

      .DESCRIPTION
      Remove a specific policy or any policies

      .EXAMPLE
      Remove-FGTPolicy -name my_policy
      Remove a policy with the name of the policy

      Remove-FGTPolicy -policyid 5
      Remove a policy with the policy id of the policy
      
      Remove-FGTPolicy -all
      Remove all policies, carefull when you use it.

      Remove-FGTPolicy -all -noConfirm
      Remove all policies with no confirmation, carefull when you use it.

  #>

  
    Param(



        [parameter(Mandatory=$true, ParameterSetName="name")]
        [String]$name,
        [parameter(Mandatory=$true, ParameterSetName="policyid")]
        [String]$policyid,
        [parameter(Mandatory=$true, ParameterSetName="all")]
        [switch]$all,
        [Parameter (Mandatory=$false)]
        [switch]$noConfirm


    )
        

if ($name) { 
           $policy = Get-FGTPolicy | Where-Object {$_.name -eq $name}
                if (!$policy) { 
                              Write-Host "$name policy does not exist"
                              break 
                              }
        
                $polid = $policy.policyid

                $uri = "api/v2/cmdb/firewall/policy/" + $polid
        

                Invoke-FGTRestMethod -method "DELETE" -uri $uri | out-Null
                Write-Host "$name has been deleted"
       
       
            }else{

                 if ($policyid) {   
                                $policy = Get-FGTPolicy | Where-Object {$_.policyid -eq $policyid}
                                if (!$policy) { 
                                                Write-Host "policy number $policyid does not exist"
                                                break 
                                              }
         
                                $uri = "api/v2/cmdb/firewall/policy/" + $policyid
        
                                Invoke-FGTRestMethod -method "DELETE" -uri $uri | out-Null
                                Write-Host "Policy $policyid has been deleted"
                                } else {
                                        if ($all -eq $True) {

                                             if ($noConfirm -eq $False) {  

                                                                    Write-Host "WARNING : all policies will be deleted" -ForegroundColor RED
                                                                    $continuekey = Read-Host "Press any key to continue"

                                                                    $uri = "api/v2/cmdb/firewall/policy/"
                                                                    Invoke-FGTRestMethod -method "DELETE" -uri $uri | out-Null
                                                                    Write-Host "all policies have been deleted"
                                                                    
                                                                        }else{

                                                                        
                                                                      
                                                                      
                                                                      
                                                                    $uri = "api/v2/cmdb/firewall/policy/"
                                                                    Invoke-FGTRestMethod -method "DELETE" -uri $uri | out-Null
                                                                    Write-Host "all policies have been deleted"  
                                                                        
                                                                        }
                                                            }

                                       }

                }
 
}

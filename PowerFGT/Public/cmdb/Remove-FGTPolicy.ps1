#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
# Copyright 2019, Benjamin Perrier <ben dot perrier at outlook dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

function Remove-FGTPolicy {
    
  <#
      .SYNOPSIS
      Remove policy or policies

      .DESCRIPTION
      Remove a specific policy or any policies

      .EXAMPLE
      Remove-FGTPolicy -name my_policy
      Remove a policy with the name of the policy

      .EXAMPLE
      Remove-FGTPolicy -policyid 5
      Remove a policy with the policy id of the policy
      
      .EXAMPLE
      Remove-FGTPolicy -all
      Remove all policies, carefull when you use it.

      .EXAMPLE
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

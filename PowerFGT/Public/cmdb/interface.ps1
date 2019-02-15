

function Get-FGTInterface {
    
  <#
      .SYNOPSIS
      Get list of all interfaces

      .DESCRIPTION
      Get list of all interface

      .EXAMPLE
      Get-FGTInterface

      Get list of all interface

  #>


        $reponse = Invoke-FGTRestMethod -uri 'api/v2/cmdb/system/interface' -method 'GET'
        $reponse.results
   }

   function Update-FGTInterface {

     <#
      .SYNOPSIS
      Update an interface

      .DESCRIPTION
      Update an interface

      .EXAMPLE
      Update-FGTInterface -name port3 -mode static -ip "192.168.1.25" -mask "255.255.255.0" -allowaccess "http https ssh ping" -alias "Ethernet3_VLAN1" -role lan
       
      Update the port3 interface

  #>

     Param(
        [Parameter (Mandatory=$true)]
        [string]$name,
        [Parameter (Mandatory=$false)]
        [ValidateSet("static","dhcp")] 
        [string]$mode,
        [Parameter (Mandatory=$false)]
        [string]$ip,
        [Parameter (Mandatory=$false)]
        [string]$mask,
        [Parameter (Mandatory=$false)]
        [string]$allowaccess,
        [Parameter (Mandatory=$false)]
        [string]$alias,
        [Parameter (Mandatory=$false)]
        [string]$role

    ) 

   $interface = @()
   $uri = "api/v2/cmdb/system/interface/" + $name
   $ipmask = $ip + " " + $mask

        $interface = new-Object -TypeName PSObject

        $interface| add-member -name "name" -membertype NoteProperty -Value $name
        $interface| add-member -name "mode" -membertype NoteProperty -Value $mode
        $interface | add-member -name "ip" -membertype NoteProperty -Value $ipmask
        $interface | add-member -name "allowaccess" -membertype NoteProperty -Value $allowaccess
        $interface | add-member -name "alias" -membertype NoteProperty -Value $alias
        $interface | add-member -name "role" -membertype NoteProperty -Value $role
        

        $interface

        Invoke-FGTRestMethod -method "PUT" -body $interface -uri $uri | out-Null
        
        }
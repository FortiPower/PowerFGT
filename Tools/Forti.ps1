
function Install-VMFortiGate {

    <#
        .SYNOPSIS
        Deploy a Fortigate VM

        .DESCRIPTION
        Deploy a Virtual Machine FortiGate on a vshpere environment with a lot of parameters like the choice of the cluster, the datastore, and the host. You can even preconfigure your VM with the network configuration, the hostname, and the dns.

        .EXAMPLE
        Install-VMFortiGate -ovf_path "C:\<forti_vapp.ovf>" -vmHost <name_of_your_host> -datastore <name_of_your_datastore> -cluster <name_of_your_cluster> -name_vm <name_of_your_virtual_machine> -InventoryLocation <yuor_folder> -hostname <hostname> -dns_primary <ip_of_DNS_1> -dns_secondary <ip_of_DNS_2> -network_mode [STATIC|DHCP] -ip <ip> -netmask <netmask> -gateway <gateway> -port_group <your_vswitch_port_group> -net_adpater [e1000|vmxnet3]
        This install your .ovf on your vsphere with the host, the datastore, the cluster, the folder to place it and the name of your vm. It also configure your vm with a hostname, an network configuration, the network adapter and the port group of your vswitch
    #>

    Param(
        [Parameter (Mandatory=$true, Position=1)]
        [string]$ovf_path,
        [Parameter (Mandatory=$true, Position=2)]
        [string]$vm_host,
        [Parameter (Mandatory=$true)]
        [string]$datastore,
        [Parameter (Mandatory=$true)]
        [string]$cluster,
        [Parameter (Mandatory=$true)]
        [string]$inventory,
        [Parameter (Mandatory=$true)]
        [string]$name_vm,
        [Parameter (Mandatory=$false)]
        [string]$hostname,
        [Parameter (Mandatory=$false)]
        [string]$dns_primary,
        [Parameter (Mandatory=$false)]
        [string]$dns_secondary,
        [Parameter (Mandatory=$false)]
        [ValidateSet ("Static", "DHCP")]
        [string]$network_mode,
        [Parameter (Mandatory=$false)]
        [string]$gateway,
        [Parameter (Mandatory=$false)]
        [string]$ip,
        [Parameter (Mandatory=$false)]
        [string]$netmask,
        [Parameter (Mandatory=$false)]
        [string]$port_group,
        [Parameter (Mandatory=$false)]
        [ValidateSet ("e1000", "vmxnet3")]
        [string]$net_adapter
    )

    Begin {
    }

    Process {

        Write-Warning "You need to have a vSwitch configured on your vSphere environment even if you use a DVS"

        if (-not (Get-Cluster -Name $cluster -ErrorAction "silentlycontinue"))
        {
            Throw "Cluster not found : $cluster"
        }

        if (-not (Get-VMHost -Name $vm_host -ErrorAction "silentlycontinue"))
        {
            Throw "Vm_Host not found : $vm_host"
        }

        if (-not (Get-Datastore -Name $datastore -ErrorAction "silentlycontinue"))
        {
            Throw "Datastore not found : $datastore"
        }
        
        if (-not (Get-Inventory -Name $inventory -ErrorAction "silentlycontinue"))
        {
            Throw "Inventory not found : $inventory"
        }

        $ovfConfig = Get-OvfConfiguration -Ovf $ovf_path

        if ( $PsBoundParameters.ContainsKey('hostname') )
        {
            $ovfConfig.Common.fgt_hostname.Value = $hostname
        }

        if ( $PsBoundParameters.ContainsKey('dns_primary') )
        {
            $ovfConfig.Common.primary_dns.Value = $dns_primary
        }

        if ( $PsBoundParameters.ContainsKey('dns_secondary') )
        {
            $ovfConfig.Common.secondary_dns.Value = $dns_secondary
        }

        if ( $PsBoundParameters.ContainsKey('network_mode') )
        {
            $ovfConfig.Common.intf0_mode.Value = $network_mode
        }

        if ( $PsBoundParameters.ContainsKey('gateway') )
        {
            $ovfConfig.Common.intf0_gateway.Value = $gateway
        }

        if ( $PsBoundParameters.ContainsKey('ip') )
        {
            $ovfConfig.Common.intf0_ip.Value = $ip
        }

        if ( $PsBoundParameters.ContainsKey('netmask') )
        {
            $ovfConfig.Common.intf0_netmask.Value = $netmask
        }

        if ( $PsBoundParameters.ContainsKey('net_adapter') )
        {
            $ovfConfig.DeploymentOption.Value = $net_adapter
        }

        if ( $PsBoundParameters.ContainsKey('port_group') )
        {
            $ovfConfig.NetworkMapping.Network_1.Value = $port_group
        }

        Import-VApp -Source $ovf_path -VMHost $vm_host -OvfConfiguration $ovfConfig -Datastore $datastore -Location $cluster -Name $name_vm -InventoryLocation $inventory

    }

    End {
    }
}

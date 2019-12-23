function Deploy-FGTVm {

    <#
        .SYNOPSIS
        Deploy a Fortigate VM

        .DESCRIPTION
        Deploy a Virtual Machine FortiGate on a vshpere environment with a lot of parameters like the choice of the cluster, the datastore, and the host. You can even preconfigure your VM with the network configuration, the hostname, and the dns.

        .EXAMPLE
        Deploy-FGTVm -ovf_path "C:\FortiGate-VM64.vapp.ovf" -vmHost "fortipowerfgt-01" -datastore "data_fortipowerfgt-01" -cluster "cluster_fortipowerfgt-01" -name_vm "Forti-VM" -InventoryLocation "Firewall" -hostname "powerfgt" -dns_primary 192.0.2.1 -dns_secondary 192.0.2.2 -int0_network_mode Static -int0_ip 192.0.2.10 -int0_netmask 255.255.255.0 -int0_gateway 192.0.2.254 -int0_port_group "powerfgt_vlan_mgmt" -net_adpater "vmxnet3"

        This install your .ovf on your vsphere with the host, the datastore, the cluster, the folder to place it and the name of your vm. It also configure your vm with a hostname, an network configuration, the network adapter and the port group of your vswitch

        .EXAMPLE
        $fortiBuildParams = @{
            ovf_path                    = "C:\FortiGate-VM64.vapp.ovf"
            vm_host                     = "fortipowerfgt-01"
            datastore                   = "data_fortipowerfgt-01"
            Cluster                     = "cluster_fortipowerfgt-01"
            inventory                   = "Firewall"
            name_vm                     = "Forti-VM"
            hostname                    = "powerfgt"
            dns_primary                 = "192.0.2.1"
            dns_secondary               = "192.0.2.2"
            int0_network_mode           = "Static"
            int0_gateway               	= "192.0.2.254"
            int0_ip                     = "192.0.2.10"
            int0_netmask                = "255.255.255.0"
            int0_port_group             = "powerfgt_vlan_01"
            net_adapter                 = "vmxnet3"
            int1_network_mode           = "Static"
            int1_ip                     = "192.0.2.11"
            int1_netmask                = "255.255.255.0"
            int1_port_group             = "powerfgt_vlan_02"
            int2_network_mode           = "Static"
            int2_ip                     = "192.0.2.12"
            int2_netmask                = "255.255.255.0"
            int2_port_group             = "powerfgt_vlan_03"
            int3_network_mode           = "Static"
            int3_ip                     = "192.0.2.13"
            int3_netmask                = "255.255.255.0"
            int3_port_group             = "powerfgt_vlan_04"
            int4_network_mode           = "Static"
            int4_ip                     = "192.0.2.14"
            int4_netmask                = "255.255.255.0"
            int4_port_group             = "powerfgt_vlan_05"
            int5_network_mode           = "Static"
            int5_ip                     = "192.0.2.15"
            int5_netmask                = "255.255.255.0"
            int5_port_group             = "powerfgt_vlan_06"
            int6_network_mode           = "Static"
            int6_ip                     = "192.0.2.16"
            int6_netmask                = "255.255.255.0"
            int6_port_group             = "powerfgt_vlan_07"
            int7_network_mode           = "Static"
            int7_ip                     = "192.0.2.17"
            int7_netmask                = "255.255.255.0"
            int7_port_group             = "powerfgt_vlan_08"
            int8_network_mode           = "Static"
            int8_ip                     = "192.0.2.18"
            int8_netmask                = "255.255.255.0"
            int8_port_group             = "powerfgt_vlan_09"
            int9_network_mode           = "Static"
            int9_ip                     = "192.0.2.19"
            int9_netmask                = "255.255.255.0"
            int9_port_group             = "powerfgt_vlan_10"
        } # end $fortiBuildParams

        PS>Deploy-FGTVm @fortiBuildParams

        Deploy FortiGate VM by pass array with settings.
    #>

    Param(
        [Parameter (Mandatory = $true, Position = 1)]
        [string]$ovf_path,
        [Parameter (Mandatory = $true, Position = 2)]
        [string]$vm_host,
        [Parameter (Mandatory = $true)]
        [string]$datastore,
        [Parameter (Mandatory = $true)]
        [string]$cluster,
        [Parameter (Mandatory = $false)]
        [string]$inventory,
        [Parameter (Mandatory = $true)]
        [string]$name_vm,
        [Parameter (Mandatory = $true)]
        [ValidateRange(31, 512)]
        [int]$capacityGB,
        [Parameter (Mandatory = $false)]
        [ValidateRange(2, 32)]
        [int]$memoryGB,
        [Parameter (Mandatory = $false)]
        [ValidateRange(2, 32)]
        [int]$cpu,
        [Parameter(Mandatory = $false)]
        [switch]$StartVM = $false,
        [Parameter (Mandatory = $false)]
        [string]$hostname,
        [Parameter (Mandatory = $false)]
        [string]$dns_primary,
        [Parameter (Mandatory = $false)]
        [string]$dns_secondary,
        [Parameter (Mandatory = $false)]
        [ValidateSet ("Static", "DHCP")]
        [string]$int0_network_mode,
        [Parameter (Mandatory = $false)]
        [string]$int0_gateway,
        [Parameter (Mandatory = $false)]
        [string]$int0_ip,
        [Parameter (Mandatory = $false)]
        [string]$int0_netmask,
        [Parameter (Mandatory = $false)]
        [string]$int0_port_group,
        [Parameter (Mandatory = $false)]
        [ValidateSet ("e1000", "vmxnet3")]
        [string]$net_adapter,
        [Parameter (Mandatory = $false)]
        [ValidateSet ("Static", "DHCP")]
        [string]$int1_network_mode,
        [Parameter (Mandatory = $false)]
        [string]$int1_ip,
        [Parameter (Mandatory = $false)]
        [string]$int1_netmask,
        [Parameter (Mandatory = $false)]
        [string]$int1_port_group,
        [Parameter (Mandatory = $false)]
        [ValidateSet ("Static", "DHCP")]
        [string]$int2_network_mode,
        [Parameter (Mandatory = $false)]
        [string]$int2_ip,
        [Parameter (Mandatory = $false)]
        [string]$int2_netmask,
        [Parameter (Mandatory = $false)]
        [string]$int2_port_group,
        [Parameter (Mandatory = $false)]
        [ValidateSet ("Static", "DHCP")]
        [string]$int3_network_mode,
        [Parameter (Mandatory = $false)]
        [string]$int3_ip,
        [Parameter (Mandatory = $false)]
        [string]$int3_netmask,
        [Parameter (Mandatory = $false)]
        [string]$int3_port_group,
        [Parameter (Mandatory = $false)]
        [ValidateSet ("Static", "DHCP")]
        [string]$int4_network_mode,
        [Parameter (Mandatory = $false)]
        [string]$int4_ip,
        [Parameter (Mandatory = $false)]
        [string]$int4_netmask,
        [Parameter (Mandatory = $false)]
        [string]$int4_port_group,
        [Parameter (Mandatory = $false)]
        [ValidateSet ("Static", "DHCP")]
        [string]$int5_network_mode,
        [Parameter (Mandatory = $false)]
        [string]$int5_ip,
        [Parameter (Mandatory = $false)]
        [string]$int5_netmask,
        [Parameter (Mandatory = $false)]
        [string]$int5_port_group,
        [Parameter (Mandatory = $false)]
        [ValidateSet ("Static", "DHCP")]
        [string]$int6_network_mode,
        [Parameter (Mandatory = $false)]
        [string]$int6_ip,
        [Parameter (Mandatory = $false)]
        [string]$int6_netmask,
        [Parameter (Mandatory = $false)]
        [string]$int6_port_group,
        [Parameter (Mandatory = $false)]
        [ValidateSet ("Static", "DHCP")]
        [string]$int7_network_mode,
        [Parameter (Mandatory = $false)]
        [string]$int7_ip,
        [Parameter (Mandatory = $false)]
        [string]$int7_netmask,
        [Parameter (Mandatory = $false)]
        [string]$int7_port_group,
        [Parameter (Mandatory = $false)]
        [ValidateSet ("Static", "DHCP")]
        [string]$int8_network_mode,
        [Parameter (Mandatory = $false)]
        [string]$int8_ip,
        [Parameter (Mandatory = $false)]
        [string]$int8_netmask,
        [Parameter (Mandatory = $false)]
        [string]$int8_port_group,
        [Parameter (Mandatory = $false)]
        [ValidateSet ("Static", "DHCP")]
        [string]$int9_network_mode,
        [Parameter (Mandatory = $false)]
        [string]$int9_ip,
        [Parameter (Mandatory = $false)]
        [string]$int9_netmask,
        [Parameter (Mandatory = $false)]
        [string]$int9_port_group
    )

    Begin {
    }

    Process {

        #Write-Warning "You need to have a vSwitch configured on your vSphere environment even if you use a DVS"
        #default vapp_config
        $vapp_config = @{
            "source" = $ovf_path
            "name"   = $name_vm
        }

        if (Get-VM $name_vm -ErrorAction "silentlyContinue") {
            Throw "VM $name_vm already exist, change name or remove VM"
        }

        if (-not (Get-Cluster -Name $cluster -ErrorAction "silentlycontinue")) {
            Throw "Cluster not found : $cluster"
        }
        else {
            $vapp_config.add("Location", $cluster)
        }

        if (-not (Get-VMHost -Name $vm_host -ErrorAction "silentlycontinue")) {
            Throw "Vm_Host not found : $vm_host"
        }
        else {
            $vapp_config.add("vmhost", $vm_host)
        }

        if (-not (Get-Datastore -Name $datastore -ErrorAction "silentlycontinue")) {
            Throw "Datastore not found : $datastore"
        }
        else {
            $vapp_config.add("datastore", $datastore)
        }

        if ( $PsBoundParameters.ContainsKey('inventory') ) {
            if (-not (Get-Inventory -Name $inventory -ErrorAction "silentlycontinue")) {
                Throw "Inventory not found : $inventory"
            }
            else {
                $vapp_config.add("inventory", $inventory)
            }
        }


        $ovfConfig = Get-OvfConfiguration -Ovf $ovf_path

        if ( $PsBoundParameters.ContainsKey('hostname') ) {
            $ovfConfig.Common.fgt_hostname.Value = $hostname
        }

        if ( $PsBoundParameters.ContainsKey('dns_primary') ) {
            $ovfConfig.Common.primary_dns.Value = $dns_primary
        }

        if ( $PsBoundParameters.ContainsKey('dns_secondary') ) {
            $ovfConfig.Common.secondary_dns.Value = $dns_secondary
        }

        if ( $PsBoundParameters.ContainsKey('int_0_network_mode') ) {
            $ovfConfig.Common.intf0_mode.Value = $int0_network_mode
        }

        if ( $PsBoundParameters.ContainsKey('int0_gateway') ) {
            $ovfConfig.Common.intf0_gateway.Value = $int0_gateway
        }

        if ( $PsBoundParameters.ContainsKey('int0_ip') ) {
            $ovfConfig.Common.intf0_ip.Value = $int0_ip
        }

        if ( $PsBoundParameters.ContainsKey('int0_netmask') ) {
            $ovfConfig.Common.intf0_netmask.Value = $int0_netmask
        }

        if ( $PsBoundParameters.ContainsKey('net_adapter') ) {
            $ovfConfig.DeploymentOption.Value = $net_adapter
        }

        if ( $PsBoundParameters.ContainsKey('int0_port_group') ) {
            $ovfConfig.NetworkMapping.Network_1.Value = $int0_port_group
        }

        if ( $PsBoundParameters.ContainsKey('int1_port_group') ) {
            $ovfConfig.NetworkMapping.Network_2.Value = $int1_port_group
        }

        if ( $PsBoundParameters.ContainsKey('int1_network_mode') ) {
            $ovfConfig.Common.intf1_mode.Value = $int1_network_mode
        }

        if ( $PsBoundParameters.ContainsKey('int1_ip') ) {
            $ovfConfig.Common.intf1_ip.Value = $int1_ip
        }

        if ( $PsBoundParameters.ContainsKey('int1_netmask') ) {
            $ovfConfig.Common.intf1_netmask.Value = $int1_netmask
        }

        if ( $PsBoundParameters.ContainsKey('int2_port_group') ) {
            $ovfConfig.NetworkMapping.Network_3.Value = $int2_port_group
        }

        if ( $PsBoundParameters.ContainsKey('int2_network_mode') ) {
            $ovfConfig.Common.intf2_mode.Value = $int2_network_mode
        }

        if ( $PsBoundParameters.ContainsKey('int2_ip') ) {
            $ovfConfig.Common.intf2_ip.Value = $int2_ip
        }

        if ( $PsBoundParameters.ContainsKey('int2_netmask') ) {
            $ovfConfig.Common.intf2_netmask.Value = $int2_netmask
        }

        if ( $PsBoundParameters.ContainsKey('int3_port_group') ) {
            $ovfConfig.NetworkMapping.Network_4.Value = $int3_port_group
        }

        if ( $PsBoundParameters.ContainsKey('int3_network_mode') ) {
            $ovfConfig.Common.intf3_mode.Value = $int3_network_mode
        }

        if ( $PsBoundParameters.ContainsKey('int3_ip') ) {
            $ovfConfig.Common.intf3_ip.Value = $int3_ip
        }

        if ( $PsBoundParameters.ContainsKey('int3_netmask') ) {
            $ovfConfig.Common.intf3_netmask.Value = $int3_netmask
        }

        if ( $PsBoundParameters.ContainsKey('int4_port_group') ) {
            $ovfConfig.NetworkMapping.Network_5.Value = $int4_port_group
        }

        if ( $PsBoundParameters.ContainsKey('int4_network_mode') ) {
            $ovfConfig.Common.intf4_mode.Value = $int4_network_mode
        }

        if ( $PsBoundParameters.ContainsKey('int4_ip') ) {
            $ovfConfig.Common.intf4_ip.Value = $int4_ip
        }

        if ( $PsBoundParameters.ContainsKey('int4_netmask') ) {
            $ovfConfig.Common.intf4_netmask.Value = $int4_netmask
        }

        if ( $PsBoundParameters.ContainsKey('int5_port_group') ) {
            $ovfConfig.NetworkMapping.Network_6.Value = $int5_port_group
        }

        if ( $PsBoundParameters.ContainsKey('int5_network_mode') ) {
            $ovfConfig.Common.intf5_mode.Value = $int5_network_mode
        }

        if ( $PsBoundParameters.ContainsKey('int5_ip') ) {
            $ovfConfig.Common.intf5_ip.Value = $int5_ip
        }

        if ( $PsBoundParameters.ContainsKey('int5_netmask') ) {
            $ovfConfig.Common.intf5_netmask.Value = $int5_netmask
        }

        if ( $PsBoundParameters.ContainsKey('int6_port_group') ) {
            $ovfConfig.NetworkMapping.Network_7.Value = $int6_port_group
        }

        if ( $PsBoundParameters.ContainsKey('int6_network_mode') ) {
            $ovfConfig.Common.intf6_mode.Value = $int6_network_mode
        }

        if ( $PsBoundParameters.ContainsKey('int6_ip') ) {
            $ovfConfig.Common.intf6_ip.Value = $int6_ip
        }

        if ( $PsBoundParameters.ContainsKey('int6_netmask') ) {
            $ovfConfig.Common.intf6_netmask.Value = $int6_netmask
        }

        if ( $PsBoundParameters.ContainsKey('int7_port_group') ) {
            $ovfConfig.NetworkMapping.Network_8.Value = $int7_port_group
        }

        if ( $PsBoundParameters.ContainsKey('int7_network_mode') ) {
            $ovfConfig.Common.intf7_mode.Value = $int7_network_mode
        }

        if ( $PsBoundParameters.ContainsKey('int7_ip') ) {
            $ovfConfig.Common.intf7_ip.Value = $int7_ip
        }

        if ( $PsBoundParameters.ContainsKey('int7_netmask') ) {
            $ovfConfig.Common.intf7_netmask.Value = $int7_netmask
        }

        if ( $PsBoundParameters.ContainsKey('int8_port_group') ) {
            $ovfConfig.NetworkMapping.Network_9.Value = $int8_port_group
        }

        if ( $PsBoundParameters.ContainsKey('int8_network_mode') ) {
            $ovfConfig.Common.intf8_mode.Value = $int8_network_mode
        }

        if ( $PsBoundParameters.ContainsKey('int8_ip') ) {
            $ovfConfig.Common.intf8_ip.Value = $int8_ip
        }

        if ( $PsBoundParameters.ContainsKey('int8_netmask') ) {
            $ovfConfig.Common.intf8_netmask.Value = $int8_netmask
        }

        if ( $PsBoundParameters.ContainsKey('int9_port_group') ) {
            $ovfConfig.NetworkMapping.Network_10.Value = $int9_port_group
        }

        if ( $PsBoundParameters.ContainsKey('int9_network_mode') ) {
            $ovfConfig.Common.intf9_mode.Value = $int9_network_mode
        }

        if ( $PsBoundParameters.ContainsKey('int9_ip') ) {
            $ovfConfig.Common.intf9_ip.Value = $int9_ip
        }

        if ( $PsBoundParameters.ContainsKey('int9_netmask') ) {
            $ovfConfig.Common.intf9_netmask.Value = $int9_netmask
        }

        Import-VApp @vapp_config -OvfConfiguration $ovfConfig

        if ( $PsBoundParameters.ContainsKey('MemoryGB') ) {
            Get-VM $name_vm | Set-VM -MemoryGB $MemoryGB -confirm:$false | Out-Null
        }

        if ( $PsBoundParameters.ContainsKey('CPU') ) {
            Get-VM $name_vm | Set-VM -NumCPU $cpu -confirm:$false | Out-Null
        }

        if ( $PsBoundParameters.ContainsKey('CapacityGB') ) {
            (Get-VM $name_vm | Get-HardDisk)[1] | Set-Harddisk -CapacityGB $CapacityGB -confirm:$false | Out-Null
        }

        if ( $StartVM ) {
            Write-Progress -Activity "Starting CPPM $name_vm"
            Get-VM $name_vm | Start-VM | Out-Null
            Write-Progress -Activity "Starting CPPM $name_vm" -Completed
        }

    }

    End {
    }
}
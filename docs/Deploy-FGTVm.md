---
external help file: PowerFGT-help.xml
Module Name: PowerFGT
online version:
schema: 2.0.0
---

# Deploy-FGTVm

## SYNOPSIS
Deploy a Fortigate VM

## SYNTAX

```
Deploy-FGTVm [-ovf_path] <String> [-vm_host] <String> -datastore <String> -cluster <String>
 [-inventory <String>] -name_vm <String> [-capacityGB <Int32>] [-memoryGB <Int32>] [-cpu <Int32>] [-StartVM]
 [-hostname <String>] [-dns_primary <String>] [-dns_secondary <String>] [-int0_network_mode <String>]
 [-int0_gateway <String>] [-int0_ip <String>] [-int0_netmask <String>] [-int0_port_group <String>]
 [-net_adapter <String>] [-int1_network_mode <String>] [-int1_ip <String>] [-int1_netmask <String>]
 [-int1_port_group <String>] [-int2_network_mode <String>] [-int2_ip <String>] [-int2_netmask <String>]
 [-int2_port_group <String>] [-int3_network_mode <String>] [-int3_ip <String>] [-int3_netmask <String>]
 [-int3_port_group <String>] [-int4_network_mode <String>] [-int4_ip <String>] [-int4_netmask <String>]
 [-int4_port_group <String>] [-int5_network_mode <String>] [-int5_ip <String>] [-int5_netmask <String>]
 [-int5_port_group <String>] [-int6_network_mode <String>] [-int6_ip <String>] [-int6_netmask <String>]
 [-int6_port_group <String>] [-int7_network_mode <String>] [-int7_ip <String>] [-int7_netmask <String>]
 [-int7_port_group <String>] [-int8_network_mode <String>] [-int8_ip <String>] [-int8_netmask <String>]
 [-int8_port_group <String>] [-int9_network_mode <String>] [-int9_ip <String>] [-int9_netmask <String>]
 [-int9_port_group <String>] [<CommonParameters>]
```

## DESCRIPTION
Deploy a Virtual Machine FortiGate on a vshpere environment with a lot of parameters like the choice of the cluster, the datastore, and the host.
You can even preconfigure your VM with the network configuration, the hostname, and the dns.

## EXAMPLES

### EXAMPLE 1
```
Deploy-FGTVm -ovf_path "C:\FortiGate-VM64.vapp.ovf" -vm_Host "fortipowerfgt-01" -datastore "data_fortipowerfgt-01" -cluster "cluster_fortipowerfgt-01" -name_vm "Forti-VM" -Inventory "Firewall" -hostname "powerfgt" -dns_primary 192.0.2.1 -dns_secondary 192.0.2.2 -int0_network_mode Static -int0_ip 192.0.2.10 -int0_netmask 255.255.255.0 -int0_gateway 192.0.2.254 -int0_port_group "powerfgt_vlan_mgmt" -net_adapter "vmxnet3"
```

This install your .ovf on your vsphere with the host, the datastore, the cluster, the folder to place it and the name of your vm.
It also configure your vm with a hostname, an network configuration, the network adapter and the port group of your vswitch

### EXAMPLE 2
```
$fortiBuildParams = @{
```

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

PS\>Deploy-FGTVm @fortiBuildParams

Deploy FortiGate VM by pass array with settings.

## PARAMETERS

### -ovf_path
{{ Fill ovf_path Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -vm_host
{{ Fill vm_host Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -datastore
{{ Fill datastore Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -cluster
{{ Fill cluster Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -inventory
{{ Fill inventory Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -name_vm
{{ Fill name_vm Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -capacityGB
{{ Fill capacityGB Description }}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -memoryGB
{{ Fill memoryGB Description }}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -cpu
{{ Fill cpu Description }}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -StartVM
{{ Fill StartVM Description }}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -hostname
{{ Fill hostname Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -dns_primary
{{ Fill dns_primary Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -dns_secondary
{{ Fill dns_secondary Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -int0_network_mode
{{ Fill int0_network_mode Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -int0_gateway
{{ Fill int0_gateway Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -int0_ip
{{ Fill int0_ip Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -int0_netmask
{{ Fill int0_netmask Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -int0_port_group
{{ Fill int0_port_group Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -net_adapter
{{ Fill net_adapter Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -int1_network_mode
{{ Fill int1_network_mode Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -int1_ip
{{ Fill int1_ip Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -int1_netmask
{{ Fill int1_netmask Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -int1_port_group
{{ Fill int1_port_group Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -int2_network_mode
{{ Fill int2_network_mode Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -int2_ip
{{ Fill int2_ip Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -int2_netmask
{{ Fill int2_netmask Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -int2_port_group
{{ Fill int2_port_group Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -int3_network_mode
{{ Fill int3_network_mode Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -int3_ip
{{ Fill int3_ip Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -int3_netmask
{{ Fill int3_netmask Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -int3_port_group
{{ Fill int3_port_group Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -int4_network_mode
{{ Fill int4_network_mode Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -int4_ip
{{ Fill int4_ip Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -int4_netmask
{{ Fill int4_netmask Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -int4_port_group
{{ Fill int4_port_group Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -int5_network_mode
{{ Fill int5_network_mode Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -int5_ip
{{ Fill int5_ip Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -int5_netmask
{{ Fill int5_netmask Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -int5_port_group
{{ Fill int5_port_group Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -int6_network_mode
{{ Fill int6_network_mode Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -int6_ip
{{ Fill int6_ip Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -int6_netmask
{{ Fill int6_netmask Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -int6_port_group
{{ Fill int6_port_group Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -int7_network_mode
{{ Fill int7_network_mode Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -int7_ip
{{ Fill int7_ip Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -int7_netmask
{{ Fill int7_netmask Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -int7_port_group
{{ Fill int7_port_group Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -int8_network_mode
{{ Fill int8_network_mode Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -int8_ip
{{ Fill int8_ip Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -int8_netmask
{{ Fill int8_netmask Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -int8_port_group
{{ Fill int8_port_group Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -int9_network_mode
{{ Fill int9_network_mode Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -int9_ip
{{ Fill int9_ip Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -int9_netmask
{{ Fill int9_netmask Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -int9_port_group
{{ Fill int9_port_group Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

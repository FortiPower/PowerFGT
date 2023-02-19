---
external help file: PowerFGT-help.xml
Module Name: PowerFGT
online version:
schema: 2.0.0
---

# Add-FGTVpnIpsecPhase1Interface

## SYNOPSIS
Add a Vpn IPsec Phase 1 Interface

## SYNTAX

```
Add-FGTVpnIpsecPhase1Interface [-name] <String> -type <String> -interface <String> [-ikeversion <String>]
 [-proposal <String[]>] [-dhgrp <Int32[]>] -psksecret <String> [-remotegw <String>] [-peertype <String>]
 [-netdevice] [-addroute] [-autodiscoverysender] [-autodiscoveryreceiver] [-exchangeinterfaceip]
 [-networkid <Int32>] [-dpd <String>] [-dpdretrycount <Int32>] [-dpdretryinterval <Int32>] [-idletimeout]
 [-data <Hashtable>] [-vdom <String[]>] [-connection <PSObject>] [<CommonParameters>]
```

## DESCRIPTION
Add a Vpn IPsec Phase 1 Interface (Version, type, interface, proposal, psksecret...
)

## EXAMPLES

### EXAMPLE 1
```
Add-FGTVpnIpsecPhase1Interface -name PowerFGT_VPN -type static -interface port2 -psksecret MySecret -remotegw 192.0.2.1
```

Create a static VPN IPsec Phase 1 Interface named PowerFGT_VPN with interface port2 with Remote Gateway 192.0.2.1

### EXAMPLE 2
```
Add-FGTVpnIpsecPhase1Interface -name PowerFGT_VPN -type dynamic -interface port2 -proposal aes256-sha256, aes256-sha512 -dhgrp 14,15 -psksecret MySecret
```

Create a dynamic VPN IPsec Phase 1 Interface named PowerFGT_VPN with interface port2, multiple proposal aes256-sha256, aes256-sha512 and DH Group 14 & 15

### EXAMPLE 3
```
$data = @{ "fragmentation" = "disable" ; "npu-offload" = "disable" }
PS C> Add-FGTVpnIpsecPhase1Interface -name PowerFGT_VPN -type static -interface port2 -psksecret MySecret -remotegw 192.0.2.1 -data $data
```

Create a dynamic VPN IPsec Phase 1 Interface named PowerFGT_VPN with fragmentation and npu-offload using -data parameter

## PARAMETERS

### -name
{{ Fill name Description }}

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

### -type
{{ Fill type Description }}

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

### -interface
{{ Fill interface Description }}

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

### -ikeversion
{{ Fill ikeversion Description }}

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

### -proposal
{{ Fill proposal Description }}

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -dhgrp
{{ Fill dhgrp Description }}

```yaml
Type: Int32[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -psksecret
{{ Fill psksecret Description }}

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

### -remotegw
{{ Fill remotegw Description }}

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

### -peertype
{{ Fill peertype Description }}

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

### -netdevice
{{ Fill netdevice Description }}

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

### -addroute
{{ Fill addroute Description }}

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

### -autodiscoverysender
{{ Fill autodiscoverysender Description }}

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

### -autodiscoveryreceiver
{{ Fill autodiscoveryreceiver Description }}

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

### -exchangeinterfaceip
{{ Fill exchangeinterfaceip Description }}

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

### -networkid
{{ Fill networkid Description }}

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

### -dpd
{{ Fill dpd Description }}

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

### -dpdretrycount
{{ Fill dpdretrycount Description }}

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

### -dpdretryinterval
{{ Fill dpdretryinterval Description }}

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

### -idletimeout
{{ Fill idletimeout Description }}

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

### -data
{{ Fill data Description }}

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -vdom
{{ Fill vdom Description }}

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -connection
{{ Fill connection Description }}

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: $DefaultFGTConnection
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

---
external help file: PowerFGT-help.xml
Module Name: PowerFGT
online version:
schema: 2.0.0
---

# Set-FGTVpnIpsecPhase1Interface

## SYNOPSIS
Configure a Vpn IPsec Phase 1 Interface

## SYNTAX

```
Set-FGTVpnIpsecPhase1Interface [-vpn] <PSObject> [-type <String>] [-ikeversion <String>] [-proposal <String[]>]
 [-dhgrp <Int32[]>] [-psksecret <String>] [-remotegw <String>] [-peertype <String>] [-netdevice] [-addroute]
 [-autodiscoverysender] [-autodiscoveryreceiver] [-exchangeinterfaceip] [-networkid <Int32>] [-dpd <String>]
 [-dpdretrycount <Int32>] [-dpdretryinterval <Int32>] [-idletimeout] [-data <Hashtable>] [-vdom <String[]>]
 [-connection <PSObject>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Configure a Vpn IPsec Phase 1 Interface (Version, type, interface, proposal, psksecret...
)

## EXAMPLES

### EXAMPLE 1
```
Get-FGTVpnIpsecPhase1Interface PowerFGT_VPN | Set-FGTVpnIpsecPhase1Interface -psksecret MySecret
```

Change psksecret of VPN IPsec Phase1 Interface PowerFGT_VPN

### EXAMPLE 2
```
Get-FGTVpnIpsecPhase1Interface PowerFGT_VPN | Set-FGTVpnIpsecPhase1Interface -proposal aes256-sha256, aes256-sha512 -dhgrp 14,1
```

Change proposal and dhgrp (multiple value) of VPN IPsec Phase1 Interface PowerFGT_VP

### EXAMPLE 3
```
$data = @{ "fragmentation" = "disable" ; "npu-offload" = "disable" }
PS C> Get-FGTVpnIpsecPhase1Interface PowerFGT_VPN | Set-FGTVpnIpsecPhase1Interface -data $data
```

Change  fragmentation and npu-offload using of VPN IPsec Phase1 Interface PowerFGT_VPN using -data parameter

## PARAMETERS

### -vpn
{{ Fill vpn Description }}

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -type
{{ Fill type Description }}

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

Required: False
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

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

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

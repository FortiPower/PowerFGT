---
external help file: PowerFGT-help.xml
Module Name: PowerFGT
online version:
schema: 2.0.0
---

# Set-FGTVpnIpsecPhase2Interface

## SYNOPSIS
Configure a Vpn IPsec Phase 2 Interface

## SYNTAX

```
Set-FGTVpnIpsecPhase2Interface [-vpn] <PSObject> [-proposal <String[]>] [-pfs] [-dhgrp <Int32[]>] [-replay]
 [-keepalive] [-autonegotiate] [-keylifeseconds <Int32>] [-comments <String>] [-srcname <String>]
 [-dstname <String>] [-srcip <String>] [-srcnetmask <String>] [-srcrange <String>] [-dstip <String>]
 [-dstnetmask <String>] [-dstrange <String>] [-data <Hashtable>] [-vdom <String[]>] [-connection <PSObject>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Configure a Vpn IPsec Phase 2 Interface (proposal, dhgrp, source, destination )

## EXAMPLES

### EXAMPLE 1
```
Get-FGTVpnIpsecPhase2Interface -name ph2_PowerFGT_VPN | Set-FGTVpnIpsecPhase2Interface -dhgrp 14 -proposal aes256-sha256
```

Change dhgrp and proposal of VPN IPsec Phase 2 Interface ph2_PowerFGT_VPN

### EXAMPLE 2
```
Get-FGTVpnIpsecPhase1Interface -name PowerFGT_VPN | Set-FGTVpnIpsecPhase2Interface -srcname VPN_LOCAL2
```

Change source object name (VPN_LOCAL2) of VPN IPsec Phase 2 Interface ph2_PowerFGT_VPN

### EXAMPLE 3
```
Get-FGTVpnIpsecPhase1Interface -name PowerFGT_VPN | Set-FGTVpnIpsecPhase2Interface -dstip 198.51.100.0 -dstnetmask 255.255.255.0
```

Change destination IP (198.51.100.0/24) of VPN IPsec Phase 2 Interface ph2_PowerFGT_VPN

### EXAMPLE 4
```
$data = @{ "protocol" = "23" ; "encapsulation" = "transport-mode" }
PS C> Get-FGTVpnIpsecPhase1Interface -name PowerFGT_VPN | Set-FGTVpnIpsecPhase2Interface -name ph2_PowerFGT_VPN -data $data
```

Change protocol and encapsulation using -data parameter of VPN IPsec Phase 2 Interface ph2_PowerFGT_VPN

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

### -pfs
{{ Fill pfs Description }}

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

### -replay
{{ Fill replay Description }}

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

### -keepalive
{{ Fill keepalive Description }}

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

### -autonegotiate
{{ Fill autonegotiate Description }}

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

### -keylifeseconds
{{ Fill keylifeseconds Description }}

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

### -comments
{{ Fill comments Description }}

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

### -srcname
{{ Fill srcname Description }}

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

### -dstname
{{ Fill dstname Description }}

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

### -srcip
{{ Fill srcip Description }}

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

### -srcnetmask
{{ Fill srcnetmask Description }}

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

### -srcrange
{{ Fill srcrange Description }}

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

### -dstip
{{ Fill dstip Description }}

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

### -dstnetmask
{{ Fill dstnetmask Description }}

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

### -dstrange
{{ Fill dstrange Description }}

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

### -ProgressAction
{{ Fill ProgressAction Description }}

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

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

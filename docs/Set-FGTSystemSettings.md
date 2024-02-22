---
external help file: PowerFGT-help.xml
Module Name: PowerFGT
online version:
schema: 2.0.0
---

# Set-FGTSystemSettings

## SYNOPSIS
Configure a FortiGate System Settings

## SYNTAX

```
Set-FGTSystemSettings [-allow_subnet_overlap] [-central_nat] [[-inspection_mode] <String>]
 [-gui_allow_unnamed_policy] [-gui_dns_database] [-gui_dynamic_routing] [-gui_explicit_proxy] [-gui_ips]
 [-gui_load_balance] [-gui_local_in_policy] [-gui_proxy_inspection] [-gui_multiple_interface_policy]
 [-gui_multiple_utm_profiles] [-gui_spamfilter] [-gui_sslvpn] [-gui_sslvpn_personal_bookmarks]
 [-gui_sslvpn_realms] [-gui_voip_profile] [-gui_waf_profile] [-gui_ztna] [[-lldp_transmission] <String>]
 [[-lldp_reception] <String>] [[-data] <Hashtable>] [[-vdom] <String[]>] [[-connection] <PSObject>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Change a FortiGate System Settings (lldp, gui....)

## EXAMPLES

### EXAMPLE 1
```
Set-FGTSystemSettings -gui_allow_unnamed_policy
```

Enable unnamed Policy

### EXAMPLE 2
```
$data = @{ "ike-port" = 1500 }
PS C> Set-FGTSystemSettings -data $data
```

Change ike-port settings using -data parameter (ike-port is available on parameter)

### EXAMPLE 3
```
$data = @{ "ike-port" = 1500 ; "ike-policy-route" = "enable"}
PS C> Set-FGTSystemSettings -data $data
```

Change ike-port and ike-policy-route settings using -data parameter

## PARAMETERS

### -allow_subnet_overlap
{{ Fill allow_subnet_overlap Description }}

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

### -central_nat
{{ Fill central_nat Description }}

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

### -inspection_mode
{{ Fill inspection_mode Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -gui_allow_unnamed_policy
{{ Fill gui_allow_unnamed_policy Description }}

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

### -gui_dns_database
{{ Fill gui_dns_database Description }}

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

### -gui_dynamic_routing
{{ Fill gui_dynamic_routing Description }}

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

### -gui_explicit_proxy
{{ Fill gui_explicit_proxy Description }}

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

### -gui_ips
{{ Fill gui_ips Description }}

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

### -gui_load_balance
{{ Fill gui_load_balance Description }}

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

### -gui_local_in_policy
{{ Fill gui_local_in_policy Description }}

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

### -gui_proxy_inspection
{{ Fill gui_proxy_inspection Description }}

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

### -gui_multiple_interface_policy
{{ Fill gui_multiple_interface_policy Description }}

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

### -gui_multiple_utm_profiles
{{ Fill gui_multiple_utm_profiles Description }}

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

### -gui_spamfilter
{{ Fill gui_spamfilter Description }}

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

### -gui_sslvpn
{{ Fill gui_sslvpn Description }}

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

### -gui_sslvpn_personal_bookmarks
{{ Fill gui_sslvpn_personal_bookmarks Description }}

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

### -gui_sslvpn_realms
{{ Fill gui_sslvpn_realms Description }}

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

### -gui_voip_profile
{{ Fill gui_voip_profile Description }}

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

### -gui_waf_profile
{{ Fill gui_waf_profile Description }}

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

### -gui_ztna
{{ Fill gui_ztna Description }}

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

### -lldp_transmission
{{ Fill lldp_transmission Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -lldp_reception
{{ Fill lldp_reception Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
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
Position: 4
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
Position: 5
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
Position: 6
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

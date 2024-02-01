---
external help file: PowerFGT-help.xml
Module Name: PowerFGT
online version:
schema: 2.0.0
---

# Get-FGTFirewallProxyPolicy

## SYNOPSIS
Get list of all Proxy Policies/rules

## SYNTAX

### default (Default)
```
Get-FGTFirewallProxyPolicy [-meta] [-skip] [-vdom <String[]>] [-connection <PSObject>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### uuid
```
Get-FGTFirewallProxyPolicy [-uuid <String>] [-filter_type <String>] [-meta] [-skip] [-vdom <String[]>]
 [-connection <PSObject>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### policyid
```
Get-FGTFirewallProxyPolicy [-policyid <String>] [-filter_type <String>] [-meta] [-skip] [-vdom <String[]>]
 [-connection <PSObject>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### filter_build
```
Get-FGTFirewallProxyPolicy [-filter_attribute <String>] [-filter_type <String>] [-filter_value <PSObject>]
 [-meta] [-skip] [-vdom <String[]>] [-connection <PSObject>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Get list of all Proxy Policies (source address, destination address, service, action, status...)

## EXAMPLES

### EXAMPLE 1
```
Get-FGTFirewallProxyPolicy
```

Get list of all Proxy policies

### EXAMPLE 2
```
Get-FGTFirewallProxyPolicy -policyid 23
```

Get Proxy policy with id 23

### EXAMPLE 3
```
Get-FGTFirewallProxyPolicy -uuid 9e73a10e-1772-51ea-a8d7-297686fd7702
```

Get Proxy policy with uuid 9e73a10e-1772-51ea-a8d7-297686fd7702

### EXAMPLE 4
```
Get-FGTFirewallProxyPolicy -meta
```

Get list of all Proxy Policies object with metadata (q_...) like usage (q_ref)

### EXAMPLE 5
```
Get-FGTFirewallProxyPolicy -skip
```

Get list of all Proxy policies (but only relevant attributes)

### EXAMPLE 6
```
Get-FGTFirewallPolicy -vdom vdomX
```

Get list of all Proxy policies on vdomX

## PARAMETERS

### -uuid
{{ Fill uuid Description }}

```yaml
Type: String
Parameter Sets: uuid
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -policyid
{{ Fill policyid Description }}

```yaml
Type: String
Parameter Sets: policyid
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -filter_attribute
{{ Fill filter_attribute Description }}

```yaml
Type: String
Parameter Sets: filter_build
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -filter_type
{{ Fill filter_type Description }}

```yaml
Type: String
Parameter Sets: uuid, policyid, filter_build
Aliases:

Required: False
Position: Named
Default value: Equal
Accept pipeline input: False
Accept wildcard characters: False
```

### -filter_value
{{ Fill filter_value Description }}

```yaml
Type: PSObject
Parameter Sets: filter_build
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -meta
{{ Fill meta Description }}

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

### -skip
Ignores the specified number of objects and then gets the remaining objects.
Enter the number of objects to skip.

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

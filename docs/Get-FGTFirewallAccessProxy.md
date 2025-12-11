---
external help file: PowerFGT-help.xml
Module Name: PowerFGT
online version:
schema: 2.0.0
---

# Get-FGTFirewallAccessProxy

## SYNOPSIS
Get list of all (ZTNA) Access Proxy

## SYNTAX

### default (Default)
```
Get-FGTFirewallAccessProxy [-filter_attribute <String>] [-filter_type <String>] [-filter_value <PSObject>]
 [-meta] [-skip] [-vdom <String[]>] [-connection <PSObject>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### name
```
Get-FGTFirewallAccessProxy [[-name] <String>] [-filter_attribute <String>] [-filter_type <String>]
 [-filter_value <PSObject>] [-meta] [-skip] [-vdom <String[]>] [-connection <PSObject>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### filter
```
Get-FGTFirewallAccessProxy [-filter_attribute <String>] [-filter_type <String>] [-filter_value <PSObject>]
 [-meta] [-skip] [-vdom <String[]>] [-connection <PSObject>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### schema
```
Get-FGTFirewallAccessProxy [-filter_attribute <String>] [-filter_type <String>] [-filter_value <PSObject>]
 [-schema] [-meta] [-skip] [-vdom <String[]>] [-connection <PSObject>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Get list of all (ZTNA) Access Proxy (vip, auth-portal, api-gateway...)

## EXAMPLES

### EXAMPLE 1
```
Get-FGTFirewallAccessProxy
```

Get list of all Access Proxy object

### EXAMPLE 2
```
Get-FGTFirewallAccessProxy -name myAccessProxy
```

Get Access Proxy named myAccessProxy

### EXAMPLE 3
```
Get-FGTFirewallAccessProxy -name FGT -filter_type contains
```

Get Access Proxy contains with *FGT*

### EXAMPLE 4
```
Get-FGTFirewallAccessProxy -schema
```

Get (API) schema of Access Proxy object

### EXAMPLE 5
```
Get-FGTFirewallAccessProxy -meta
```

Get list of all Access Proxy object with metadata (q_...) like usage (q_ref)

### EXAMPLE 6
```
Get-FGTFirewallAccessProxy -skip
```

Get list of all Access Proxy  object (but only relevant attributes)

### EXAMPLE 7
```
Get-FGTFirewallAccessProxy -vdom vdomX
```

Get list of all Access Proxy object on vdomX

## PARAMETERS

### -name
{{ Fill name Description }}

```yaml
Type: String
Parameter Sets: name
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -filter_attribute
{{ Fill filter_attribute Description }}

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

### -filter_type
{{ Fill filter_type Description }}

```yaml
Type: String
Parameter Sets: (All)
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
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -schema
{{ Fill schema Description }}

```yaml
Type: SwitchParameter
Parameter Sets: schema
Aliases:

Required: False
Position: Named
Default value: False
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

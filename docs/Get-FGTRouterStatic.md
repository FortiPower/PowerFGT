---
external help file: PowerFGT-help.xml
Module Name: PowerFGT
online version:
schema: 2.0.0
---

# Get-FGTRouterStatic

## SYNOPSIS
Get list of all "static routes"

## SYNTAX

### default (Default)
```
Get-FGTRouterStatic [-filter_attribute <String>] [-filter_type <String>] [-filter_value <PSObject>] [-skip]
 [-vdom <String[]>] [-connection <PSObject>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### device
```
Get-FGTRouterStatic [-device <String>] [-filter_attribute <String>] [-filter_type <String>]
 [-filter_value <PSObject>] [-skip] [-vdom <String[]>] [-connection <PSObject>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### dst
```
Get-FGTRouterStatic [-dst <String>] [-filter_attribute <String>] [-filter_type <String>]
 [-filter_value <PSObject>] [-skip] [-vdom <String[]>] [-connection <PSObject>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### gateway
```
Get-FGTRouterStatic [-gateway <String>] [-filter_attribute <String>] [-filter_type <String>]
 [-filter_value <PSObject>] [-skip] [-vdom <String[]>] [-connection <PSObject>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### seq_num
```
Get-FGTRouterStatic [-seq_num <Int32>] [-filter_attribute <String>] [-filter_type <String>]
 [-filter_value <PSObject>] [-skip] [-vdom <String[]>] [-connection <PSObject>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### filter
```
Get-FGTRouterStatic [-filter_attribute <String>] [-filter_type <String>] [-filter_value <PSObject>] [-skip]
 [-vdom <String[]>] [-connection <PSObject>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Get list of all "static routes" (destination network, gateway, port, distance, weight...)

## EXAMPLES

### EXAMPLE 1
```
Get-FGTRouterStatic
```

Get list of all static route object

### EXAMPLE 2
```
Get-FGTRouterStatic -device port2
```

Get static route object with device equal port2

### EXAMPLE 3
```
Get-FGTRouterStatic -dst "198.51.100.0 255.255.255.0"
```

Get static route object with dst (destination) equal 198.51.100.0 255.255.255.0

### EXAMPLE 4
```
Get-FGTRouterStatic -gateway 198.51.100.254
```

Get static route object with gateway equal 198.51.100.254

### EXAMPLE 5
```
Get-FGTRouterStatic -seq_num 10
```

Get static route object with seq-num equal 10

### EXAMPLE 6
```
Get-FGTRouterStatic -filter_attribute gateway -filter_value 192.0.2.1
```

Get static route object with gateway equal 192.0.2.1

### EXAMPLE 7
```
Get-FGTRouterStatic -filter_attribute device -filter_value port -filter_type contains
```

Get static route object with device contains port

### EXAMPLE 8
```
Get-FGTRouterStatic -skip
```

Get list of all static route object (but only relevant attributes)

### EXAMPLE 9
```
Get-FGTRouterStatic -vdom vdomX
```

Get list of all static route object on vdomX

## PARAMETERS

### -device
{{ Fill device Description }}

```yaml
Type: String
Parameter Sets: device
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -dst
{{ Fill dst Description }}

```yaml
Type: String
Parameter Sets: dst
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -gateway
{{ Fill gateway Description }}

```yaml
Type: String
Parameter Sets: gateway
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -seq_num
{{ Fill seq_num Description }}

```yaml
Type: Int32
Parameter Sets: seq_num
Aliases:

Required: False
Position: Named
Default value: 0
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

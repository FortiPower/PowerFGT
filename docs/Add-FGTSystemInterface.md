---
external help file: PowerFGT-help.xml
Module Name: PowerFGT
online version:
schema: 2.0.0
---

# Add-FGTSystemInterface

## SYNOPSIS
Add an interface

## SYNTAX

### vlan
```
Add-FGTSystemInterface [-name] <String> [-alias <String>] [-role <String>] -vlan_id <Int32> -interface <String>
 [-allowaccess <String[]>] [-status <String>] [-device_identification <String>] [-mode <String>] [-ip <String>]
 [-netmask <String>] [-vdom_interface <String>] [-vdom <String[]>] [-connection <PSObject>]
 [<CommonParameters>]
```

### aggregate
```
Add-FGTSystemInterface [-name] <String> [-alias <String>] [-role <String>] -member <String[]> -atype <String>
 [-allowaccess <String[]>] [-status <String>] [-device_identification <String>] [-mode <String>] [-ip <String>]
 [-netmask <String>] [-vdom_interface <String>] [-vdom <String[]>] [-connection <PSObject>]
 [<CommonParameters>]
```

## DESCRIPTION
Add an interface (Type, Role, Vlan, Address IP...
)

## EXAMPLES

### EXAMPLE 1
```
Add-FGTSystemInterface -name PowerFGT -interface port10 -vlan_id 10
```

This creates a new interface using only mandatory parameters.

### EXAMPLE 2
```
Add-FGTSystemInterface -name PowerFGT_lacp -atype lacp -member port9, port10
```

This creates a new interface LACP (aggregate) with port9 and port 10

### EXAMPLE 3
```
Add-FGTSystemInterface -name PowerFGT_static -atype static -member port9, port10
```

This creates a new interface Redundant (static) with port9 and port 10

### EXAMPLE 4
```
Add-FGTSystemInterface -name PowerFGT -alias Alias_PowerFGT -role lan -vlan_id 10 -interface port10 -allowaccess https,ping,ssh -status up -device_identification $true -mode static -ip 192.0.2.1 -netmask 255.255.255.0 -vdom_interface root
```

Create an interface named PowerFGT with alias Alias_PowerFGT, role lan with vlan id 10 on interface port10.
Administrative access by https and ssh, ping authorize on ip 192.0.2.1 and state connected.

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

### -alias
{{ Fill alias Description }}

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

### -role
{{ Fill role Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Lan
Accept pipeline input: False
Accept wildcard characters: False
```

### -vlan_id
{{ Fill vlan_id Description }}

```yaml
Type: Int32
Parameter Sets: vlan
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -interface
{{ Fill interface Description }}

```yaml
Type: String
Parameter Sets: vlan
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -member
{{ Fill member Description }}

```yaml
Type: String[]
Parameter Sets: aggregate
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -atype
{{ Fill atype Description }}

```yaml
Type: String
Parameter Sets: aggregate
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -allowaccess
{{ Fill allowaccess Description }}

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

### -status
{{ Fill status Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Up
Accept pipeline input: False
Accept wildcard characters: False
```

### -device_identification
{{ Fill device_identification Description }}

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

### -mode
{{ Fill mode Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Static
Accept pipeline input: False
Accept wildcard characters: False
```

### -ip
{{ Fill ip Description }}

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

### -netmask
{{ Fill netmask Description }}

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

### -vdom_interface
{{ Fill vdom_interface Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Root
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

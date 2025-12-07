---
external help file: PowerFGT-help.xml
Module Name: PowerFGT
online version:
schema: 2.0.0
---

# Set-FGTSystemInterface

## SYNOPSIS
Modify an interface

## SYNTAX

```
Set-FGTSystemInterface [-interface] <PSObject> [-alias <String>] [-role <String>] [-allowaccess <String[]>]
 [-mode <String>] [-ip <String>] [-netmask <String>] [-status <String>] [-device_identification <String>]
 [-vdom_interface <String>] [-data <Hashtable>] [-vdom <String[]>] [-dhcprelayip <String[]>]
 [-connection <PSObject>] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Modify the properties of an existing interface (admin acces, alias, status...)

## EXAMPLES

### EXAMPLE 1
```
Get-FGTSystemInterface -name PowerFGT | Set-FGTSystemInterface -alias ALIAS_PowerFGT -role lan -mode static -ip 192.0.2.1 -netmask 255.255.255.0 -allowaccess ping,https -device_identification $false -status up
```

This modifies the interface named PowerFGT with an alias, the LAN role, in static mode with 192.0.2.1 as IP, with ping and https allow access, and with device identification disable and not connected

### EXAMPLE 2
```
Get-FGTSystemInterface -name PowerFGT | Set-FGTSystemInterface -dhcprelayip "10.0.0.1","10.0.0.2"
```

This enables DHCP relay and sets 2 ip addresses to relay to.

### EXAMPLE 3
```
Get-FGTSystemInterface -name PowerFGT | Set-FGTSystemInterface -dhcprelayip $null
```

This disables DCHP relay and clears the relay ip addresses

### EXAMPLE 4
```
$data = @{ "sflow-sampler" = "enable" }
PS C:\>Get-FGTSystemInterface -name PowerFGT | Set-FGTSystemInterface -data $data
```

Configure sflow-sampler setting using -data parameter on interface PowerFGT

## PARAMETERS

### -interface
{{ Fill interface Description }}

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

### -mode
{{ Fill mode Description }}

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

### -status
{{ Fill status Description }}

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

### -vdom_interface
{{ Fill vdom_interface Description }}

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

### -dhcprelayip
{{ Fill dhcprelayip Description }}

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

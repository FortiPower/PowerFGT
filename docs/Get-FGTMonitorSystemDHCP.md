---
external help file: PowerFGT-help.xml
Module Name: PowerFGT
online version:
schema: 2.0.0
---

# Get-FGTMonitorSystemDHCP

## SYNOPSIS
Get System DHCP

## SYNTAX

```
Get-FGTMonitorSystemDHCP [[-interface] <String>] [[-scope] <String>] [[-connection] <PSObject>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Get System DHCP (status, ip, expire_time, interface, mac...)

## EXAMPLES

### EXAMPLE 1
```
Get-FGTMonitorSystemDHCP
```

Get System DHCP

### EXAMPLE 2
```
Get-FGTMonitorSystemDHCP -interface port1
```

Get System DHCP with interface port1

### EXAMPLE 3
```
Get-FGTMonitorSystemDHCP -scope vdom
```

Get System DHCP from scope vdom

## PARAMETERS

### -interface
{{ Fill interface Description }}

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

### -scope
{{ Fill scope Description }}

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

### -connection
{{ Fill connection Description }}

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
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

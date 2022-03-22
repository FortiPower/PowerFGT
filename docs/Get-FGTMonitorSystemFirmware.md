---
external help file: PowerFGT-help.xml
Module Name: PowerFGT
online version:
schema: 2.0.0
---

# Get-FGTMonitorSystemFirmware

## SYNOPSIS
Get System Firmware

## SYNTAX

```
Get-FGTMonitorSystemFirmware [-upgrade_paths] [[-connection] <PSObject>] [<CommonParameters>]
```

## DESCRIPTION
Get System Firmware (and upgrade paths)

## EXAMPLES

### EXAMPLE 1
```
Get-FGTMonitorSystemFirmware
```

Get System Firmware (current and available)

### EXAMPLE 2
```
Get-FGTMonitorSystemFirmware -upgrade_paths
```

Get System Firmware Upgrade Paths (need to have FortiGuard)

## PARAMETERS

### -upgrade_paths
{{ Fill upgrade_paths Description }}

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

### -connection
{{ Fill connection Description }}

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
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

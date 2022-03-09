---
external help file: PowerFGT-help.xml
Module Name: PowerFGT
online version:
schema: 2.0.0
---

# Move-FGTFirewallPolicy

## SYNOPSIS
Move a FortiGate Policy

## SYNTAX

### after
```
Move-FGTFirewallPolicy [-policy] <PSObject> [-after] -id <PSObject> [-vdom <String[]>] [-connection <PSObject>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

### before
```
Move-FGTFirewallPolicy [-policy] <PSObject> [-before] -id <PSObject> [-vdom <String[]>]
 [-connection <PSObject>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Move a Policy/Rule object (after or before) on the FortiGate

## EXAMPLES

### EXAMPLE 1
```
$MyFGTPolicy = Get-FGTFirewallPolicy -name MyFGTPolicy
PS C:\>$MyFGTPolicy | Move-FGTFirewallPolicy -after -id 12
```

Move Policy object $MyFGTPolicy after Policy id 12

### EXAMPLE 2
```
$MyFGTPolicy = Get-FGTFirewallPolicy -name MyFGTPolicy
PS C:\>$MyFGTPolicy | Move-FGTFirewallPolicy -before -id (Get-FGTFirewallPolicy -name MyFGTPolicy23)
```

Move Policy object $MyFGTPolicy before MyFGTPolicy23 (using Get-FGTFirewallPolicy)

## PARAMETERS

### -policy
{{ Fill policy Description }}

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

### -after
{{ Fill after Description }}

```yaml
Type: SwitchParameter
Parameter Sets: after
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -before
{{ Fill before Description }}

```yaml
Type: SwitchParameter
Parameter Sets: before
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -id
{{ Fill id Description }}

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases:

Required: True
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

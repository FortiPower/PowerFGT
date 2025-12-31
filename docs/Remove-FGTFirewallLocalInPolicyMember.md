---
external help file: PowerFGT-help.xml
Module Name: PowerFGT
online version:
schema: 2.0.0
---

# Remove-FGTFirewallLocalInPolicyMember

## SYNOPSIS
Remove a FortiGate Local In Policy Member

## SYNTAX

```
Remove-FGTFirewallLocalInPolicyMember [-policy] <PSObject> [-srcaddr <String[]>] [-intf <String[]>]
 [-dstaddr <String[]>] [-vdom <String[]>] [-connection <PSObject>] [-ProgressAction <ActionPreference>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Remove a FortiGate Local In Policy Member (source, destination address and interface)

## EXAMPLES

### EXAMPLE 1
```
$MyFGTPolicy = Get-FGTFirewallLocalInPolicy -policyid 23
PS C:\>$MyFGTPolicy | Remove-FGTFirewallLocalInPolicyMember -srcaddr MyAddress1
```

Remove source MyAddress1 member to MyFGTPolicy (policy id 23)

### EXAMPLE 2
```
$MyFGTPolicy = Get-FGTFirewallLocalInPolicy -policyid 23
PS C:\>$MyFGTPolicy | Remove-FGTFirewallLocalInPolicyMember -dstaddr MyAddress1, MyAddress2
```

Remove destination MyAddress1 and MyAddress2 member to MyFGTPolicy (policy id 23)

### EXAMPLE 3
```
$MyFGTPolicy = Get-FGTFirewallLocalInPolicy -policyid 23
PS C:\>$MyFGTPolicy | Remove-FGTFirewallLocalInPolicyMember -intf port1
```

Remove port1 member to interface of MyFGTPolicy (policy id 23)

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

### -srcaddr
{{ Fill srcaddr Description }}

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

### -intf
{{ Fill intf Description }}

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

### -dstaddr
{{ Fill dstaddr Description }}

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

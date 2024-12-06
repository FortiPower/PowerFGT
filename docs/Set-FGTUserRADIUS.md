---
external help file: PowerFGT-help.xml
Module Name: PowerFGT
online version:
schema: 2.0.0
---

# Set-FGTUserRADIUS

## SYNOPSIS
Change a FortiGate RADIUS Server

## SYNTAX

```
Set-FGTUserRADIUS [-userradius] <PSObject> [-name <String>] [-server <String>] [-secret <SecureString>]
 [-secondary_server <String>] [-secondary_secret <SecureString>] [-tertiary_server <String>]
 [-tertiary_secret <SecureString>] [-timeout <Int32>] [-nas_ip <String>] [-auth_type <String>]
 [-nas_id <String>] [-data <Hashtable>] [-vdom <String[]>] [-connection <PSObject>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Change a FortiGate RADIUS Server

## EXAMPLES

### EXAMPLE 1
```
$MyFGTUserRADIUS = Get-FGTUserRADIUS -name MyFGTUserRADIUS
PS C:\>$MyFGTUserRADIUS | Set-FGTUserRADIUS -server mynewRADIUSserver
```

Change server name from MyFGTUserRADIUS to mynewRADIUSserver

### EXAMPLE 2
```
$MyFGTUserRADIUS = Get-FGTUserRADIUS -name MyFGTUserRADIUS
PS C:\>$mysecret = ConvertTo-SecureString mysecret -AsPlainText -Force
PS C:\>$MyFGTUserRADIUS | Set-FGTUserRADIUS -secondary_server radius2.powerfgt -secondary_secret $mysecret
```

Change secondary server and secret

### EXAMPLE 3
```
$MyFGTUserRADIUS = Get-FGTUserRADIUS -name MyFGTUserRADIUS
PS C:\>$mysecret = ConvertTo-SecureString mysecret -AsPlainText -Force
PS C:\>$MyFGTUserRADIUS | Set-FGTUserRADIUS -tertiary_server radius2.powerfgt -tertiary_secret $mysecret
```

Change tertiary server and secret

### EXAMPLE 4
```
$data = @{ "timeout" = "200" }
PS C:\>$MyFGTUserRADIUS = Get-FGTUserRADIUS -name MyFGTUserRADIUS
PS C:\>$MyFGTUserRADIUS | Set-FGTUserRADIUS -data $data
```

Change timeout to 200sec

## PARAMETERS

### -userradius
{{ Fill userradius Description }}

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

### -name
{{ Fill name Description }}

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

### -server
{{ Fill server Description }}

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

### -secret
{{ Fill secret Description }}

```yaml
Type: SecureString
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -secondary_server
{{ Fill secondary_server Description }}

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

### -secondary_secret
{{ Fill secondary_secret Description }}

```yaml
Type: SecureString
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -tertiary_server
{{ Fill tertiary_server Description }}

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

### -tertiary_secret
{{ Fill tertiary_secret Description }}

```yaml
Type: SecureString
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -timeout
{{ Fill timeout Description }}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -nas_ip
{{ Fill nas_ip Description }}

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

### -auth_type
{{ Fill auth_type Description }}

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

### -nas_id
{{ Fill nas_id Description }}

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

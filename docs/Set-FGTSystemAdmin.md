---
external help file: PowerFGT-help.xml
Module Name: PowerFGT
online version:
schema: 2.0.0
---

# Set-FGTSystemAdmin

## SYNOPSIS
Configure an Admin

## SYNTAX

```
Set-FGTSystemAdmin [-admin] <PSObject> [-name <String>] [-accprofile <String>] [-comments <String>]
 [-trusthost1 <String>] [-trusthost2 <String>] [-trusthost3 <String>] [-trusthost4 <String>]
 [-trusthost5 <String>] [-trusthost6 <String>] [-trusthost7 <String>] [-trusthost8 <String>]
 [-trusthost9 <String>] [-trusthost10 <String>] [-data <Hashtable>] [-vdom <String[]>] [-connection <PSObject>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Change a (system) Administrator (name, comments, accprofile, trusted host ...
)

## EXAMPLES

### EXAMPLE 1
```
$MyFGTAdmin = Get-FGTSystemAdmin -name MyFGTAdmin
PS > $MyFGTAdmin | Set-FGTSystemAdmin -name MySuperAdmin
```

Change MyFGTAdmin name to MySuperAdmin

### EXAMPLE 2
```
$MyFGTAdmin = Get-FGTSystemAdmin -name MyFGTAdmin
PS > $MyFGTAdmin | Set-FGTSystemAdmin -accprofile prof_admin
```

Change MyFGTAdmin access profile to prof_admin

### EXAMPLE 3
```
$MyFGTAdmin = Get-FGTSystemAdmin -name MyFGTAdmin
PS > $MyFGTAdmin | Set-FGTSystemAdmin -comments "Changed by PowerFGT"
```

Change MyFGTAdmin comments to "Changed by PowerFGT"

### EXAMPLE 4
```
$MyFGTAdmin = Get-FGTSystemAdmin -name MyFGTAdmin
PS > $MyFGTAdmin | Set-FGTSystemAdmin -trusthost1 192.0.2.1/32
```

Change MyFGTAdmin Trust host 1 to 192.0.2.1/32

### EXAMPLE 5
```
$MyFGTAdmin = Get-FGTSystemAdmin -name MyFGTAdmin
PS > $MyFGTAdmin | Set-FGTSystemAdmin -trusthost3 198.51.100.0/24
```

Change MyFGTAdmin Trust host 3 to 198.51.100.0/24

### EXAMPLE 6
```
$MyFGTAdmin = Get-FGTSystemAdmin -name MyFGTAdmin
PS > $MyFGTAdmin | Set-FGTSystemAdmin -trusthost4 0.0.0.0/0
```

Change MyFGTAdmin Trust host 4 to 0.0.0.0/0 (allow from anywhere)

### EXAMPLE 7
```
$data = @{ "two-factor" = "email" ; "email-to" = "admin@fgt.power" }
PS > $MyFGTAdmin = Get-FGTSystemAdmin -name MyFGTAdmin
PS > $MyFGTAdmin | Set-FGTSystemAdmin -data $data
```

Change MyFGTAdmin to set two-factor to email and email-to using -data

## PARAMETERS

### -admin
{{ Fill admin Description }}

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

### -accprofile
{{ Fill accprofile Description }}

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

### -comments
{{ Fill comments Description }}

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

### -trusthost1
{{ Fill trusthost1 Description }}

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

### -trusthost2
{{ Fill trusthost2 Description }}

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

### -trusthost3
{{ Fill trusthost3 Description }}

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

### -trusthost4
{{ Fill trusthost4 Description }}

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

### -trusthost5
{{ Fill trusthost5 Description }}

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

### -trusthost6
{{ Fill trusthost6 Description }}

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

### -trusthost7
{{ Fill trusthost7 Description }}

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

### -trusthost8
{{ Fill trusthost8 Description }}

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

### -trusthost9
{{ Fill trusthost9 Description }}

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

### -trusthost10
{{ Fill trusthost10 Description }}

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

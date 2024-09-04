---
external help file: PowerFGT-help.xml
Module Name: PowerFGT
online version:
schema: 2.0.0
---

# Set-FGTUserLocal

## SYNOPSIS
Configure a FortiGate Local User

## SYNTAX

### default (Default)
```
Set-FGTUserLocal [-userlocal] <PSObject> [-name <String>] [-status] [-two_factor <String>]
 [-two_factor_notification <String>] [-fortitoken <String>] [-email_to <String>] [-sms_phone <String>]
 [-data <Hashtable>] [-vdom <String[]>] [-connection <PSObject>] [-ProgressAction <ActionPreference>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

### local
```
Set-FGTUserLocal [-userlocal] <PSObject> [-name <String>] [-status] [-passwd <SecureString>]
 [-two_factor <String>] [-two_factor_notification <String>] [-fortitoken <String>] [-email_to <String>]
 [-sms_phone <String>] [-data <Hashtable>] [-vdom <String[]>] [-connection <PSObject>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Change a FortiGate Local User

## EXAMPLES

### EXAMPLE 1
```
$MyFGTUserLocal = Get-FGTUserLocal -name MyFGTUserLocal
PS C:\>$MyFGTUserLocal | Set-FGTUserLocal -status $false
```

Change MyFGTUserLocal to status disable

### EXAMPLE 2
```
$MyFGTUserLocal = Get-FGTUserLocal -name MyFGTUserLocal
$mypassword = ConvertTo-SecureString mypassword -AsPlainText -Force
PS C:\>$MyFGTUserLocal | Set-FGTUserLocal -passwd $mypassword
```

Change MyFGTUserLocal to value (Password) MyFGTUserLocalPassword

### EXAMPLE 3
```
$MyFGTUserLocal = Get-FGTUserLocal -name MyFGTUserLocal
PS C:\>$MyFGTUserLocal | Set-FGTUserLocal -email_to newpowerfgt@fgt.power
```

Change MyFGTUserLocal to set email to newpowerfgt@fgt.power

### EXAMPLE 4
```
$data = @{ "sms-phone" = "XXXXXXXXXX" }
PS C:\>$MyFGTUserLocal = Get-FGTUserLocal -name MyFGTUserLocal
PS C:\>$MyFGTUserLocal | Set-FGTUserLocal -data $data
Change MyFGTUserLocal to set SMS Phone
```

## PARAMETERS

### -userlocal
{{ Fill userlocal Description }}

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

### -status
{{ Fill status Description }}

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

### -passwd
{{ Fill passwd Description }}

```yaml
Type: SecureString
Parameter Sets: local
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -two_factor
\[Parameter (Mandatory = $false, ParameterSetName = "radius")\]
        \[string\]$radius_server,
        \[Parameter (Mandatory = $false, ParameterSetName = "tacacs")\]
        \[string\]$tacacs_server,

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

### -two_factor_notification
{{ Fill two_factor_notification Description }}

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

### -fortitoken
{{ Fill fortitoken Description }}

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

### -email_to
{{ Fill email_to Description }}

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

### -sms_phone
{{ Fill sms_phone Description }}

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

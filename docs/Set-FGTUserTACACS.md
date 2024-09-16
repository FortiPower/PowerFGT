---
external help file: PowerFGT-help.xml
Module Name: PowerFGT
online version:
schema: 2.0.0
---

# Set-FGTUserTACACS

## SYNOPSIS
Change a FortiGate TACACS Server

## SYNTAX

```
Set-FGTUserTACACS [-usertacacs] <PSObject> [-name <String>] [-server <String>] [-key <SecureString>]
 [-secondary_server <String>] [-secondary_key <SecureString>] [-tertiary_server <String>]
 [-tertiary_key <SecureString>] [-port <Int32>] [-authen_type <String>] [-authorization <String>]
 [-data <Hashtable>] [-vdom <String[]>] [-connection <PSObject>] [-ProgressAction <ActionPreference>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Change a FortiGate TACACS Server

## EXAMPLES

### EXAMPLE 1
```
$MyFGTUserTACACS = Get-FGTUserTACACS -name MyFGTUserTACACS
PS C:\>$MyFGTUserTACACS | Set-FGTUserTACACS -server mynewTACACSserver
```

Change server name from MyFGTUserTACACS to mynewTACACSserver

### EXAMPLE 2
```
$MyFGTUserTACACS = Get-FGTUserTACACS -name MyFGTUserTACACS
PS C:\>$mykey = ConvertTo-SecureString mykey -AsPlainText -Force
PS C:\>$MyFGTUserTACACS | Set-FGTUserTACACS -secondary_server tacacs2.powerfgt -secondary_key $mykey
```

Change secondary server and key

### EXAMPLE 3
```
$MyFGTUserTACACS = Get-FGTUserTACACS -name MyFGTUserTACACS
PS C:\>$mykey = ConvertTo-SecureString mykey -AsPlainText -Force
PS C:\>$MyFGTUserTACACS | Set-FGTUserTACACS -tertiary_server tacacs3.powerfgt -tertiary_key $mykey
```

Change tertiary server and key

### EXAMPLE 4
```
$MyFGTUserTACACS = Get-FGTUserTACACS -name MyFGTUserTACACS
PS C:\>$MyFGTUserTACACS | Set-FGTUserTACACS -authorization disable
```

Change authorization to disable

### EXAMPLE 5
```
$data = @{ "port" = "10049" }
PS C:\>$MyFGTUserTACACS = Get-FGTUserTACACS -name MyFGTUserTACACS
PS C:\>$MyFGTUserTACACS | Set-FGTUserTACACS -data $data
```

Change port to 10049

## PARAMETERS

### -usertacacs
{{ Fill usertacacs Description }}

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

### -key
{{ Fill key Description }}

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

### -secondary_key
{{ Fill secondary_key Description }}

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

### -tertiary_key
{{ Fill tertiary_key Description }}

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

### -port
{{ Fill port Description }}

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

### -authen_type
{{ Fill authen_type Description }}

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

### -authorization
{{ Fill authorization Description }}

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

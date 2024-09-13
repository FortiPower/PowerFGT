---
external help file: PowerFGT-help.xml
Module Name: PowerFGT
online version:
schema: 2.0.0
---

# Set-FGTUserLDAP

## SYNOPSIS
Change a FortiGate LDAP Server

## SYNTAX

```
Set-FGTUserLDAP [-userldap] <PSObject> [-name <String>] [-server <String>] [-secondary_server <String>]
 [-tertiary_server <String>] [-cnid <String>] [-dn <String>] [-type <String>] [-username <String>]
 [-password <SecureString>] [-secure <String>] [-data <Hashtable>] [-vdom <String[]>] [-connection <PSObject>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Set a FortiGate LDAP Server (Server, dc, cnid...)

## EXAMPLES

### EXAMPLE 1
```
$MyFGTUserLDAP = Get-FGTUserLDAP -name MyFGTUserLDAP
PS C:\>$MyFGTUserLDAP | Set-FGTUserLDAP -server mynewldapserver
```

Change server of MyFGTUserLDAP to mynewldapserver

### EXAMPLE 2
```
$MyFGTUserLDAP = Get-FGTUserLDAP -name MyFGTUserLDAP
$mypassword = ConvertTo-SecureString mypassword -AsPlainText -Force
PS C:\>$MyFGTUserLDAP | Set-FGTUserLDAP -username myusername -password $mypassword -type regular
```

Change type to regular and change username and password

### EXAMPLE 3
```
$MyFGTUserLDAP = Get-FGTUserLDAP -name MyFGTUserLDAP
PS C:\>$MyFGTUserLDAP | Set-FGTUserLDAP -secure ldaps
```

Change MyFGTUserLDAP to user secure connection (LDAPS and port 636)

### EXAMPLE 4
```
$data = @{ "port" = "10389" }
PS C:\>$MyFGTUserLDAP = Get-FGTUserLDAP -name MyFGTUserLDAP
PS C:\>$MyFGTUserLDAP | Set-FGTUserLDAP -data $data
```

Change MyFGTUserLDAP to port 10389

## PARAMETERS

### -userldap
{{ Fill userldap Description }}

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

### -cnid
{{ Fill cnid Description }}

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

### -dn
{{ Fill dn Description }}

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

### -type
{{ Fill type Description }}

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

### -username
{{ Fill username Description }}

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

### -password
{{ Fill password Description }}

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

### -secure
{{ Fill secure Description }}

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

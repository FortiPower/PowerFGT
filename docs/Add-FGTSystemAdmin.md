---
external help file: PowerFGT-help.xml
Module Name: PowerFGT
online version:
schema: 2.0.0
---

# Add-FGTSystemAdmin

## SYNOPSIS
Add a (System) Administrator

## SYNTAX

```
Add-FGTSystemAdmin [-name] <String> -password <SecureString> -accprofile <String> [-comments <String>]
 [-trusthost1 <String>] [-trusthost2 <String>] [-trusthost3 <String>] [-trusthost4 <String>]
 [-trusthost5 <String>] [-trusthost6 <String>] [-trusthost7 <String>] [-trusthost8 <String>]
 [-trusthost9 <String>] [-trusthost10 <String>] [-data <Hashtable>] [-vdom <String[]>] [-connection <PSObject>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Add a System Administrator (name, password, accprofile, ...)

## EXAMPLES

### EXAMPLE 1
```
$mypassword = ConvertTo-SecureString mypassword -AsPlainText -Force
PS > Add-FGTSystemAdmin -name MyFGTAdmin -accprofile super_admin -password $mypassword
```

Add a System Admin named MyFGTAdmin with access Profile super_admin and password

### EXAMPLE 2
```
$mypassword = ConvertTo-SecureString mypassword -AsPlainText -Force
PS > Add-FGTSystemAdmin -name MyFGTAdmin -accprofile super_admin -password $mypassword -comments "Added By PowerFGT"
```

Add a System Admin named MyFGTAdmin with a comments

### EXAMPLE 3
```
$mypassword = ConvertTo-SecureString mypassword -AsPlainText -Force
PS > Add-FGTSystemAdmin -name MyFGTAdmin -accprofile super_admin -password $mypassword -trusthost1 192.0.2.1/32 -trusthost2 198.51.100.0/24
```

Add a System Admin named MyFGTAdmin with trusthost1 (only host 192.0.2.1) and trusthost2 (network 198.51.100.0/24).
You can add up to 10 trusthost (trusthost1 to trusthost10)

### EXAMPLE 4
```
$mypassword = ConvertTo-SecureString mypassword -AsPlainText -Force
PS > $data = @{ "guest-auth" = "enable" }
PS > Add-FGTSystemAdmin -name MyFGTAdmin -accprofile super_admin -password $mypassword -data $data
```

Add a System Admin named MyFGTAdmin with -data to enable guest-auth

## PARAMETERS

### -name
{{ Fill name Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
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

Required: True
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

Required: True
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

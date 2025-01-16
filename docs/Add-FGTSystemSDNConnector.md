---
external help file: PowerFGT-help.xml
Module Name: PowerFGT
online version:
schema: 2.0.0
---

# Add-FGTSystemSDNConnector

## SYNOPSIS
Add a SDN Connector

## SYNTAX

```
Add-FGTSystemSDNConnector [-name] <String> -server <String> -username <String> -password <SecureString>
 [-status] [-verify_certificate] [-update_interval <Int32>] [-data <Hashtable>] [-vdom <String[]>]
 [-connection <PSObject>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Add a SDN Connector (Status, server, type ...
)

## EXAMPLES

### EXAMPLE 1
```
$mypassword = ConvertTo-SecureString mysecret -AsPlainText -Force
PS C:\>Add-FGTSystemSDNConnector -name MySDNConnector -server MyVcenter -username powerfgt@vsphere.local -password $mypassword
```

Create a new SDN Connector type vCenter/ESX with username and password

### EXAMPLE 2
```
$mypassword = ConvertTo-SecureString mysecret -AsPlainText -Force
PS C:\>Add-FGTSystemSDNConnector -name MySDNConnector -server MyVcenter -username powerfgt@vsphere.local -password $mypassword -status:$false -verify_certificate:false
```

Create a new SDN Connector type vCenter/ESX with username and password with disable status and verify-certificate

### EXAMPLE 3
```
$data = @{ 'server-port' = "8443" }
PS C:\>$mypassword = ConvertTo-SecureString mysecret -AsPlainText -Force
PS C:\>Add-FGTSystemSDNConnector -name MySDNConnector -server MyVcenter -username powerfgt@vsphere.local -password $mypassword -data $data
```

This creates a new SDN Connector with server-port enable using -data parameter

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

### -server
{{ Fill server Description }}

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

### -username
{{ Fill username Description }}

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

### -verify_certificate
{{ Fill verify_certificate Description }}

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

### -update_interval
{{ Fill update_interval Description }}

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

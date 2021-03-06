---
external help file: PSDokuWiki-help.xml
Module Name: PSDokuWiki
online version: https://github.com/AndyDLP/PSDokuWiki/blob/master/docs/Get-DokuPageInfo.md
schema: 2.0.0
---

# Get-DokuPageInfo

## SYNOPSIS
Returns information about a Wiki page

## SYNTAX

```
Get-DokuPageInfo [-FullName] <String[]> [<CommonParameters>]
```

## DESCRIPTION
Returns information about a Wiki page

## EXAMPLES

### EXAMPLE 1
```powershell
$PageInfo = Get-DokuPageInfo -FullName "namespace:namespace:page"
```

## PARAMETERS

### -FullName
The full page name for which to return the data, including namespaces

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Management.Automation.PSObject
## NOTES
AndyDLP - 2018-05-26

## RELATED LINKS

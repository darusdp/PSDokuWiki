﻿function Get-DokuAttachmentInfo {
    [CmdletBinding()]
    [OutputType([psobject])]
    param
    (
        [Parameter(Mandatory = $true,
            Position = 1,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The full name of the file to get information from')]
        [ValidateNotNullOrEmpty()]
        [string[]]$FullName
    )

    begin {}

    process {
        foreach ($attachmentName in $FullName) {
            $APIResponse = Invoke-DokuApiCall -MethodName 'wiki.getAttachmentInfo' -MethodParameters @($attachmentName)
            if ($APIResponse.CompletedSuccessfully -eq $true) {
                $ArrayValues = ($APIResponse.XMLPayloadResponse | Select-Xml -XPath "//struct").Node.Member.Value.Innertext
                $attachmentObject = [PSCustomObject]@{
                    FullName        = $attachmentName
                    Size            = $ArrayValues[1]
                    LastModified    = Get-Date -Date ($ArrayValues[0])
                    FileName        = ($attachmentName -split ":")[-1]
                    ParentNamespace = ($attachmentName -split ":")[-2]
                    RootNamespace   = if (($attachmentName -split ":")[0] -eq $attachmentName) {"::"} else {($attachmentName -split ":")[0]}
                }
                $attachmentObject.PSObject.TypeNames.Insert(0, "DokuWiki.Attachment.Info")
                $attachmentObject            
            } elseif ($null -eq $APIResponse.ExceptionMessage) {
                Write-Error "Fault code: $($APIResponse.FaultCode) - Fault string: $($APIResponse.FaultString)"
            } else {
                Write-Error "Exception: $($APIResponse.ExceptionMessage)"
            }
        } # foreach attachment
    } # process

    end {}
}
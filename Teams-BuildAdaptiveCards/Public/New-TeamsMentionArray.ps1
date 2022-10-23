function New-TeamsMentionArray{
    [CmdletBinding()]
    param(
        [Parameter(HelpMessage = "Provide a mention entity" , Mandatory = $true)]
        [mentionEntity]$MentionEntity
    )
    return [mentionArray]::New($MentionEntity)
}
function Update-TeamsMentionArray {
    [CmdletBinding()]
    param(
        [Parameter(HelpMessage = "Message" , Mandatory = $true)]
        [validateSet("Add","Remove")]
        [string]$Action,
        [Parameter(HelpMessage = "Provide the Teams Array" , Mandatory = $true)]
        [mentionArray]$MentionArray,
        [Parameter(HelpMessage = "Provide the mention to add or remove" , Mandatory = $true)]
        [mentionEntity]$Mention
    )

    if($Action -eq "Add"){
        $mentionArray.Add($Mention)
        return $mentionArray
    }
    if($Action -eq "Remove"){
        $mentionArray.Remove($mention)
        return $mentionArray
    }
}
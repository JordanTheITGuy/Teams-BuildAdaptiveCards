function New-SingleTeamsMention {
    [CmdletBinding()]
    param(
        [Parameter(HelpMessage = "Provide the UPN (E-mail) of the user you would like to tag in teams" , Mandatory = $True, ValueFromPipeline = $True, ValueFromPipelineByPropertyName = $True)]
        [string]$UPN,
        [Parameter(HelpMessage = "Provide the first and last name of the user you would like to tag in teams" , Mandatory = $True, ValueFromPipeline = $True, ValueFromPipelineByPropertyName = $True )]
        [string]$FullName
    )
    $entity = [mentionEntity]::New($UPN, $FullName)
    return $entity
}
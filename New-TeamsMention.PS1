function New-TeamsMention{
    [CmdletBinding()]
    param(
        [Parameter(HelpMessage = "Provide the UPN (E-mail) of the user you would like to tag in teams" , Mandatory = $True, ValueFromPipeline = $True, ValueFromPipelineByPropertyName = $True)]
        [string]$UPN,
        [Parameter(HelpMessage = "Provide the first and last name of the user you would like to tag in teams" , Mandatory = $True, ValueFromPipeline = $True, ValueFromPipelineByPropertyName = $True )]
        [string]$FullName
    )
    begin {
        class mentionEntity{
            [string]$type
            [string]$text
            [hashtable]$mentioned
        
            mentionEntity([string]$id, [string]$name){
                $this.type = "mention"
                $this.text = "<at>$($name)</at>"
                $this.mentioned = @{
                    id = $id
                    name = $name
                }
            }
        }
    }
    process{
        $entity = [mentionEntity]::New($UPN,$FullName)
        return $entity
    }
}

function New-TeamsAdaptiveCard{
    [CmdletBinding()]
    param(
        [Parameter(HelpMessage = "Provide the header you would like the message to have" , Mandatory = $true)]
        [string]$Header,
        [Parameter(HelpMessage = "Provide the message body you would like the card to contain" , Mandatory = $true)]
        [string]$MessageBody,
        [Parameter(HelpMessage = "Provide the facts object" , Mandatory = $false)]
        [msgFactSet]$Facts,
        [Parameter(HelpMessage = "Provide the Notification objects list for people, or groups you would like to tag" , Mandatory = $FALSE)]
        [msTeams]$Mentions,
        [Parameter(HelpMessage = "If this message should indicate failure enable this switch" , Mandatory = $false)]
        [switch]$Failure,
        [Parameter(HelpMessage = "Returns the results as JSON" , Mandatory = $FALSE)]
        [switch]$AsJson
    )
    begin{

    }
    process{
        if($Failure){
            $messageHeader = [msgHeader]::New($Header, $false)
        }
        else{
            $messageHeader = [msgHeader]::New($Header, $true)
        }
        if($Facts){
            $msgBody = [msgBody]::New($messageHeader,$Facts,$MessageBody)
        }
        else{
            $msgBody = [msgBody]::New($messageHeader,$MessageBody)
        }
        if($Mentions){
            $content = [jsonContent]::New($msgBody,$Mentions)
        }
        else{
            $content = [jsonContent]::New($msgBody)
        }
        $jsonAttachmenets = [jsonAttachments]::new($content)
        $jsonPayload = [jsonPayload]::New($jsonAttachmenets)
        
        if($AsJson){
            return $jsonPayload.ToJson()
        }
        else{
            return $jsonPayload
        }
            
    }
}

function New-TeamsFact{
    [CmdletBinding()]
    param(
        #TODO: Consider Pipeline Input, add examples and notes.
        [Parameter(HelpMessage = "A fact, or set of facts must ultimately be presented as a hashtable." , Mandatory = $FALSE)]
        [hashtable]$Facts
    )
    begin{

    }
    process{
        $factArray = [System.Collections.Generic.List[psobject]]::New()
        foreach($fact in $facts.GetEnumerator()){
            $fact = [fact]::New($fact.Name,$fact.Value)
            $factArray.Add($fact)
        }
        return [msgFactSet]::New($factArray)
    }
}

function New-TeamsMention{
    [CmdletBinding()]
    param(
        #TODO: Add examples and notes.
        [Parameter(HelpMessage = "Provide the UPN (E-mail) of the user you would like to tag in teams" , Mandatory = $True, ValueFromPipeline = $True, ValueFromPipelineByPropertyName = $True)]
        [string]$UPN,
        [Parameter(HelpMessage = "Provide the first and last name of the user you would like to tag in teams" , Mandatory = $True, ValueFromPipeline = $True, ValueFromPipelineByPropertyName = $True )]
        [string]$FullName
    )
    begin {
        
    }
    process{
        $entity = [mentionEntity]::New($UPN,$FullName)
        return [msTeams]::New(@($entity))
    }
}

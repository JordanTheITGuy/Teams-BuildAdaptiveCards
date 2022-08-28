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

class msTeams{
    [array]$entities
    msTeams([array]$entities){
        $this.entities = $entities
    }
}

class fact{
    [string]$title
    [string]$value 

    fact([string]$title, [string]$value){
        $this.title = $title
        $this.value = $value
    }
}

class msgFactSet{
    [string]$type
    [array]$facts

    msgFactSet([array]$facts){
        $this.type = "FactSet"
        $this.facts = $facts
    }
}

class msgHeader{
    [string]$type
    [string]$size
    [string]$weight
    [string]$text
    [string]$style
    [string]$color

    msgHeader([string]$text,[bool]$isSuccess){
        $this.type = "TextBlock"
        $this.size = "Large"
        $this.weight = "Bolder"
        $this.text = $text
        $this.style = "heading"
        $this.color = if($isSuccess){
            "Good"
        }
        else{
            "Attention"
        }
    }
}

class msgContent{
    [string]$type
    [string]$text
    [bool]$wrap

    msgContent([string]$text){
        $this.type = "TextBlock"
        $this.text = $text
        $this.wrap = $true
    }
}

class msgBody{
    [array]$body
    
    msgBody([msgHeader]$msgHeader, [msgfactSet]$msgfactSet,[msgContent]$msgContent){
        $this.body = @($msgHeader,$msgContent,$msgfactSet)
    }

    msgBody([msgHeader]$msgHeader, [msgContent]$msgContent){
        $this.body = @($msgHeader,$msgContent)
    }

}

class jsonContent{
    [string]$schema
    [string]$type
    [string]$version
    [array]$body
    [msTeams]$msTeams

    jsonContent([msgBody]$body){
        $this.schema = "http://adaptivecards.io/schemas/adaptive-card.json"
        $this.type = "AdaptiveCard"
        $this.version = "1.3"
        $this.body = $body.body
    }

    jsonContent([msgBody]$body,[msTeams]$msTeams){
        $this.schema = "http://adaptivecards.io/schemas/adaptive-card.json"
        $this.type = "AdaptiveCard"
        $this.version = "1.3"
        $this.body = $body.body
        $this.msTeams = $msTeams.entities
    }
}

class jsonAttachments{
    [string]$contentType 
    [string]$contentUrl
    [jsonContent]$content

    jsonAttachments([jsonContent]$content){
        $this.contentType = "application/vnd.microsoft.card.adaptive"
        $this.contentUrl = $null
        $this.content = $content
    }
}

class jsonPayload{
    [string]$type
    [array]$attachments
    
    jsonPayload([jsonAttachments]$jsonAttachments){
        $this.type = "message"
        $this.attachments = $jsonAttachments
    }

    [string] ToJson(){
        return $this | ConvertTo-Json -Depth 100
    }
}

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

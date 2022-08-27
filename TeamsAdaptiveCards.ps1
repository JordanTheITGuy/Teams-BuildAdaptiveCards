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
        $this.size = "Medium"
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
}

class jsonContent{
    [string]$schema
    [string]$type
    [string]$version
    [array]$body
    jsonContent([msgBody]$body){
        $this.schema = "http://adaptivecards.io/schemas/adaptive-card.json"
        $this.type = "AdaptiveCard"
        $this.version = "1.2"
        $this.body = $body.body
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

}

$msgHeader = [msgHeader]::New("Hello World",$false)
$msgContent = [msgContent]::New("This is a test o the thing")
$fact = [fact]::new("Burger","Bacon") 
$fact1 = [fact]::new("Burger","turkey") 
$msgFactSet = [msgFactSet]::New(@($fact,$fact1))
$msgBody = [msgBody]::new($msgHeader,$msgFactSet,$msgContent)
$msgBody | ConvertTo-Json -Depth 20
$content = [jsonContent]::New($msgBody)
$jsonAttachmenets = [jsonAttachments]::new($content)
$jsonPayload = [jsonPayload]::New($jsonAttachmenets)

$uri = ""
$restParams = @{
    Uri         = $uri
    ContentType = "application/json"
    Method      = 'POST'
    Body        = $($jsonPayload | ConvertTo-Json -Depth 20)
}
Invoke-WebRequest @restParams
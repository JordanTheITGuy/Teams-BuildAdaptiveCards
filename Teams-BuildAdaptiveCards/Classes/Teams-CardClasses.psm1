class mentionEntity {
    [string]$type
    [string]$text
    [hashtable]$mentioned

    mentionEntity([string]$id, [string]$name) {
        $this.type = "mention"
        $this.text = "<at>$($name)</at>"
        $this.mentioned = @{
            id   = $id
            name = $name
        }
    }
}

class msTeams {
    [array]$entities
    msTeams([array]$entities) {
        $this.entities = $entities
    }
}


enum teamsColumnType {
    TextBlock = 0
    Image = 1
}

class teamsColumnRecord {
    [string]$type
    [string]$text
    [string]$url
    [string]$altText

    teamsColumnRecord([string]$text) {
            $this.type = "TextBlock"
            $this.text = $text
    }

    teamsColumnRecord([teamsColumnType]$type,[string]$url,[string]$altText) {
            $this.type = $type
            $this.url = $url
            $this.altText = $altText
    }
}

class teamsColumn {
    [string]$Type
    [array]$items

    teamsColumn([array]$items){
        if($items[0].GetType().Name -eq "teamsColumnRecord") {
            $this.Type = "Column"
            $this.items = $items
        }
    }
}


class teamsColumnSet {
    [string]$type
    [array]$columns

    teamsColumnSet([array]$columns){
        if($columns[0].GetType().Name -eq "teamsColumn") {
            $this.type = "ColumnSet"
            $this.columns = $columns
        }
    }
}


class fact {
    [string]$title
    [string]$value 

    fact([string]$title, [string]$value) {
        $this.title = $title
        $this.value = $value
    }
}

class msgFactSet {
    [string]$type
    [array]$facts

    msgFactSet([array]$facts) {
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

    msgHeader([string]$text,[string]$color){
        $this.type = "TextBlock"
        $this.size = "Large"
        $this.weight = "Bolder"
        $this.text = $text
        $this.style = "heading"
        $this.color = switch ($color) {
            "Good" {
                "Good"
              }
            "Attention" {
                "Attention"
            }
            "Accent"{
                "Accent"
            }
            "Warning"{
                "Warning"
            }
            "Dark"{
                "Dark"
            }
            "Light"{
                "Light"
            }
            Default {
                "Default"
            }
        }
    }
}


class msgContent {
    [string]$type
    [string]$text
    [bool]$wrap

    msgContent([string]$text) {
        $this.type = "TextBlock"
        $this.text = $text
        $this.wrap = $true
    }
}

class msgBody {
    [array]$body
    
    msgBody([msgHeader]$msgHeader, [msgfactSet]$msgfactSet, [msgContent]$msgContent) {
        $this.body = @($msgHeader, $msgContent, $msgfactSet)
    }

    msgBody([msgHeader]$msgHeader, [msgContent]$msgContent) {
        $this.body = @($msgHeader, $msgContent)
    }
    msgBody([msgHeader]$msgHeader,[msgContent]$msgContent,[teamsColumnSet]$teamsColumnSet) {
        $this.body = @($msgHeader,$msgContent,$teamsColumnSet)
    }

}

class jsonContent {
    [string]$schema
    [string]$type
    [string]$version
    [array]$body
    [msTeams]$msTeams

    jsonContent([msgBody]$body) {
        $this.schema = "http://adaptivecards.io/schemas/adaptive-card.json"
        $this.type = "AdaptiveCard"
        $this.version = "1.3"
        $this.body = $body.body
    }

    jsonContent([msgBody]$body, [msTeams]$msTeams) {
        $this.schema = "http://adaptivecards.io/schemas/adaptive-card.json"
        $this.type = "AdaptiveCard"
        $this.version = "1.3"
        $this.body = $body.body
        $this.msTeams = $msTeams.entities
    }
}

class jsonAttachments {
    [string]$contentType 
    [string]$contentUrl
    [jsonContent]$content

    jsonAttachments([jsonContent]$content) {
        $this.contentType = "application/vnd.microsoft.card.adaptive"
        $this.contentUrl = $null
        $this.content = $content
    }
}

class jsonPayload {
    [string]$type
    [array]$attachments
    
    jsonPayload([jsonAttachments]$jsonAttachments) {
        $this.type = "message"
        $this.attachments = $jsonAttachments
    }

    [string] ToJson() {
        return $this | ConvertTo-Json -Depth 100
    }
}
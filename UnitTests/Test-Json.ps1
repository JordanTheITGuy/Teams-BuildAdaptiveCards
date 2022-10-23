#Requires -Modules Pester,Teams-BuildAdaptiveCards

Describe Build-Json {
    It "Should generate json for a simple card with no features" {
        $result = New-TeamsAdaptiveCard -Header "Example Header" -MessageBody "Content in the body" -HeaderColor "Dark"
        $result | should -be jsonPayload
    }
}

Describe Build-Json-WithMention {
    It "Should generate json for a simple card with a Mention" {
        $mention = New-SingleTeamsMention -UPN jordan@somedomain.com -FullName "Jordan Benzing"
        $mentionArray = New-TeamsMentionArray -Mention $mention
        $result = New-TeamsAdaptiveCard -Header "Example Header" -MessageBody "Content in the body" -HeaderColor "Dark" -Mention $mentionArray
        $result | should -be jsonPayload
    }
}

Describe Send-Message-WithMention {
    It "Should generate JSON which includes a mention, and send it to a webhook, and return Post 200" { 
    $webhookData = Get-Content -path $PSScriptRoot/environment.json | ConvertFrom-Json -Depth 10
    $webhookData = Get-Content -path ./UnitTests/environment.json | ConvertFrom-Json -Depth 10
    $mention = New-SingleTeamsMention -UPN $webhookData.Email  -FullName "Jordan Benzing"
    $mentionArray = New-TeamsMentionArray -Mention $mention
    $result = New-TeamsAdaptiveCard -Header "Example Header" -MessageBody "Content in the body <at>Jordan Benzing</at>" -HeaderColor "Dark" -Mention $mentionArray
    $restParams = @{
        uri = $webhookData.uri
        ContentType = $webhookData.ContentType
        Method = $webhookData.Method
        body = $result.ToJson()
    }
    $resp = Invoke-webrequest @restParams
    $resp.StatusCode | Should -be "200"
    $resp.Content | Should -be "1"
    $resp.StatusDescription | Should -be "OK"
    }
}
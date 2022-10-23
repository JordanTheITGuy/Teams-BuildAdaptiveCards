function New-TeamsAdaptiveCard{
    [CmdletBinding()]
    param(
        [Parameter(HelpMessage = "Provide the header you would like the message to have" , Mandatory = $true)]
        [string]$Header,
        [Parameter(HelpMessage = "Provide the message body you would like the card to contain" , Mandatory = $true)]
        [string]$MessageBody,
        [Parameter(HelpMessage = "Provide a columnSet Object " , Mandatory = $FALSE)]
        [teamsColumnSet]$columnSet,
        [Parameter(HelpMessage = "Provide the facts object" , Mandatory = $false)]
        [msgFactSet]$Facts,
        [Parameter(HelpMessage = "Provide the Notification objects list for people, or groups you would like to tag" , Mandatory = $FALSE)]
        [msTeams]$Mentions,
        [Parameter(HelpMessage = "Specify the type header this card should have if not specified the default will be used." , Mandatory = $false)]
        [ValidateSet("Dark","Light","Accent","Warning","Attention","Good")]
        [string]$HeaderColor,
        [Parameter(HelpMessage = "Returns the results as JSON" , Mandatory = $FALSE)]
        [switch]$AsJson
    )
        $messageHeader = [msgHeader]::New($Header, $HeaderColor)
        if($Facts){
            $msgBody = [msgBody]::New($messageHeader,$Facts,$MessageBody)
        }
        else{
            $msgBody = [msgBody]::New($messageHeader,$MessageBody)
        }
        if($columnSet){
            $msgBody = [msgBody]::New($messageHeader,$MessageBody,$columnSet)
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
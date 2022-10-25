#Requires -Modules Pester,Teams-BuildAdaptiveCards

Describe TeamsMentions {

    It "Should always be of type mentionEntity"{
         $result = New-SingleTeamsMention -UPN jordan@domain.com -FullName "Jordan Benzing"
         $result | Should -Be mentionEntity
    }
}

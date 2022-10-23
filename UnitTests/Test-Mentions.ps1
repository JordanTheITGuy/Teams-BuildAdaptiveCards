#Requires -Modules Pester,Teams-BuildAdaptiveCards

Describe New-TeamsMention {
    It "Given parameters should return the data, in an array of size 1"{
         $result = New-TeamsMention -UPN jordan@domain.com -FullName "Jordan Benzing"
         $result.count | Should -be 1
    }

    It "Should always be of type msTeams"{
         $result = New-TeamsMention -UPN jordan@domain.com -FullName "Jordan Benzing"
         $result | Should -Be msTeams
    }
}

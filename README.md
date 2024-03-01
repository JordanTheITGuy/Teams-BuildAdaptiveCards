# Teams-BuildAdaptiveCards

Adaptive cards are challenging to say the least. Mostly, this is due to how the JSON is incredible intolerant of errors. This makes coding around it, time consuming and frustrating. This set of functions, seeks to work around that using the power of Classes, and the logic of powershell to break things down. This started as something I needed to create for usage with some Azure Function logic, and then slowly evolved overtime, I hope you find it useful. 

The code in it's current state works...

Import the module.

```powershell
import-Module .\Teams-BuildAdaptiveCards.psm1
```

Generate a mention... or don't, I'm not your parent.

```powershell
$mention = New-SingleTeamsMention -UPN "jordan@SomeDomain.Com" -FullName "Jordan Benzing"
```

Generate some facts...
```powershell
$facts = New-TeamsFact -Facts @{STATE = "PASS";WORLD = "HARD"}
```

Generate some JSON...

```powershell
$json = New-TeamsAdaptiveCard -Header "Who Watches the Watchmen?" -MessageBody "<at>Jordan Benzing</at> - You have failed this city." -Failure -Mentions $mention -AsJson
```

Send the message. - I'm using a JSON file in gitignore to hold my URL for my webhook so the world doesn't get to see it. Sorry.

```powershell
$testConfig = Get-Content -Path .\testUrl.json | ConvertFrom-Json -Depth 5>> $restParams = @{
     Uri         = $testConfig.uri
     ContentType = $testConfig.ContentType
     Method      = $testConfig.Method
     Body        = $json
}
Invoke-WebRequest @restParams
```

Recive Message

![image](/images/FailedThisCity.png)
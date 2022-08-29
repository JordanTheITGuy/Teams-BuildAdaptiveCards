function New-TeamsFact {
    [CmdletBinding()]
    param(
        #TODO: Consider Pipeline Input, add examples and notes.
        [Parameter(HelpMessage = "A fact, or set of facts must ultimately be presented as a hashtable." , Mandatory = $false)]
        [hashtable]$Facts
    )
    begin {

    }
    process {
        $factArray = [System.Collections.Generic.List[psobject]]::New()
        foreach ($fact in $Facts.GetEnumerator()) {
            $fact = [fact]::New($fact.Name, $fact.Value)
            $factArray.Add($fact)
        }
        return [msgFactSet]::New($factArray)
    }
}
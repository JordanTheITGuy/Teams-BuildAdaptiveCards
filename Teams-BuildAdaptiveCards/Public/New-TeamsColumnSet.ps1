function New-TeamsColumnSet {
    [CmdletBinding()]
    param(
        [Parameter(HelpMessage = "Provide a PSobject for columns" , Mandatory = $false)]
        [psobject]$InputObject
    )
    $columnSet = [System.Collections.Generic.List[psobject]]::New()
    foreach ($item in $InputObject) {
        if ($InputObject.Count -gt 1) {
            if ([array]::indexof($InputObject, $item) -eq 0) {
                $properties = ($InputObject | Get-Member | Where-Object { $_.MemberType -eq "NoteProperty" -or $_.MemberType -eq "Property" }).Name
                $row = @(Foreach ($prop in $properties) {
                        $record = [teamsColumnRecord]::New($prop)
                        $record
                    })
                $fullRow = [teamsColumn]::New($row)
                $columnSet.Add($fullRow)
            }
            else {  
                $properties = ($InputObject | Get-Member | Where-Object { $_.MemberType -eq "NoteProperty" -or $_.MemberType -eq "Property" }).Name
                $row = @(Foreach ($prop in $properties) {
                        $record = [teamsColumnRecord]::New($item.$prop)
                        $record
                    })
                $fullRow = [teamsColumn]::New($row)
                $columnSet.Add($fullRow)
            }

        }
        else {
            $properties = ($InputObject | Get-Member | Where-Object { $_.MemberType -eq "NoteProperty" -or $_.MemberType -eq "Property" }).Name
            $row = @(Foreach ($prop in $properties) {
                    $record = [teamsColumnRecord]::New($item.$prop)
                    $record
                })
            $fullRow = [teamsColumn]::New($row)
            $columnSet.Add($fullRow)
        }
    }
    $result = [teamsColumnSet]::New($columnSet)
    return $result
}

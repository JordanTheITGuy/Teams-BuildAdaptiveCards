[cmdletbinding()]
param (
    [parameter(Mandatory = $false)]
    [System.IO.FileInfo]$modulePath = "./Teams-BuildAdaptiveCards",

    [parameter(Mandatory = $false)]
    [switch]$buildLocal
)

try {
    #region clear build dir if prod build triggered
    if (!$buildLocal) {
        Remove-Item "./bin" -Recurse -Force
    }
    #endregion
    #region Generate a new version number
    $moduleName = Split-Path -Path $modulePath -Leaf
    $PreviousVersion = Find-Module -Name $moduleName -ErrorAction SilentlyContinue | Select-Object *
    [Version]$exVer = $PreviousVersion ? $PreviousVersion.Version : $null
    if ($buildLocal) {
        $rev = ((Get-ChildItem -Path "$PSScriptRoot\bin\release\" -ErrorAction SilentlyContinue).Name | Measure-Object -Maximum | Select-Object -ExpandProperty Maximum) + 1
        $newVersion = New-Object -TypeName Version -ArgumentList 1, 0, 0, $rev
    }
    else {
        $newVersion = if ($exVer) {
            $rev = ($exVer.Revision + 1)
            New-Object version -ArgumentList $exVer.Major, $exVer.Minor, $exVer.Build, $rev
        }
        else {
            $rev = ((Get-ChildItem "$PSScriptRoot\bin\release\" -ErrorAction SilentlyContinue).Name | Measure-Object -Maximum | Select-Object -ExpandProperty Maximum) + 1
            New-Object Version -ArgumentList 1, 0, 0, $rev
        }
    }
    $releaseNotes = (Get-Content ".\$moduleName\ReleaseNotes.txt" -Raw -ErrorAction SilentlyContinue).Replace("{{NewVersion}}", $newVersion)
    if ($PreviousVersion) {
        $releaseNotes = @"
$releaseNotes

$($previousVersion.releaseNotes)
"@
    }
    #endregion

    #region Build out the release
    if ($buildLocal) {
        [System.IO.FileInfo]$relPath = Join-Path -Path "$PSScriptRoot" -ChildPath "bin\release\$rev\$moduleName"
    }
    else {
        [System.IO.FileInfo]$relPath = Join-Path -Path "$PSScriptRoot" -ChildPath "bin\release\$moduleName"
    }
    "Version is $newVersion"
    "Module path: $modulePath"
    "Module name: $moduleName"
    "Release path: $relPath"
    "Import module command: `"Import-Module ./bin/release/Teams-BuildAdaptiveCards/Teams-BuildAdaptiveCards.psm1`""
    if (!(Test-Path -Path $relPath)) {
        New-Item -Path $relPath -ItemType Directory -Force | Out-Null
    }

    Copy-Item -Path "$modulePath\*" -Destination "$relPath" -Recurse -Exclude ".gitKeep", "ReleaseNotes.txt"

    $Manifest = @{
        Path              = "$relPath\$moduleName.psd1"
        ModuleVersion     = $newVersion
        Description       = (Get-Content "./ModuleInfo/ModuleDescription.md" -Raw).ToString()
        FunctionsToExport = (Get-ChildItem -Path "$relPath\Public\*.ps1" -Recurse).BaseName
        ReleaseNotes      = $releaseNotes
    }
    Update-ModuleManifest @Manifest
}
catch {
    $_
}
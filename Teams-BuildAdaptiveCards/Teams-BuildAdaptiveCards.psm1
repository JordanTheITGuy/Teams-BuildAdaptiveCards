using module 'Classes\Teams-CardClasses.psm1'

#region Get public and private function definition files.
$public  = @(Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue)
#$Private = @(Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue)
#endregion
#region Dot source the files
foreach ($import in @($public))
{
    try
    {
        . $import.FullName
    }
    catch
    {
        Write-Error -Message "Failed to import function $($import.FullName): $_"
    }
}
#endregion
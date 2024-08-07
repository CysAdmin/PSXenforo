#Get public and private function definition files.
$Public  = @( Get-ChildItem -Path $PSScriptRoot\Public\ps1 -Filter *.ps1 -Recurse -ErrorAction SilentlyContinue )
$Private = @( Get-ChildItem -Path $PSScriptRoot\Private\ps1 -Filter *.ps1 -Recurse -ErrorAction SilentlyContinue )

#Dot source the files
Foreach($import in @($Public + $Private))
{
    Try
    {
        . $import.fullname
    }
    Catch
    {
        Write-Error -Message "Failed to import function $($import.fullname): $_"
    }
}

# Export the Public functions
Export-ModuleMember -Function $Public.Basename -Alias *
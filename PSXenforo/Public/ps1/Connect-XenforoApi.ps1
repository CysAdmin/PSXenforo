<#
.SYNOPSIS
Connect to the XenForo API.

.DESCRIPTION
This function connects to the XenForo API using the provided API key and base URL.
It validates the connection by making a test request to the API.

.PARAMETER ApiKey
The API key used for authentication with the XenForo API.

.PARAMETER ApiUrl
The base URL of the XenForo API.

.EXAMPLE
Connect-XenforoApi -ApiKey "your-api-key" -ApiUrl "https://your-xenforo-site.com/api"

.NOTES
Ensure you provide a valid API key and the correct base URL for your XenForo instance.
#>
Function Connect-XenforoApi {
    param(
        [Parameter(Mandatory = $true)]
        [string]$ApiKey,
        
        [Parameter(Mandatory = $true)]
        [string]$ApiUrl
    )
    
    begin {
        # Store the API key and URL globally for use by other functions
        $global:ApiKey = $ApiKey
        $global:ApiUrl = $ApiUrl
    }
    
    process {
        # Make a test request to validate the connection
        $result = Invoke-XenforoRequest -Method Get -Resource "/"
        
        # Check for errors in the response
        if ($result.psobject.Properties.Name.Contains("Error")) {
            return $result
        } else {
            # Create a custom object with the API connection details
            $object = [PSCustomObject]@{
                VersionId   = $result.version_id
                SiteTitle   = $result.site_title
                BaseUrl     = $result.base_url
                ApiUrl      = $result.api_url
                Key         = $result.key.type
            }
            # Return the custom object formatted as a table
            return $object | Format-Table
        }
    }
}

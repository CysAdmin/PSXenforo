<#
.SYNOPSIS
Retrieves alert details from a Xenforo forum using alert ID and user ID.

.DESCRIPTION
The Get-XenforoAlerts function queries a Xenforo forum to retrieve information about specific alerts by their ID and optionally filters by user ID.
It converts the API response into custom PowerShell objects with selected properties for better readability and usability.

.PARAMETER Id
The ID of the alert to retrieve. Must be a non-negative integer.

.PARAMETER UserId
The ID of the user for whom the alerts should be retrieved. Must be a non-negative integer. Default is 1.

.EXAMPLE
PS> Get-XenforoAlerts -Id 12345 -UserId 1

Retrieves the alert with ID 12345 for user ID 1 from the Xenforo forum and displays its details, such as the alert text, from user ID, and from username.

.EXAMPLE
PS> Get-XenforoAlerts -UserId 1

Retrieves all alerts for user ID 1 from the Xenforo forum and displays their details.

.NOTES
The function relies on Invoke-XenforoRequest to perform the actual API call to the Xenforo forum.
The custom object returned includes properties such as Action, AlertId, AlertText, EventDate, FromUserId, FromUsername, and ViewDate.
The default display properties are AlertText, FromUserId, and FromUsername.
#>
Function Get-XenforoAlerts {
    param(
        [ValidateScript({ $_ -as [int] -and $_ -ge 0 })]
        [ValidateNotNullOrEmpty()][string]$Id,
        [ValidateScript({ $_ -as [int] -and $_ -ge 0 })]
        [ValidateNotNullOrEmpty()][string]$UserId = 1
    )

    # Configure a default display set
    $defaultDisplaySet = 'AlertText', 'FromUserId', 'FromUsername'
    $defaultDisplayPropertySet = New-Object System.Management.Automation.PSPropertySet('DefaultDisplayPropertySet', [string[]]$defaultDisplaySet)
    $PSStandardMembers = [System.Management.Automation.PSMemberInfo[]]@($defaultDisplayPropertySet)

    Function Get-CustomObject {
        param (
            $Alert
        )

        $customObject = [PSCustomObject]@{
           Action           = $Alert.action
           AlertId          = $Alert.alert_id
           AlertText        = $Alert.alert_text
           EventDate        = [System.DateTimeOffset]::FromUnixTimeSeconds($Alert.event_date)
           FromUserId       = $Alert.user_id
           FromUsername     = $Alert.username
           ViewDate         = [System.DateTimeOffset]::FromUnixTimeSeconds($Alert.view_date)
        }
        $customObject | Add-Member MemberSet PSStandardMembers $PSStandardMembers
        return $customObject
    }

    if($Id){
        # Retrieve Alert details for the specified Id
        $result = Invoke-XenforoRequest -Method Get -Resource "/alerts/$($Id)" -UserId $UserId
        if($result.psobject.Properties.Name.Contains("Error")){
            return $result
        }
        return Get-CustomObject -Alert $result.alert 
    }else {
        # Retrieve details for all alerts
        $result = Invoke-XenforoRequest -Method Get -Resource "/alerts/" -UserId $UserId
        if($result.psobject.Properties.Name.Contains("Error")){
            return $result
        }
        $objectArray = $result.alerts | ForEach-Object { Get-CustomObject -Alert $_ }
        return $objectArray
    }

    
}
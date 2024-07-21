<#
.SYNOPSIS
Retrieves a specific post from a Xenforo forum using its ID.

.DESCRIPTION
The Get-XenforoPost function queries a Xenforo forum to retrieve information about a specific post by its ID. 
It converts the API response into custom PowerShell objects with specific properties to enhance readability and usability.

.PARAMETER Id
The ID of the post to retrieve. Must be a non-negative integer.

.EXAMPLE
PS> Get-XenforoPost -Id 12345

Retrieves the post with ID 12345 from the Xenforo forum and displays its details, such as the thread title, username, and post date.

.NOTES
The function relies on Invoke-XenforoRequest to perform the actual API call to the Xenforo forum.
The custom object returned includes properties such as CanEdit, IsLastPost, IsFirstPost, LastEditDate, Message, PostDate, ThreadId, ThreadTitle, UserId, and Username.
The default display properties are ThreadTitle, Username, and PostDate.
#>
Function Get-XenforoPost {
    param(
        [Parameter(Mandatory)]
        [ValidateScript({ $_ -as [int] -and $_ -ge 0 })]
        $Id
    )

    # Define the default properties to display
    $defaultDisplaySet = 'ThreadTitle', 'Username', 'PostDate'
    $defaultDisplayPropertySet = New-Object System.Management.Automation.PSPropertySet('DefaultDisplayPropertySet', [string[]]$defaultDisplaySet)
    $PSStandardMembers = [System.Management.Automation.PSMemberInfo[]]@($defaultDisplayPropertySet)

    # Function to convert the API thread objects to PowerShell custom objects with desired properties
    Function Get-CustomObject {
        param (
            $Post
        )

        $customObject = [PSCustomObject]@{
            CanEdit         = $Post.can_edit
            IsLastPost      = $Post.is_last_post
            IsFirstPost     = $Post.is_first_post
            LastEditDate    = [System.DateTimeOffset]::FromUnixTimeSeconds($Post.last_edit_date).DateTime
            Message         = $Post.Message
            PostDate        = [System.DateTimeOffset]::FromUnixTimeSeconds($Post.post_date).DateTime
            ThreadId        = $Post.thread_id
            ThreadTitle     = $Post.Thread.title
            UserId          = $Post.user_id
            Username        = $Post.username
        }

        # Add the default display properties to the custom object
        $customObject | Add-Member MemberSet PSStandardMembers $PSStandardMembers
        return $customObject
    }

    $result = Invoke-XenforoRequest -Method Get -Resource "/posts/$($Id)"

    # Check if the result contains an error and return it if present
    if ($result.psobject.Properties.Name.Contains("Error")) {
        return $result
    }

    # Convert the threads to custom objects and return them
    $objectArray = $result.post | ForEach-Object { Get-CustomObject -Post $_ }
    return $objectArray
}
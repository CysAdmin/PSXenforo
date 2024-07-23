<#
.SYNOPSIS
Retrieves threads from a specified XenForo forum or the latest threads.

.DESCRIPTION
This function retrieves threads from a specified XenForo forum or the latest threads if no forum ID is provided. It can handle pagination and returns custom objects with default and extended properties.

.PARAMETER ForumId
The ID of the forum from which to retrieve threads.

.PARAMETER Page
The page number to retrieve when pagination is needed.

.PARAMETER UserId
The User Id of the User which context is used for unread threads. Empty will result in current API User

.EXAMPLE
Get-XenforoThreads -ForumId 1

Retrieves the threads from the forum with ID 1.

.EXAMPLE
Get-XenforoThreads -ForumId 1 -Page 2

Retrieves the threads from the forum with ID 1, page 2.

.EXAMPLE
Get-XenforoThreads

Retrieves the threads from the What's New Section in the API calling User's context.

.NOTES
Ensure you have the necessary Permissions on the API Calling User.
#>
Function Get-XenforoThreads {
    [CmdletBinding(DefaultParameterSetName = "WhatsNewThreads")]
    param(
        # ForumId is mandatory when using the ForumThreads parameter set
        [Parameter(Mandatory, ParameterSetName = "ForumThreads")]
        [ValidateScript({$_ -ge 0 })]
        [int]$ForumId,

        # Page is optional and can be used with both parameter sets
        [Parameter(ParameterSetName = "ForumThreads")]
        [Parameter(ParameterSetName = "WhatsNewThreads")]
        [Parameter(ParameterSetName = "UnreadThreads")]
        [ValidateScript({ $_ -as [int] -and $_ -ge 0 })]
        [int]$Page,

        [Parameter(Mandatory, ParameterSetName = "UnreadThreads")]
        [switch]$UnreadThreads,

        [Parameter(Mandatory, ParameterSetName = "Pagination")]
        [Parameter(ParameterSetName = "UnreadThreads")]
        [switch]$Pagination,

        [ValidateScript({$_ -ge 0 })]
        [int]$UserId
    )

    # Define the default properties to display
    $defaultDisplaySet = 'ThreadId', 'ViewCount', 'OwnerName', 'OwnerId', 'ReplyCount', 'Title'
    $defaultDisplayPropertySet = New-Object System.Management.Automation.PSPropertySet('DefaultDisplayPropertySet', [string[]]$defaultDisplaySet)
    $PSStandardMembers = [System.Management.Automation.PSMemberInfo[]]@($defaultDisplayPropertySet)

    # Function to convert the API thread objects to PowerShell custom objects with desired properties
    Function Get-CustomObject {
        param (
            $Thread
        )

        $customObject = [PSCustomObject]@{
            CanEdit                 = $Thread.can_edit
            CanEditTags             = $Thread.can_edit_tags
            CanHardDelete           = $Thread.can_hard_delete
            CanReply                = $Thread.can_reply
            CanSoftDelete           = $Thread.can_soft_delete
            CanViewAttachements     = $Thread.can_view_attachments
            DiscussionOpen          = $Thread.discussion_open
            DiscussionType          = $Thread.discussion_Type
            DiscussionState         = $Thread.discussion_state
            FirstPostId             = $Thread.first_post_id
            IsUnread                = $Thread.is_unread
            LastPostDate            = [System.DateTimeOffset]::FromUnixTimeSeconds($Thread.last_post_date).DateTime
            LastPostId              = $Thread.last_post_id
            LastPostUserId          = $Thread.last_post_user_id
            LastPostUsername        = $Thread.last_post_username
            ThreadId                = $Thread.thread_id
            ReplyCount              = $Thread.reply_count
            OwnerName               = $Thread.username
            OwnerId                 = $Thread.user_id
            ViewCount               = $Thread.view_count
            Title                   = $Thread.title
        }

        # Add the default display properties to the custom object
        $customObject | Add-Member MemberSet PSStandardMembers $PSStandardMembers
        return $customObject
    }

    # Determine the resource URL based on the parameter set
    if ($PSCmdlet.ParameterSetName -eq "ForumThreads") {
        $resource = if ($Page) { "/forums/$($ForumId)/threads?page=$($Page)" } else { "/forums/$($ForumId)/threads" }
        $result = Invoke-XenforoRequest -Method Get -Resource $resource -UserId $UserId
    } elseif ($PSCmdlet.ParameterSetName -eq "WhatsNewThreads") {
        $resource = if ($Page) { "/threads?unread=true&page=$($Page)" } else { "/threads?unread=true"}
        $result = Invoke-XenforoRequest -Method Get -Resource $resource -UserId $UserId
    }elseif ($PSCmdlet.ParameterSetName -eq "UnreadThreads"){
        $resource = if ($Page) { "/threads?unread=true&page=$($Page)" } else { "/threads?unread=true"}
        $result = Invoke-XenforoRequest -Method Get -Resource $resource -UserId $UserId
        if($Pagination){
            return $result.pagination
        }
        
    }elseif ($PSCmdlet.ParameterSetName -eq "Pagination"){
        $resource = "/threads?unread=true"
        $result = Invoke-XenforoRequest -Method Get -Resource $resource -UserId $UserId
        return $result.pagination
    }

    # Check if the result contains an error and return it if present
    if ($result.psobject.Properties.Name.Contains("Error")) {
        return $result
    }

    # Convert the threads to custom objects and return them
    $objectArray = $result.threads | ForEach-Object { Get-CustomObject -Thread $_ }
    return $objectArray
}
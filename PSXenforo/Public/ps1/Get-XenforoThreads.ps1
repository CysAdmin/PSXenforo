<#
.SYNOPSIS
Retrieves threads from a specified XenForo forum or the latest threads.

.DESCRIPTION
This function retrieves threads from a specified XenForo forum or the latest threads if no forum ID is provided. It can handle pagination and returns custom objects with default and extended properties.

.PARAMETER ForumId
The ID of the forum from which to retrieve threads.

.PARAMETER Page
The page number to retrieve when pagination is needed.

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
Function Get-XenforoThreads{
    [CmdletBinding(DefaultParameterSetName = "WhatsNewThreads")]
    param(
        [Parameter(Mandatory, ParameterSetName = "ForumThreads")]
        [ValidateScript({ $_ -as [int] -and $_ -ge 0 })]
        $ForumId,

        [Parameter(ParameterSetName = "ForumThreads")]
        [Parameter(ParameterSetName = "WhatsNewThreads")]
        [ValidateScript({ $_ -as [int] -and $_ -ge 0 })]
        [int]$Page
    )
    

    $defaultDisplaySet = 'ThreadId', 'ViewCount', 'OwnerName', 'OwnerId', 'ReplyCount', 'Title'
    $defaultDisplayPropertySet = New-Object System.Management.Automation.PSPropertySet('DefaultDisplayPropertySet', [string[]]$defaultDisplaySet)
    $PSStandardMembers = [System.Management.Automation.PSMemberInfo[]]@($defaultDisplayPropertySet)

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
        $customObject | Add-Member MemberSet PSStandardMembers $PSStandardMembers
        return $customObject
    }
    if($PSCmdlet.ParameterSetName -eq "ForumThreads"){
        $resource = if ($Page) { "/forums/$($ForumId)/threads?page=$($Page)" } else { "/forums/$($ForumId)/threads" }
        $result = Invoke-XenforoRequest -Method Get -Resource $resource      
    }elseif($PSCmdlet.ParameterSetName -eq "WhatsNewThreads"){
        $result = Invoke-XenforoRequest -Method Get -Resource "/threads/"
    }

    if($result.psobject.Properties.Name.Contains("Error")){
        return $result
    }

    $objectArray = $result.threads | ForEach-Object { Get-CustomObject -Thread $_ }
    return $objectArray 
}
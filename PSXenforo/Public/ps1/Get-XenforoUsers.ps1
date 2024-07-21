<#
.SYNOPSIS
Retrieves user details from a Xenforo forum using various parameters.

.DESCRIPTION
The Get-XenforoUsers function queries a Xenforo forum to retrieve information about users by their ID, name, or email. 
It also supports retrieving all users with optional pagination. The function converts the API response into custom PowerShell objects with selected properties for better readability and usability.

.PARAMETER Id
The ID of the user to retrieve. Must be a non-negative integer.

.PARAMETER Name
The username of the user to retrieve. Must be a non-empty string.

.PARAMETER Email
The email of the user to retrieve. Must be a non-empty string.

.PARAMETER Page
The page number for retrieving all users with pagination. Must be a non-negative integer.

.EXAMPLE
PS> Get-XenforoUsers -Id 12345

Retrieves the user with ID 12345 from the Xenforo forum and displays their details.

.EXAMPLE
PS> Get-XenforoUsers -Name "JohnDoe"

Retrieves the user with the username "JohnDoe" from the Xenforo forum and displays their details.

.EXAMPLE
PS> Get-XenforoUsers -Email "john.doe@example.com"

Retrieves the user with the email "john.doe@example.com" from the Xenforo forum and displays their details.

.EXAMPLE
PS> Get-XenforoUsers -Page 2

Retrieves the second page of users from the Xenforo forum and displays their details.

.NOTES
The function relies on Invoke-XenforoRequest to perform the actual API call to the Xenforo forum.
The custom object returned includes properties such as ActivityVisible, CanBan, CanEdit, CanFollow, CanIgnore, CanPostProfile, CanViewProfile, CanViewProfilePosts, CanWarn, IsAdmin, IsBanned, IsDiscouraged, IsFollowed, IsIgnored, IsModerator, IsStaff, IsSuperAdmin, LastActivity, RegisterDate, UserId, UserState, UserTitle, and Username.
The default display properties are Username, UserId, IsBanned, IsAdmin, and UserState.
#>
Function Get-XenforoUsers{
    param(
        [Parameter(Mandatory, ParameterSetName = "ByID")]
        [ValidateScript({ $_ -as [int] -and $_ -ge 0 })]
        [ValidateNotNullOrEmpty()][string]$Id,                
        
        [Parameter(Mandatory, ParameterSetName = "ByName")]
        [ValidateNotNullOrEmpty()][string]$Name,

        [Parameter(Mandatory, ParameterSetName = "ByEmail")]
        [ValidateNotNullOrEmpty()][string]$Email,

        [Parameter(ParameterSetName = "AllUsers")]
        [ValidateScript({$_ -ge 0 })]
        [ValidateNotNullOrEmpty()][int]$Page
    )

    # Configure a default display set
    $defaultDisplaySet = 'Username', 'UserId', 'IsBanned', 'IsAdmin', 'UserState'
    $defaultDisplayPropertySet = New-Object System.Management.Automation.PSPropertySet('DefaultDisplayPropertySet', [string[]]$defaultDisplaySet)
    $PSStandardMembers = [System.Management.Automation.PSMemberInfo[]]@($defaultDisplayPropertySet)

    Function Get-CustomObject {
        param (
            $User
        )

        $customObject = [PSCustomObject]@{
            ActivityVisible         = $User.activity_visible
            CanBan                  = $User.can_ban
            CanEdit                 = $User.can_edit
            CanFollow               = $User.can_follow
            CanIgnore               = $User.can_ignore
            CanPostProfile          = $User.can_post_profile
            CanViewProfile          = $User.can_view_profile
            CanViewProfilePosts     = $User.can_view_profile_posts
            CanWarn                 = $User.can_warn
            IsAdmin                 = $User.is_admin
            IsBanned                = $User.is_banned
            IsDiscouraged           = $User.is_discouraged
            IsFollowed              = $User.is_followed
            IsIgnored               = $User.is_ignored
            IsModerator             = $User.is_moderator
            IsStaff                 = $User.is_staff
            IsSuperAdmin            = $User.is_super_admin
            LastActivity            = [System.DateTimeOffset]::FromUnixTimeSeconds($User.last_activity)
            RegisterDate            = [System.DateTimeOffset]::FromUnixTimeSeconds($User.register_date)
            UserId                  = $User.user_id
            UserState               = $User.user_state
            UserTitle               = $User.user_title
            Username                = $User.username
        }
        $customObject | Add-Member MemberSet PSStandardMembers $PSStandardMembers
        return $customObject
    }

    if ($Id) {
        # Retrieve User by UserID
        $result = Invoke-XenforoRequest -Method Get -Resource "/users/$($Id)"
        if($result.psobject.Properties.Name.Contains("Error")){
            return $result
        }
        return Get-CustomObject -User $result.user
    } elseif ($Email) {
        # Retrieve User by Email 
        $result = Invoke-XenforoRequest -Method Get -Resource "/users/find-email?email=$($Email)"
        if($result.psobject.Properties.Name.Contains("Error")){
            return $result
        }
        return Get-CustomObject -User $result.user
    } elseif ($Name) {
        # Retrieve User by Username
        $result = Invoke-XenforoRequest -Method Get -Resource "/users/find-name?username=$($Name)"
        if($result.psobject.Properties.Name.Contains("Error")){
            return $result
        }
        return Get-CustomObject -User $result.exact
    }else{
        # Retrieve all Users
        $resource = if($Page){"/users/?page=$($Page)"} else {"/users"}
        $result = Invoke-XenforoRequest -Method Get -Resource $resource
        if($result.psobject.Properties.Name.Contains("Error")){
            return $result
        }
        $objectArray = $result.users | ForEach-Object { Get-CustomObject -User $_ }
        return $objectArray
    }
}
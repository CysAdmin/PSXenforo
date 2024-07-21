<#
.SYNOPSIS
Retrieves details of a specific forum node from a Xenforo forum using its ID.

.DESCRIPTION
The Get-XenforoForum function queries a Xenforo forum to retrieve information about a specific forum node by its ID. 
It converts the API response into a custom PowerShell object with selected properties for better readability and usability.

.PARAMETER Id
The ID of the forum node to retrieve. Must be a non-negative integer.

.EXAMPLE
PS> Get-XenforoForum -Id 123

Retrieves the forum node with ID 123 from the Xenforo forum and displays its details, such as the node title, parent node title, and parent node ID.

.NOTES
The function relies on Invoke-XenforoRequest to perform the actual API call to the Xenforo forum.
The custom object returned includes properties such as NodeId, NodeTitle, ParentNodeId, and ParentNodeTitle.
The default display properties are NodeTitle, ParentNodeTitle, and ParentNodeId.
#>
Function Get-XenforoForum {
    param(
        [Parameter(Mandatory)]
        [ValidateScript({ $_ -as [int] -and $_ -ge 0 })]
        [ValidateNotNullOrEmpty()][string]$Id
    )

    # Configure a default display set
    $defaultDisplaySet = 'NodeTitle', 'ParentNodeTitle', 'ParentNodeId'
    $defaultDisplayPropertySet = New-Object System.Management.Automation.PSPropertySet('DefaultDisplayPropertySet', [string[]]$defaultDisplaySet)
    $PSStandardMembers = [System.Management.Automation.PSMemberInfo[]]@($defaultDisplayPropertySet)

    Function Get-CustomObject {
        param (
            $Forum
        )

        $customObject = [PSCustomObject]@{
            NodeId              = $Forum.node_id
            NodeTitle           = $Forum.title
            ParentNodeId        = $Forum.parent_node_id
            ParentNodeTitle     = $Forum.breadcrumbs.title
        }
        $customObject | Add-Member MemberSet PSStandardMembers $PSStandardMembers
        return $customObject
    }

    # Retrieve Forum details for the specified Id
    $result = Invoke-XenforoRequest -Method Get -Resource "/forums/$($Id)"
    if($result.psobject.Properties.Name.Contains("Error")){
        return $result
    }
    return Get-CustomObject -Forum $result.forum 
}

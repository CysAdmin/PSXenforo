<#
.SYNOPSIS
Retrieve Xenforo nodes information based on the provided Id or all nodes.

.DESCRIPTION
This function retrieves node information from Xenforo based on the specified Id or returns all nodes if no Id is provided.
Default Output Attributes 'Title', 'NodeId', 'NodeTypeId'. If you need more, check with select-object *

.PARAMETER Id
[OPTIONAL] Specifies the Id of the node to retrieve. Must be a non-negative integer.

.EXAMPLE
Get-XenforoNodes -Id 123
Retrieve details for the Xenforo node with Id 123.

.EXAMPLE
Get-XenforoNodes
Retrieve details for all Xenforo nodes.

#>
Function Get-XenforoNodes {
    param(
        [ValidateScript({ $_ -as [int] -and $_ -ge 0 })]
        [ValidateNotNullOrEmpty()][string]$Id
    )

    # Configure a default display set
    $defaultDisplaySet = 'Title', 'NodeId', 'NodeTypeId'
    $defaultDisplayPropertySet = New-Object System.Management.Automation.PSPropertySet('DefaultDisplayPropertySet', [string[]]$defaultDisplaySet)
    $PSStandardMembers = [System.Management.Automation.PSMemberInfo[]]@($defaultDisplayPropertySet)

    Function Get-CustomObject {
        param (
            $Node
        )

        $customObject = [PSCustomObject]@{
            DisplayInList   = $Node.display_in_list
            NodeTypeId      = $Node.node_type_id
            ParentNodeId    = $Node.parent_node_id
            ParentNodeTitle = $Node.breadcrumbs.title
            Title           = $Node.Title
            NodeId          = $Node.node_id
            Description     = $Node.Description
            DisplayOrder    = $Node.display_order
        }
        $customObject | Add-Member MemberSet PSStandardMembers $PSStandardMembers
        return $customObject
    }

    if ($Id) {
        # Retrieve node details for the specified Id
        $result = Invoke-XenforoRequest -Method Get -Resource "/nodes/$($Id)"
        return Get-CustomObject -Node $result.node
    } else {
        # Retrieve details for all nodes
        $result = Invoke-XenforoRequest -Method Get -Resource "/nodes/"
        $objectArray = $result.nodes | ForEach-Object { Get-CustomObject -Node $_ }
        return $objectArray
    }
}

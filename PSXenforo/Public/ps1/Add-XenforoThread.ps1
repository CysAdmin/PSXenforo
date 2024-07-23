Function Add-XenforoThread{
    param(
        [Parameter(Mandatory)]         
        [ValidateNotNullOrEmpty()] [int] $NodeId,

        [Parameter(Mandatory)] 
        [ValidateNotNullOrEmpty()] [string] $Content,

        [Parameter(Mandatory)] 
        [ValidateNotNullOrEmpty()] [string] $Title,

        [Parameter(Mandatory)] 
        [ValidateNotNullOrEmpty()] [string] $UserId
    )

    $Data = @{
        "node_id"   = $NodeId
        "title"     = $Title
        "message"   = $Content
    }
    
    return Invoke-XenforoRequest -Method Post -Resource "/threads" -Data $Data -UserId $UserId
}
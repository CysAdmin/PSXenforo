Function Add-XenforoPost{
    param(
        [Parameter(Mandatory)]         
        [ValidateNotNullOrEmpty()] [int] $ThreadId,

        [Parameter(Mandatory)] 
        [ValidateNotNullOrEmpty()] [string] $Content,

        [Parameter(Mandatory)] 
        [ValidateNotNullOrEmpty()] [string] $UserId
    )

    $Data = @{
        "thread_id" = $Thread
        "message"   = $Content
    }
    
    return Invoke-XenforoRequest -Method Post -Resource "/posts" -Data $Data -UserId $UserId
}
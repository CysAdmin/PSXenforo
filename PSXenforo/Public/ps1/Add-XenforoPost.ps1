Function Add-XenforoPost{
    param(
        [Parameter(Mandatory)]         
        [ValidateNotNullOrEmpty()] [int] $ThreadId,

        [Parameter(Mandatory)] 
        [ValidateNotNullOrEmpty()] [string] $Content,

        [Parameter(Mandatory)] 
        [ValidateNotNullOrEmpty()] [string] $UserId
    )
    begin{
        $Data = @{
            "thread_id" = $ThreadId
            "message"   = $Content
        }        
    }    
    process{
        return Invoke-XenforoRequest -Method Post -Resource "/posts" -Data $Data -UserId $UserId
    }
    
    
}
Function Add-XenforoAlert{
    param(
        [Parameter(Mandatory)]         
        [ValidateNotNullOrEmpty()] [int] $ToUserId,

        [Parameter(Mandatory)] 
        [ValidateNotNullOrEmpty()] [string] $Content,

        [Parameter(Mandatory)] 
        [ValidateNotNullOrEmpty()] [string] $FromUserId
    )
    
    $resource = "/alerts?to_user_id=$($ToUserId)&alert=$($Content)"

    return Invoke-XenforoRequest -Method Post -Resource $resource -UserId $FromUserId
}
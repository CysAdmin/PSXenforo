Function Set-XenforoThreadRead{
    param(
        [Parameter(Mandatory)] 
        [ValidateNotNullOrEmpty()] [string] $ThreadId,

        [ValidateNotNullOrEmpty()] [string] $UserId
    )
    
    if($UserId){
        return Invoke-XenforoRequest -Method Post -Resource "/threads/$($ThreadId)/mark-read" -UserId $UserId
    }else{
        return Invoke-XenforoRequest -Method Post -Resource "/threads/$($ThreadId)/mark-read"
    }
    
}
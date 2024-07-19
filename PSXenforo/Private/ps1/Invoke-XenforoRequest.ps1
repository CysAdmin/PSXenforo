Function Invoke-XenforoRequest{
    param(
        [Parameter(Mandatory)]
        [ValidateSet("Get", "Post", "Put", "Delete")]
        [string]$Method,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Resource,

        [ValidateNotNullOrEmpty()]
        [string]$UserId = 1
    )
    $ApiKey = Get-XenforoApiKey
    $Uri = (Get-XenforoApiUrl) + $Resource
    $headers = @{
        'XF-Api-Key'    = $ApiKey        
        'XF-Api-User'   = $UserId
    }
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    try {
        $result = Invoke-RestMethod -Method $Method -Uri $Uri -Headers $headers
    }
    catch {
        if($_.ErrorDetails.Message){
            return Get-XenforoError -ErrorMessage ($_.ErrorDetails.Message | ConvertFrom-Json ).errors.Message
        }else{
            return Get-XenforoError -ErrorMessage $_.Exception.Response.ReasonPhrase
        }        
    }
    
    return $result
}
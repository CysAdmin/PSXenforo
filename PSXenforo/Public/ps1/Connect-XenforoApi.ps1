Function Connect-XenforoApi{
    param(
        [string]$ApiKey,
        [string]$ApiUrl
    )
    begin{
        $global:ApiKey = $ApiKey
        $global:ApiUrl = $ApiUrl
    }
    process{
        $result =  Invoke-XenforoRequest -Method Get -Resource "/"
    if($result.psobject.Properties.Name.Contains("Error")){
        return $result
    }else{
        $object = [PSCustomObject]@{
            VersionId   = $result.version_id
            SiteTitle   = $result.site_title
            BaseUrl     = $result.base_url
            ApiUrl      = $result.api_url
            Key         = $result.key.type
        }
        return $object | Format-Table
    }
    }
    
    
}
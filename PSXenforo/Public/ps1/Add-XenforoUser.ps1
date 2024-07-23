Function Add-XenforoUser{
    param(
        [Parameter(Mandatory)]         
        [ValidateNotNullOrEmpty()] [string] $Username,

        [Parameter(Mandatory)] 
        [ValidateNotNullOrEmpty()] [string] $EmailAddress,

        [Parameter(Mandatory)] 
        [ValidateNotNullOrEmpty()] [string] $Password
    )

    $Data = @{
        "username"      = $RandomUser
        "email"         = $Email
        "password"      = $Password
    }
    
    return Invoke-XenforoRequest -Method Post -Resource "/users" -Data $Data
}
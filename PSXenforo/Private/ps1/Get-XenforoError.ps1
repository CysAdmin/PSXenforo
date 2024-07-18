Function Get-XenforoError {
    param(
        [string]$ErrorMessage
    )
    $errorObject = New-Object psobject
    $errorObject | Add-Member -MemberType NoteProperty -Name "Error" -Value $ErrorMessage
    return $errorObject
}
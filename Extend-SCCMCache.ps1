####
# This script can be used to extend the SCCM Cache remotly!
###
$pc = "PC-NAME" # Write pc names!
$cacheSizeMB = 270000  # change the value


$session = New-PSSession -ComputerName $pc

$scriptBlock = {
    param($cacheSizeMB)

    $currentCacheSize = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoftc" -Name "CacheSize"
  
    if ($currentCacheSize.CacheSize -lt $cacheSizeMB) {
     
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\SMS\Mobile Client" -Name "CacheSize" -Value $cacheSizeMB

        Write-Host "SCCM cache size increased to $cacheSizeMB MB."
    } else {
        Write-Host "SCCM cache size is already equal to or greater than $cacheSizeMB MB."
    }
}


Invoke-Command -Session $session -ScriptBlock $scriptBlock -ArgumentList $cacheSizeMB


Remove-PSSession $session

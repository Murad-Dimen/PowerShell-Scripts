######
# This script will copy a folder/file! 
######
$PCList =  @("PC-NAME")  # Write pc names! separate them with comma!


$ScriptBlock = {
    param ($PC)
    ## You need to change the path 
    $stat = Copy-Item -Path "Source Path"  -Destination "Destination Path" -Recurse -Container -Force
    if ($stat) {
        Write-Host "$PC : $stat"
    } else {
        Write-Host "$PC : Copy failed"
    }
}

   foreach ($PC in $PCList) {
      Start-Job -ScriptBlock $ScriptBlock -ArgumentList $PC
   }

   Get-Job | Wait-Job

   Get-Job | Receive-Job

   Get-Job | Remove-Job
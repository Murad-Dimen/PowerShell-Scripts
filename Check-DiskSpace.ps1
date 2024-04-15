######
# This script will display the free disk space for a pc or a set of pcs
######
$PCList =  @("PC-NAME") # Write pc names! separate them with comma!

foreach ($pc in $PCList) {
    $scriptBlock = {
        $freeSpaceGB = (Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Root -eq "C:\" }).Free / 1GB
        $freeSpaceGB
    }

    $freeSpace = Invoke-Command -ComputerName $pc -ScriptBlock $scriptBlock

    Write-Host "Free disk space on $pc : $($freeSpace) GB"
}
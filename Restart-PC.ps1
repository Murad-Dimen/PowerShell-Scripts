######
# This script will restart pc remotely!!
######

$PCList =  @("PC-NAME")  # Write pc names! separate them with comma!

# Remember to change the list name
foreach ( $PC in $PCList)
	{      
        $stat = Restart-Computer -ComputerName $PC -Wait -For PowerShell -Timeout 300 -Delay 2
        if ($stat -eq "Failed") {
            Write-Host "Failed to restart computer: $PC"
        } else {
            Write-Host "Computer $PC restarted successfully."
        }
    }
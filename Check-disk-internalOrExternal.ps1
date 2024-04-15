###
# Check if the disk in a specific pc if it an external or internal disk!
###
$PCList =  @("PC-NAME")  # Write pc names! separate them with comma!

foreach ($computer in $PCList) {
    try {
        $disks = Get-CimInstance -ClassName Win32_DiskDrive -ComputerName $computer
        foreach ($disk in $disks) {
            $driveLetter = ($disk.DeviceID -split "\\")[2]

            if ($disk.MediaType -eq "Fixed hard disk media") {
                $diskType = "Internal"
            } else {
                $diskType = "External"
            }

            Write-Host "PC Name:$computer, Drive Letter: $($disk.DeviceID), Disk Type: $diskType"
        }
    } catch {
        Write-Host "Failed to retrieve disk information from $computer."
    }
}

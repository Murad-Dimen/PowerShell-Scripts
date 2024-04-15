####
# This script will implement the bitlocker encryption on the specified disk.
####

$PCList =  @("PC-NAME")  # Write pc names! separate them with comma!

foreach ($computer in $PCList) {
    Write-Host "Encrypting disk on $computer..."
    ## NB! Remember to change the disk name/letter!
    $encryptionCommand = "Enable-BitLocker -MountPoint 'D:' -RecoveryPasswordProtector -UsedSpaceOnly -SkipHardwareTest"

    Invoke-Command -ComputerName $computer -ScriptBlock {
        param ($cmd)
        Invoke-Expression $cmd
    } -ArgumentList $encryptionCommand

    Write-Host "Disk encryption started on $computer"
}


##
# You can use this to put your own password!!
###

#$computers = Get-Content 'C:\ComputerList.txt'

#$bitlockerPassword = ""

#foreach ($computer in $computers) {
#    Write-Host "Encrypting disk on $computer..."
    
#    $encryptionCommand = "Enable-BitLocker -MountPoint 'C:' -Password $bitlockerPassword -UsedSpaceOnly -SkipHardwareTest"

#    Invoke-Command -ComputerName $computer -ScriptBlock {
#        param ($cmd)
#        Invoke-Expression $cmd
#    } -ArgumentList $encryptionCommand

#    Write-Host "Disk encryption started on $computer"
#}

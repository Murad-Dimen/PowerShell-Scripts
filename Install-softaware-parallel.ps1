########
# This script will install a program on multiple computers at the same time silently!
# You can add multiple software at the same time!
#########

$PCList =  @("PC-NAME")  # Write pc names! separate them with comma!


$ScriptBlock = {
    # Exempel of installing Slide Viewer silently and remotely of a single or a sett of PCs.
    # NB! Remember to change the path to where you downloaded file is.

    #Slide viewer
    Start-Process "C:\temp\Install\SlideViewer\SlideViewer_2.6_RTM_v2.6.0.166179_x64.exe" -ArgumentList  /S -Wait -NoNewWindow 
    
    # Another exempel og .msi software!
    #Move suite
    (Start-Process "msiexec" -ArgumentList "/i C:\temp\install\Move\MoveLink2022ForPetrel2021.msi /quiet /norestart" -Wait -Passthru).ExitCode
    
}

$Jobs = @()
foreach ($PC in $PCList) {
    $Jobs += Invoke-Command -ComputerName $PC -ScriptBlock $ScriptBlock -AsJob
}

$Jobs | Wait-Job

$Jobs | Receive-Job
$Jobs | Remove-Job
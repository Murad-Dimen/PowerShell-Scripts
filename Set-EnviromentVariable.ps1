#####
# The script will set an Environment Variables on a single or a set of PCs!
# You need to have the license variable name and its value!
# You can check the EnvVariables by going to (Advanced System Setting -> Environment variables)
####
$PCList =  @("PC-NAME")  # Write pc names! separate them with comma!

##Exempel license Variables remember to change them
$licenseVariables = @(
    @{ Name = "LICENSE_ONE_LICENSE_FILE"; Value = "VALUE" },
    @{ Name = "LICENSE_TWO_LICENSE_FILE"; Value = "VALUE" }
)

# Remember to change the list name
foreach ($PC in $PCList) {
    Invoke-Command -ComputerName $PC -ScriptBlock {
        
        param($vars, $computerName)
        Write-Host "$($computerName)"

        foreach ($var in $vars) { 
            [System.Environment]::SetEnvironmentVariable($var.Name, $var.Value, [System.EnvironmentVariableTarget]::Machine)
            Write-Host "Setting $($var.Name) to $($var.Value)"
        } 
    } -ArgumentList $licenseVariables, $PC
}
#######
# This script checks Microsoft licensing information for a user in you company!
######

##########
# Run the following command as an administrator to establish a connection
# with Microsoft Online Services.
#
# command:

# Install-Module -Name MSOnline 
# Import-Module MSOnline
# Connect-MsolService 
##########

########
# Once the connection is established, you can execute the script!
###############

$mailDomain = "@Test.com"  #Change the mail-domain if you need!
$usernames =  "UserName"     # You can use it to retrieve a single user license
                      
#Get-Content -Path ".\username.txt" #You can use it to retrieve a group of users. NB! change the file name if you need!

foreach ($username in $usernames) {
    $userPrincipalName = $username + $mailDomain   

    Get-MsolUser -UserPrincipalName $userPrincipalName | Select-Object -Property DisplayName, Licenses, UserPrincipalName 
}  


## If you want to Write the output to a .txt file use the following script

#foreach ($username in $usernames) {
#    $userPrincipalName = $username + $mailDomain   

#    Get-MsolUser -UserPrincipalName $userPrincipalName | Select-Object -Property DisplayName, Licenses, UserPrincipalName | Format-Table -AutoSize | Out-File -FilePath "UserLicenseInfo.txt" -Append
#}

 








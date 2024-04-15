######
# This script will check the disk encryption on a singel or a set of PCs, and the write the output to a HTML file that will be easier for us to read it.
# The file will display the output in a form of tables!
# Se the exempel DiskEncryptionReport1.html file!
######

[CmdletBinding()]
Param (
    [Parameter(ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
    [Alias("Servers")]
    [string[]]$Name = @("PC-NAME"),  # Write pc names! separate them with comma!
    [int]$AlertThreshold = 10,
    [string]$Path = ".\DiskEncryptionReport1.html"  # The output will be wrten to this file!
)

Begin {
    Write-Verbose "$(Get-Date): Script begins!"

    
    $HeaderHTML = @"
    <html>
    <head>
    <style type='text/css'>
    body { background-color:#DCDCDC; }
    table { border:1px solid gray; font:normal 12px verdana, arial, helvetica, sans-serif; border-collapse: collapse; padding-left:30px; padding-right:30px; }
    th { color:black; text-align:left; border: 1px solid black; font:normal 16px verdana, arial, helvetica, sans-serif; font-weight:bold; background-color: #6495ED; padding-left:6px; padding-right:6px; }
    td.up { background-color:#32CD32; border: 1px solid black; }
    td.down { background-color:#B22222; border: 1px solid black; }
    td { border: 1px solid black; padding-left:6px; padding-right:6px; }
    div.red { background-color:#B22222; float:left; text-align:right; }
    div.green { background-color:#32CD32; float:left; }
    div.free { background-color:#7FFF00; float:left; text-align:right; }
    a.detail { cursor:pointer; color:#1E90FF; text-decoration:underline; }
    </style>
    </head>
    <body>
    <h1>Disk Encryption Status Report</h1>
    <p>
    <table class="Main">
    <tr><th style="width:175px;">Computer Name</th><th style="width:175px;">Drive Letter</th><th>Encrypted</th></tr>
"@

    $FooterHTML = @"
    </table>
    </body>
    </html>
"@

    $DiskDetailHTML = ""
    $WmiErrorDetails = @()
}

Process {
    Write-Verbose "Processing computers..."
  
    ForEach ($Computer in $Name) {
        Write-Verbose "Testing $Computer..."
        $ErrorReport = $null
        If (Test-Connection $Computer -Quiet) {
        
            Try {
                $Disks = Invoke-Command -ComputerName $Computer -ScriptBlock {
                    Get-BitLockerVolume | Select-Object `
                        @{LABEL="ComputerName";EXPRESSION={$env:COMPUTERNAME}},
                        MountPoint,
                        @{LABEL="Encrypted";EXPRESSION={$_.ProtectionStatus -eq 'On'}}
                } -ErrorAction Stop

                foreach ($disk in $Disks) {
                    $ComputerName = $disk.ComputerName
                    $DriveLetter = $disk.MountPoint
                    $Encrypted = $disk.Encrypted

                    if ($Encrypted) {
                        $EncryptedHtml = "<td class='up'>True</td>"
                    } else {
                        $EncryptedHtml = "<td class='down'>False</td>"
                    }

                    $DiskDetailHTML += "<tr><td>$ComputerName</td><td>$DriveLetter</td>$EncryptedHtml</tr>"
                }
            }
            Catch {
                Write-Verbose "Error encountered gathering information for $Computer"
                $ErrorReport = $Error[0]
                $WmiErrorDetails += "Computer: $Computer`nError: $ErrorReport`n`n"
                $Error.Clear() | Out-Null
            }

            If ($ErrorReport) {
                Write-Verbose "WMI Error for $Computer : $ErrorReport"
                $WmiErrorDetails += "Computer: $Computer`nError: $ErrorReport`n`n"
            }
        } Else {
            Write-Verbose "$Computer is not reachable."
            $DiskDetailHTML += "<tr><td><font color='red'>$Computer (Inactive)</font></td><td></td><td></td></tr>"
        }
    }
}

End {
    Write-Verbose "Generating HTML report..."
  
    $HTML = $HeaderHTML + $DiskDetailHTML + $FooterHTML
    $HTML | Out-File $Path

    Write-Verbose "$(Get-Date): Script completed!"
}

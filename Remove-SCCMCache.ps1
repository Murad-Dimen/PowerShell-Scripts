
######
# This script will remove the SCCM-Caceh!!
######
$PCList =  @("PC-NAME")  # Write pc names! separate them with comma!

# Remember to change the list name
foreach ( $PC in $PCList)
	{  
        #Lager en remote-session med hver enhet
        $session = New-PSSession -ComputerName $PC
        # Bruker Invoke-Command for å kjøre scripte på PC'en
        Invoke-Command -Session  $session -ScriptBlock{

            ## Initialize the CCM resource manager com object
            $CCMComObject = New-Object -ComObject 'UIResource.UIResourceMgr'
            ## Get the CacheElementIDs to delete
            $CacheInfo = $CCMComObject.GetCacheInfo().GetCacheElements()
            ## Remove cache items
            ForEach ($CacheItem in $CacheInfo) {
               $null = $CCMComObject.GetCacheInfo().DeleteCacheElement([string]$($CacheItem.CacheElementID))
               

            }

     
        }
    }
# The original script for Provisioning of SQL Server Azure VM was created by Sourabh Agrawal and Amit Banerjee
# The script is modified by Parikshit Savjani to suit the readers of the book SQL on Azure Succintly

#Create and Attach the Disks
Write-Host "`n[INFO] - Script is creating and attaching 4  data disks, Please wait." -ForegroundColor Yellow
for($i = 0; $i -lt 4; $i++) 
{
    $disklabel = "disk$VMName"
    $diskname = $disklabel + $i.ToString() 
    Add-AzureDataDisk -VM $vm -CreateNew -DiskSizeInGB 20 -DiskLabel $diskname -LUN $i -HostCaching None | out-null
}        
$vm | Update-AzureVM | out-null

#Make Sure all Disks are attached and working..
$vm = Get-AzureVM -Name $VMName -ServiceName $ServiceName
[array]$CreatedDataDisks = Get-AzureDataDisk -VM $vm
$CreatedDataDisksCount = $CreatedDataDisks.Count

If($CreatedDataDisksCount -eq 4)
{
    Write-Host "`nDisk Creation Successfull - All 4 disks are up and running" -ForegroundColor Green
}
else
{
    Write-Host "`nData disk creation failed " -ForegroundColor Red
    Exit
}

# check to make sure vm is done building

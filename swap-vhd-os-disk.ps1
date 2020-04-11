Login-AzAccount

$RGName = "testRG"
$VMName = "testVM"


$New_OSDISK = "VHD_URL_PATH_OF_BLOB_STORAGE"

#$VM = Get-AzureRMVM -Name $VMName -ResourceGroupName $RGName

$VM = Get-AzVM -Name $VMName -ResourceGroupName $RGName

#Stop-AzureRmVM -Name $VM.Name -ResourceGroupName $VM.ResourceGroupName -Force

Stop-AzVM -Name $VM.Name -ResourceGroupName $VM.ResourceGroupName -Force

$VM.StorageProfile.OsDisk.Vhd.Uri = $New_OSDISK

#Update-AzureRmVM -VM $VM -ResourceGroupName $RGName

Update-AzVM -VM $VM -ResourceGroupName $RGName

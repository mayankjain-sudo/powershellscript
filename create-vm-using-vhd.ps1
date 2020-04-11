# Variables for the Resource Group, Networking and the Virtual Machine
$ResourceGroupName  ="TestRG"
$Location = "Central India"
$VMName = "testvm"

# Retreived from storage account in Azure Portal after VHD upload
$OSDiskUri = "VHD_URL_PATH_OF_BLOB_STORAGE"
$VMSize = "Standard_DS1_v2"
 
# Networking 
$SubnetName = "testvm-Subnet"  
$InterfaceName = "testvm-NIC1"
$VNetName = "testvm-VNet"  
$VNetResourceGroupName = "TestRG"
$OSDiskName = $VMName

# Login to Azure
#Login-AzAccount

# Networking
# Create Network Security Group, Subnet and Virtual Network
$NSG = New-AzNetworkSecurityGroup -Name $ResourceGroupName -ResourceGroupName $ResourceGroupName -Location $Location 
$Subnet = New-AzVirtualNetworkSubnetConfig -Name $SubnetName -AddressPrefix 10.0.0.0/24 -NetworkSecurityGroup $NSG
$VNet = New-AzVirtualNetwork -Name $VNetName -ResourceGroupName $VNetResourceGroupName -Location $Location -AddressPrefix 10.0.0.0/16 -Subnet $Subnet 

# Create the Interface
$pip = New-AzPublicIpAddress -Name "$VMName-IP" -ResourceGroupName $ResourceGroupName -Location $Location -AllocationMethod Dynamic
$Interface  = New-AzNetworkInterface -Name $InterfaceName -ResourceGroupName $ResourceGroupName -Location $Location -SubnetId $vnet.Subnets[0].Id -PublicIpAddressId $pip.Id

# VM Details 
$VirtualMachine  = New-AzVMConfig -VMName $VMName -VMSize $VMSize # -AvailabilitySetID $AvailabilitySet.Id
$VirtualMachine  = Add-AzVMNetworkInterface -VM $VirtualMachine -Id $Interface.Id
$VirtualMachine  = Set-AzVMOSDisk -VM $VirtualMachine -Name $OSDiskName -VhdUri $OSDiskUri -CreateOption Attach -Linux

# Create the VM in Azure
New-AzVM -ResourceGroupName $ResourceGroupName -Location $Location -VM $VirtualMachine

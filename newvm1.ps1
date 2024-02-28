# Define variables
$resourceGroupName = "rg_007"
$location = "EastUS"
$vnetName = "vn_007"
$subnetName = "SN001"
$vmName = "myVM"
$username = "azadmin"  # Replace with your desired username
$password = "Password@123"  # Replace with your desired password

# Create a new resource group (if necessary)
New-AzResourceGroup -Name $resourceGroupName -Location $location

# Create a virtual network
$vnet = New-AzVirtualNetwork -ResourceGroupName $resourceGroupName -Location $location -Name $vnetName -AddressPrefix "10.0.0.0/16"

# Create a subnet
$subnet = Add-AzVirtualNetworkSubnetConfig -Name $subnetName -AddressPrefix "10.0.0.0/17" -VirtualNetwork $vnet
Set-AzVirtualNetwork -VirtualNetwork $vnet

# Create a new network security group
$networkSecurityGroupName = "myNetworkSecurityGroup"
$networkSecurityGroup = New-AzNetworkSecurityGroup -ResourceGroupName $resourceGroupName -Location $location -Name $networkSecurityGroupName

# Open ports 80 and 3389 in the network security group
$networkSecurityGroup | Add-AzNetworkSecurityRuleConfig -Name "HTTP" -Description "Allow HTTP" -Access Allow -Protocol Tcp -Direction Inbound -Priority 100 -SourceAddressPrefix * -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 80
$networkSecurityGroup | Add-AzNetworkSecurityRuleConfig -Name "RDP" -Description "Allow RDP" -Access Allow -Protocol Tcp -Direction Inbound -Priority 200 -SourceAddressPrefix * -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 3389
$networkSecurityGroup | Set-AzNetworkSecurityGroup

# Create a credential object
$cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $username, (ConvertTo-SecureString -String $password -AsPlainText -Force)

# Create a virtual machine
New-AzVm -ResourceGroupName $resourceGroupName -Name $vmName -Location $location -Image "MicrosoftWindowsServer:WindowsServer:2022-datacenter-azure-edition:latest" -VirtualNetworkName $vnetName -SubnetName $subnetName -SecurityGroupName $networkSecurityGroupName -OpenPorts 80,3389 -Credential $cred

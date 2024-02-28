# Define variables
$resourceGroupName = "rg_117"
$location = "EastUS"
$vnetName = "vn_007"
$subnetName = "SN001"
$adminUsername = "adminUser"
$adminPassword = "P@ssw0rd123"  # Replace with your desired password

# Prompt the user to enter the number of VMs to create
$numberOfVMs = Read-Host "Enter the number of VMs to create"

# Create an array to store VM configurations
$vmConfigurations = @()

# Populate the array with VM configurations
for ($i = 1; $i -le $numberOfVMs; $i++) {
    $vmConfigurations += @{
        Name = "vm$i"
        Image = "MicrosoftWindowsServer:WindowsServer:2022-datacenter-azure-edition:latest"
        OpenPorts = 80, 3389
    }
}

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

# Create virtual machines
foreach ($vmConfig in $vmConfigurations) {
    $vmName = $vmConfig.Name
    $image = $vmConfig.Image
    $openPorts = $vmConfig.OpenPorts
    
    # Create a virtual machine
    New-AzVm -ResourceGroupName $resourceGroupName -Name $vmName -Location $location -Image $image -VirtualNetworkName $vnetName -SubnetName $subnetName -SecurityGroupName $networkSecurityGroupName -OpenPorts $openPorts -Credential (New-Object PSCredential -ArgumentList $adminUsername, (ConvertTo-SecureString -String $adminPassword -AsPlainText -Force))
}

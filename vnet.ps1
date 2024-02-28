# Define variables
$resourceGroupName = "rg_007"
$location = "EastUS"
$vnetName = "vn_007"
$subnetName = "SN001"

# Create a new resource group (if necessary)
New-AzResourceGroup -Name $resourceGroupName -Location $location

# Create a virtual network
$vnet = New-AzVirtualNetwork -ResourceGroupName $resourceGroupName -Location $location -Name $vnetName -AddressPrefix "10.0.0.0/16"

# Create a subnet
$subnet = Add-AzVirtualNetworkSubnetConfig -Name $subnetName -AddressPrefix "10.0.0.0/17" -VirtualNetwork $vnet
Set-AzVirtualNetwork -VirtualNetwork $vnet

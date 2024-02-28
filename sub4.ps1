# Define variables
$resourceGroupName = "rg001"
$location = "EastUS"
$vnetName = "vnet001"

# Virtual network configuration
$vnetConfig = @{
    ResourceGroupName = $resourceGroupName
    Location = $location
    Name = $vnetName
    AddressPrefix = "10.0.0.0/8"
}

# Subnet configurations
$subnets = @(
    @{
        Name = "Subnet1"
        AddressPrefix = "10.0.0.0/10"
    },
    @{
        Name = "Subnet2"
        AddressPrefix = "10.64.0.0/10"
    },
    @{
        Name = "Subnet3"
        AddressPrefix = "10.128.0.0/10"
    },
    @{
        Name = "Subnet4"
        AddressPrefix = "10.192.0.0/10"
    }
)


New-AzResourceGroup -Name $resourceGroupName -Location $location

# Create a virtual network
$vnet = New-AzVirtualNetwork @vnetConfig

# Add subnets to the virtual network
foreach ($subnet in $subnets) {
    Add-AzVirtualNetworkSubnetConfig -Name $subnet.Name -AddressPrefix $subnet.AddressPrefix -VirtualNetwork $vnet
}

# Apply the subnet configurations
Set-AzVirtualNetwork -VirtualNetwork $vnet

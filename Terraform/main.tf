# Creates the resource group for K8s Clusters
resource "azurerm_resource_group" "rg" {
  name     = "Weight-Tracker-K8s"
  location = "eastus"
}

# Creates Container Registry
resource "azurerm_container_registry" "acr" {
  name                = "weightappregistrybk"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Standard"
  admin_enabled       = true
}

# Creates K8s Cluster for Staging
module "aks-staging" {
  source          = "../modules/aks"
  rg_name         = azurerm_resource_group.rg.name
  server_location = azurerm_resource_group.rg.location
  cluster_name    = "Weight-Tracker-Cluster-Staging"
  aks_k8s_version = "1.22.11"
  domain_prefix   = "weight-tracker-cluster-staging-dns"
  aks_vm_size = "Standard_B2s"
  aks_osdisksize = "30"
  aks_min_server_count = "1"
  aks_max_server_count = "2"
  aks_max_pods_per_node = "3"
  admin_user = var.admin_user
  ssh_public_key = var.ssh_public_key
  scope = azurerm_kubernetes_cluster.acr.id
}

# Creates K8s Cluster for Production
module "aks-production" {
  source          = "../modules/aks"
  rg_name         = azurerm_resource_group.rg.name
  server_location = azurerm_resource_group.rg.location
  cluster_name    = "Weight-Tracker-Cluster-Production"
  aks_k8s_version = "1.22.11"
  domain_prefix   = "weight-tracker-cluster-production-dns"
  aks_vm_size = "Standard_B2s"
  aks_osdisksize = "30"
  aks_min_server_count = "2"
  aks_max_server_count = "3"
  aks_max_pods_per_node = "3"
  admin_user = var.admin_user
  ssh_public_key = var.ssh_public_key
  scope = azurerm_kubernetes_cluster.acr.id
}
# Creates AKS Cluster
resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = var.cluster_name
  location            = var.server_location
  resource_group_name = var.rg_name
  dns_prefix          = "${var.domain_prefix}-k8s"
  kubernetes_version  = var.aks_k8s_version

  linux_profile {
      admin_username = var.admin_user

      ssh_key {
          key_data = var.ssh_public_key
      }
  }

  default_node_pool {
    name                 = "agentpool"
    orchestrator_version = var.aks_k8s_version
    vm_size              = var.aks_vm_size
    type                 = "VirtualMachineScaleSets"
    enable_auto_scaling  = true
    min_count            = var.aks_min_server_count
    max_count            = var.aks_max_server_count
    os_disk_size_gb      = var.aks_osdisksize
  }

  network_profile {
      load_balancer_sku = "standard"
      network_plugin = "kubenet"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    environment = "Dev"
  }
}

resource "azurerm_role_assignment" "kub_to_acr" {
  scope                = var.scope
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.k8s.kubelet_identity[0].object_id
}
# Create a resource group
resource "azurerm_resource_group" "aks_rg" {
  name     = "myAKSResourceGroup"
  location = var.region
}

# Create an AKS cluster
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "myAKSCluster"
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  dns_prefix          = "myakscluster"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_DC2ds_v3"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Development"
  }
}

# Create a Kubernetes deployment
resource "kubernetes_deployment" "ip-finder" {
  metadata {
    name = "my-ip-finder-deployment"
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "ip-finder"
      }
    }

    template {
      metadata {
        labels = {
          app = "ip-finder"
        }
      }

      spec {
        container {
          image = var.image
          name  = "ip-finder"

          port {
            container_port = 5000
          }
        }
      }
    }
  }
}

# Create a Kubernetes service
resource "kubernetes_service" "ip-finder" {
  metadata {
    name = "my-ip-finder-deployment"
  }

  spec {
    selector = {
      app = kubernetes_deployment.ip-finder.spec.0.template.0.metadata.0.labels.app
    }

    port {
      port        = 80
      target_port = 5000
    }

    type = "LoadBalancer"
  }
}
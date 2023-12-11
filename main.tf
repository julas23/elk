provider "azurerm" {
  features {}
}

resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = "aks-cluster"
  location            = "East US"  # Escolha a região desejada
  resource_group_name = "my-aks-resource-group"
  dns_prefix          = "aks-cluster"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_DS2_v2"
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "helm_release" "elasticsearch" {
  name       = "elasticsearch"
  repository = "https://helm.elastic.co"
  chart      = "elasticsearch"
  namespace  = "elasticsearch"

  values = [
    {
      name  = "masterNode.replicas"
      value = "2"
    },
    {
      name  = "dataNode.replicas"
      value = "2"
    },
  ]
}

resource "kubernetes_service" "elasticsearch_svc" {
  metadata {
    name      = "elasticsearch"
    namespace = "elasticsearch"
  }

  spec {
    selector = {
      app = "elasticsearch"
    }

    port {
      protocol   = "TCP"
      port       = 9200
      target_port = 9200
    }

    type = "ClusterIP"
  }
}

resource "helm_release" "kibana" {
  name       = "kibana"
  repository = "https://helm.elastic.co"
  chart      = "kibana"
  namespace  = "kibana"
}

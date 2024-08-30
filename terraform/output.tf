# Output the cluster's kube_config
output "kube_config" {
  value     = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive = true
}

# Output the public IP of the load balancer
output "load_balancer_ip" {
  value = kubernetes_service.ip-finder.status.0.load_balancer.0.ingress.0.ip
}
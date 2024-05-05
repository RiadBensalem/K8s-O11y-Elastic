output "elasticsearch_endpoint" {
  value = ec_deployment.k8s_observability.elasticsearch[0].https_endpoint
}

output "elasticsearch_username" {
  value = ec_deployment.k8s_observability.elasticsearch_username
}

output "elasticsearch_password" {
  value = ec_deployment.k8s_observability.elasticsearch_password
  sensitive = true
}

output "kibana_endpoint" {
  value = ec_deployment.k8s_observability.kibana[0].https_endpoint
}


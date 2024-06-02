output "elasticsearch_endpoint" {
  value = ec_deployment.k8s_observability.elasticsearch.https_endpoint
}

output "elasticsearch_username" {
  value = ec_deployment.k8s_observability.elasticsearch_username
}

output "elasticsearch_password" {
  value = ec_deployment.k8s_observability.elasticsearch_password
  sensitive = true
}

output "kibana_endpoint" {
  value = ec_deployment.k8s_observability.kibana.https_endpoint
}

output "fleet_endpoint" {
  value = ec_deployment.k8s_observability.integrations_server.endpoints.fleet
}


output "enrollment_tokens" {
  value = data.elasticstack_fleet_enrollment_tokens.k8s_monitoring_et.tokens
}

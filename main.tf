data "ec_stack" "latest" {
  version_regex = "latest"
  region        = "eu-west-1"
}

resource "ec_deployment" "k8s_observability" {
  
  name = "k8s_observability"

  region                 = "eu-west-1"
  version                = data.ec_stack.latest.version
  deployment_template_id = "aws-storage-optimized"

  elasticsearch = {
    hot = {
      autoscaling = {}
    }
  }

  kibana = {}
  integrations_server = {}

  # Optional observability settings
  observability = {
  deployment_id = "self"
}

  tags = {
    "monitoring" = "source"
  }
}


resource "elasticstack_fleet_integration" "k8s_integration" {
  name    = "kubernetes"
  version = "1.58.0"
  force   = true
}


resource "elasticstack_fleet_agent_policy" "k8s_monitoring_policy" {
  name            = "k8s Monitoring Policy"
  namespace       = "default"
  description     = "k8s monitoring"
  sys_monitoring  = true
  monitor_logs    = true
  monitor_metrics = true
}

data "elasticstack_fleet_enrollment_tokens" "k8s_monitoring_et" {
  policy_id = elasticstack_fleet_agent_policy.k8s_monitoring_policy.policy_id
}


resource "elasticstack_fleet_integration_policy" "fleet_integration_policy" {
  name                = "k8s Integration Policy"
  namespace           = "default"
  description         = "k8s integration policy"
  agent_policy_id     = elasticstack_fleet_agent_policy.k8s_monitoring_policy.policy_id
  integration_name    = elasticstack_fleet_integration.k8s_integration.name
  integration_version = elasticstack_fleet_integration.k8s_integration.version
}

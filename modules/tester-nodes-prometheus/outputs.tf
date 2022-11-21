#### Outputs

output "grafana_url" {
  value = format("http://%s:3000", var.test-node-eips[0])
}
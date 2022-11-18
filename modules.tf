########## Create an RE cluster on AWS from scratch #####
#### Modules to create the following:
#### Test node with Redis and Memtier
#### Test node with RIOT
#### Test node with Prometheus and Grafana for advanced monitoring on cluster


########### Test Node Module
#### Create Test nodes
#### Ansible playbooks configure Test node with Redis and Memtier
module "tester-nodes" {
    source             = "./modules/tester-nodes"
    owner              = var.owner
    region             = var.region
    subnet_azs         = var.subnet_azs
    ssh_key_name       = var.ssh_key_name
    ssh_key_path       = var.ssh_key_path
    test_instance_type = var.test_instance_type
    test-node-count    = var.test-node-count
    ### vars pulled from previous modules
    vpc_name           = var.vpc_name
    vpc_subnets_ids    = var.vpc_subnets_ids
    vpc_security_group_ids = var.vpc_security_group_ids

}

output "test-node-eips" {
  value = module.tester-nodes.test-node-eips
}

module "tester-nodes-riot" {
    source             = "./modules/tester-nodes-riot"
    ssh_key_path       = var.ssh_key_path
    test-node-count    = var.test-node-count
    riot_version       = var.riot_version
    vpc_name           = var.vpc_name


    depends_on = [
      module.tester-nodes
    ]
}

########## Prometheus and Grafana Module
##### install prometheus on new node
module "tester-nodes-prometheus" {
    source             = "./modules/tester-nodes-prometheus"
    ssh_key_path       = var.ssh_key_path
    vpc_name           = var.vpc_name
    dns_fqdn           = var.dns_fqdn
    test-node-eips     = module.tester-nodes.test-node-eips


    depends_on = [module.tester-nodes, module.tester-nodes-riot]
}

#### dns FQDN output used in future modules
output "grafana_url" {
  value = module.tester-nodes-prometheus.grafana_url
}

output "grafana_username" {
  value = "admin"
}

output "grafana_password" {
  value = "secret"
}
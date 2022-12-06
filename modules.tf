########## Create a Tester node for your Redis Enterprise Cluster #####
#### Modules to create the following:
#### Test node with Redis and Memtier installed
#### Test node with RIOT installed
#### Test node with Prometheus and Grafana for advanced monitoring on cluster
#### (Prometheus and Grafana require the cluster FQDN as an input)


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
    ### vars updated from user RE Cluster VPC
    vpc_name           = var.vpc_name
    vpc_subnets_ids    = var.vpc_subnets_ids
    vpc_security_group_ids = var.vpc_security_group_ids

}

output "test-node-eips" {
  value = module.tester-nodes.test-node-eips
}

# output "test-node-public_dns" {
#   value = module.tester-nodes.public_dns
# }


########## MYSQL Install
##### install MySQL on Node
module "tester-nodes-mysql" {
    source             = "./modules/tester-nodes-mysql"
    ssh_key_path       = var.ssh_key_path
    test-node-count    = var.test-node-count
    test-node-eips     = module.tester-nodes.test-node-eips
    vpc_name           = var.vpc_name


    depends_on = [
      module.tester-nodes
    ]
}


# ########## RIOT Module
# ##### install RIOT and required Java packages on node
# module "tester-nodes-riot" {
#     source             = "./modules/tester-nodes-riot"
#     ssh_key_path       = var.ssh_key_path
#     test-node-count    = var.test-node-count
#     riot_version       = var.riot_version
#     vpc_name           = var.vpc_name


#     depends_on = [
#       module.tester-nodes
#     ]
# }

# ########## Prometheus and Grafana Module
# ##### install prometheus on new node 
# ##### (cavet, Prometheus and Grafana will only work on 1 node, 
# ##### if you create more the extra nodes will not have functional Prometheus and Grafana configurations)
# module "tester-nodes-prometheus" {
#     source             = "./modules/tester-nodes-prometheus"
#     ssh_key_path       = var.ssh_key_path
#     vpc_name           = var.vpc_name
#     dns_fqdn           = var.dns_fqdn
#     test-node-eips     = module.tester-nodes.test-node-eips

#     #currently breaks sometimes if you try riot & prometheus without the depends on riot here.
#     depends_on = [module.tester-nodes, module.tester-nodes-riot]
# }

# #### dns FQDN output used in future modules
# output "grafana_url" {
#   value = module.tester-nodes-prometheus.grafana_url
# }

# output "grafana_username" {
#   value = "admin"
# }

# output "grafana_password" {
#   value = "secret"
# }
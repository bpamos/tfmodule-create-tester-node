#### Generating Ansible config, inventory, playbook 
#### and configuring test nodes and installing Redis and Memtier

#### Sleeper, after instance, eip assoc, local file inventories & cfg created
#### otherwise it can run to fast, not find the inventory file and fail or hang
resource "time_sleep" "wait_30_seconds_test" {
  create_duration = "30s"
}


#### Generate Ansible Playbook
resource "local_file" "playbook_setup" {
    count = var.test-node-count
    content  = templatefile("${path.module}/ansible/playbooks/playbook_test_node_prometheus.yaml.tpl", {
        vpc_name = var.vpc_name
    })
    filename = "${path.module}/ansible/playbooks/playbook_test_node_prometheus.yaml"
  depends_on = [time_sleep.wait_30_seconds_test]
}



#### Generate riot yaml to configure the version number
resource "local_file" "prometheus" {
    content  = templatefile("${path.module}/ansible/prometheus/prometheus.yml.tpl", {
        cluster_fqdn = var.dns_fqdn
    })
    filename = "/tmp/${var.vpc_name}_prometheus.yml"
  depends_on = [time_sleep.wait_30_seconds_test, local_file.playbook_setup]
}


#### Generate docker-compose.yml file
resource "local_file" "docker_compose" {
    content  = templatefile("${path.module}/ansible/prometheus/docker-compose.yml.tpl", {
        vpc_name = var.vpc_name
    })
    #filename = "/tmp/${var.vpc_name}_docker_compose.yml"
    filename = "/tmp/docker-compose.yml"
  depends_on = [time_sleep.wait_30_seconds_test, local_file.playbook_setup]
}




######################
# Run ansible playbook to install redis and memtier
resource "null_resource" "ansible_test_run_prometheus" {
  count = var.test-node-count
  provisioner "local-exec" {
    command = "ansible-playbook ${path.module}/ansible/playbooks/playbook_test_node_prometheus.yaml --private-key ${var.ssh_key_path} -i /tmp/${var.vpc_name}_test_node_${count.index}.ini"
  }
  depends_on = [time_sleep.wait_30_seconds_test, local_file.playbook_setup, local_file.prometheus, local_file.docker_compose]
}

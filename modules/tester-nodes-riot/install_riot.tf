#### Generating Ansible playbook 
#### and configuring test nodes for RIOT

#### Sleeper, after instance, eip assoc, local file inventories & cfg created
#### otherwise it can run to fast, not find the inventory file and fail or hang
resource "time_sleep" "wait_30_seconds_test" {
  create_duration = "30s"
}


#### Generate riot yaml to configure the version number
resource "local_file" "riot_yaml" {
    content  = templatefile("${path.module}/ansible/playbooks/playbook_test_node_riot.yaml.tpl", {
        riot_version = var.riot_version
    })
    filename = "${path.module}/ansible/playbooks/playbook_test_node_riot.yaml"
  depends_on = [time_sleep.wait_30_seconds_test]
}

######################
# Run ansible playbook to install RIOT
resource "null_resource" "ansible_test_run_riot" {
  count = var.test-node-count
  provisioner "local-exec" {
    command = "ansible-playbook ${path.module}/ansible/playbooks/playbook_test_node_riot.yaml --private-key ${var.ssh_key_path} -i /tmp/${var.vpc_name}_test_node_${count.index}.ini"
  }
  depends_on = [time_sleep.wait_30_seconds_test, local_file.riot_yaml]
}

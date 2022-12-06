#### Generating Ansible playbook 
#### and configuring test nodes for RIOT

#### Sleeper, after instance, eip assoc, local file inventories & cfg created
#### otherwise it can run to fast, not find the inventory file and fail or hang
resource "time_sleep" "wait_30_seconds_test" {
  create_duration = "30s"
}


#### Generate riot yaml to configure the version number
resource "local_file" "load_data_py" {
    content  = templatefile("${path.module}/python/load_data.py.tpl", {
        test_node_host_ip = var.test-node-eips[0]
    })
    filename = "${path.module}/python/load_data.py"
  depends_on = [time_sleep.wait_30_seconds_test]
}

######################
# Run ansible playbook to install Mysql
resource "null_resource" "ansible_test_mysql" {
  count = var.test-node-count
  provisioner "local-exec" {
    command = "ansible-playbook ${path.module}/ansible/playbooks/playbook_mysql.yaml --private-key ${var.ssh_key_path} -i /tmp/${var.vpc_name}_test_node_${count.index}.ini -e @${path.module}/ansible/group_vars/all/main.yaml"
  }
  depends_on = [time_sleep.wait_30_seconds_test, local_file.load_data_py]
}


#Run ansible-playbook to create crdb from python script (REST API)
resource "null_resource" "load_mysql_data5" {
  provisioner "local-exec" {
    command = "python3 ${path.module}/python/load_data.py"
    }

    depends_on = [
      local_file.load_data_py,
      null_resource.ansible_test_mysql
    ]
}



#### Generate riot yaml to configure the version number
resource "local_file" "query_py" {
    content  = templatefile("${path.module}/python/query_data.py.tpl", {
        test_node_host_ip = var.test-node-eips[0]
    })
    filename = "${path.module}/python/query_data.py"
  depends_on = [time_sleep.wait_30_seconds_test]
}

#Run ansible-playbook to create crdb from python script (REST API)
resource "null_resource" "query_data1" {
  provisioner "local-exec" {
    command = "python3 ${path.module}/python/query_data.py"
    }

    depends_on = [
      local_file.load_data_py,
      null_resource.ansible_test_mysql,
      null_resource.load_mysql_data5
    ]
}
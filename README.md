# tfmodule-create-tester-node
Terraform modules to create a Tester node for a Redis Enterprise Cluster.

Assuming the user already has an up and running cluster deployed in an AWS VPC.

The user can take their current `subnet azs`, `subnet ids`, and `security group id`, input them as variables and deploy a test node.

**Test Node Options:**
* Create Tester node with Redis OSS and Memtier Benchmark installed.
* Optional:
    - Configure and install RIOT on Tester Node
    - Configure Prometheus and Grafana for advanced montioring of the Redis Cluster

## Terraform Modules to provision the following:
* Test node with Redis and Memtier installed
* Test node with RIOT configured and installed
* Prometheus and Grafana node configured for advanced monitoring of Redis Cluster

### !!!! Requirements !!!
* aws access key and secret key
* an **AWS generated** SSH key for the region you are creating the cluster
    - *you must chmod 400 the key before use*
* Users Redis Cluster Subnet Azs, Subnet Ids, Security Group Id
* Optional:
    - Configure RIOT:
        - Require RIOT Version
    - Configure Prometheus and Grafana:
        - Require Redis Cluster FQDN

### Prerequisites
* aws-cli (aws access key and secret key)
* terraform installed on local machine
* ansible installed on local machine
* VS Code

#### Prerequisites (detailed instructions)
1.  Install `aws-cli` on your local machine and run `aws configure` ([link](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html)) to set your access and secret key.
    - If using an aws-cli profile other than `default`, `main.tf` may need to edited under the `provider "aws"` block to reflect the correct `aws-cli` profile.
2.  Download the `terraform` binary for your operating system ([link](https://www.terraform.io/downloads.html)), and make sure the binary is in your `PATH` environment variable.
    - MacOSX users:
        - (if you see an error saying something about security settings follow these instructions), ([link](https://github.com/hashicorp/terraform/issues/23033))
        - Just control click the terraform unix executable and click open. 
    - *you can also follow these instructions to install terraform* ([link](https://learn.hashicorp.com/tutorials/terraform/install-cli))
 3.  Install `ansible` via `pip3 install ansible` to your local machine.
     - A terraform local-exec provisioner is used to invoke a local executable and run the ansible playbooks, so ansible must be installed on your local machine and the path needs to be updated.
     - example steps:

    ```
    # create virtual environment
    python3 -m venv ./venv
    # Check if you have pip
    python3 -m pip -V
    # Install ansible and check if it is in path
    python3 -m pip install --user ansible
    # check if ansible is installed:
    ansible --version
    # If it tells you the path needs to be updated, update it
    echo $PATH
    export PATH=$PATH:/path/to/directory
    # example: export PATH=$PATH:/Users/username/Library/Python/3.8/bin
    # (*make sure you choose the correct python version you are using*)
    # you can check if its in the path of your directory by typing "ansible-playbook" and seeing if the command exists
    ```

* (*for more information on how to install ansible to your local machine:*) ([link](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html))

## Getting Started:
Now that you have terraform and ansible installed you can get started provisioning your RE cluster on AWS using terraform modules.

Since creating a Redis Enterprise cluster from scratch takes many components (VPC, DNS, Nodes, and creating the cluster via REST API) it is best to break these up into invidivual `terraform modules`. That way if a user already has a pre-existing VPC, they can utilize their existing VPC instead of creating a brand new one.

There are two important files to understand. `modules.tf` and `terraform.tfvars.example`.
* `modules.tf` contains the following: 
    - `tester-nodes` (creates test nodes with Redis and Memtier installed)
    - `tester-nodes-riot` (Configures and installs RIOT on tester node) (example of how to use RIOT can be found below)
    - `tester-nodes-prometheus` (Configures tester node with prometheus and grafana configured for advanced monitoring on the Redis Enterprise Cluster)    
    * *the individual modules can contains inputs from previously generated from run modules.*

* `terraform.tfvars.example`:
    - An example of a terraform variable managment file. The variables in this file are utilized as inputs into the module file. You can choose to use these or hardcode your own inputs in the modules file.
    - to use this file you need to change it from `terraform.tfvars.example` to simply `terraform.tfvars` then enter in your own inputs.

### Instructions for Use:
1. Open repo in VS code
2. Copy the variables template. or rename it `terraform.tfvars`
    ```bash
    cp terraform.tfvars.example terraform.tfvars
    ```
3. Update `terraform.tfvars` variable inputs with your own inputs
    - Some require user input, some will will use a default value if none is given
4. Now you are ready to go!
    * Open a terminal in VS Code:
    ```bash
    # ensure ansible is in path
    ansible --version
    # run terraform commands
    terraform init
    terraform plan
    terraform apply
    # Enter a value: yes
    # can take around 5 to 10 minutes to provision
    ```

 - example output:
 ```
 Outputs:

If you run prometheus and grafana module you will find a `grafana_url` if you provisioned the prometheus node.
The `username = admin` and `password = secret` 

## Cleanup

Remove the resources that were created.

```bash
  terraform destroy
  # Enter a value: yes
```



*********
# RIOT

The tester node follows the instructions from (https://developer.redis.com/riot/riot-redis/cookbook.html)
to install java and such.
Then downloads a user input version of RIOT.

To use RIOT the user can:
Go to tester node:
* redis-server
* open new ec2 terminal to access redis
* redis-cli
    - set some keys (ie. set key A)
* Test RIOT Migration
    - riot-redis-xxxxx/bin/riot-redis (then the command)
    -example: `riot-redis-2.18.5/bin/riot-redis -u redis://127.0.0.1:6379 replicate-ds -u redis://redis-16404.bamos-west.demo.redislabs.com:16404 -a test`



#### Required Variables

variable "ssh_key_path" {
    description = "name of ssh key to be added to instance"
}

# variable "owner" {
#     description = "owner tag name"
# }

#### VPC
variable "vpc_name" {
  description = "The VPC Project Name tag"
}

#### Test Instance Variables

#### instance type to use for test node with redis and memtier installed on it
variable "test-node-count" {
  description = "number of data nodes"
  default     = 1
}


variable "dns_fqdn" {
  description = "dns_fqdn"
  default     = ""
}

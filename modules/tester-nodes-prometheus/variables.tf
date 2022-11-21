#### Required Variables

variable "ssh_key_path" {
    description = "name of ssh key to be added to instance"
}

variable "vpc_name" {
  description = "The VPC Project Name tag"
}


variable "dns_fqdn" {
  description = "dns_fqdn"
  default     = ""
}

variable "test-node-eips" {
  description = "test-node-eips"
  default     = ""
}
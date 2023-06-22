variable "ami" {
  type        = string
  description = "Ami Id"
}

variable "instance_type" {}

variable "tags" {}

variable "sg_name" {}

variable "ingress_rules" {}

variable "egress_rules" {}
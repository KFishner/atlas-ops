variable "access_key" {
	description = "AWS access key"
}

variable "secret_key" {
	description = "AWS secret key"
}

variable "atlas_username" { }

variable "atlas_user_token" { }

variable "atlas_environment" { }

variable "key_name" { }

variable "consul_server_count" { 
  default = 3
}

variable "subnet_id" { }

variable "elb_name" { }

variable "security_group" { }

variable "ami" { }

variable "instance_type" { }

variable "user_data" { }

variable "asg_name" { }

variable "azs" { }

variable "subnet_id" { }

variable "nodes" { }

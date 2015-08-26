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

variable "nodejs_count" { }

variable "azs" {
  default = "us-east-1b"
}
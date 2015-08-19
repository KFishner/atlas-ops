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

variable "sec_groups" {
    default = {
      dev = "sg-e1e78686"
      production = "sg-39e7865e,sg-e1e78686"
    }
}

variable "env" {
    description = "Environment in which to setup new cluster"
    default = "dev"
}
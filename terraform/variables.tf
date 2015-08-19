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
      dev = "sg-5781c432"
      production = "sg-0cf28f69,sg-8d4439e8"
    }
}

variable "env" {
    description = "Environment in which to setup new cluster"
    default = "dev"
}
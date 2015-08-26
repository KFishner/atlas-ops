variable "vpc-cidr" {
	default = "172.31.0.0/16"
}

variable "subnet-cidr" {
	default = "172.31.16.0/20"
}

variable "azs" {
  default = "us-east-1b"
}
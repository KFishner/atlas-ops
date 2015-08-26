resource "aws_vpc" "main" {
    cidr_block = "${var.vpc-cidr}"
    enable_dns_hostnames = true

    lifecycle = {
      create_before_destroy = true
    }
}

resource "aws_subnet" "main" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "${var.subnet-cidr}"
    map_public_ip_on_launch = true
    availability_zone = "${var.azs}"

    lifecycle = {
      create_before_destroy = true
    }
}

resource "aws_internet_gateway" "gw" {
    vpc_id = "${aws_vpc.main.id}"

    lifecycle = {
      create_before_destroy = true
    }
}

resource "aws_route_table" "r" {
    vpc_id = "${aws_vpc.main.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.gw.id}"
    }

    lifecycle = {
      create_before_destroy = true
    }
}

resource "aws_route_table_association" "a" {
    subnet_id = "${aws_subnet.main.id}"
    route_table_id = "${aws_route_table.r.id}"

    lifecycle = {
      create_before_destroy = true
    }
}

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

resource "aws_launch_configuration" "web" {
    lifecycle {
        create_before_destroy = true
    }

    name = "${var.elb_name} - ${var.ami}"
    image_id = "${var.ami}"
    instance_type = "${var.instance_type}"
    key_name = "${var.key_name}"
    user_data = "${var.user_data}"
    security_groups = ["${var.security_group}"]
}

resource "aws_autoscaling_group" "web" {
    lifecycle {
        create_before_destroy = true
    }

    name = "${var.asg_name}"
    launch_configuration = "${aws_launch_configuration.web.name}"
    desired_capacity = "${var.nodes}"
    min_size = "${var.nodes}"
    max_size = "${var.nodes}"
    min_elb_capacity = "${var.nodes}"
    load_balancers = [
        "${aws_elb.web.id}",
    ]
    availability_zones = ["${split(",", var.azs)}"]
    vpc_zone_identifier = ["${var.subnet_id}"]

    tag {
      key = "Name"
      value = "web-http"
      propagate_at_launch = true
    }
}

resource "aws_elb" "web" {
    name = "${var.elb_name}"
    security_groups = ["${var.security_group}"]
    subnets = ["${var.subnet_id}"]
    connection_draining = true

    listener {
        instance_port = 80
        instance_protocol = "http"
        lb_port = 80
        lb_protocol = "http"
    }

    health_check {
        target = "HTTP:80/_health_check"
        healthy_threshold = 2
        unhealthy_threshold = 2
        interval = 15
        timeout = 10
    }
}
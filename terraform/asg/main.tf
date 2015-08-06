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
    vpc_zone_identifier = ["${split(",", var.private_subnet_ids)}"]

    tag {
      key = "Name"
      value = "web-http"
      propagate_at_launch = true
    }
}
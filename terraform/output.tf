output "address" {
    value = "${aws_instance.haproxy.public_dns}"
}
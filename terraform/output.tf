output "haproxy-address" {
  value = <<HAPROXY

Navigate to HA-Proxy on port 1936 = ${aws_instance.haproxy.public_ip}:1936

HAPROXY
}
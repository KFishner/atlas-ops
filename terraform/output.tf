output "haproxy-address" {
  value = <<HAPROXY

Hit the web servers through HA-Proxy = ${aws_instance.haproxy.public_ip}:8080
Navigate to HA-Proxy stats on port 1936 = ${aws_instance.haproxy.public_ip}:1936/haproxy?stats

HAPROXY
}
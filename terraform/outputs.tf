output "ip" {
  value = "$aws_eip.ip.public_ip"
}

output "consul_address" {
  value = "${module.consul.server_address}"
}

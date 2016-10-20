output "ip" {
  value = "${aws_eip.ip.public_ip}"
}

output "dns" {
  value = "${aws_instance.personal.public_dns}"
}

output "floating-ip" {
  value = "${digitalocean_floating_ip.float.ip_address}"
}

output "ip" {
  value = "${digitalocean_droplet.droplet.ipv4_address}"
}

output "fqdn" {
  value = "${digitalocean_record.record.fqdn}"
}

output "tag" {
  value = "${digitalocean_tag.tag.name}"
}

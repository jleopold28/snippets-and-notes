provider "digitalocean" {
  token = "${var.do_token}"
}

resource "digitalocean_droplet" "droplet" {
  image    = "ubuntu-lamp"
  name     = "matt-test"
  region   = "nyc1"
  size     = "512mb"
  ssh_keys = ["${digitalocean_ssh_key.key.id}"]
}

resource "digitalocean_ssh_key" "key" {
  name       = "Matt SSH Key"
  public_key = "${file("/home/matt/.ssh/id_rsa.pub")}"
}

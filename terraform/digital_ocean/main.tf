# Specify DO provider
provider "digitalocean" {
  token = "${var.do_token}"
}

# Create droplet
resource "digitalocean_droplet" "droplet" {
  image      = "ubuntu-16-04-x64"
  name       = "matt-test"
  region     = "nyc1"
  size       = "512mb"
  ssh_keys   = ["${digitalocean_ssh_key.key.id}"]
  tags       = ["${digitalocean_tag.tag.name}"]
  volume_ids = ["${digitalocean_volume.volume.id}"]
}

# Establish floating ip
resource "digitalocean_floating_ip" "float" {
  droplet_id = "${digitalocean_droplet.droplet.id}"
  region     = "${digitalocean_droplet.droplet.region}"
}

# Create a domain
resource "digitalocean_domain" "domain" {
  name = "sealand.shadow-soft.com"
  ip_address = "${digitalocean_droplet.droplet.ipv4_address}"
}

# Add a record to the domain
resource "digitalocean_record" "record" {
  domain = "${digitalocean_domain.domain.name}"
  type   = "A"
  name   = "record"
  value  = "192.168.0.123"
}

# Create ssh key
resource "digitalocean_ssh_key" "key" {
  name       = "Matt SSH Key"
  public_key = "${file("/home/matt/.ssh/id_rsa.pub")}"
}

# Create tag
resource "digitalocean_tag" "tag" {
  name = "happy-fun-time"
}

# Create expanded volume
resource "digitalocean_volume" "volume" {
  region      = "nyc1"
  name        = "a-volume"
  size        = 100
  description = "this is a volume"
}

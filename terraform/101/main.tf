provider "aws" {
  version = "~> 1.5"

  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

provider "dnsimple" {
  version = "~> 0.1"
}

resource "aws_instance" "web" {
  ami                    = "ami-db24d8b6"
  instance_type          = "t2.micro"
  subnet_id              = "subnet-c02e6198"
  vpc_security_group_ids = ["sg-b1fe76ca"]

  tags {
    Identity = "..."
    Name     = "${var.label}"
    Zip      = "zap"
  }
}

resource "dnsimple_record" "web" {
  domain = "hashicorp.com"
  name   = "web"
  ttl    = "3600"
  type   = "A"
  value  = "${aws_instance.web.public_ip}"
}

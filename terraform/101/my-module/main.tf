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
  key_name               = "${aws_key_pair.key.id}"
  count                  = "${var.num_webs}"

  tags {
    Identity = "..."
    Name     = "${var.label} ${count.index + 1}/${var.num_webs}"
    Zip      = "zap"
  }

  connection {
    user        = "ubuntu"
    private_key = "${file("/home/matt/.ssh/id_rsa")}"
  }

  provisioner "file" {
    source      = "assets"
    destination = "/tmp/"
  }

  provisioner "remote-exec" {
    inline = ["sudo sh /tmp/assets/setup-web.sh"]
  }
}

resource "aws_key_pair" "key" {
  key_name   = "${var.identity}-key"
  public_key = "${file(""/home/matt/.ssh/id_rsa.pub")}"
}

resource "dnsimple_record" "web" {
  domain = "hashicorp.com"
  name   = "web"
  ttl    = "3600"
  type   = "A"
  value  = "${aws_instance.web.0.public_ip}"
}

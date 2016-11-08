provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

resource "aws_instance" "personal" {
  ami                    = "${lookup(var.amis, var.region)}"
  instance_type          = "t2.micro"
  key_name               = "${aws_key_pair.personal.key_name}"
  vpc_security_group_ids = ["sg-9c0199e6"]
}

resource "aws_eip" "ip" {
  instance = "${aws_instance.personal.id}"
}

resource "aws_key_pair" "personal" {
  key_name = "mschuchard-us-east"
  public_key = "${var.public_key}"
}

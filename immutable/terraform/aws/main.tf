provider "aws" {
  shared_credentials_file = "/home/matt/.aws/credentials"
  region                  = "us-east-1"
}

resource "aws_key_pair" "key" {
  key_name   = "mschuchard-key"
  public_key = "${file("/home/matt/.ssh/id_rsa.pub")}"
}

resource "aws_instance" "example" {
  ami           = "amazon-lamp"
  instance_type = "t2.micro"
  key_name      = "${aws_key_pair.key.key_name}"
}

resource "aws_eip" "ip" {
  instance = "${aws_instance.example.id}"
}

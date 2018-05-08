module "my-module" {
  source = "./my-module"

  ami                = "${var.ami}"
  subnet_id          = "${var.subnet_id}"
  vpc_security_group = "${var.vpc_security_group}"
  identity           = "${var.identity}"
  instance_type      = "${var.instance_type}"
}

output "public_ip" {
  value = "${module.my-module.public_ip}"
}

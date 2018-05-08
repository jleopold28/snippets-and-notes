variable "animal" {}

data "template_file" "setup" {
  template = "${file("templates/setup.sh")}"

  vars {
    animal = "${var.animal}"
  }
}

output "template" {
  value = "${data.template_file.setup.rendered}"
}

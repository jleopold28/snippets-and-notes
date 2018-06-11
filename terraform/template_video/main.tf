variable "region" {
  type = "string"

  default = "us-west-1a"
}

variable "owner_id" {
  type = "string"

  default = "1234567890"
}

data "template_file" "iam_policy" {
  template = "${file("${path.module}/templates/iam_policy.tpl.json")}"

  vars {
    region   = "${var.region}"
    owner_id = "${var.owner_id}"
  }
}

output "iam_policy" {
  value = "${data.template_file.iam_policy.rendered}"
}

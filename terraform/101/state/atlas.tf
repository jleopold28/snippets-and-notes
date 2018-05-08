data "terraform_remote_state" "vpc" {
  # except atlas is gone
  backend = "atlas"

  config {
    name         = "hashicorp/vpc-prod"
    access_token = "xxx.atlasv1.xxx"
  }
}

resource "aws_instance" "example" {
  subnet_id = "${data.terraform_temote_state.vpc.subnet_id}"
}

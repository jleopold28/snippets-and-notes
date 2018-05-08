resource "random_id" "server" {
  keepers = {
    # generate a new id each time we switch to a new ami
    ami_id = "${var.ami_id}"
  }

  byte_length = 4
}

output "id" {
  value = "${random_id.server.hex}"
}

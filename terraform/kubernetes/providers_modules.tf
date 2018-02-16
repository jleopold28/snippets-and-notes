# we need dynamic default input variables for static creds based on config file path and "locals" give us that
locals {
  # merge input vars map with dynamic cert and key map to create new map
  kube_config_static = "${merge(
    var.kube_config_static,
    map(
      "client_cert", "${file("${var.kube_config_path}/../client-cert.pem")}",
      "client_key", "${file("${var.kube_config_path}/../client-key.pem")}",
      "cluster_ca_cert", "${file("${var.kube_config_path}/../cluster-ca-cert.pem")}"
    )
  )}"
}

provider "kubernetes" {
  version = "~> 1.0"

  # load the config file or utilize static creds
  load_config_file = "${var.use_kube_config}"

  # use config file in specified path
  config_path = "${var.kube_config_path}"

  # use static credentials
  host     = "${local.kube_config_static["host"]}"
  username = "${local.kube_config_static["user"]}"
  password = "${local.kube_config_static["password"]}"

  client_certificate     = "${local.kube_config_static["client_cert"]}"
  client_key             = "${local.kube_config_static["client_key"]}"
  cluster_ca_certificate = "${local.kube_config_static["cluster_ca_cert"]}"
}

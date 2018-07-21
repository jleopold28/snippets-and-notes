resource "kubernetes_storage_class" "default" {
  metadata {
    name        = "default"
    annotations = "${map("storageclass.kubernetes.io/is-default-class", "true")}"
  }

  storage_provisioner = "kubernetes.io/aws-ebs"

  parameters {
    type = "gp2"
  }

  depends_on = ["module.eks"]

  #reclaimPolicy: Retain
  #mountOptions:
  #  - debug
}

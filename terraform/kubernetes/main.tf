resource "kubernetes_pod" "app" {
  metadata {
    name = "${var.app}"

    labels {
      App = "${var.app}"
    }
  }

  spec {
    container {
      image = "${var.image_deploy}"
      name  = "${var.app}"

      port {
        container_port = "${var.port}"
      }
    }
  }
}

resource "kubernetes_service" "app" {
  metadata {
    name = "${kubernetes_pod.app.metadata.0.name}"
  }

  spec {
    selector {
      App = "${kubernetes_pod.app.metadata.0.labels.App}"
    }

    port {
      port        = "${kubernetes_pod.app.spec.0.container.port.container_port}"
      target_port = "${kubernetes_pod.app.spec.0.container.port.container_port}"
    }

    type = "LoadBalancer"
  }
}

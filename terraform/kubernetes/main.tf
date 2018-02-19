resource "kubernetes_replication_controller" "app" {
  metadata {
    name = "${var.app}"

    labels {
      App = "${var.app}"
    }
  }

  template {
    replicas = 2

    selector {
      App = "${var.app}"
    }

    container {
      image = "${var.image_deploy}"
      name  = "${var.app}"

      port {
        container_port = "${var.port}"
      }

      resources {
        limits {
          cpu    = "${var.cpu}"
          memory = "${var.mem}"
        }

        requests {
          cpu    = "250m"
          memory = "32Mi"
        }
      }
    }
  }
}

resource "kubernetes_service" "app" {
  metadata {
    name = "${kubernetes_replication_controller.app.metadata.0.name}"
  }

  spec {
    selector {
      App = "${kubernetes_replication_controller.app.metadata.0.labels.App}"
    }

    port {
      port        = "${kubernetes_replication_controller.app.template.0.container.port.container_port}"
      target_port = "${kubernetes_replication_controller.app.template.0.container.port.container_port}"
    }

    type = "LoadBalancer"
  }
}

# this would be independent of the app deployments

resource "kubernetes_resource_quota" "cluster" {
  metadata {
    name = "cluster"
  }

  spec {
    hard {
      pods = 25
    }

    scopes = ["BestEffort"]
  }
}

resource "kubernetes_limit_range" "cluster" {
  metadata {
    name = "cluster"
  }

  spec {
    limit {
      type = "Pod"

      max {
        # these limits are actually only for one pod, but this is still a fun note
        cpu    = "${var.cpu * kubernetes_resource_quota.cluster.spec.0.hard.pods}"
        memory = "${var.memory * kubernetes_resource_quota.cluster.spec.0.hard.pods}"
      }
    }

    limit {
      type = "PersistentVolumeClaim"

      min {
        storage = "24M"
      }
    }

    limit {
      type = "Container"

      default {
        # these limits are actually only for one container, but this is still a fun note
        cpu    = "${var.cpu * kubernetes_resource_quota.cluster.spec.0.hard.pods * kubernetes_replication_controller.app.template.0.replicas}"
        memory = "${var.memory * kubernetes_resource_quota.cluster.spec.0.hard.pods * kubernetes_replication_controller.app.template.0.replicas}"
      }
    }
  }
}

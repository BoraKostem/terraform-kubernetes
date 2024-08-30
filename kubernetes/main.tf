resource "kubernetes_namespace" "borakostem" {
  metadata {
    name = var.namespace_name
  }
}

resource "kubernetes_deployment" "terraform_deployment" {
  metadata {
    name      = "kube-terraform"
    namespace = var.namespace_name
    labels = {
      app = "kube-terraform"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "kube-terraform"
      }
    }

    template {
      metadata {
        labels = {
          app = "kube-terraform"
        }
      }

      spec {
        container {
          name  = "kube-terraform"
          image = "my-harbor-url.com/borakostem/flask-kube:latest"

          resources {
            limits = {
              cpu    = "500m"
              memory = "128Mi"
            }
          }

          port {
            container_port = 5000
          }

          liveness_probe {
            http_get {
              path = "/health"
              port = 5000
            }
            initial_delay_seconds = 3
            period_seconds        = 10
            timeout_seconds       = 5
          }
        }

        image_pull_secrets {
          name = "harbor-secret"
        }
      }
    }
  }
}

resource "kubernetes_horizontal_pod_autoscaler_v2" "terraform_hpa" {
  metadata {
    name      = "terraform-hpa"
    namespace = var.namespace_name
  }

  spec {
    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = "kube-terraform"
    }

    min_replicas = 2
    max_replicas = 5

    metric {
      type = "Resource"
      resource {
        name = "cpu"
        target {
          type = "Utilization"
          average_utilization = 70
        }
      }
    }
  }
}

resource "kubernetes_service" "terraform_service" {
  metadata {
    name      = "terraform-service"
    namespace = var.namespace_name
  }

  spec {
    selector = {
      app = "kube-terraform"
    }

    port {
      protocol    = "TCP"
      port        = 5000
      target_port = 5000
      node_port   = 30001
    }

    type = "NodePort"
  }
}
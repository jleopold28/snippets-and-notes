output "lb_ip" {
  value = "${kubernetes_service.app.load_balancer_ingress.0.hostname}"
}

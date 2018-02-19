variable "use_kube_config" {
  type = "string"

  description = <<EOF
Boolean value for whether or not to use the Kubernetes config file.
EOF

  default = "true"
}

variable "kube_config_path" {
  type = "string"

  description = <<EOF
(optional) Path to the Kubernetes config file.
EOF

  default = "~/.kube/config"
}

variable "kube_config_static" {
  type = "map"

  description = <<EOF
(optional) Map of static Kubernetes credentials.
EOF

  default = {
    "host"     = "https://company.com"
    "user"     = "root"
    "password" = "password"
  }
}

variable "app" {
  type = "string"

  description = <<EOF
The application being deployed.
EOF

  default = "pos"
}

variable "image_deploy" {
  type = "string"

  description = <<EOF
The Docker Image to deploy in the pod.
EOF

  default = "pos:latest"
}

variable "port" {
  type = "string"

  description = <<EOF
The exposed port for the application.
EOF

  default = "80"
}

variable "cpu" {
  type = "string"

  description = <<EOF
The required number of processors for the application.
EOF

  default = "0.5"
}

variable "memory" {
  type = "string"

  description = <<EOF
The required amount of memory for the application.
EOF

  default = "128Mi"
}

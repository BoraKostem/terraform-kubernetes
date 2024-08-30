variable "kubeconfig_path" {
  description = "Path to the kubeconfig file"
  type        = string
  default     = "~/.kube/config"
}

variable "namespace_name" {
  description = "Name of the namespace"
  type        = string
  default     = "borakostem-flask"
}
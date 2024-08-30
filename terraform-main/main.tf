module "kubernetes" {
    source = "../kubernetes"
    namespace_name = var.namespace_name
    kubeconfig_path = var.kubeconfig_path
}
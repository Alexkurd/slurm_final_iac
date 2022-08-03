data "yandex_kubernetes_cluster" "s041120" {
  cluster_id = yandex_kubernetes_cluster.s041120.id
}

locals {
  cluster_public_ip = data.yandex_kubernetes_cluster.s041120.master[0].external_v4_endpoint
  cluster_cert      = base64encode(data.yandex_kubernetes_cluster.s041120.master[0].cluster_ca_certificate)
  cluster_user_pk   = data.yandex_kubernetes_cluster.s041120.service_account_id
  cluster_id        = data.yandex_kubernetes_cluster.s041120.cluster_id
  kubeconfig = templatefile("${path.module}/kubeconfig.tftpl",
    {
      CLUSTER_ID = local.cluster_id,
      CA_ROOT    = local.cluster_cert,
      CLUSTER_IP : local.cluster_public_ip
  })
}

data "yandex_container_registry" "s041120" {
  name = yandex_container_registry.s041120.name
}

output "registry_id" {
  value = yandex_container_registry.s041120.id
}

output "api_public_ip" {
  value = yandex_vpc_address.public_ip.external_ipv4_address.0.address
}

output "bastion_ip" {
  value = yandex_compute_instance.bastion.network_interface.0.nat_ip_address
}

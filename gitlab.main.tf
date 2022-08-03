provider "gitlab" {
  token = var.gitlab_token
}

variable "gitlab_token" {}
#variable "gitlab_project_id" {}
variable "gitlab_group" {
  default = "s041120"
}

//Group vars
resource "gitlab_group_variable" "TF_VAR_yc_registry_id" {
  group = var.gitlab_group
  key   = "TF_VAR_yc_registry_id"
  value = yandex_container_registry.s041120.id
}

resource "gitlab_group_variable" "s3_sa_id" {
  group = var.gitlab_group
  key   = "s3_sa_id"
  value = yandex_iam_service_account_static_access_key.sa-static-key.access_key
}

resource "gitlab_group_variable" "s3_sa_key" {
  group = var.gitlab_group
  key   = "s3_sa_key"
  value = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
}

resource "gitlab_group_variable" "kubeconfig" {
  group = var.gitlab_group
  key   = "kubeconfig"
  value = local.kubeconfig
}

resource "gitlab_group_variable" "yc_config" {
  group = var.gitlab_group
  key   = "yc_config"
  value = base64decode(local.yc_config)
}

resource "gitlab_group_variable" "TF_VAR_pg_host" {
  group = var.gitlab_group
  key   = "TF_VAR_pg_host"
  value = "c-${yandex_mdb_postgresql_cluster.postgre.id}.rw.mdb.yandexcloud.net"
}

resource "gitlab_group_variable" "TF_VAR_LB_IP" {
  group = var.gitlab_group
  key   = "TF_VAR_LB_IP"
  value = yandex_vpc_address.public_ip.external_ipv4_address.0.address
}
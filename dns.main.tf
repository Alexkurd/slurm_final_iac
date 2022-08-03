provider "cloudflare" {
  #email   = var.CF_EMAIL
  api_token = var.CF_API_TOKEN
}

#variable "CF_EMAIL" {}
variable "CF_API_TOKEN" {}
variable "CF_ZONE_ID" {
  default = "5936e84db269e338c2fe8a6c37104f43"
}

resource "cloudflare_record" "root" {
  zone_id = var.CF_ZONE_ID
  name    = "@"
  value   = "s3.s041120.tech.website.yandexcloud.net"
  type    = "CNAME"
  proxied = true
}

resource "cloudflare_record" "api" {
  zone_id = var.CF_ZONE_ID
  name    = "api"
  value   = yandex_vpc_address.public_ip.external_ipv4_address.0.address
  type    = "A"
  proxied = true
}

resource "cloudflare_record" "bastion" {
  zone_id = var.CF_ZONE_ID
  name    = "bastion"
  value   = yandex_compute_instance.bastion.network_interface.0.nat_ip_address
  type    = "A"
  proxied = false
}
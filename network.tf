resource "yandex_vpc_network" "s041120" {
  name = "s041120"
}

resource "yandex_vpc_subnet" "s041120" {
  name           = "s041120"
  zone           = var.zone
  network_id     = yandex_vpc_network.s041120.id
  v4_cidr_blocks = ["10.5.0.0/24"]
}

resource "yandex_vpc_address" "public_ip" {
  name = "LbIp"

  external_ipv4_address {
    zone_id = var.zone
  }
}
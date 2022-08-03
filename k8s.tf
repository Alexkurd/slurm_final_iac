resource "yandex_kubernetes_cluster" "s041120" {
  name = "s041120"

  network_id = yandex_vpc_network.s041120.id

  master {
    version = "1.21"
    zonal {
      zone      = yandex_vpc_subnet.s041120.zone
      subnet_id = yandex_vpc_subnet.s041120.id
    }

    public_ip = true

    #security_group_ids = [yandex_vpc_security_group.security_group_name.id]

    maintenance_policy {
      auto_upgrade = true
      maintenance_window {
        start_time = "15:00"
        duration   = "3h"
      }
    }
  }

  service_account_id      = yandex_iam_service_account.k8s-sa.id
  node_service_account_id = yandex_iam_service_account.k8s-sa.id

  depends_on = [
    yandex_iam_service_account.k8s-sa
  ]

  labels = {
    my_key       = "my_value"
    my_other_key = "my_other_value"
  }

  release_channel         = "STABLE"
  network_policy_provider = "CALICO"
}
// Create SA
resource "yandex_iam_service_account" "k8s-sa" {
  folder_id = var.folder_id
  name      = "tf-k8s-sa"
}

resource "yandex_resourcemanager_folder_iam_member" "k8s-sa" {
  folder_id = var.folder_id
  role      = "editor"
  member    = "serviceAccount:${yandex_iam_service_account.k8s-sa.id}"
}

resource "yandex_kubernetes_node_group" "s041120" {
  cluster_id = yandex_kubernetes_cluster.s041120.id
  name       = "s041120-node"
  version    = "1.21"

  instance_template {
    platform_id = "standard-v2"

    network_interface {
      nat        = true
      subnet_ids = [yandex_vpc_subnet.s041120.id]
    }

    resources {
      memory = 2
      cores  = 2
    }

    boot_disk {
      type = "network-hdd"
      size = 64
    }

    container_runtime {
      type = "docker"
    }

    metadata = {
      #ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
    }
  }

  scale_policy {
    fixed_scale {
      size = 1
    }
  }

  allocation_policy {
    location {
      zone = var.zone
    }
  }

  maintenance_policy {
    auto_upgrade = true
    auto_repair  = true

    maintenance_window {
      day        = "monday"
      start_time = "15:00"
      duration   = "3h"
    }

    maintenance_window {
      day        = "friday"
      start_time = "10:00"
      duration   = "4h30m"
    }
  }
}
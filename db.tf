resource "yandex_mdb_postgresql_cluster" "postgre" {
  name                = "mypg"
  environment         = "PRODUCTION"
  network_id          = yandex_vpc_network.s041120.id
  deletion_protection = false

  config {
    version = 14
    resources {
      resource_preset_id = "b2.micro"
      disk_type_id       = "network-ssd"
      disk_size          = "10"
    }
    access {
      web_sql = true
    }
  }

  host {
    zone             = var.zone
    subnet_id        = yandex_vpc_subnet.s041120.id
    name             = "yelb-db"
    assign_public_ip = true
  }
}

resource "yandex_mdb_postgresql_user" "postgre_user" {
  cluster_id = yandex_mdb_postgresql_cluster.postgre.id
  name       = var.pg_user
  password   = var.pg_password
  conn_limit = 50
  settings = {
    default_transaction_isolation = "read committed"
    log_min_duration_statement    = 5000
  }
}


resource "yandex_mdb_postgresql_database" "postgre_db" {
  cluster_id = yandex_mdb_postgresql_cluster.postgre.id
  name       = var.pg_dbname
  owner      = yandex_mdb_postgresql_user.postgre_user.name
  lc_collate = "en_US.UTF-8"
  lc_type    = "en_US.UTF-8"
}


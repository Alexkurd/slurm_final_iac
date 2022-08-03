resource "yandex_container_registry" "s041120" {
  name      = "s041120"
  folder_id = var.folder_id

  labels = {
    branch = "main"
  }
}
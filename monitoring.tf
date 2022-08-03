resource "yandex_iam_service_account" "monitoring-sa" {
  folder_id = var.folder_id
  name      = "tf-monitoring-sa"
}

// Grant permissions
resource "yandex_resourcemanager_folder_iam_member" "monitoring-sa" {
  folder_id = var.folder_id
  role      = "logging.writer"
  member    = "serviceAccount:${yandex_iam_service_account.monitoring-sa.id}"
}

resource "yandex_logging_group" "monitoring-group" {
  name      = "flluentbit-group"
  folder_id = var.folder_id
}
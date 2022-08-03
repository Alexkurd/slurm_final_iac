variable "public_key" {}

variable "region" {
  default = "ru-central1"
}
variable "zone" {
  default = "ru-central1-a"
}
variable "domain" {
  default = "s041120.tech"
}

variable "cloud_id" {}
variable "folder_id" {}
variable "yc_token" {}

//Database
variable "pg_dbname" {}
variable "pg_user" {}
variable "pg_password" {}
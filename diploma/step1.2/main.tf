terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  service_account_key_file = "sa.json"
  cloud_id  = "b1gnent42f5ngd6p9ko6"
  folder_id = "b1g2ll8gqs3068utaas2"
  zone = "ru-central1-a"
}

// Create terraform SA
resource "yandex_iam_service_account" "terraform-sa" {
  folder_id = "b1g2ll8gqs3068utaas2"
  name      = "terraform-sa"
}

// Grant permissions to terraform  sa
resource "yandex_resourcemanager_folder_iam_member" "sa-editor" {
  folder_id = "b1g2ll8gqs3068utaas2"
  role      = "editor"
  member    = "serviceAccount:${yandex_iam_service_account.terraform-sa.id}"
} 

// Create Static Access Keys for terraform SA
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.terraform-sa.id
  description        = "static access key for object storage"
}

terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  token     = ""
  cloud_id  = "b1g1vahdpuk84crtqbeo"
  folder_id = "b1g4uhj60ck9ocv7ojdt"
  zone      = "ru-central1-a"
}

resource "yandex_compute_image" "ubuntu2004img" {
  name       = "ubuntu-20-04-lts-v20211220"
  source_image = "f2eds5lpj5spivf93dkt"
}
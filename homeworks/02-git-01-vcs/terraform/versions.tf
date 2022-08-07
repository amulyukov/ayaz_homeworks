terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"

backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "ayazmulyukovs3bucket"
    region     = "ru-central1"
    key        = "prod/terraform.tfstate"
    access_key = "YCAJEac1SUI_TENum6cmkUXCo"
    secret_key = "git status"

    skip_region_validation      = true
    skip_credentials_validation = true
  }

}
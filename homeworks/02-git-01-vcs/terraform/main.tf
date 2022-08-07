provider "yandex" {
  token     = var.yc_token
  cloud_id  = var.yandex_cloud_id
  folder_id = var.yandex_folder_id
  zone      = "ru-central1-a"
}

resource "yandex_compute_image" "ubuntu2004img" {
  name       = "ubuntu-20-04-lts-v20210811a"
  source_image = "fd8fbgvdt6mktnprvo89"
}

resource "yandex_vpc_network" "net" {
  name = "net"
}

resource "yandex_vpc_subnet" "subnet" {
  name           = "subnet"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.net.id
  v4_cidr_blocks = ["192.168.50.0/24"]
}

locals {
  instance = {
  stage = 1
  prod = 2
  }
}

resource "yandex_compute_instance" "vm-count" {
  name = "vm-${count.index}-${terraform.workspace}"

  resources {
    cores  = "2"
    memory = "2"
  }

  boot_disk {
    initialize_params {
      image_id = "${yandex_compute_image.ubuntu2004img.id}"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet.id
    nat       = true
  }

  count = local.instance[terraform.workspace]
}

locals {
  id = toset([
    "2",
    "3",
  ])
}

resource "yandex_compute_instance" "vm-for" {
  for_each = local.id
  name     = "vm-${each.key}-${terraform.workspace}"

  resources {
    cores  = "2"
    memory = "2"
  }

  boot_disk {
    initialize_params {
      image_id = "${yandex_compute_image.ubuntu2004img.id}"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet.id
    nat       = true
  }
}

resource "yandex_storage_bucket" "my_bucket_for_state" {
  access_key = "YCAJEac1SUI_TENum6cmkUXCo"
  secret_key = ""
  bucket = "ayazmulyukovs3bucket"
}




locals {
  project = "ivory-bonus-321503"
  region  = "us-east1"
  zone    = "us-east1-c"
}

provider "google" {
  credentials = file("/usr/bin/instance.json")
  project     = local.project
  region      = local.region
  zone        = local.zone
}

resource "google_compute_instance" "dofin_server" {
   name         = "dofin-elk"
   machine_type = "e2-standard-2"
   zone         = "us-east1-c"

   labels  = {
     maintainer = "devops"
     env = "dev"
   }

   boot_disk {
     initialize_params {
       image = "ubuntu-os-cloud/ubuntu-2004-lts"
     }
   }

   network_interface {

     network = "default"

     access_config {
      // Ephemeral IP
    }
  }
}


provider "google" {
        credentials = file("/usr/bin/cluster.json")
        project = "ivory-bonus-321503"
        region = "us-east1"
        zone   = "us-east1-b"
}
module "gke" {
  source                     = "terraform-google-modules/kubernetes-engine/google"
  project_id                 = "ivory-bonus-321503"
  name                       = "dofin-dev-cluster"
  region                     = "us-east1"
  regional                   = "false"
  zones                      = ["us-east1-b"]
  ip_range_pods              = ""
  ip_range_services          = ""
  network                    = "default"
  subnetwork                 = "default"
  http_load_balancing        = false
  horizontal_pod_autoscaling = true
  network_policy             = false

  node_pools = [
    {
      name                      = "dofin-node-pool"
      machine_type              = "e2-standard-2"
      min_count                 = 1
      max_count                 = 2
      local_ssd_count           = 0
      disk_size_gb              = 100
      disk_type                 = "pd-standard"
      image_type                = "COS_CONTAINERD"
      auto_repair               = true
      auto_upgrade              = true
      service_account           = "kubernetes-cluster@ivory-bonus-321503.iam.gserviceaccount.com"
      preemptible               = true
      initial_node_count        = 2
    },
  ]

  node_pools_oauth_scopes = {
    all = []

    default-node-pool = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  node_pools_labels = {
    all = {}
     default-node-pool = {
      default-node-pool = true
    }
  }

  node_pools_metadata = {
    all = {}

    default-node-pool = {
      node-pool-metadata-custom-value = "my-node-pool"
    }
  }

  node_pools_taints = {
    all = []

    default-node-pool = [
      {
        key    = "default-node-pool"
        value  = true
        effect = "PREFER_NO_SCHEDULE"
      },
    ]
  }

  node_pools_tags = {
    all = []

    default-node-pool = [
      "default-node-pool",
    ]
  }
}

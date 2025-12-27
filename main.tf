data "google_project" "project" {
  project_id = var.project_id
}

locals {
  project_id         = data.google_project.project.project_id
  compute_sa         = "serviceAccount:${data.google_project.project.number}-compute@developer.gserviceaccount.com"
  subnet_range       = "192.168.0.0/24"
  pod_range          = "10.0.0.0/16"
  service_range      = "172.16.16.0/20"
  master_range       = "10.255.0.16/28"
  max_pods_per_node  = "64"
  initial_node_count = 1
  min_node_count     = 1
  max_node_count     = 6
  preemptible        = true
  machine_type       = "n1-standard-2"
}

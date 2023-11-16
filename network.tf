resource "google_compute_network" "network" {
  project                         = var.project_id
  name                            = var.name
  auto_create_subnetworks         = "false"
  routing_mode                    = "REGIONAL"
  delete_default_routes_on_create = "true"
}

resource "google_compute_route" "default_route" {
  project          = var.project_id
  name             = "default-route"
  dest_range       = "0.0.0.0/0"
  network          = google_compute_network.network.self_link
  next_hop_gateway = "default-internet-gateway"
  priority         = 1000
}

resource "google_compute_subnetwork" "subnet" {
  project                  = var.project_id
  name                     = "${var.name}-cluster-subnet"
  ip_cidr_range            = local.subnet_range
  region                   = var.region
  private_ip_google_access = "true"
  network                  = google_compute_network.network.id
  secondary_ip_range = [
    {
      range_name    = "pod-range"
      ip_cidr_range = local.pod_range
    },
    {
      range_name    = "service-range"
      ip_cidr_range = local.service_range
    },

  ]
}

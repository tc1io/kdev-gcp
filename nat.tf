resource "google_compute_address" "nat" {
  count   = var.number_of_nat_ips
  project = var.project_id
  region  = var.region
  name    = "${var.name}-nat-${count.index}"
}

resource "google_compute_router" "nat" {
  count   = var.number_of_nat_ips > 0 ? 1 : 0
  project = var.project_id
  region  = var.region
  name    = var.name
  network = google_compute_network.network.id
}

resource "google_compute_router_nat" "nat" {
  count                              = var.number_of_nat_ips > 0 ? 1 : 0
  project                            = var.project_id
  region                             = var.region
  name                               = var.name
  router                             = google_compute_router.nat[0].name
  nat_ip_allocate_option             = "MANUAL_ONLY"
  nat_ips                            = [for nat in google_compute_address.nat : nat.self_link]
  min_ports_per_vm                   = 64
  udp_idle_timeout_sec               = 30
  icmp_idle_timeout_sec              = 30
  tcp_established_idle_timeout_sec   = 1200
  tcp_transitory_idle_timeout_sec    = 30
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  log_config {
    enable = true
    filter = "ALL"
  }

  subnetwork {
    name                     = google_compute_subnetwork.subnet.self_link
    source_ip_ranges_to_nat  = ["PRIMARY_IP_RANGE", "LIST_OF_SECONDARY_IP_RANGES"]
    secondary_ip_range_names = ["pod-range"]
  }

  timeouts {
    create = "10m"
    update = "20m"
    delete = "10m"
  }
}


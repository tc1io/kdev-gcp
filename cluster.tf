resource "random_shuffle" "available_zones" {
  input        = data.google_compute_zones.available.names
  result_count = 3
}

data "google_compute_zones" "available" {
  project = var.project_id
  region  = var.region
}

data "google_container_engine_versions" "region" {
  project  = var.project_id
  location = var.region
}

resource "google_container_cluster" "default" {
  name                      = var.name
  project                   = var.project_id
  location                  = var.region
  node_locations            = sort(random_shuffle.available_zones.result)
  network                   = google_compute_network.network.name
  subnetwork                = google_compute_subnetwork.subnet.name
  enable_shielded_nodes     = true
  default_max_pods_per_node = local.max_pods_per_node
  initial_node_count        = 0
  remove_default_node_pool  = true

  release_channel {
    channel = "STABLE"
  }

  master_auth {
    client_certificate_config {
      issue_client_certificate = "false"
    }
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = "pod-range"
    services_secondary_range_name = "service-range"
  }

  node_pool {
    name = "default-pool"
  }

  private_cluster_config {
    enable_private_endpoint = false
    enable_private_nodes    = true
    master_ipv4_cidr_block  = local.master_range
  }

  logging_config {
    enable_components = ["SYSTEM_COMPONENTS", "WORKLOADS"]
  }

  monitoring_config {
    enable_components = ["SYSTEM_COMPONENTS"]
    managed_prometheus {
      enabled = false #var.enable_managed_prom
    }
  }

  dynamic "master_authorized_networks_config" {
    for_each = var.cluster_master_authorized_networks_config
    content {
      dynamic "cidr_blocks" {
        for_each = master_authorized_networks_config.value.cidr_blocks
        content {
          cidr_block   = lookup(cidr_blocks.value, "cidr_block", "")
          display_name = lookup(cidr_blocks.value, "display_name", "")
        }
      }
    }
  }

  lifecycle {
    ignore_changes = [
      node_pool,
      master_authorized_networks_config,
    ]
    prevent_destroy = "false"
  }

  timeouts {
    create = "30m"
    update = "60m"
    delete = "30m"
  }
}

resource "google_container_node_pool" "default" {
  project            = var.project_id
  location           = var.region
  name               = var.name
  cluster            = google_container_cluster.default.name
  initial_node_count = local.initial_node_count
  max_pods_per_node  = local.max_pods_per_node
  version            = google_container_cluster.default.min_master_version
  autoscaling {
    min_node_count  = local.min_node_count
    max_node_count  = local.max_node_count
    location_policy = "ANY"
  }

  node_config {
    preemptible     = local.preemptible
    service_account = "default"
    #oauth_scopes    = var.oauth_scopes
    machine_type = local.machine_type
    image_type   = "COS_CONTAINERD"
    disk_size_gb = "30"
    disk_type    = "pd-standard"

    tags = ["cluster"]

    shielded_instance_config {
      enable_secure_boot          = true
      enable_integrity_monitoring = true
    }
  }

  lifecycle {
    prevent_destroy = "false"

    ignore_changes = [
      initial_node_count,
    ]
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  timeouts {
    create = "30m"
    update = "60m"
    delete = "30m"
  }
}

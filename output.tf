output "console_address_name" {
  value = google_compute_global_address.console.name
}
output "console_address_ip" {
  value = google_compute_global_address.console.address
}
output "assets_address_name" {
  value = google_compute_global_address.assets.name
}
output "assets_address_ip" {
  value = google_compute_global_address.assets.address
}

output "console_dns" {
  value = google_dns_record_set.console.name
}
output "assets_dns" {
  value = google_dns_record_set.assets.name
}

output "cluster_self_link" {
  value = google_container_cluster.default.self_link
}
output "cluster_endpoint" {
  description = "The cluster endpoint to connect to"
  value       = google_container_cluster.default.endpoint
}

output "cluster_master_auth" {
  description = "The master auth data of the cluster"
  value       = google_container_cluster.default.master_auth
  sensitive   = true
}

output "cluster_instance_group_urls" {
  description = "The instance group urls"
  value       = google_container_node_pool.default.instance_group_urls
}

output "cluster_name" {
  description = "The full name of the created cluster"
  value       = google_container_cluster.default.name

}
output "nat_addresses_ips" {
  value = google_compute_address.nat.*.address
}

data "google_dns_managed_zone" "zone" {
  project = var.project_id
  name    = "econ-dev"
}

resource "google_dns_record_set" "console" {
  project      = var.project_id
  name         = "console.${var.name}.econ.dev."
  type         = "A"
  ttl          = 60
  managed_zone = data.google_dns_managed_zone.zone.name
  rrdatas      = [google_compute_global_address.console.address]
}
resource "google_dns_record_set" "assets" {
  project      = var.project_id
  name         = "assets.${var.name}.econ.dev."
  type         = "A"
  ttl          = 60
  managed_zone = data.google_dns_managed_zone.zone.name
  rrdatas      = [google_compute_global_address.assets.address]
}

resource "google_compute_global_address" "console" {
  project      = var.project_id
  name         = "${var.name}-console"
  address_type = "EXTERNAL"
}
resource "google_compute_global_address" "assets" {
  project      = var.project_id
  name         = "${var.name}-assets"
  address_type = "EXTERNAL"
}

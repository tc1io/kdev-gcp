resource "google_compute_firewall" "allow_lb_ingress" {
  name        = "${var.name}-http-ingress"
  description = "Allow internal incoming HTTP traffic"
  project     = var.project_id
  network     = google_compute_network.network.self_link
  priority    = "1000"
  direction   = "INGRESS"
  allow {
    protocol = "tcp"
    ports = [
      "80",
    ]
  }

  target_tags = ["cluster"]
  source_ranges = [
    "130.211.0.0/22",
    "35.191.0.0/16"
  ]
}
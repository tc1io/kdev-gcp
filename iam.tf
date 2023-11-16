resource "google_project_iam_member" "compute_sa_can_pull" {
  project = var.project_id
  role    = "roles/storage.objectViewer"
  member  = local.compute_sa
}

resource "google_project_iam_member" "compute_sa_can_write_logs" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = local.compute_sa
}

resource "google_project_iam_member" "compute_sa_can_write_metrics" {
  project = var.project_id
  role    = "roles/monitoring.metricWriter"
  member  = local.compute_sa
}
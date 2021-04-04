locals {
  project  = var.project
  image    = var.image
  location = var.location

  service_name = "app"
}

# Providers

provider "google" {
  project = local.project
}

# APIs

resource "google_project_service" "run_api" {
  service            = "run.googleapis.com"
  disable_on_destroy = true
}

resource "google_project_service" "resource_manager_api" {
  service            = "cloudresourcemanager.googleapis.com"
  disable_on_destroy = true
}

resource "google_project_service" "container_registry_api" {
  service            = "containerregistry.googleapis.com"
  disable_on_destroy = true
}

resource "google_project_service" "iam_api" {
  service            = "iam.googleapis.com"
  disable_on_destroy = true
}

# Cloud Run service

resource "google_cloud_run_service" "run_service" {
  name = local.service_name

  location = local.location

  template {
    spec {
      containers {
        image = local.image
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  depends_on = [google_project_service.run_api, google_project_service.resource_manager_api]
}

resource "google_cloud_run_service_iam_member" "allUsers" {
  service  = google_cloud_run_service.run_service.name
  location = google_cloud_run_service.run_service.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}

# Service Account for deployment

resource "google_service_account" "deployment_sa" {
  project      = local.project
  account_id   = "deployment-sa"
  display_name = "Deployment Service Account"
}

resource "google_service_account_key" "deployment_sa_key" {
  service_account_id = google_service_account.deployment_sa.name
}

resource "google_project_iam_member" "deployment_sa_role_editor" {
  project = local.project
  role    = "roles/editor"
  member  = "serviceAccount:${google_service_account.deployment_sa.email}"
}

# Outputs

output "url" {
  value = google_cloud_run_service.run_service.status[0].url
}

output "deployment_sa_key" {
  sensitive = true
  value     = base64decode(google_service_account_key.deployment_sa_key.private_key)
}
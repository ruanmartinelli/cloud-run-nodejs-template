terraform {
  required_version = ">= 0.13"

  # backend "gcs" {
  #   bucket = "tfstate-PROJECT_ID"
  # }

  required_providers {
    google = ">= 3.3"
  }
}
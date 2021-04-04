terraform {
  required_version = ">= 0.13"

  backend "gcs" {
    bucket = "tfstate-my-cool-project-9981"
  }

  required_providers {
    google = ">= 3.3"
  }
}
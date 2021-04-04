terraform {
  required_version = ">= 0.13"

  backend "gcs" {
    bucket = "tfstate-crested-grove-309715"
  }

  required_providers {
    google = ">= 3.3"
  }
}
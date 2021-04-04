terraform {
  required_version = ">= 0.13"

  // backend "gcs" {
  //   bucket = "BUCKET_NAME"
  // }

  required_providers {
    google = ">= 3.3"
  }
}
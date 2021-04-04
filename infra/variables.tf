variable "project" {
  type = string
}

variable "location" {
  type    = string
  default = "us-central1"
}

variable "image" {
  type    = string
  default = "gcr.io/cloudrun/hello"
}

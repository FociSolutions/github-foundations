terraform {
  required_version = ">= 1.8"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 6.9.0" # tftest
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 6.9.0" # tftest
    }
    github = {
      source  = "integrations/github"
      version = "6.4.0"
    }
  }
}

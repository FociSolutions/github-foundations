locals {
  folder = (
    var.folder_create
    ? try(google_folder.folder.0, null)
    : try(data.google_folder.folder.0, null)
  )
}

data "google_folder" "folder" {
  count  = var.folder_create ? 0 : 1
  folder = var.id
}

resource "google_folder" "folder" {
  count        = var.folder_create ? 1 : 0
  display_name = var.folder_name
  parent       = var.parent
}
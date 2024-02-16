locals {
  project_parent = var.project_parent == null ? google_folder.folder[0].id : var.project_parent
}

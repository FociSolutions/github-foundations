/**
 * Copyright 2022 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

locals {
  project_id = "${local.prefix}${var.project_name}${random_id.unique_project_suffix.dec}" #TODO project id's need to be a min of 4 and a max of 30 characters. So we need to make sure input isn't more than 23 characters since the 2 byte random_id is 7 digits
  descriptive_name = (
    var.descriptive_name != null ? var.descriptive_name : local.project_id
  )
  parent_type = local.project_parent == null ? null : split("/", local.project_parent)[0]
  parent_id   = local.project_parent == null ? null : split("/", local.project_parent)[1]
  prefix      = var.prefix == null ? "" : "${var.prefix}-"
  project = (
    var.project_create ?
    {
      project_id = try(google_project.project.0.project_id, null)
      number     = try(google_project.project.0.number, null)
      name       = try(google_project.project.0.name, null)
    }
    : {
      project_id = local.project_id
      number     = try(data.google_project.project.0.number, null)
      name       = try(data.google_project.project.0.name, null)
    }
  )
}

data "google_project" "project" {
  count      = var.project_create ? 0 : 1
  project_id = "${local.prefix}${var.project_name}" #TODO - clean this up. It doesn't make any sense that we add a prefix if we are asking them for an existing project name
}

resource "random_id" "unique_project_suffix" {
  byte_length = 2
}

resource "google_project" "project" {
  count               = var.project_create ? 1 : 0
  org_id              = local.parent_type == "organizations" ? local.parent_id : null
  folder_id           = local.parent_type == "folders" ? local.parent_id : null
  project_id          = local.project_id
  name                = local.descriptive_name
  billing_account     = var.billing_account
  auto_create_network = var.auto_create_network
  labels              = var.labels
  skip_delete         = var.skip_delete
  depends_on          = [google_folder.folder]
}

resource "google_project_service" "project_services" {
  for_each                   = toset(var.services)
  project                    = local.project.project_id
  service                    = each.value
  disable_on_destroy         = var.service_config.disable_on_destroy
  disable_dependent_services = var.service_config.disable_dependent_services
}


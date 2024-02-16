resource "google_storage_bucket" "bucket" {
  name                        = lower(var.bucket_name)
  depends_on                  = [google_project_service.project_services]
  project                     = google_project.project[0].project_id
  location                    = var.location
  storage_class               = var.storage_class
  force_destroy               = var.force_destroy
  uniform_bucket_level_access = var.uniform_bucket_level_access
  labels                      = var.labels
  default_event_based_hold    = var.default_event_based_hold
  requester_pays              = var.requester_pays
  versioning {
    enabled = var.versioning
  }

  dynamic "autoclass" {
    for_each = var.autoclass == null ? [] : [""]
    content {
      enabled = var.autoclass
    }
  }

  dynamic "website" {
    for_each = var.website == null ? [] : [""]

    content {
      main_page_suffix = var.website.main_page_suffix
      not_found_page   = var.website.not_found_page
    }
  }

  dynamic "encryption" {
    for_each = var.encryption_key == null ? [] : [""]

    content {
      default_kms_key_name = var.encryption_key
    }
  }

  dynamic "retention_policy" {
    for_each = var.retention_policy == null ? [] : [""]
    content {
      retention_period = var.retention_policy.retention_period
      is_locked        = var.retention_policy.is_locked
    }
  }

  dynamic "logging" {
    for_each = var.logging_config == null ? [] : [""]
    content {
      log_bucket        = var.logging_config.log_bucket
      log_object_prefix = var.logging_config.log_object_prefix
    }
  }

  dynamic "cors" {
    for_each = var.cors == null ? [] : [""]
    content {
      origin          = var.cors.origin
      method          = var.cors.method
      response_header = var.cors.response_header
      max_age_seconds = max(3600, var.cors.max_age_seconds)
    }
  }

  dynamic "lifecycle_rule" {
    for_each = var.lifecycle_rules
    iterator = rule
    content {
      action {
        type          = rule.value.action.type
        storage_class = rule.value.action.storage_class
      }
      condition {
        age                        = rule.value.condition.age
        created_before             = rule.value.condition.created_before
        custom_time_before         = rule.value.condition.custom_time_before
        days_since_custom_time     = rule.value.condition.days_since_custom_time
        days_since_noncurrent_time = rule.value.condition.days_since_noncurrent_time
        matches_prefix             = rule.value.condition.matches_prefix
        matches_storage_class      = rule.value.condition.matches_storage_class
        matches_suffix             = rule.value.condition.matches_suffix
        noncurrent_time_before     = rule.value.condition.noncurrent_time_before
        num_newer_versions         = rule.value.condition.num_newer_versions
        with_state                 = rule.value.condition.with_state
      }
    }
  }

  dynamic "custom_placement_config" {
    for_each = var.custom_placement_config == null ? [] : [""]

    content {
      data_locations = var.custom_placement_config
    }
  }
}
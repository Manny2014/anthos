resource "google_kms_key_ring" "binary_auth" {
  name     = "binary-auth-keyring"
  project  = google_project.this.project_id
  location = data.terraform_remote_state.bootstrap.outputs.org_default_location
  depends_on = [
    google_project.this,
    module.enabled_services,
  ]
}

resource "google_kms_crypto_key" "binary_auth_key" {
  name     = "binary-auth-key"
  key_ring = google_kms_key_ring.binary_auth.id
  purpose  = "ASYMMETRIC_SIGN"

  version_template {
    algorithm = "EC_SIGN_P256_SHA256"
  }

  # lifecycle {
  #   prevent_destroy = true
  # }
}
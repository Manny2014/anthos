# SS -> WILL ACT AS ATTESTOR & ATTESTATION PROJECT
# -----------------------------------------------

resource "google_container_analysis_note" "default" {
  project  = google_project.this.project_id

  name = "default-attestor-note"
  attestation_authority {
    hint {
      human_readable_name = "My Default attestor"
    }
  }
  depends_on = [
    google_project.this,
    module.enabled_services,
  ]
}

data "google_kms_crypto_key_version" "binary_auth_key" {
  crypto_key = google_kms_crypto_key.binary_auth_key.id
}

# REPRESENTS AN APPROVAL PARTY
resource "google_binary_authorization_attestor" "default" {
  project  = google_project.this.project_id
  name = "default-attestor"
  attestation_authority_note {
    note_reference = google_container_analysis_note.default.name
    public_keys {
        id = data.google_kms_crypto_key_version.binary_auth_key.id
        pkix_public_key {
            public_key_pem      = data.google_kms_crypto_key_version.binary_auth_key.public_key[0].pem
            signature_algorithm = data.google_kms_crypto_key_version.binary_auth_key.public_key[0].algorithm
        }
    }
  }
}

# TODO: THINK THIS IS ONLY NEEDED IF ATTESTATIONS ARE IN A DIFF PROJEC...
resource "google_project_iam_binding" "container_analysis_note_occurrences_viewer" {
  project  = google_project.this.project_id
  role    = "roles/containeranalysis.notes.occurrences.viewer"
  members = [
    "serviceAccount:service-${google_project.this.number}@gcp-sa-binaryauthorization.iam.gserviceaccount.com"
  ]
}
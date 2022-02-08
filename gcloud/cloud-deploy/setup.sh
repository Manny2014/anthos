PROJECT_ID=dev-playground-5491

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member=serviceAccount:$(gcloud projects describe $PROJECT_ID \
    --format="value(projectNumber)")-compute@developer.gserviceaccount.com \
    --role="roles/clouddeploy.jobRunner"

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member=serviceAccount:$(gcloud projects describe $PROJECT_ID \
    --format="value(projectNumber)")-compute@developer.gserviceaccount.com \
    --role="roles/container.developer"

 gcloud deploy apply --file clouddeploy.yaml --region=us-central1 --project=$PROJECT_ID

 gcloud deploy releases create test-release-001 \
  --project=$PROJECT_ID \
  --region=us-central1 \
  --delivery-pipeline=rust-rocket-server \
  --images=rust_rocket_server=us-central1-docker.pkg.dev/shared-network-19f4/main/rust_rocket_server@sha256:3bd0671e53d931468245b7571af240e361b0e18d477d3d74755a95b316db984c

# GET STATUS
gcloud deploy rollouts list --project=$PROJECT_ID \
--delivery-pipeline rust-rocket-server \
--release test-release-002 --region us-central1

gcloud deploy rollouts describe --project=$PROJECT_ID \
--delivery-pipeline rust-rocket-server \
--release test-release-002 --region us-central1


# ISSUES:
- It hung for a long time (10+minutes) with no real feed back
- Issue was binary auth, CB logs are not enough
- Only suports GKE (thought itd be more)
- No Cleanup options? OnFail?Keep?
- Could be "partially" centralized 
# POSITIVES
- 
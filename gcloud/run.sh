 gcloud beta container hub config-management apply \
     --membership=$CLUSTER_NAME \
     --config=app-spec.yaml \
     --project=$PROJECT_ID


# CONFIG CONNECTOR
gcloud iam service-accounts create config-connector --project $PROJECT_ID

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:config-connector@$PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/owner"

gcloud iam service-accounts add-iam-policy-binding \
config-connector@$PROJECT_ID.iam.gserviceaccount.com \
--member="serviceAccount:$PROJECT_ID.svc.id.goog[cnrm-system/cnrm-controller-manager]" \
--role="roles/iam.workloadIdentityUser" \
--project $PROJECT_ID
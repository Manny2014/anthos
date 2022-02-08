 gcloud beta container hub config-management apply \
     --membership=$CLUSTER_NAME \
     --config=app-spec.yaml \
     --project=$PROJECT_ID
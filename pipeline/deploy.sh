#!/usr/bin/env bash
# =================================================================================================
# CLOUD RUN FUNCTION AUTOMATED DEPLOYMENT SCRIPT
# =================================================================================================
# Usage:
#   ./pipeline/deploy.sh [PROJECT_ID] [BUCKET_NAME] [REGION] [TRIGGER_LOCATION]
#
# Defaults can also be configured via environment variables:
#   export GCP_PROJECT="your-project-id"
#   export BUCKET_NAME="your-bucket-name"
#   export REGION="us-central1"
#   export TRIGGER_LOCATION="us"
# =================================================================================================

set -e

PROJECT_ID="YOUR_PROJECT_ID"
BUCKET_NAME="YOUR_BUCKET_NAME"
REGION="us-central1"
TRIGGER_LOCATION="us"
DATASET_ID="looker_bq_costs"
FUNCTION_NAME="looker-system-activity-loader"

if [ "" = "YOUR_PROJECT_ID" ] || [ "" = "YOUR_BUCKET_NAME" ]; then
  echo "[ERROR] Please specify your GCP Project ID and GCS Bucket Name."
  echo "Example: ./pipeline/deploy.sh my-gcp-project my-looker-export-bucket us-central1 us"
  exit 1
fi

echo "============================================================"
echo "Deploying Cloud Run Function: "
echo "Project:          "
echo "Bucket:           "
echo "Region:           "
echo "Trigger Location: "
echo "Dataset:          "
echo "============================================================"

gcloud functions deploy ""   --gen2   --runtime=python311   --region=""   --trigger-location=""   --source=""/bin/cloud_function"   --entry-point=gcs_to_bigquery_loader   --trigger-event-filters="type=google.cloud.storage.object.v1.finalized"   --trigger-event-filters="bucket="   --set-env-vars="GCP_PROJECT=,BQ_DATASET="   --memory=512Mi   --timeout=300s   --project=""

echo "============================================================"
echo "Deployment completed successfully!"
echo "============================================================"

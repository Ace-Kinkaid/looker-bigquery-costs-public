#!/usr/bin/env bash
# =================================================================================================
# CLOUD RUN FUNCTION AUTOMATED DEPLOYMENT SCRIPT
# =================================================================================================
# Usage:
#   ./pipeline/deploy.sh [PROJECT_ID] [BUCKET_NAME] [REGION] [TRIGGER_LOCATION]
#
# Defaults can also be configured via environment variables:
#   export PROJECT_ID="my-awesome-gcp-project"
#   export BUCKET_NAME="my-awesome-gcs-bucket"
#   export REGION="us-central1"
#   export TRIGGER_LOCATION="us"
#   export DATASET_ID="looker_bq_costs"
# =================================================================================================

set -e

# =================================================================================================
# CONFIGURATION PLACEHOLDERS (Update these or pass as CLI arguments)
# =================================================================================================
PROJECT_ID="${1:-${PROJECT_ID:-my-awesome-gcp-project}}"
BUCKET_NAME="${2:-${BUCKET_NAME:-my-awesome-gcs-bucket}}"
REGION="${3:-${REGION:-us-central1}}"
TRIGGER_LOCATION="${4:-${TRIGGER_LOCATION:-us}}"
DATASET_ID="${DATASET_ID:-looker_bq_costs}"
FUNCTION_NAME="looker-system-activity-loader"

if [ "${PROJECT_ID}" = "my-awesome-gcp-project" ] || [ "${BUCKET_NAME}" = "my-awesome-gcs-bucket" ]; then
  echo "[WARNING] Using default placeholder values for PROJECT_ID or BUCKET_NAME."
  echo "To deploy with your actual environment values, pass arguments or set environment variables:"
  echo "  ./pipeline/deploy.sh <YOUR_PROJECT_ID> <YOUR_BUCKET_NAME> [REGION] [TRIGGER_LOCATION]"
  echo "  or:"
  echo "  export PROJECT_ID=\"<YOUR_PROJECT_ID>\""
  echo "  export BUCKET_NAME=\"<YOUR_BUCKET_NAME>\""
  echo "  ./pipeline/deploy.sh"
  echo ""
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "============================================================"
echo "Deploying Cloud Run Function: ${FUNCTION_NAME}"
echo "Project:          ${PROJECT_ID}"
echo "Bucket:           ${BUCKET_NAME}"
echo "Region:           ${REGION}"
echo "Trigger Location: ${TRIGGER_LOCATION}"
echo "Dataset:          ${DATASET_ID}"
echo "============================================================"

gcloud functions deploy "${FUNCTION_NAME}" \
  --gen2 \
  --runtime=python311 \
  --region="${REGION}" \
  --trigger-location="${TRIGGER_LOCATION}" \
  --source="${SCRIPT_DIR}/cloud_function" \
  --entry-point=gcs_to_bigquery_loader \
  --trigger-event-filters="type=google.cloud.storage.object.v1.finalized" \
  --trigger-event-filters="bucket=${BUCKET_NAME}" \
  --set-env-vars="GCP_PROJECT=${PROJECT_ID},BQ_DATASET=${DATASET_ID}" \
  --memory=512Mi \
  --timeout=300s \
  --project="${PROJECT_ID}"

echo "============================================================"
echo "Deployment completed successfully!"
echo "============================================================"

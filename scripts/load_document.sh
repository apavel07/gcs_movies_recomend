# https://cloud.google.com/generative-ai-app-builder/docs/refresh-data#discoveryengine_v1_generated_DocumentService_RefreshStructured_sync-drest

curl -X POST \
-H "Authorization: Bearer $(gcloud auth print-access-token)" \
-H "Content-Type: application/json" \
"https://discoveryengine.googleapis.com/v1beta/projects/mware-data/locations/global/collections/default_collection/dataStores/mware-apavel-store-1_1741885585552/branches/0/documents:import" \
-d '{
  "bigquerySource": {
    "projectId": "mware-data",
    "datasetId":"mware_curated",
    "tableId": "document",
    "dataSchema": "document",
  },
  "reconciliationMode": "INCREMENTAL",
}'


#curl -X POST \
#-H "Authorization: Bearer $(gcloud auth print-access-token)" \
#-H "Content-Type: application/json" \
#"https://discoveryengine.googleapis.com/v1beta/projects/PROJECT_ID/locations/global/collections/default_collection/dataStores/DATA_STORE_ID/branches/0/documents:import" \
#-d '{
#  "bigquerySource": {
#    "projectId": "PROJECT_ID",
#    "datasetId":"DATASET_ID",
#    "tableId": "TABLE_ID",
#    "dataSchema": "DATA_SCHEMA_BQ",
#  },
#  "reconciliationMode": "RECONCILIATION_MODE",
#  "autoGenerateIds": AUTO_GENERATE_IDS,
#  "idField": "ID_FIELD",
#  "errorConfig": {
#    "gcsPrefix": "ERROR_DIRECTORY"
#  }
#}'
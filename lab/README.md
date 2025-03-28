https://polbox.tv/pl/wideoteka/serial/thriller/bates-motel/
https://chat.team24.biz/group/AI


https://cloud.google.com/generative-ai-app-builder/docs/try-media-recommendations

https://cloud.google.com/generative-ai-app-builder/docs/about-media-recommendations-types#recommended-for-you

https://console.cloud.google.com/welcome?inv=1&invt=AbrqTw&project=mware-data

Recomended for you (CTR) 



----------------------
Lab
https://cloud.google.com/generative-ai-app-builder/docs/try-media-recommendations?cloudshell=true
----------------------

# set the default project for the command-line
gcloud config set project mware-data

# load sample data
bq load --skip_leading_rows=1 apavel_lab.movies \
  gs://cloud-samples-data/gen-app-builder/media-recommendations/movies.csv \
  movieId:integer,title,genres
  
bq load --skip_leading_rows=1 apavel_lab.ratings \
  gs://cloud-samples-data/gen-app-builder/media-recommendations/ratings.csv \
  userId:integer,movieId:integer,rating:float,time:timestamp
  
-----------------------------  
# CREATE VIEW with console 
-----------------------------  
bq mk --project_id=mware-data \
 --use_legacy_sql=false \
 --view '
  WITH t AS (
    SELECT
      CAST(movieId AS string) AS id,
      SUBSTR(title, 0, 128) AS title,
      SPLIT(genres, "|") AS categories
      FROM `mware-data.apavel_lab.movies`)
    SELECT
      id, "default_schema" as schemaId, null as parentDocumentId,
      TO_JSON_STRING(STRUCT(title as title, categories as categories,
      CONCAT("http://mytestdomain.movie/content/", id) as uri,
      "2023-01-01T00:00:00Z" as available_time,
      "2033-01-01T00:00:00Z" as expire_time,
      "movie" as media_type)) as jsonData
    FROM t;' \
apavel_lab.movies_view  

bq mk --project_id=mware-data \
 --use_legacy_sql=false \
 --view '
 WITH t AS (
  SELECT
    MIN(UNIX_SECONDS(time)) AS old_start,
    MAX(UNIX_SECONDS(time)) AS old_end,
    UNIX_SECONDS(TIMESTAMP_SUB(
    CURRENT_TIMESTAMP(), INTERVAL 90 DAY)) AS new_start,
    UNIX_SECONDS(CURRENT_TIMESTAMP()) AS new_end
  FROM `mware-data.apavel_lab.ratings`)
  SELECT
    CAST(userId AS STRING) AS userPseudoId,
    "view-item" AS eventType,
    FORMAT_TIMESTAMP("%Y-%m-%dT%X%Ez",
    TIMESTAMP_SECONDS(CAST(
      (t.new_start + (UNIX_SECONDS(time) - t.old_start) *
      (t.new_end - t.new_start) / (t.old_end - t.old_start))
    AS int64))) AS eventTime,
    [STRUCT(movieId AS id, null AS name)] AS documents,
  FROM `mware-data.apavel_lab.ratings`, t
  WHERE rating >= 4;' \
  apavel_lab.user_events




bq show --format=ddl mware-data:mware.events_media_complete_1



curl -X POST -H "Authorization: Bearer $(gcloud auth print-access-token)" \
-H "Content-Type: application/json" \
https://discoveryengine.googleapis.com/v1beta/projects/142998836949/locations/global/collections/default_collection/engines/apavel-recommendations_1741885368373/servingConfigs/apavel-recommendations_1741885368373:recommend \
-d '{"userEvent":{"eventType":"view-home-page","userPseudoId":"<USER_PSEUDO_ID>","documents":[{"id":"10013"}]}}'

curl -X POST -H "Authorization: Bearer $(gcloud auth print-access-token)" \
-H "Content-Type: application/json" \
https://discoveryengine.googleapis.com/v1beta/projects/142998836949/locations/global/collections/default_collection/engines/apavel-recommendations_1741885368373/servingConfigs/apavel-recommendations_1741885368373:recommend \
-d '{"userEvent":{"eventType":"view-home-page","userPseudoId":"12623708","documents":[{"id":"10013"}]}}'

curl -X POST -H "Authorization: Bearer $(gcloud auth print-access-token)" -H "Content-Type: application/json" https://discoveryengine.googleapis.com/v1beta/projects/142998836949/locations/global/collections/default_collection/engines/apavel-recommendations_1741885368373/servingConfigs/apavel-recommendations_1741885368373:recommend -d '{"userEvent":{"eventType":"view-home-page","userPseudoId":"<USER_PSEUDO_ID>","documents":[{"id":"10013"}]}}'


gcloud iam service-accounts keys create key.json --iam-account=<SERVICE_ACCOUNT_EMAIL>
gcloud iam service-accounts keys create key.json --iam-account=apavel07@gmail.com


gcloud auth login
gcloud auth application-default login
Credentials saved to file: [C:\Users\panane01\AppData\Roaming\gcloud\application_default_credentials.json]

export GOOGLE_APPLICATION_CREDENTIALS="path/to/key.json"

# Check token
$TOKEN = gcloud auth print-access-token
curl -Method GET -Uri "https://www.googleapis.com/oauth2/v1/tokeninfo?access_token=$TOKEN"

# check project 
gcloud config list

# set project 
# gcloud config set project YOUR_PROJECT_ID
gcloud config set project mware-data

# grant permissions
gcloud projects add-iam-policy-binding YOUR_PROJECT_ID `
    --member="user:YOUR_EMAIL@example.com" `
    --role="roles/editor"

gcloud projects add-iam-policy-binding mware-data --member="user:apavel07@gmail.com" --role="roles/editor"
12634185

$BODY = '{"userEvent":{"eventType":"view-home-page","userPseudoId":"<USER_PSEUDO_ID>","documents":[{"id":"10013"}]}}'

$TOKEN = gcloud auth print-access-token
$URL = "https://discoveryengine.googleapis.com/v1beta/projects/142998836949/locations/global/collections/default_collection/engines/apavel-recommendations_1741885368373/servingConfigs/apavel-recommendations_1741885368373:recommend"
$BODY = '{"userEvent":{"eventType":"view-home-page","userPseudoId":"12623708","documents":[{"id":"38514"},{"id":"37901"},{"id":"24205"}]}}'
$BODY = '{"userEvent":{"eventType":"view-home-page","userPseudoId":"12634185","documents":[{"id":"38514"},{"id":"37901"},{"id":"24205"}]}}'

curl -Method POST -Uri $URL -Headers @{
    "Authorization" = "Bearer $TOKEN"
    "Content-Type" = "application/json"
} -Body $BODY 



{"id":"38514"},{"id":"37901"},{"id":"24205"}

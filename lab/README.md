### Events structure ### 
https://cloud.google.com/generative-ai-app-builder/docs/user-events

### Document structure ###
https://cloud.google.com/generative-ai-app-builder/docs/media-documents#json-schema


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

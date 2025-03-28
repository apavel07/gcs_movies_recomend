--------------------
-- CREATE VIEW in BQ GUI
----------------------
CREATE VIEW apavel_lab.movies_view
AS
WITH t AS (
    SELECT
        CAST(movieId AS string) AS id,
        SUBSTR(title, 0, 128) AS title,
        SPLIT(genres, "|") AS categories
    FROM `mware-data.apavel_lab.movies`)
SELECT
    id,
    "default_schema" as schemaId,
    null as parentDocumentId,
    TO_JSON_STRING(STRUCT(
        title as title,
        categories as categories,
        CONCAT("http://mytestdomain.movie/content/", id) as uri,
        "2023-01-01T00:00:00Z" as available_time,
        "2033-01-01T00:00:00Z" as expire_time,
        "movie" as media_type)) as jsonData
FROM t;


CREATE VIEW apavel_lab.user_events
AS
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
  WHERE rating >= 4;

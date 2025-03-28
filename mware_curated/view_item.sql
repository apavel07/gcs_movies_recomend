CREATE OR REPLACE VIEW mware_curated.view_item
AS
WITH t AS (
SELECT
    CAST(userPseudoId AS STRING) userPseudoId,
    'view-item' AS eventType,
    eventTime,
    --documents,
    ARRAY(
        SELECT AS STRUCT
            CAST(m.id_content AS STRING) AS id
        FROM UNNEST(JSON_EXTRACT_ARRAY(evv.documents)) AS json
        JOIN mware_curated.movies m ON JSON_EXTRACT_SCALAR(json, '$.id') = CAST(m.uri AS STRING)
    ) AS documents
FROM mware.events_view_video_1 evv
)
SELECT *
FROM t
WHERE ARRAY_LENGTH(documents) > 0


--
--CREATE OR REPLACE VIEW mware_curated.user_events
--AS
--SELECT
----    CAST(userPseudoId AS STRING) userPseudoId,
----    "view-item" AS eventType,
----    eventTime,
--    ARRAY(
--    SELECT AS STRUCT
--      JSON_EXTRACT_SCALAR(json, '$.id') AS id,
--      m.title
--    FROM UNNEST(JSON_EXTRACT_ARRAY(evv.documents)) AS json
--    JOIN mware_curated.movies m ON JSON_EXTRACT_SCALAR(json, '$.id') = CAST(m.uri AS STRING)
--    ) AS documents
--FROM mware.events_view_video_1 evv

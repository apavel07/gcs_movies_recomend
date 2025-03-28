WITH t AS (
SELECT
    CAST(userPseudoId AS STRING) userPseudoId,
    'view-item' AS eventType,
    CAST(eventTime AS TIMESTAMP) AS eventTime,
    --documents,
    ARRAY(
        SELECT AS STRUCT
            CAST(m.id_content AS STRING) AS id
        FROM UNNEST(JSON_EXTRACT_ARRAY(evv.documents)) AS json
        JOIN mware_curated.movies m ON JSON_EXTRACT_SCALAR(json, '$.id') = CAST(m.uri AS STRING)
    ) AS documents
FROM mware.events_view_video_1 evv
UNION ALL
SELECT
    CAST(userPseudoId AS STRING) userPseudoId,
    'view-item' AS eventType,
    TIMESTAMP_SUB(CAST(eventTime AS TIMESTAMP), INTERVAL 30 DAY) AS eventTime,
    --documents,
    ARRAY(
        SELECT AS STRUCT
            CAST(m.id_content AS STRING) AS id
        FROM UNNEST(JSON_EXTRACT_ARRAY(evv.documents)) AS json
        JOIN mware_curated.movies m ON JSON_EXTRACT_SCALAR(json, '$.id') = CAST(m.uri AS STRING)
    ) AS documents
FROM mware.events_view_video_1 evv
UNION ALL
SELECT
    CAST(userPseudoId AS STRING) userPseudoId,
    'view-item' AS eventType,
    TIMESTAMP_SUB(CAST(eventTime AS TIMESTAMP), INTERVAL 60 DAY) AS eventTime,
    --documents,
    ARRAY(
        SELECT AS STRUCT
            CAST(m.id_content AS STRING) AS id
        FROM UNNEST(JSON_EXTRACT_ARRAY(evv.documents)) AS json
        JOIN mware_curated.movies m ON JSON_EXTRACT_SCALAR(json, '$.id') = CAST(m.uri AS STRING)
    ) AS documents
FROM mware.events_view_video_1 evv
) 
SELECT
    t.userPseudoId,
    t.eventType,
    FORMAT_TIMESTAMP('%Y-%m-%dT%H:%M:%S%z', t.eventTime) AS eventTime,
    t.documents
FROM t 
WHERE ARRAY_LENGTH(documents) > 0
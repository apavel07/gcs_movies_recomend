CREATE OR REPLACE VIEW mware_curated.view_item
AS
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
),
t2 AS (
    SELECT
        userPseudoId,
        eventType,
        TIMESTAMP_SUB(eventTime, INTERVAL 0 DAY) AS eventTime,
        t.documents
    FROM t
    WHERE ARRAY_LENGTH(documents) > 0

    UNION ALL

    SELECT
        userPseudoId,
        eventType,
        TIMESTAMP_SUB(eventTime, INTERVAL 22 DAY) AS eventTime,
        t.documents
    FROM t
    WHERE ARRAY_LENGTH(documents) > 0

    UNION ALL

    SELECT
        userPseudoId,
        eventType,
        TIMESTAMP_SUB(eventTime, INTERVAL 44 DAY) AS eventTime,
        t.documents
    FROM t
    WHERE ARRAY_LENGTH(documents) > 0

        UNION ALL

    SELECT
        userPseudoId,
        eventType,
        TIMESTAMP_SUB(eventTime, INTERVAL 66 DAY) AS eventTime,
        t.documents
    FROM t
    WHERE ARRAY_LENGTH(documents) > 0
)
SELECT
    userPseudoId,
    eventType,
    FORMAT_TIMESTAMP('%Y-%m-%dT%H:%M:%S%:z', eventTime) AS eventTime,
    documents
FROM t2
CREATE OR REPLACE VIEW mware_curated.user_events
AS
WITH view_item AS (
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
        ) AS documents,
        CAST(NULL AS ARRAY<STRUCT<pageCategory STRING>>) as pageInfo,
        null as attributionToken,
        null as searchInfo
    FROM mware.events_view_video_1 evv
    LIMIT 2
),
view_category_page AS (
    SELECT
        CAST(userPseudoId AS STRING) userPseudoId,
        'view-category-page' AS eventType,
        eventTime,
        CAST(NULL AS ARRAY<STRUCT<id STRING>>) as documents,
        [STRUCT( category AS pageCategory)] AS pageInfo,
        null as attributionToken,
        null as searchInfo
    FROM mware.events_view_video_category_1
    LIMIT 2
),
search_ AS (
    SELECT
        CAST(userPseudoId AS STRING) userPseudoId,
        'search' AS eventType,
        eventTime,
        ARRAY(
            SELECT AS STRUCT
                CAST(m.id_content AS STRING) AS id
            FROM UNNEST(JSON_EXTRACT_ARRAY(evv.documents)) AS json
            JOIN mware_curated.movies m ON JSON_EXTRACT_SCALAR(json, '$.id') = CAST(m.uri AS STRING)
        ) AS documents,
        --documents,
        CAST(NULL AS ARRAY<STRUCT<pageCategory STRING>>) AS pageInfo,
        null as attributionToken,
        null as searchInfo
    FROM mware.events_search_2 AS evv
    LIMIT 2
)
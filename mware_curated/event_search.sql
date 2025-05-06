CREATE OR REPLACE VIEW mware_curated.event_search
AS
SELECT
    CAST(userPseudoId AS STRING) userPseudoId,
    'search' AS eventType,
    eventTime,
    ARRAY(
        SELECT AS STRUCT
            CAST(m.id_content AS STRING) AS id
        FROM UNNEST(JSON_EXTRACT_ARRAY(evv.documents)) AS json
        JOIN mware.vod_content m ON JSON_EXTRACT_SCALAR(json, '$.id') = CAST('vod/' || m.id_content AS STRING)
    ) AS documents,
    CAST(NULL AS STRUCT<pageCategory STRING>) AS pageInfo,
    null as attributionToken,
    searchInfo as searchInfo
FROM mware.events_search_2 AS evv




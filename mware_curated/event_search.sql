CREATE OR REPLACE VIEW mware_curated.event_search
AS
WITH t AS (
    SELECT
        CAST(userPseudoId AS STRING) userPseudoId,
        'search' AS eventType,
        eventTime,
        ARRAY(
            SELECT AS STRUCT
                SUBSTR(JSON_VALUE(json, '$.id'),5) as id
            FROM UNNEST(JSON_EXTRACT_ARRAY(evv.documents)) AS json
            -- отбрасываем события, у которых нет документов
            JOIN mware_curated.document m
                ON SUBSTR(JSON_EXTRACT_SCALAR(json, '$.id'),5) = CAST(m.id AS STRING)
        ) AS documents,
        CAST(NULL AS STRUCT<pageCategory STRING>) AS pageInfo,
        null as attributionToken,
        searchInfo as searchInfo
    FROM mware.events_search_2 AS evv
)
SELECT *
FROM t
WHERE ARRAY_LENGTH(documents) > 0




--CREATE OR REPLACE VIEW mware_curated.event_search
--AS
--SELECT
--    CAST(userPseudoId AS STRING) userPseudoId,
--    'search' AS eventType,
--    eventTime,
--    ARRAY(
--        SELECT AS STRUCT
--            CAST(m.id_content AS STRING) AS id
--        FROM UNNEST(JSON_EXTRACT_ARRAY(evv.documents)) AS json
--        JOIN mware.vod_content m ON JSON_EXTRACT_SCALAR(json, '$.id') = CAST('vod/' || m.id_content AS STRING)
--    ) AS documents,
--    CAST(NULL AS STRUCT<pageCategory STRING>) AS pageInfo,
--    null as attributionToken,
--    searchInfo as searchInfo
--FROM mware.events_search_2 AS evv






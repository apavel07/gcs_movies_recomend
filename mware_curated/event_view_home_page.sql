CREATE OR REPLACE VIEW mware_curated.event_view_home_page
AS
WITH ehp AS
(
SELECT
    CAST(userPseudoId AS STRING) userPseudoId,
    eventTime,
    CAST(REPLACE(JSON_VALUE(documents, "$.id"), 'vod/', '') AS INT) AS document_id,
    product_name,
    count(*) quantity
FROM mware.events_homepage AS ehp
JOIN UNNEST(JSON_QUERY_ARRAY(ehp.documents)) AS documents
WHERE REPLACE(JSON_VALUE(documents, "$.id"), 'vod/', '') IN (SELECT DISTINCT id FROM mware_curated.document)
GROUP BY ehp.userPseudoId, ehp.eventTime, ehp.product_name, CAST(REPLACE(JSON_VALUE(documents, "$.id"), 'vod/', '') AS INT)
)
SELECT
    userPseudoId,
    'view-home-page' AS eventType,
    eventTime,
    ARRAY_AGG(STRUCT(document_id AS id, quantity)) AS documents,
    STRUCT(
        STRUCT([product_name] AS text) AS product_name
      ) AS attributes
FROM ehp
GROUP BY userPseudoId, eventType, eventTime, product_name



--CREATE OR REPLACE VIEW mware_curated.event_view_home_page
--AS
--SELECT
--    CAST(userPseudoId AS STRING) userPseudoId,
--    'view-home-page' AS eventType,
--    eventTime,
--    ARRAY(
--        SELECT AS STRUCT
--            CAST(m.id_content AS STRING) AS id,
--            1 as quantity
--        FROM UNNEST(JSON_EXTRACT_ARRAY(ehp.documents)) AS json
--        JOIN mware.vod_content m ON JSON_EXTRACT_SCALAR(json, '$.id') = CAST('vod/' || m.id_content AS STRING)
--    ) AS documents,
--    STRUCT(
--        STRUCT([product_name] AS text) AS product_name
--      ) AS attributes
--FROM mware.events_homepage AS ehp
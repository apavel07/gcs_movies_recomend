CREATE OR REPLACE VIEW mware_curated.event_view_home_page
AS
SELECT
    CAST(userPseudoId AS STRING) userPseudoId,
    'view-home-page' AS eventType,
    eventTime,
        ARRAY(
        SELECT AS STRUCT
            CAST(m.id_content AS STRING) AS id,
            1 as quantity
        FROM UNNEST(JSON_EXTRACT_ARRAY(ehp.documents)) AS json
        JOIN mware.vod_content m ON JSON_EXTRACT_SCALAR(json, '$.id') = CAST('vod/' || m.id_content AS STRING)
    ) AS documents,
    STRUCT(
        STRUCT([product_name] AS text) AS example_text_attribute
--        STRUCT([] AS numbers) AS example_number_attribute
      ) AS attributes
FROM mware.events_homepage AS ehp
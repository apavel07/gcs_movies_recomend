CREATE OR REPLACE VIEW mware_curated.search
AS
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
    CAST(NULL AS STRUCT<pageCategory STRING>) AS pageInfo,
    null as attributionToken,
    searchInfo as searchInfo
FROM mware.events_search_2 AS evv
LIMIT 2




--var user_event = {
--  eventType: "search",
--  userPseudoId: "user-pseudo-id",
--  eventTime: "2020-01-01T03:33:33.000001Z",
--  searchInfo: {
--    searchQuery: "search-query",
--  },
--  pageInfo: {
--    pageCategory: "category1 > category2",
--  },
--  attributionToken: "attribution-token",
--  documents: [
--    {
--      id: "document-id1",
--    },
--    {
--      id: "document-id2",
--    },
--  ]
--};
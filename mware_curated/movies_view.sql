CREATE OR REPLACE VIEW mware_curated.movies_view
AS
SELECT DISTINCT
    CAST(id_content AS STRING) as id,
    "default_schema" as schemaId,
    null as parentDocumentId,
    TO_JSON_STRING(STRUCT(
        SUBSTR(title, 0, 1000) as title,
        categories as categories,
        CONCAT("vod/", id_content) as uri,
        "2023-01-01T00:00:00Z" as available_time,
        "2033-01-01T00:00:00Z" as expire_time,
        "movie" as media_type
    )) as jsonData
FROM mware.vod_content


--SELECT
--    uri as id,
--    "default_schema" as schemaId,
--    null as parentDocumentId,
--    TO_JSON_STRING(STRUCT(
--        SUBSTR(title, 0, 1000) as title,
--        categories as categories,
--        CONCAT("http://mware.movie/", uri) as uri,
--        "2023-01-01T00:00:00Z" as available_time,
--        "2033-01-01T00:00:00Z" as expire_time,
--        "movie" as media_type
--    )) as jsonData
--from mware.vod_content


--https://cloud.google.com/generative-ai-app-builder/docs/media-documents#json-schema

--title
--String - required
--Document title from your database. A UTF-8 encoded string. Limited to 1000 characters.

--categories
--String - required
--Document categories. This property is repeated for supporting one document belonging to several parallel categories. Use the full category path for higher quality results.
--To represent the full path of a category, use the > symbol to separate hierarchies. If > is part of the category name, replace it with another character(s).
--For example:
--"categories": [ "sports > highlight" ]
--A document can contain at most 250 categories. Each category is a UTF-8 encoded string with a length limit of 5000 characters.

--uri
--String - required
--URI of the document. Length limit of 5000 characters.

--available_time
--Datetime - required
--The time that the content is available to the end-users. This field identifies the freshness of a content for end-users. The timestamp should conform to RFC 3339 standard.
--For example:
--"2022-08-26T23:00:17Z"


--expire_time
--Datetime - optional
--The time that the content will expire for the end-users. This field identifies the freshness of a content for end-users. The timestamp should conform to RFC 3339 standard.
--For example:
--"2032-12-31T23:00:17Z"
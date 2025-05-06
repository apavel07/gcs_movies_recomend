CREATE OR REPLACE VIEW mware_curated.event_view_category_page
AS
SELECT
    CAST(userPseudoId AS STRING) userPseudoId,
    'view-category-page' AS eventType,
    eventTime,
    STRUCT( category AS pageCategory) AS pageInfo
FROM mware.events_view_video_category_1


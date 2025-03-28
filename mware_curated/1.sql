SELECT array_length(JSON_QUERY_ARRAY(documents)), documents
FROM `mware-data.mware.events_media_play_1`
where array_length(JSON_QUERY_ARRAY(documents)) > 1
LIMIT 10
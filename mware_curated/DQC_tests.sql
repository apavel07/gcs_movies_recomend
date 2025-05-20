select *
from `mware-data.mware_curated.event_view_item`
where userPseudoId is null or eventType is null or eventTime is null or ARRAY_LENGTH(documents) = 0
limit 1
;

select *
from mware_curated.document
where id is null or length(id) = 0 or jsonData is null
limit 1
;

select *
from mware_curated.event_search
where userPseudoId is null or eventType is null or eventTime is null or (ARRAY_LENGTH(documents) = 0 AND searchInfo IS NULL)
limit 1
;

select *
from mware_curated.event_view_category_page
where userPseudoId is null or eventType is null or eventTime is null or pageInfo IS NULL
limit 1
;
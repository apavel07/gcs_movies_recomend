select * from mware.vod_content
where uri like 'vod/38621%' or id_content = 38621

select documents[0].id from mware.events_view_video_1
where JSON_VALUE(documents[0], '$.id') LIKE 'vod/38621%'

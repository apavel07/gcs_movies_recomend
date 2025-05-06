CREATE OR REPLACE VIEW `mware-data.mware_curated.movies`
AS
SELECT DISTINCT
  id_content,
  title,
  'vod/' || id_content AS URI
FROM mware.vod_content
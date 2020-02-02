# WCC Fountain data converter

Converts the WCC fountain data from this URL into a useful GeoJSON format:

URL: https://gis.wcc.govt.nz/arcgis/rest/services/Parks/Parks/MapServer/15/query?f=json&returnGeometry=true&spatialRel=esriSpatialRelIntersects&maxAllowableOffset=76&geometry={%22xmin%22%3A19450471.965504095%2C%22ymin%22%3A-5087648.602626465%2C%22xmax%22%3A19489607.723986052%2C%22ymax%22%3A-5048512.844144508%2C%22spatialReference%22%3A{%22wkid%22%3A102100}}&geometryType=esriGeometryEnvelope&inSR=102100&outFields=*&outSR=102100

## Instructions

1. If necessary, update the contents of `wcc_fountains.geojson` from the above URL
1. `docker-compose run app bundle exec ruby convert.rb`
1. `open fountains.geojson`


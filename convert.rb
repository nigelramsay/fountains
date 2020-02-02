require "json"
require "byebug"
require "rgeo"
require "rgeo/proj4"
require 'rgeo/geo_json'

wgs84_proj4 = '+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs'
wgs84_factory = RGeo::Geographic.spherical_factory(:srid => 4326, :proj4 => wgs84_proj4)

wcc_proj4 = '+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +wktext  +no_defs'

wcc_wkt = <<WKT
PROJCS["WGS 84 / Pseudo-Mercator",
    GEOGCS["WGS 84",
        DATUM["WGS_1984",
            SPHEROID["WGS 84",6378137,298.257223563,
                AUTHORITY["EPSG","7030"]],
            AUTHORITY["EPSG","6326"]],
        PRIMEM["Greenwich",0,
            AUTHORITY["EPSG","8901"]],
        UNIT["degree",0.0174532925199433,
            AUTHORITY["EPSG","9122"]],
        AUTHORITY["EPSG","4326"]],
    PROJECTION["Mercator_1SP"],
    PARAMETER["central_meridian",0],
    PARAMETER["scale_factor",1],
    PARAMETER["false_easting",0],
    PARAMETER["false_northing",0],
    UNIT["metre",1,
        AUTHORITY["EPSG","9001"]],
    AXIS["X",EAST],
    AXIS["Y",NORTH],
    EXTENSION["PROJ4","+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +wktext  +no_defs"],
    AUTHORITY["EPSG","3857"]]
WKT

wcc_factory = RGeo::Cartesian.factory(:srid => 3857, :proj4 => wcc_proj4, :coord_sys => wcc_wkt)

file = File.open "wcc_fountains.geojson"
data = JSON.load file

features = data["features"].map do |fountain|
  wcc_coordinates = fountain["geometry"]["coordinates"].first
  wcc_point = wcc_factory.point(wcc_coordinates[0], wcc_coordinates[1])
  wgs84_point = RGeo::Feature.cast(wcc_point, :factory => wgs84_factory, :project => true)

  {
    type: "Feature",
    properties: {
      description: fountain["properties"]["Description"],
      "ref:wcc:asset_number" => fountain["properties"]["Asset_Number"]
    },
    geometry: {
      type: "Point",
      coordinates: [
        wgs84_point.x,
        wgs84_point.y
      ]
    }
  }
end


geojson = {
  type: "FeatureCollection",
  features: features
}

File.write("fountains.geojson", geojson.to_json)
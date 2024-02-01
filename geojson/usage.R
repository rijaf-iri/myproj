
### create geojson from shapefiles
cntr_shp_file <- "~/ADT/AWS_DATA/SHP/gadm41_RWA_0.shp"
cntr_geojson_file <- "~/ADT/AWS_DATA/GEOJSON/country-boundaries.geojson"

create_geojson(0, cntr_shp_file, cntr_geojson_file)

###
prov_shp_file <- "~/ADT/AWS_DATA/SHP/gadm41_RWA_1.shp"
prov_geojson_file <- "~/ADT/AWS_DATA/GEOJSON/subdivision1.geojson"

create_geojson(1, prov_shp_file, prov_geojson_file)

###
distr_shp_file <- "~/ADT/AWS_DATA/SHP/gadm41_RWA_2.shp"
distr_geojson_file <- "~/ADT/AWS_DATA/GEOJSON/subdivision2.geojson"

create_geojson(2, distr_shp_file, distr_geojson_file)

###
sect_shp_file <- "~/ADT/AWS_DATA/SHP/gadm41_RWA_3.shp"
sect_geojson_file <- "~/ADT/AWS_DATA/GEOJSON/subdivision3.geojson"

create_geojson(3, sect_shp_file, sect_geojson_file)

###############
### create JavaScript description file for the subdivision

province <- list(subdiv_id = 1, subdiv_name = "Province", attr_id = "GID_1", attr_name = "NAME_1")
district <- list(subdiv_id = 2, subdiv_name = "District", attr_id = "GID_2", attr_name = "NAME_2")
sector <- list(subdiv_id = 3, subdiv_name = "Sector", attr_id = "GID_3", attr_name = "NAME_3")

js_outupt_file <- "~/ADT/AWS_DATA/GEOJSON/subdivision_names.js"

create_js_file(province, district, sector, js_outupt_file)

###############
### symbolic link
## symbolic link all file from AWS_DATA/GEOJSON to apiADT/app/static/geojson

ln -s ~/ADT/AWS_DATA/GEOJSON/country-boundaries.geojson ~/ADT/apiADT/app/static/geojson
ln -s ~/ADT/AWS_DATA/GEOJSON/subdivision_names.js ~/ADT/apiADT/app/static/geojson
ln -s ~/ADT/AWS_DATA/GEOJSON/subdivision1.geojson ~/ADT/apiADT/app/static/geojson
ln -s ~/ADT/AWS_DATA/GEOJSON/subdivision2.geojson ~/ADT/apiADT/app/static/geojson

###############
## test


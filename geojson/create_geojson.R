
convert_shp_to_geojson <- function(shapefile, geojson, bbox = NULL,
                                   simplify = TRUE, ...)
{
    shp <- sf::st_read(shapefile, quiet = TRUE)
    if(is.null(bbox)){
        bbox <- sf::st_bbox(shp)
        bbox[1:2] <- bbox[1:2] - 0.01
        bbox[3:4] <- bbox[3:4] + 0.01
    }

    tmp <- geojsonio::geojson_json(shp)
    if(simplify)
        tmp <- rmapshaper::ms_simplify(tmp, ...)

    tmp <- rmapshaper::ms_clip(tmp, bbox = bbox)
    geojsonio::geojson_write(tmp, file = geojson)
}

create_geojson <- function(subdiv_id, shape_file, geojson_file){
    convert_shp_to_geojson(shape_file, geojson_file, simplify = FALSE)
    txt <- readLines(geojson_file, warn = FALSE)
    if(subdiv_id == 0){
        tmp <- "country_geojson"
    }else{
        tmp <- paste0("subdivision", subdiv_id, "_geojson")
    }
    txt <- paste0("var ", tmp, "=", txt)
    cat(txt, file = geojson_file)
}

convJSON <- function(obj, ...){
    args <- list(...)
    if(!'pretty' %in% names(args)) args$pretty <- TRUE
    if(!'auto_unbox' %in% names(args)) args$auto_unbox <- TRUE
    if(!'na' %in% names(args)) args$na <- "null"
    args <- c(list(x = obj), args)
    json <- do.call(jsonlite::toJSON, args)
    return(json)
}

create_js_file <- function(..., js_outupt_file){
    args <- list(...)
    sub_id <- sapply(args, '[[', 'subdiv_id')
    sub_name <- sapply(args, '[[', 'subdiv_name')
    attr_id <- sapply(args, '[[', 'attr_id')
    attr_name <- sapply(args, '[[', 'attr_name')

    if(length(sub_name) != length(sub_id) ||
       length(attr_id) != length(sub_id) ||
       length(attr_name) != length(sub_id))
    {
        stop("subdivision list elements number do not match")
    }

    def_geojson <- lapply(seq_along(args), function(j){
        list(
            selectName = sub_name[j],
            displayAdmin = attr_name[j],
            idAdmin = attr_id[j]
         )
    })
    names(def_geojson) <- paste0("sub-division", sub_id)
    def_geojson <- convJSON(def_geojson)
    def_geojson <- paste("var subdivision_names = ", def_geojson)
    cat(def_geojson, file = js_outupt_file)
}

convJSON <- function(obj, ...){
    args <- list(...)
    if(!'pretty' %in% names(args)) args$pretty <- TRUE
    if(!'auto_unbox' %in% names(args)) args$auto_unbox <- TRUE
    if(!'na' %in% names(args)) args$na <- "null"
    args <- c(list(x = obj), args)
    json <- do.call(jsonlite::toJSON, args)
    return(json)
}

formatCDTCoordsFile <- function(cdt_coords_file){
    awsCrd <- utils::read.table(cdt_coords_file, sep = ',', header = TRUE,
                                stringsAsFactors = FALSE, quote = "\"",
                                fileEncoding = "UTF-8")
    awsCrd$LonX <- awsCrd[, 3]
    awsCrd$LatX <- awsCrd[, 4]
    cLon <- mean(awsCrd[, 3], na.rm = TRUE)
    cLat <- mean(awsCrd[, 4], na.rm = TRUE)
    json <- convJSON(awsCrd, pretty = FALSE)
    list(clon = cLon, clat = cLat, json = json)
}

leafletHtmlTemplate <- function(){
    "<!DOCTYPE html> <html> <head> <title> Stations coordinates </title> <script src=\"https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js\"></script> <link rel=\"stylesheet\" href=\"https://unpkg.com/leaflet@1.9.4/dist/leaflet.css\" crossorigin=\"\" /> <script src=\"https://unpkg.com/leaflet@1.9.4/dist/leaflet.js\" crossorigin=\"\"></script> <style> html, body { height: 100%; } #mapAWSCoords { width: 100%; height: 95%; border: 1px solid #AAA; } </style> </head> <body> <div id=\"mapAWSCoords\"></div> <script> $(document).ready(function() { var data_json = <<<DATA_JSON>>> ; var mymap = L.map(\"mapAWSCoords\", { center: [ <<<CENTER_LAT>>> , <<<CENTER_LON>>> ], minZoom: 2, zoom: 6 }); var mytile = L.tileLayer(\"http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png\", { attribution: '&copy; <a href=\"https://www.openstreetmap.org/copyright\">OpenStreetMap</a>', maxZoom: 19, subdomains: [\"a\", \"b\", \"c\"] }).addTo(mymap); $.each(data_json, function() { var keys = Object.keys(this); var contenu = keys.map(v => { if (v === 'LonX' || v === 'LatX') { return; } return '<b>' + v + ' : </b>' + this[v] + '<br>'; }); contenu = contenu.join(''); if (typeof this.LonX !== \"undefined\") { L.marker([this.LatX, this.LonX]) .bindPopup(contenu) .addTo(mymap); } }); }); </script> </body> </html>"
}

displayCDTCoordsFile <- function(cdt_coords_file){
    ret <- formatCDTCoordsFile(cdt_coords_file)
    tmp <- leafletHtmlTemplate()
    tmp <- sub("<<<DATA_JSON>>>", ret$json, tmp)
    tmp <- sub("<<<CENTER_LAT>>>", ret$clat, tmp)
    tmp <- sub("<<<CENTER_LON>>>", ret$clon, tmp)
    link <- paste0(tempfile(), '.html')
    cat(tmp, file = link)
    utils::browseURL(paste0('file://', link))
}

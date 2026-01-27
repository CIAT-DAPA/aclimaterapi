#' Get geoserver workspace
#'
#' @description Gets and lists all the workspaces of the GeoServer using the HTTP GET method.
#'
#' @param url_root Url root where the Geoserver is located.
#' 
#' @param user User to authenticate in the Geoserver.
#' 
#' @param password Password to authenticate in the Geoserver.
#'
#' @return A dataframe with workspace information.
#'
#' @examples
#' url_root = "https://geo.aclimate.org/geoserver/"
#' obj_f = get_geo_workspaces(url_root, user, password)
#' print(obj_f)
#'
#' @export
get_geo_workspaces = function(url_root, user , password){
    library(httr)
    library(rjson)
    httr::set_config(config(ssl_verifypeer = 0L))
    # Downloading data
    url = paste0(url_root, "/rest/workspaces.json")
    request = GET(url, authenticate(user, password))
    # Extracting content directly from the request object
    response = httr::content(request, as = "text", encoding = "UTF-8")
    data = fromJSON(response)
    workspaces_list <- data$workspaces$workspace
    workspace_df <- data.frame(workspace_name = character(), workspace_href = character(), stringsAsFactors = FALSE)

    for (i in seq_along(workspaces_list)) {
        workspace <- workspaces_list[[i]]
        workspace_df <- rbind(workspace_df, data.frame(workspace_name = workspace$name, workspace_href = workspace$href, stringsAsFactors = FALSE))
    }

    row.names(workspace_df) <- NULL
    return (workspace_df)
}


#' Get geoserver mosaic stores
#'
#' @description Retrieves and lists all the mosaic stores of a specific workspace using the HTTP GET method.
#'
#' @param url_root Url root where the Geoserver is located.
#'
#' @param workspace Name of the workspace from which the mosaic datastores are to be obtained.
#' 
#' @param user User to authenticate in the Geoserver.
#' 
#' @param password Password to authenticate in the Geoserver.
#'
#' @return A dataframe with mosaics stores information.
#'
#' @examples
#' url_root = "https://geo.aclimate.org/geoserver/"
#' workspace = "climate_indices_pe"
#' obj_f = get_geo_mosaic_name(url_root, workspace, user, password)
#' print(obj_f)
#'
#' @export
get_geo_mosaic_name = function(url_root, workspace, user, password){
    library(httr)
    library(rjson)
    httr::set_config(config(ssl_verifypeer = 0L))
    # Downloading data
    url = paste0(url_root, "rest/workspaces/", workspace, "/coveragestores.json")
    request = GET(url, authenticate(user, password))
    # Extracting content directly from the request object
    response = httr::content(request, as = "text", encoding = "UTF-8")
    data = fromJSON(response)
    if (exists("data") && is.list(data$coverageStores) && is.list(data$coverageStores$coverageStore)){
        mosaics_list <- data$coverageStores$coverageStore
        mosaics_df <- data.frame(mosaic_name = character(), mosaic_href = character(), stringsAsFactors = FALSE)

        for (i in seq_along(mosaics_list)) {
            mosaic <- mosaics_list[[i]]
            mosaics_df <- rbind(mosaics_df, data.frame(mosaic_name = mosaic$name, mosaic_href = mosaic$href, stringsAsFactors = FALSE))
        }

        row.names(mosaics_df) <- NULL
        return (mosaics_df)
    }else{
        return(data.frame(mosaic_name = character(), mosaic_href = character(), stringsAsFactors = FALSE))
    }
}


#' Get geoserver mosaics
#'
#' @description Obtains the desired mosaic from the GeoServer using the HTTP GET method, by using the date, workspace, and store.
#'
#' @param url_root Url root where the Geoserver is located.
#'
#' @param workspace Name of the workspace from which the mosaics datastores are to be obtained.
#'
#' @param mosaic_name Name of the store from which the mosaics are to be obtained.
#'
#' @param year Year by which the mosaic will be filtered. Integer
#'
#' @param month Month by which the mosaic will be filtered. Integer (Optional, default value 1)
#'
#' @param day Day by which the mosaic will be filtered. Integer (Optional, default value 1)
#' 
#'
#' @return A raster with mosaic information or Null if an error is encountered, it will also be printed to the console.
#'
#' @examples
#' url_root = "https://geo.aclimate.org/geoserver/"
#' workspace = "climate_indices_pe"
#' mosaic_name = "freq_rh80_t_20_25"
#' year = 2014
#' month = 5
#' day = 1
#' raster = get_geo_mosaics(url_root, workspace, mosaic_name, year, month, day)
#' print(raster)
#'
#' @export
get_geo_mosaics = function(url_root, workspace, mosaic_name, year, month=1, day=1){
    library(httr)
    library(terra)
    library(raster)
    httr::set_config(config(ssl_verifypeer = 0L))
    # Downloading data
    url = URLencode(paste0(url_root, workspace, "/ows?",
                 "service=WCS",
                 "&request=GetCoverage",
                 "&version=2.0.1",
                 "&coverageId=", mosaic_name,
                 "&format=image/geotiff",
                 "&subset=Time(\"",year,"-",sprintf("%02d", month),"-",sprintf("%02d", day),"T00:00:00.000Z\")"))
    request = GET(url)

    if (request$status_code == 200) {
        temp_tiff <- tempfile(fileext = ".tif")
        writeBin(content(request, "raw"), temp_tiff)

        raster_data <- raster(temp_tiff)
        return (raster_data)

    } else {
        response = content(request, as = "text", encoding = "UTF-8")
        match_result <- regmatches(response, regexpr("<ows:ExceptionText>(.*?)</ows:ExceptionText>", response, perl = TRUE))

        if (length(match_result) > 0) {
            exception_text <- gsub("<ows:ExceptionText>", "", match_result[[1]])
            exception_text <- gsub("</ows:ExceptionText>", "", exception_text)
            cat("Error making the request. Status code:", request$status_code, "\n" , "Msg: ", exception_text, "\n")
        } else {
            cat("Error making the request. Status code:", request$status_code, "\n")
        }
        return(NULL)
    }

}


#' Get geoserver polygon stores
#'
#' @description Retrieves and lists all the polygon stores of a specific workspace using the HTTP GET method.
#'
#' @param url_root Url root where the Geoserver is located.
#'
#' @param workspace Name of the workspace from which the polygon datastores are to be obtained.
#' 
#' @param user User to authenticate in the Geoserver.
#' 
#' @param password Password to authenticate in the Geoserver.
#'
#' @return A dataframe with polygons stores information.
#'
#' @examples
#' url_root = "https://geo.aclimate.org/geoserver/"
#' workspace = "administrative"
#' obj_f = get_geo_polygon_name(url_root, workspace, user, password)
#' print(obj_f)
#'
#' @export
get_geo_polygon_name = function(url_root, workspace, user, password){
    library(httr)
    library(rjson)
    httr::set_config(config(ssl_verifypeer = 0L))
    # Downloading data
    url = paste0(url_root, "rest/workspaces/", workspace, "/datastores.json")
    request = GET(url, authenticate(user, password))
    # Extracting content directly from the request object
    response = httr::content(request, as = "text", encoding = "UTF-8")
    data = fromJSON(response)
    if (exists("data") && is.list(data$dataStores) && is.list(data$dataStores$dataStore)){
        polygons_list <- data$dataStores$dataStore
        polygons_df <- data.frame(polygon_name = character(), polygon_href = character(), stringsAsFactors = FALSE)

        for (i in seq_along(polygons_list)) {
            polygon <- polygons_list[[i]]
            polygons_df <- rbind(polygons_df, data.frame(polygon_name = polygon$name, polygon_href = polygon$href, stringsAsFactors = FALSE))
        }

        row.names(polygons_df) <- NULL
        return (polygons_df)
    }else{
        return(data.frame(polygon_name = character(), polygon_href = character(), stringsAsFactors = FALSE))
    }
}


#' Get geoserver shapefiles
#'
#' @description Obtains the desired shapefile from the GeoServer using the HTTP GET method, by using workspace, and polygon name
#'
#' @param url_root Url root where the Geoserver is located.
#'
#' @param workspace Name of the workspace from which the shapefiles are to be obtained.
#'
#' @param polygon_name Name of the store from which the shapefiles are to be obtained.
#'
#' @return A shapefile with the polygon information or Null if an error is encountered, it will also be printed to the console.
#'
#' @examples
#' url_root = "https://geo.aclimate.org/geoserver/"
#' workspace = "administrative"
#' polygon_name = "ao_adm1"
#' shapefile = get_geo_polygons(url_root, workspace, polygon_name)
#' print(shapefile)
#'
#' @export
get_geo_polygons = function(url_root, workspace, polygon_name){
    library(httr)
    library(sf)
    httr::set_config(config(ssl_verifypeer = 0L))
    # Downloading data
    url = URLencode(paste0(url_root, workspace, "/ows?",
                           "service=WFS",
                           "&request=GetFeature",
                           "&version=2.0.1",
                           "&typeNames=", workspace,":",polygon_name,
                           "&outputFormat=application/json"))
    request = GET(url)

    if (request$status_code == 200) {
        sf_obj_geoserver <- st_read(content(request, "text", encoding = "UTF-8"), quiet = TRUE)

        return (sf_obj_geoserver)

    } else {
        response = content(request, as = "text", encoding = "UTF-8")
        match_result <- regmatches(response, regexpr("<ows:ExceptionText>(.*?)</ows:ExceptionText>", response, perl = TRUE))

        if (length(match_result) > 0) {
            exception_text <- gsub("<ows:ExceptionText>", "", match_result[[1]])
            exception_text <- gsub("</ows:ExceptionText>", "", exception_text)
            cat("Error making the request. Status code:", request$status_code, "\n" , "Msg: ", exception_text, "\n")
        } else {
            cat("Error making the request. Status code:", request$status_code, "\n")
        }
        return(NULL)
    }

}

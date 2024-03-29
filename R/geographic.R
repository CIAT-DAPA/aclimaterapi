#' Get country
#'
#' @description Obtain a global list of registered countries in the AClimate system using the HTTP GET method. Ideal for a broad overview of countries covered by AClimate.
#'
#' @param url_root Url root where the API is located.
#'
#' @return A data.frame, with the list of all countries.
#'
#' @examples
#' url_root = "https://webapi.aclimate.org/api/"
#' df = get_geographic_country(url_root)
#' print(head(df))
#'
#' @export
get_geographic_country = function(url_root){
    library(httr)
    library(rjson)
    httr::set_config(config(ssl_verifypeer = 0L))
    # Build url to call the API
    url = paste0(url_root,"Geographic/Country/json")
    request = GET(url)
    # Call API
    response = content(request, as = "text", encoding = "UTF-8")
    # Transform in JSON
    data = fromJSON(response)
    # Transform in data.frame
    df = do.call(rbind,
                    lapply(data,function(c){
                        data.frame(id=c$id, iso2=c$iso2, name=c$name)
                    }))
    return (df)
}

#' Get weather stations
#'
#' @description Retrieve detailed information on states, municipalities, weather stations, and crop-related details for a selected country. This endpoint, using the HTTP GET method, supports localized decision-making in agriculture.
#'
#' @param url_root Url root where the API is located.
#' @param country_id Id of the country
#'
#' @return A data.frame, with the list of all weather stations.
#'
#' @examples
#' url_root = "https://webapi.aclimate.org/api/"
#' country_id = "61e59d829d5d2486e18d2ea8"
#' df = get_geographic(url_root, country_id)
#' print(head(df))
#'
#' @export
get_geographic = function(url_root, country_id){
    library(httr)
    library(rjson)
    httr::set_config(config(ssl_verifypeer = 0L))
    # Downloading data
    url = paste0(url_root,"Geographic/",country_id,"/json")
    request = GET(url)
    response = content(request, as = "text", encoding = "UTF-8")
    data = fromJSON(response)

    df = do.call(rbind,
                    lapply(data,function(s){
                        do.call(rbind,lapply(s$municipalities,function(m){
                            do.call(rbind,lapply(m$weather_stations,function(w){
                                data.frame(country_id=s$country["id"],country_iso2=s$country["iso2"],country_name=s$country["name"],
                                            state_id=s$id, state_name=s$name,
                                            municipality_id=m$id, municipality_name=m$name,
                                            ws_id=w$id, ws_ext_id=w$ext_id, ws_name=w$name, ws_origin=w$origin, ws_lat=w$latitude, ws_lon=w$longitude)
                            }))
                        }))
                    }))
    return (df)
}

#' Get weather stations with crop information
#'
#' @description Access crop-grouped data for states, municipalities, and meteorological stations within a chosen country. The endpoint, utilizing the HTTP GET method, offers insights for optimized decision-making based on specific crops.
#'
#' @param url_root Url root where the API is located.
#' @param country_id Id of the country
#'
#' @return A data.frame, with the list of all weather stations.
#'
#' @examples
#' url_root = "https://webapi.aclimate.org/api/"
#' country_id = "61e59d829d5d2486e18d2ea8"
#' df = get_geographic_crop(url_root, country_id)
#' print(head(df))
#'
#' @export
get_geographic_crop = function(url_root, country_id){
    library(httr)
    library(rjson)
    httr::set_config(config(ssl_verifypeer = 0L))
    # Downloading data
    url = paste0(url_root,"Geographic/Crop/",country_id,"/json")
    request = GET(url)
    response = content(request, as = "text", encoding = "UTF-8")
    data = fromJSON(response)
    df = do.call(rbind,
                    lapply(data,function(cr){
                        do.call(rbind,lapply(cr$states,function(s){
                            do.call(rbind,lapply(s$municipalities,function(m){
                                do.call(rbind,lapply(m$weather_stations,function(w){
                                    data.frame(crop_id=cr$id,crop_name=cr$name,
                                                country_iso2=s$country["iso2"],country_name=s$country["name"],
                                                state_id=s$id, state_name=s$name,
                                                municipality_id=m$id, municipality_name=m$name,
                                                ws_id=w$id, ws_ext_id=w$ext_id, ws_name=w$name, ws_origin=w$origin, ws_lat=w$latitude, ws_lon=w$longitude)
                                }))
                            }))
                        }))
                    }))
    return (df)
}



#' Get weather stations
#'
#' @description Retrieve detailed information weather stations, and crop-related details for a selected country. This endpoint, using the HTTP GET method, supports localized decision-making in agriculture.
#'
#' @param url_root Url root where the API is located.
#' @param country_id Id of the country
#'
#' @return A list, with the list of all weather stations.
#'
#' @examples
#' url_root = "https://webapi.aclimate.org/api/"
#' country_id = "61e59d829d5d2486e18d2ea8"
#' ws_list = get_geographic_ws(url_root, country_id)
#' print(head(ws_list))
#'
#' @export
get_geographic_ws = function(url_root, country_id){
    library(httr)
    library(rjson)
    httr::set_config(config(ssl_verifypeer = 0L))
    # Downloading data
    url = paste0(url_root,"Geographic/",country_id,"/WeatherStations","/json")
    request = GET(url)
    response = content(request, as = "text", encoding = "UTF-8")
    data = fromJSON(response)
    return (data)
}

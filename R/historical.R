#' Get climatology
#'
#' @description  Retrieve the climatology of a selected weather station using the HTTP GET method. This endpoint offers access to valuable climatology data.
#'
#' @param url_root Url root where the API is located.
#' @param stations Array of strings with the ids of the weather stations.
#'
#' @return A data.frame, with the climatology of different climatic variables
#'
#' @examples
#' url_root = "https://webapi.aclimate.org/api/"
#' stations=c("58504f1a006cb93ed40eebe2","58504f1a006cb93ed40eebe3")
#' df = get_historical_climatology(url_root, stations)
#' print(df)
#'
#' @export
get_historical_climatology = function(url_root, stations){
    library(httr)
    library(rjson)
    httr::set_config(config(ssl_verifypeer = 0L))
    # Download data
    ws = paste(stations,collapse=",")
    url = paste0(url_root,"Historical/Climatology/",ws,"/json")
    request = GET(url)
    response = content(request, as = "text", encoding = "UTF-8")
    data = fromJSON(response)
    df = do.call(rbind,
                lapply(data,function(w){
                    do.call(rbind,lapply(w$monthly_data,function(md){
                        do.call(rbind,lapply(md$data,function(wd){
                            data.frame(ws_id=w$weather_station,
                                month=md$month,
                                measure=wd$measure, value=wd$value)
                        }))
                    }))
                }))
    return (df)
}

#' Get historical climate information
#'
#' @description  Retrieve the weather history of a selected weather station using the HTTP GET method. This endpoint offers access to valuable historical climatic data.
#'
#' @param url_root Url root where the API is located.
#' @param stations Array of strings with the ids of the weather stations.
#'
#' @return A data.frame, with the climatology of different climatic variables
#'
#' @examples
#' url_root = "https://webapi.aclimate.org/api/"
#' stations=c("58504f1a006cb93ed40eebe2","58504f1a006cb93ed40eebe3")
#' df = get_historical_historicalclimatic(url_root, stations)
#' print(df)
#'
#' @export
get_historical_historicalclimatic = function(url_root, stations){
    library(httr)
    library(rjson)
    httr::set_config(config(ssl_verifypeer = 0L))
    # Download data
    ws = paste(stations,collapse=",")
    url = paste0(url_root,"Historical/HistoricalClimatic/",ws,"/json")
    request = GET(url)
    response = content(request, as = "text", encoding = "UTF-8")
    data = fromJSON(response)
    df = do.call(rbind,
                lapply(data,function(w){
                    do.call(rbind,lapply(w$monthly_data,function(md){
                        do.call(rbind,lapply(md$data,function(wd){
                            data.frame(ws_id=w$weather_station,
                                year=w$year,
                                month=md$month,
                                measure=wd$measure, value=wd$value)
                        }))
                    }))
                }))
    return (df)
}

#' Get years with historical crop performance data
#'
#' @description  Through this endpoint you can obtain the years that contain historical crop performance data of the selected weather station.
#'
#' @param url_root Url root where the API is located.
#' @param stations Array of strings with the ids of the weather stations.
#'
#' @return A data.frame, with the climatology of different climatic variables
#'
#' @examples
#' url_root = "https://webapi.aclimate.org/api/"
#' stations=c("58504f1a006cb93ed40eebe2","58504f1a006cb93ed40eebe3")
#' df = get_historical_historicalyieldyears(url_root, stations)
#' print(df)
#'
#' @export
get_historical_historicalyieldyears = function(url_root, stations){
    library(httr)
    library(rjson)
    httr::set_config(config(ssl_verifypeer = 0L))
    # Download data
    ws = paste(stations,collapse=",")
    url = paste0(url_root,"Historical/HistoricalYieldYears/",ws,"/json")
    request = GET(url)
    response = content(request, as = "text", encoding = "UTF-8")
    data = fromJSON(response)
    #df = #do.call(rbind,
                #lapply(data,function(y){
                    #data.frame(year=data)
                #}))
    df = data.frame(year=data)
    return (df)
}

#' Get historical crop performance
#'
#' @description Access yield data obtained through the crop model process using the HTTP GET method. This endpoint provides valuable information on crop yields, offering insights derived from the crop model process.
#'
#' @param url_root Url root where the API is located.
#' @param stations Array of strings with the ids of the weather stations.
#'
#' @return A data.frame, with the crop forecast result for the weather stations.
#'
#' @examples
#' url_root = "https://webapi.aclimate.org/api/"
#' stations=c("58504f1a006cb93ed40eebe2","58504f1a006cb93ed40eebe3")
#' years=c("2022","2023")
#' df = get_historical_historicalyield(url_root, stations, years)
#' print(head(df))
#'
#' @export
get_historical_historicalyield = function(url_root, stations, years){
    library(httr)
    library(rjson)
    httr::set_config(config(ssl_verifypeer = 0L))
    # Download data
    ws = paste(stations,collapse=",")
    years_formated = paste(years,collapse=",")
    url = paste0(url_root,"Historical/HistoricalYield/",ws,"/",years_formated,"/json")
    request = GET(url)
    response = content(request, as = "text", encoding = "UTF-8")
    data = fromJSON(response)
    df = do.call(rbind,
                    lapply(data,function(w){
                        do.call(rbind,lapply(w$yield,function(wy){
                            do.call(rbind,lapply(wy$data,function(y){
                                data.frame(ws_id=w$weather_station,
                                            cultivar=wy$cultivar, soil=wy$soil, start=wy$start, end=wy$end,
                                            measure=y$measure,
                                            median=y$median,avg=y$avg,min=y$min,max=y$max,
                                            quar_1=y$quar_1,quar_2=y$quar_2,quar_3=y$quar_3,
                                            conf_lower=y$conf_lower,conf_upper=y$conf_upper,
                                            sd=y$sd,perc_5=y$perc_5,perc_95=y$perc_95,
                                            coef_var=y$coef_var)
                            }))
                        }))
                    }))
    return (df)
}

<!-- README.md is generated from README.Rmd. Please edit that file -->

# AClimate R API

The AClimate R API package is a comprehensive R interface for accessing the AClimate Web API.
This package seamlessly integrates with R, providing users with convenient access to a wide range of agro-climatic
forecasts offered by the AClimate platform.

- [Oficial website](https://www.aclimate.org).
- Source code [source code](https://github.com/CIAT-DAPA/aclimaterapi/).
- Documentation of Web API and Dictionary of variable [documentation](https://docs.aclimate.org/en/latest/08-webapi.html).
- Depends **R (>= 4.2)**
- Author [stevensotelo](https://github.com/stevensotelo), [scalderon](https://github.com/santiago123x)

## Key Features

- Data Access: Access all relevant information from the AClimate platform, including accurate and up-to-date seasonal climate forecasts.

- User-Friendly: The package is designed with ease of use in mind, ensuring that users can effortlessly retrieve the information they need.

- Seamless Integration: Integrate AClimate data directly into R workflows, making it simple for users to incorporate climate and agroclimatic forecasts into their existing data analysis and decision-making processes

## Install

**Installation from GitHub**

The easiest way to install the package is from [Github repository](https://github.com/CIAT-DAPA/aclimaterapi/) and using devtools.

```r
devtools::install_github("CIAT-DAPA/aclimaterapi")
```

The above command, when executed in R, downloads and installs the `AClimate R API` from official repository `CIAT-DAPA`.

**Manual Installation from ZIP File**

You can also download the ZIP file from the [Release](https://github.com/CIAT-DAPA/aclimaterapi/releases) section and manually install it using the following command:

```r
install.packages("/file_path/aclimaterapi_x.x.x.tar.gz", repos = NULL, type = "source")
```

Replace "/file_path/" with the location of your downloaded file.

## Remove

The easiest way to remove the package is:

```r
remove.packages("aclimaterapi")
```

## How to use

The following list are recommendations which should be take into account when you try to use the package.

### Import library

Once you have installed the library, you should import it in order to get access to all functions

```r
library("aclimaterapi")
```

### Url of the Web API

The first thing that you have to identify is the url which is located the Web API. This parameter will be asked in all methods.

You can create a global variable with this url:

```r
url_root = "https://webapi.aclimate.org/api/"
```

## Functions

### Get countries

The method **get_geographic_country** allows to users get a list of all countries.

```r
df = get_geographic_country(url_root)
print(head(df))
```

### Get weather stations

The method **get_geographic** allows to users get a list of all weather stations available in the system.

```r
df = get_geographic(url_root)
print(head(df))
```

### Get weather stations with crop information

The method **get_geographic** allows to users get a list of the states of the selected country with each of their municipalities and meteorological stations and for each meteorological station their productive ranges for each crop.

```r
country_id = "61e59d829d5d2486e18d2ea8"
df = get_geographic_crop(url_root, country_id)
print(head(df))
```

### Get weather stations information

The method **get_geographic** allows to users get a list of detailed information weather stations, and crop-related details for a selected country.

```r
country_id = "61e59d829d5d2486e18d2ea8"
ws_list = get_geographic_ws(url_root, country)
print(head(ws_list))
```

### Get agronomy setup

The method **get_agronomy** allows to users get a list of cultivars and soils available into the AClimate platform.

```r
df = get_agronomy(url_root)
print(df)
```

### Get climate forecast

The method **get_forecast_climate**, function which gets the forecast climate for a set of weather stations available into the AClimate platform.

You can find the ids of the weather stations in the method **get_geographic**

```r
stations=c("58504f1a006cb93ed40eebe2","58504f1a006cb93ed40eebe3")
obj_f = get_forecast_climate(url_root, stations)
print(obj_f$probabilities)
print(obj_f$performance)
print(obj_f$scenarios)
```

### Get crop forecast

The method **get_forecast_crop**, function which gets the crop forecast for a set of weather stations available into the AClimate platform.

You can find the ids of the weather stations in the method **get_geographic**

```r
stations=c("58504f1a006cb93ed40eebe2","58504f1a006cb93ed40eebe3")
df = get_forecast_crop(url_root, stations)
print(head(df))
```

### Get forecast id

The method **get_forecast_information**, function which gets access primary forecast data for each month within a desired year.

```r
year= 2023
forecasts = get_forecast_information(url_root, year)
print(forecasts)
```

### Get subseasonal forecast

The method **get_forecast_subseasonal**, function which gets information from the subseasonal forecast process, including probabilities and climatic scenarios.

You can find the ids of the weather stations in the method **get_geographic**

```r
stations = c("63a3744005732d2a14260392","63a374ce05732d2a14260499")
subseasonal_data = get_forecast_subseasonal(url_root, stations)
print(subseasonal_data)
```

### Get previous climate forecast

The method **get_forecast_climate_previous**, function which gets the information obtained through the forecast process that is desired by means of the Id, the seasonal and subseasonal probabilities and the climatic scenarios.

You can find the ids of the weather stations in the method **get_geographic**
You can find the forecast id in the method **get_forecast_information**

```r
forecast = "657006544afb9646da8c6b78"
stations=c("58504f1a006cb93ed40eebe2","58504f1a006cb93ed40eebe3")
obj_fp = get_forecast_climate_previous(url_root, forecast, stations)
print(obj_fp)
```

### Get previous crop forecast

The method **get_forecast_crop_previous**, function which gets the crop forecast information for a specific forecast indicated in the parameters.

You can find the ids of the weather stations in the method **get_geographic**
You can find the forecast id in the method **get_forecast_information**

```r
forecast = "657006544afb9646da8c6b78"
stations=c("58504f1a006cb93ed40eebe2","58504f1a006cb93ed40eebe3")
df = get_forecast_crop_previous(url_root, forecast, stations)
print(head(df))
```

### Get forecast crop exceedance

The method **get_forecast_crop_exc**, function which gets the information obtained through of all forecast in the crop model process, yield data.

You can find the ids of the weather stations in the method **get_geographic**

```r
stations=c("58504f1a006cb93ed40eebe2","58504f1a006cb93ed40eebe3")
df = get_forecast_crop_exc(url_root, stations)
print(head(df))
```

### Get historical climatology

The method **get_historical_climatology**, function which gets the climatology of a selected weather station.

You can find the ids of the weather stations in the method **get_geographic**

```r
stations=c("58504f1a006cb93ed40eebe2","58504f1a006cb93ed40eebe3")
df = get_historical_climatology(url_root, stations)
print(df)
```

### Get historical climate information

The method **get_historical_historicalclimatic**, function which gets the weather history of a selected weather station.

You can find the ids of the weather stations in the method **get_geographic**

```r
stations=c("58504f1a006cb93ed40eebe2","58504f1a006cb93ed40eebe3")
df = get_historical_historicalclimatic(url_root, stations)
print(df)
```

### Get years with historical crop performance data

The method **get_historical_historicalyieldyears**, function which gets the years that contain historical crop performance data of the selected weather station.

You can find the ids of the weather stations in the method **get_geographic**

```r
stations=c("58504f1a006cb93ed40eebe2","58504f1a006cb93ed40eebe3")
df = get_historical_historicalyieldyears(url_root, stations)
print(df)
```

### Get historical crop performance

The method **get_historical_historicalyield**, function which gets the yield data obtained through the crop model process.

You can find the ids of the weather stations in the method **get_geographic**

```r
stations=c("58504f1a006cb93ed40eebe2","58504f1a006cb93ed40eebe3")
years=c("2022","2023")
df = get_historical_historicalyield(url_root, stations, years)
print(head(df))
```

### Get geoserver workspace

The method **get_geo_workspaces**, function which gets all the workspaces of the GeoServer.

**Note:** For geoserver functions, use the geoserver URL instead of the API URL:

```r
url_geoserver = "https://geo.aclimate.org/geoserver/"
user = "your_username"
password = "your_password"
obj_f = get_geo_workspaces(url_geoserver, user, password)
print(obj_f)
```

### Get geoserver mosaic stores

The method **get_geo_mosaic_name**, function which gets all the mosaic stores of a specific workspace.

You can find the workspace in the method **get_geo_workspaces**

```r
user = "your_username"
password = "your_password"
workspace = "climate_indices_pe"
obj_f = get_geo_mosaic_name(url_geoserver, workspace, user, password)
print(obj_f)
```

### Get geoserver mosaics

The method **get_geo_mosaics**, function which gets the desired mosaic from the GeoServer.

You can find the workspace in the method **get_geo_workspaces**
You can find the mosaic_name in the method **get_geo_mosaic_name**

```r
workspace = "climate_indices_pe"
mosaic_name = "freq_rh80_t_20_25"
year = 2014
month = 5
day = 1
raster = get_geo_mosaics(url_geoserver, workspace, mosaic_name, year, month, day)
print(raster)
```

### Get geoserver polygon stores

The method **get_geo_polygon_name**, function which gets all the polygon stores of a specific workspace.

You can find the workspace in the method **get_geo_workspaces**

```r
user = "your_username"
password = "your_password"
workspace = "administrative"
obj_f = get_geo_polygon_name(url_geoserver, workspace, user, password)
print(obj_f)
```

### Get geoserver shapefiles

The method **get_geo_polygons**, function which gets the desired shapefile from the GeoServer.

You can find the workspace in the method **get_geo_workspaces**
You can find the polygon_name in the method **get_geo_polygon_name**

```r
workspace = "administrative"
polygon_name = "ao_adm1"
shapefile = get_geo_polygons(url_geoserver, workspace, polygon_name)
print(shapefile)
```

## Developer

### Configure dev environment

To set up your development environment, start by installing the necessary packages in R. You can do this by running the following commands:

```r
install.packages("devtools")
install.packages("roxygen2")
install.packages("httr")
install.packages("rjson")
install.packages("raster")
install.packages("sf")
```

These commands install the devtools and roxygen2 libraries, which are essential for package development.

### Build package

Once you've installed the required libraries, import them into your R session by running the following commands:

```r
library(devtools)
library(roxygen2)
library(httr)
library(rjson)
library(raster)
library(sf)
```

After importing the libraries, set your working directory to the location of the package source code:

```r
setwd("/path/source_code/")
```

Replace "/path/source_code/" with the actual location of your package's source code.

Proceed to build the package documentation by running the following command:

```r
devtools::document()
```

This command generates the documentation associated with the package.

Finally, to build the package, execute the following command:

```r
devtools::build()
```

This last step compiles the package, creating a compressed file containing everything needed for distribution.

> [!NOTE]
> The final section involving devtools is optional and intended for local package creation. If you wish to contribute, follow the steps outlined in the next section, **"Repository Management."** By submitting a pull request to the **"stage"** branch, the documentation will be automatically updated, and a new release will be created.

# Repository management:

### 3 main branches are managed.

- **master:**
  No changes should be made directly, since it is updated when pulling or pushing to the stage branch

- **stage:**
  The changes tested and ready to be sent to production must be sent to this branch, for their subsequent process of automatic tests, merge into master and creation of the release.

- **develop:**
  Branch where the development version of the project will be managed, normally changes will be sent to stage from this branch.

## Release:

    The release will be created automatically if changes are sent to stage, either by means of a pull request or a push.

    The release consists of versioning, which consists of the following format

    Release 0.0.0

- If you want to increase the last value, you must use the following tag within the commit a stage -> **#patch**
  - Current Release = Release 0.0.0

  - Release output = Release 0.0.1

- If you want to increase the value of the medium, you must use the following tag within the commit a stage -> **#minor**
  - Current Release = Release 0.0.0

  - Release output = Release 0.1.0

- If you want to increase the value of the medium, you must use the following tag within the commit a stage -> **#major**
  - Current Release = Release 0.0.0

  - Release output = Release 1.0.0

By **default** if a tag is not sent within the commit it will increment the last value, similar to the #patch tag.

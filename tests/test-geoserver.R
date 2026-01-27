# library(testthat)
# library(webmockr)
# library(httr)
# library(sf)

# source("../R/geoserver.R")

# source("mocks/geoserver.R")

# context("Module geoserver Tests - Aclimate API")

# url_root = "https://geo.aclimate.org/geoserver/"

# dir_current <- getwd()

# httr_mock()

# test_that("get_geo_workspaces Returns a dataframe with workspace information.", {




#     stub_request("GET", paste0(url_root, "/rest/workspaces.json")) %>%
#         to_return(status = 200, body = geo_workspace_mock_data)

#     setwd(dirname(dir_current))

#     result <- get_geo_workspaces(url_root)


#     setwd(dir_current)

#     expect_is(result, "data.frame")
#     expect_true("workspace_name" %in% names(result))
#     expect_true("workspace_href" %in% names(result))
#     expect_equal(ncol(result), 2)
#     expect_equal(nrow(result), 8)
# })


# test_that("get_geo_mosaic_name Returns a dataframe with mosaics stores information.", {

#     workspace = "climate_indices_pe"


#     stub_request("GET", paste0(url_root, "rest/workspaces/", workspace, "/coveragestores.json")) %>%
#         to_return(status = 200, body = geo_mosaic_name_mock_data)

#     setwd(dirname(dir_current))

#     result <- get_geo_mosaic_name(url_root, workspace)

#     setwd(dir_current)

#     expect_is(result, "data.frame")
#     expect_true("mosaic_name" %in% names(result))
#     expect_true("mosaic_href" %in% names(result))
#     expect_equal(ncol(result), 2)
#     expect_equal(nrow(result), 15)
# })

# httr_mock(FALSE)

# test_that("get_geo_mosaics Returns a raster with mosaic information.", {

#     workspace = "climate_indices_pe"
#     mosaic_name = "freq_rh80_t_20_25"
#     year = 2014
#     month = 5


#     result <- get_geo_mosaics(url_root, workspace, mosaic_name, year, month)



#     expect_is(result, "RasterLayer")

# })

# httr_mock()

# test_that("get_geo_polygon_name Returns a dataframe with polygons stores information.", {

#     workspace = "administrative"


#     stub_request("GET", paste0(url_root, "rest/workspaces/", workspace, "/datastores.json")) %>%
#         to_return(status = 200, body = geo_polygon_name_mock_data)

#     setwd(dirname(dir_current))

#     result <- get_geo_polygon_name(url_root, workspace)

#     setwd(dir_current)


#     expect_is(result, "data.frame")
#     expect_true("polygon_name" %in% names(result))
#     expect_true("polygon_href" %in% names(result))
#     expect_equal(ncol(result), 2)
#     expect_equal(nrow(result), 8)
# })


# httr_mock(FALSE)

# test_that("get_geo_polygons Returns a shapefile with the polygon information.", {

#     workspace = "administrative"
#     polygon_name = "ao_adm1"


#     result <- get_geo_polygons(url_root, workspace, polygon_name)



#     expect_is(result, "sf")

# })

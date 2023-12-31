% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/agronomy.R
\name{get_agronomy}
\alias{get_agronomy}
\title{Get agronomy setup}
\usage{
get_agronomy(url_root)
}
\arguments{
\item{url_root}{Url root where the API is located.}
}
\value{
A List with 2 attributes (cultivars, soils).
}
\description{
Access a concise list of soils and cultivars associated with each crop using the HTTP GET method. This endpoint provides essential agronomic details, facilitating informed decisions related to soil and cultivar selection for specific crops.
}
\examples{
url_root = "https://webapi.aclimate.org/api/"
obj_f = get_agronomy(url_root)
print(obj_f)

}

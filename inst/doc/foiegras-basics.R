## ----setup, include = FALSE----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)
library(foieGras)
library(dplyr)
library(ggplot2)
library(sf)

## ----data 1, echo = FALSE------------------------------------------------
data(ellie, package = "foieGras")
head(ellie)

## ----data 2, echo = FALSE------------------------------------------------
data(rope, package = "foieGras")
head(rope)

## ----data 3, echo = FALSE------------------------------------------------
data(ellie, package = "foieGras")
ellie[3:5, c("smaj","smin","eor")] <- NA
head(ellie)

## ----data 4, echo = FALSE, message=FALSE---------------------------------
data(ellie, package = "foieGras")
foo <- sf::st_as_sf(ellie, coords=c("lon","lat"), crs = 4326) 
foo <- sf::st_transform(foo, crs = "+init=epsg:3031 +units=km")
head(foo)

## ----fit_ssm, message=FALSE----------------------------------------------
## load foieGras example data
data(ellie)
## prefilter and fit Random Walk SSM, using a 24 h time step
fit <- fit_ssm(ellie, model = "rw", time.step = 24)

## ----fit summary---------------------------------------------------------
fit$ssm[[1]]

## ----fit plot, fig.width=7,fig.height=7----------------------------------
# plot time-series of the predicted values
plot(fit$ssm[[1]], what = "predicted")

## ----ggplot map, fig.width=7, fig.height=7, message=FALSE----------------
library(rnaturalearth)
library(ggspatial)

## change units from km to m (attempt to avoid win-builder error)
ploc_sf <- grab(fit, what = "predicted") %>% st_transform(., crs = "+init=epsg:3395 +units=m")

## get coastline data
coast <- ne_countries(scale=110, returnclass = "sf") 

ggplot() +
  annotation_spatial(data = coast, fill = grey(0.8), lwd = 0) +
  layer_spatial(data = ploc_sf, colour = "firebrick", size = 1.25) +
  scale_x_continuous(breaks = seq(-180, 180, by = 5)) +
  scale_y_continuous(breaks = seq(-85, -30, by = 5)) +
  theme_bw()

## ----reproject ggplot map, fig.width=7, fig.height=7---------------------
## use Antarctic Polar Stereographic projection approximately centred on the track midpoint
coast <- coast %>% st_transform(., crs = "+init=epsg:3031 +lon_0=85 +units=m")

lab_dates <- with(ploc_sf, seq(min(date), max(date), l = 5)) %>% as.Date()

ggplot() +
  annotation_spatial(data = coast, fill = grey(0.8), lwd = 0) +
  layer_spatial(data = ploc_sf, aes(colour = as.numeric(as.Date(date))), size = 1.25) + 
  theme(legend.position = "bottom", 
        legend.text = element_text(size = 8, vjust = 0), 
        legend.key.width = unit(1.5, "cm"),
        legend.key.height = unit(0.5, "cm"),
        legend.title = element_blank()
  ) + scale_colour_viridis_c(breaks = as.numeric(lab_dates), 
                             option = "viridis", 
                             labels = lab_dates, 
                             end = 0.95)

## ----grab----------------------------------------------------------------
## grab predicted locations from fit object as a projected sf object 
plocs_sf <- grab(fit, what = "p")

## grab predicted locations in unprojected form
plocs <- grab(fit, what = "p", as_sf = FALSE)

## unprojected form looks like this
plocs

## ----multi-fits----------------------------------------------------------
# load royal penguin example data
data(rope)

fit <- fit_ssm(rope, vmax = 20, model = "crw", time.step = 6)

# list fit outcomes for all penguins
fit

## ----plot all rope, fig.width=7, fig.height=7----------------------------
plocs <- grab(fit, what = "p")

ggplot(plocs, aes(colour = id)) + 
  geom_sf() + 
  scale_colour_viridis_d(option="cividis")


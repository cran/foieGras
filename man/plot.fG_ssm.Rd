% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plot.fG_ssm.R
\name{plot.fG_ssm}
\alias{plot.fG_ssm}
\title{plot}
\usage{
\method{plot}{fG_ssm}(
  x,
  what = c("fitted", "predicted"),
  type = 1,
  outlier = TRUE,
  pages = 0,
  ncol = 1,
  ask = TRUE,
  pal = "Zissou1",
  ...
)
}
\arguments{
\item{x}{a \code{foieGras} ssm fit object with class \code{fG_ssm}}

\item{what}{specify which location estimates to display on time-series plots: fitted or predicted}

\item{type}{of plot to generate: 1-d time series for lon and lat separately (type = 1, default) or 2-d track plot (type = 2)}

\item{outlier}{include outlier locations dropped by prefilter (outlier = TRUE, default)}

\item{pages}{each individual is plotted on a separate page by default (pages = 0),
multiple individuals can be combined on a single page; pages = 1}

\item{ncol}{number of columns to arrange plots when combining individuals on a single page (ignored if pages = 0)}

\item{ask}{logical; if TRUE (default) user is asked for input before each plot is rendered. set to FALSE to return ggplot objects}

\item{pal}{\code{hcl.colors} palette to use (default: "Zissou1"; type \code{hcl.pals()} for options)}

\item{...}{additional arguments to be ignored}
}
\value{
a ggplot object with either: (type = 1) 1-d time series of fits to data,
separated into x and y components (units = km) with prediction uncertainty ribbons (2 x SE);
or (type = 2) 2-d fits to data (units = km)
}
\description{
visualize fits from an fG_ssm object
}
\examples{
## generate a fG_ssm fit object (call is for speed only)
xs <- fit_ssm(sese2, spdf=FALSE, model = "rw", time.step=72, 
control = ssm_control(se = FALSE, verbose = 0))

plot(xs, what = "f", type = 1)
plot(xs, what = "p", type = 2)

}

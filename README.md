
<!-- README.md is generated from README.Rmd. Please edit that file -->

# realEstate

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![Travis build
status](https://travis-ci.com/w4356y/realEstate.svg?branch=master)](https://travis-ci.com/w4356y/realEstate)
[![AppVeyor build
status](https://ci.appveyor.com/api/projects/status/github/w4356y/realEstate?branch=master&svg=true)](https://ci.appveyor.com/project/w4356y/realEstate)
<!-- badges: end -->

The goal of realEstate is to take a create a public shiny app to have a
overview of the house price of a specific city.

## Install

``` r
if (!requireNamespace("devtools", quietly = TRUE))
    install.packages("devtools")
devtools::install_github("w4356y/realEstate")
```

## Usage

``` r
realEstate::run_app()
```

The app can also be accessed in
[shinyio](https://w4356y.shinyapps.io/realEstate/).

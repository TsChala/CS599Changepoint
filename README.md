# CS599Changepoint
##### CS599 Unsupervised Learning - R package coding project 2
This is sample package written for the course CS599 Unsupervised Learning.
This package includes two changepoint detection algorithms:
- Binary segmentation
    - written in R
- Optimal segmentation using dynamic programmin algorithm
    - written in C++ and integrated to R using Rcpp
***
## Installation
You can install the latest version of this package from [GitHub](https://github.com/TsChala/CS599Changepoint). For installation the *remotes* package is needed.

    # install.packages("remotes")
    remotes::install_github("TsChala/CS599Changepoint")
***
## Usage
Here is an example code for demonstrating the usage of this package. We can use the DYNPROG_interface function for optimal changepoint detection on the neuroblastoma data set with up to 3 segments. The output will be a loss matrix of dimension [N_data]x[N_segments]
    
    data(neuroblastoma, package="neuroblastoma")
    library(data.table)
    nb.dt <- data.table(neuroblastoma$profiles)
    data.dt <- nb.dt[profile.id=="1" & chromosome=="1"]
    DYNPROG_interface(data.dt$logratio,3)

Binary segmentation for changepoint detection. As an example we can use this function on a sequential data set from the neuroblastome package. The result will be a vector containint the square loss values for segments 1 to 3.

    data(neuroblastoma, package="neuroblastoma")
    library(data.table)
    nb.dt <- data.table(neuroblastoma$profiles)
    data.dt <- nb.dt[profile.id=="1" & chromosome=="1"]
    BINSEG(data.dt$logratio,3)
    

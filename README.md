# CS599Changepoint
##### CS599 Unsupervised Learning - R package coding project 2
This is sample package written for the course CS599 Unsupervised Learning at Northern Arizona University.
This package includes two changepoint detection algorithms:
- Binary segmentation (not working for all scenarios)
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
    dynprog.result <- DYNPROG_interface(data.dt$logratio[1:20],3)
    dynprog.result
    #>    [,1]           [,2]           [,3]
    #>    [1,] -0.2005639  2.121996e-314   0.000000e+00
    #>    [2,] -0.4144319  -4.145404e-01  2.369443e-307
    #>    [3,] -0.6638488  -6.652346e-01  -6.653431e-01
    #>    [4,] -0.9875409  -9.959477e-01  -9.973335e-01
    #>    [5,] -1.2108213  -1.215358e+00  -1.219684e+00
    #>    [6,] -1.4675929  -1.472240e+00  -1.476064e+00
    #>    [7,] -1.6351244  -1.640448e+00  -1.645249e+00
    #>    [8,] -1.8955374  -1.898193e+00  -1.904762e+00
    #>    [9,] -2.1689437  -2.172221e+00  -2.177607e+00
    #>    [10,] -2.3377612  -2.342699e+00  -2.347360e+00
    #>    [11,] -2.6001250  -2.602470e+00  -2.609250e+00
    #>    [12,] -2.9381113  -2.947946e+00  -2.950727e+00
    #>    [13,] -3.1939237  -3.200354e+00  -3.205273e+00
    #>    [14,] -3.3650837  -3.370389e+00  -3.376820e+00
    #>    [15,] -3.8153675  -3.856944e+00  -3.862249e+00
    #>    [16,] -4.1930990  -4.245635e+00  -4.250941e+00
    #>    [17,] -4.4037171  -4.431440e+00  -4.458643e+00
    #>    [18,] -4.6356915  -4.654360e+00  -4.691071e+00
    #>    [19,] -4.8488148  -4.860635e+00  -4.905971e+00
    #>    [20,] -5.1592916  -5.173803e+00  -5.213123e+00

Binary segmentation for changepoint detection. As an example we can use this function on a sequential data set from the neuroblastome package. The result will be a vector containint the square loss values for segments 1 to 3.

    data(neuroblastoma, package="neuroblastoma")
    library(data.table)
    nb.dt <- data.table(neuroblastoma$profiles)
    data.dt <- nb.dt[profile.id=="1" & chromosome=="1"]
    binseg.result <- BINSEG(data.dt$logratio,3)
    binseg.result
    #>    [1] 1.1220205 0.8162898 0.7037958
    

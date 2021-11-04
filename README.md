# CS599Clustering
##### CS599 Unsupervised Learning - R package coding project 1
This is sample package written for the course CS599 Unsupervised Learning.
This package includes two unsupervised clustering algorithms:
- Hiearchical clustering algorithm using the single linkage method
    - written in R
- K-Means algorithm
    - written in C++ and integrated to R using Rcpp
***
## Installation
You can install the latest version of this package from [GitHub](https://github.com/TsChala/CS599Clustering). For installation the *remotes* package is needed.

    # install.packages("remotes")
    remotes::install_github("TsChala/CS599Clustering")
***
## Usage
Here is an example code for demonstrating the usage of this package. We can use the HCLUST function for agglomerative hierarchical clustering using the single linkage method. The output is a vector containing the cluster assignments for each data point. This examples uses the iris data set with 3 clusters for demonstration.
    
    library(CS599Clustering)
    data.mat <- iris[,1:4]
    K <- 3
    hclust.result <- HCLUST(data.mat,K)
    > hclust.result
    #>    [1] 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 3 3 3 3 3 3 3 3 3
    #>    [60] 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 2 3 3 3 3 3 3 3 3 3 3 3
    #>    [119] 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3

The second function that we have in this package is the kmeansclust_interface, which is the implementation of the K-means clustering algorithm in C++ using Rcpp. It is noted that the input should be a numeric matrix, otherwise the function cannot run. The returned values are the cluster assignments to each data point.

    kmeansclust_interface(as.matrix(iris[,1:2]),3)
    #>  [1] 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 2 2 3 2 3 2 3 2
    #>  [60] 3 3 3 3 3 3 2 3 3 3 3 3 3 3 3 2 2 2 2 3 3 3 3 3 3 3 3 2 3 3 3 3 3 3 3 3 3 3 3 3 3 2 3 2 2 2 2 3 2 2 2 2 2 2 3 3 2 2 2
    #>  [119] 2 3 2 3 2 3 2 2 3 3 2 2 2 2 2 3 3 2 2 2 3 2 2 2 3 2 2 2 3 2 2 3
    

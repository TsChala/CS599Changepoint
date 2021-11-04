#include <Rcpp.h>
#include "DYNPROG.h"
using namespace Rcpp;

//' Dynamic programming for optimal segmentation
//'
//' Dynamic programming for changepoint detection of a givens sequence of data with up to N_segments
//'
//' @param data_vec numeric data vector, [N_data]
//' @param N_segments number of max segments
//'
//' @return loss_mat, loss matrix [N_data] x [N_segments]
//' @useDynLib CS599Changepoint, .registration = TRUE
//' @importFrom Rcpp evalCpp
//' @export
//' 
//' @examples
//' data(neuroblastoma, package="neuroblastoma")
//' library(data.table)
//' nb.dt <- data.table(neuroblastoma$profiles)
//' data.dt <- nb.dt[profile.id=="1" & chromosome=="1"]
//' DYNPROG_interface(data.dt$logratio,3)
// [[Rcpp::export]]
NumericMatrix DYNPROG_interface
(NumericVector data_vec, int N_segments){
  int N_data = data_vec.length();
  double *data_ptr = &data_vec[0];
  NumericMatrix loss_mat(N_data, N_segments);
  double *loss_mat_ptr = &loss_mat[0];
  int status = DYNPROG
    (N_data,
     N_segments,
     data_ptr,
     //inputs above, outputs below.
     loss_mat_ptr);
  
  if(status == ERROR_N_DATA_MUST_BE_POSITIVE){
    Rcpp::stop("Number of data points must be postive");
  }
  
  if(status == ERROR_N_SEGMENTS_MUST_BE_POSITIVE){
    Rcpp::stop("Number of segments must be postive");
  }
  
  if(status == ERROR_N_SEGMENTS_MUST_BE_SMALLER_THAN_N_DATA){
    Rcpp::stop("Number of data points must be larger than the number of segments");
  }
  
  return loss_mat;
}
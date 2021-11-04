#include "DYNPROG.h"
#include <math.h>
#include <iostream>
#include <Rcpp.h>
#include <cmath>

int DYNPROG(
  const int N_data,
  const int N_segments,
  const double *data_ptr,  
  double *loss_mat_ptr
){
  if(N_data < 1){
    return ERROR_N_DATA_MUST_BE_POSITIVE;
  }
  
  if(N_segments < 1){
    return ERROR_N_SEGMENTS_MUST_BE_POSITIVE;
  }
  
  if(N_segments > N_data){
    return ERROR_N_SEGMENTS_MUST_BE_SMALLER_THAN_N_DATA;
  }
  
  double *cum_sum_ptr = new double[N_data]; //cumulative_sum vector
  // calculate cumulative sum
  for(int data_i=0; data_i< N_data; data_i++){
    double data_value = data_ptr[data_i];
    if(data_i !=0){
      cum_sum_ptr[data_i] = cum_sum_ptr[data_i-1] + data_value;}
    else {
      cum_sum_ptr[data_i] = data_value;
    }
    //Rcpp::Rcout<<cum_sum_ptr[data_i]<<std::endl;
  }
  
  //calculate first loss
  for(int data_i=0; data_i< N_data; data_i++){
    loss_mat_ptr[data_i] = -pow(cum_sum_ptr[data_i],2)/(data_i+1);
  }
  
  int best_index = 0;

  
  for(int segment_i = 1; segment_i < N_segments; segment_i++){
    for(int up_to_t = segment_i; up_to_t <= N_data; up_to_t++){
      int *possible_prev_end_ptr =  new int[up_to_t-segment_i+1];
      int *N_last_segs_ptr = new int[up_to_t-segment_i+1];
      double *prev_loss = new double[up_to_t-segment_i+1];
      double *sum_last_segs = new double[up_to_t-segment_i+1];
      for (int i=0; i< up_to_t-segment_i; i++){
        possible_prev_end_ptr[i] = segment_i+i;
        N_last_segs_ptr[i] = up_to_t - i- segment_i;
        prev_loss[i] = loss_mat_ptr[(segment_i-1)*N_data + possible_prev_end_ptr[i]-1];
        sum_last_segs[i] = cum_sum_ptr[up_to_t-1]-cum_sum_ptr[possible_prev_end_ptr[i]-1];
      }
      
      double *total_loss = new double[up_to_t-segment_i+1];
      
      for(int data_i=0; data_i < up_to_t-segment_i; data_i++){
        total_loss[data_i] = -pow(sum_last_segs[data_i],2)/(N_last_segs_ptr[data_i]) + 
          prev_loss[data_i];
        
      }
      
      // calculate index of the minimal loss value
      best_index = 0;
      
      for(int i = 0; i < up_to_t-segment_i+1; i++)
      {
        if(total_loss[i] < total_loss[best_index]){
          best_index = i;
        }
      }
      loss_mat_ptr[segment_i*N_data + up_to_t-1] = total_loss[best_index];
    }
    
  }
  return 0;
}
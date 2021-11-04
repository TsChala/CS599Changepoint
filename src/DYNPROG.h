#define ERROR_N_DATA_MUST_BE_POSITIVE 1
#define ERROR_N_SEGMENTS_MUST_BE_POSITIVE 2
#define ERROR_N_SEGMENTS_MUST_BE_SMALLER_THAN_N_DATA 3
int DYNPROG(
  const int N_data,
  const int N_segments,
  const double *data_ptr,
  // inputs above, outputs below
  double *loss_mat_ptr
);
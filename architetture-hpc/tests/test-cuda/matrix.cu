#include <cuda_runtime.h>

__global__ void my_sgemm_0kernel(int M, int K, float *A, int lda, float *B, int ldb, float *C, int ldc) {
    int idx_x = threadIdx.x;
    int idx_y = threadIdx.y;
    int kk;
    float sum = 0;
    
    if (idx_x < M && idx_y < M) {
        for (kk = 0; kk < K; kk ++) {
            sum += A[idx_y * lda + kk] * B[kk * ldb + idx_x];
        }
        C[idx_y * ldc + idx_x] += sum;
    }
}

__global__ void my_sgemm_1kernel(int M, int K, float *A, int lda, float *B, int ldb, float *C, int ldc) {
    int idx_x = blockIdx.x * blockDim.x + threadIdx.x;
    int idx_y = blockIdx.y * blockDim.y + threadIdx.y;
    int kk;
    float sum = 0;
    if (idx_x < M && idx_y < M) {
        for (kk = 0; kk < K; kk ++) {
            sum += A[idx_y * lda + kk] * B[kk * ldb + idx_x];
        }
        C[idx_y * ldc + idx_x] += sum;
    }
}

__global__ void my_sgemm_2kernel(int M, int K, float *A, int lda, float *B, int ldb, float *C, int ldc) {
    
    __shared__ float As[TILEWIDTH][TILEWIDTH];
    __shared__ float Bs[TILEWIDTH][TILEWIDTH];

    int idx_x = blockIdx.x * TILEWIDTH + threadIdx.x;
    int idx_y = blockIdx.y * TILEWIDTH + threadIdx.y;
    int jj, kk;
    float sum = 0;

    for (kk = 0; kk < K/TILEWIDTH; kk++) {
        As[threadIdx.y][threadIdx.x] = A[idx_y * lda + (kk * TILEWIDTH + threadIdx.x)];
        Bs[threadIdx.y][threadIdx.x] = B[(kk * TILEWIDTH + threadIdx.y)* ldb + idx_x];

        __syncthreads();
        
        for (jj = 0; jj < TILEWIDTH; jj++) {
            sum += As[threadIdx.y][jj] * Bs[jj][threadIdx.x];
            __syncthreads();
        }
        C[idx_y * ldc + idx_x] += sum;
    }
}

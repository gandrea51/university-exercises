#include <cuda_runtime.h>


__global__ void my_reduce_0(double *idata, double *odata, unsigned int n) {
    
    __shared__ double sdata[TILEWIDTH];
    unsigned int stride, idx = threadIdx.x;
    unsigned int ii = (blockIdx.x * blockDim.x ) + threadIdx.x;
    
    sdata[idx] = (ii < n) ? idata[ii] : 0.0;
    __syncthreads();

    for (stride = 1; stride < blockDim.x; stride <<= 1) {
        if (idx % (2*stride) == 0 ) sdata[idx] += sdata[idx+stride];
        __syncthreads();
    }
    if (idx == 0) odata[blockIdx.x] = sdata[0];
}

__global__ void my_reduce_1(double *idata, double *odata, unsigned int n) {
    __shared__ double sdata[TILEWIDTH];
    unsigned int stride, idx = threadIdx.x;
    unsigned int ii = blockIdx.x * blockDim.x + threadIdx.x;
    
    sdata[idx] = (ii < n) ? idata[ii] : 0.0;
    __syncthreads();

    for (stride = blockDim.x/2; stride > 0; stride >>= 1) {
        if (idx < stride) sdata[idx] += sdata[idx + stride];
        __syncthreads();
    }
    if (idx == 0) odata[blockIdx.x] = sdata[0];
}
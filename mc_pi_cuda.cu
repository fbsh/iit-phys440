#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>


__global__ void trial(int seed, bool count_d[], double x_d[], double y_d[]) {
    long long id = blockIdx.x * blockDim.x + threadIdx.x;
    double x = x_d[id], y = y_d[id];
    if(x*x + y*y <= 1) {
        count_d[id] = true;
    }
    else {
        count_d[id] = false;
    }
}

int main(int argc, char* argv[]) {
    int seed = time(NULL);
    long long total = 1e6;  // Default 1 million samples
    int tn = 128;             // Default 128 threads

    if(argc >= 2) {
        total = atoi(argv[1]);  // Get the number of samples from the arg
    }
    if(argc >= 3) {
        tn = atoi(argv[2]);     // Get the number of threads from the arg
    }
    dim3 threads(tn);
    dim3 blocks((total+tn-1) / tn);
    long long real_total = threads.x * blocks.x;

    bool* count_h = new bool[real_total];
    bool* count_d;
    double* x_h = new double[real_total];
    double* y_h = new double[real_total];
    double* x_d, *y_d;
    for(long long i = 0; i < real_total; i++) {
        x_h[i] = (double)rand() / RAND_MAX;
        y_h[i] = (double)rand() / RAND_MAX;
    }
    cudaMalloc(&count_d, real_total * sizeof(bool));  // Graphic memory for saving results
    cudaMalloc(&x_d, real_total * sizeof(double));    // random number array x
    cudaMalloc(&y_d, real_total * sizeof(double));    // random number array y
    cudaMemcpy(x_d, x_h, real_total * sizeof(double), cudaMemcpyHostToDevice);  // copy random number array
    cudaMemcpy(y_d, y_h, real_total * sizeof(double), cudaMemcpyHostToDevice);  // copy random number array

    trial<<<blocks, threads>>>(seed, count_d, x_d, y_d);

    cudaMemcpy(count_h, count_d, real_total * sizeof(bool), cudaMemcpyDeviceToHost);

    long long count = 0;
    for(long long i = 0; i < real_total; i++) {
        if(count_h[i]) {
            count++;
        }
    }
    double pi = 4 * (double)count / real_total;
    double r = 1;
    double volume = 4 * (double)pi * r * r * r / 3;
    double surface = 4 * (double)pi * r * r;
    double bound_volume = r * r * r;
    double bound_surface =  6 * r * r;

    printf("[+] total                       = %lld\n", real_total);  // The actual total may be different from the parameter, depending on whether it is divisible or not
    printf("[+] count                       = %lld\n", count);
    printf("[+] pi                          = %f\n", pi);
    printf("[+] loss                        = %e\n", acos(-1) - pi);

    printf("[+] volume of the unit sphere   = %f\n", volume);
    printf("[+] surface of the unit sphere  = %f\n", surface);
    printf("[+] volume of the box           = %f\n", bound_volume);
    printf("[+] surface of the box          = %f\n", bound_surface);

    printf("\nBlocks  = %d\n", blocks.x);
    printf("Threads = %d\n", threads.x);

    return 0;
}
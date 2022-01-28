#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>

int main(int argc, char* argv[]) {
    srand(time(NULL));      // Randomly initialize seeds
    long long total = 1e6;  // Default 1 million samples

    if(argc >= 2) {
        total = atoi(argv[1]);  // Get the number of samples from the arg
    }

    long long count = 0;
    double x, y;
    for(long long i = 0; i < total; i++) {
        x = (double)rand() / RAND_MAX;
        y = (double)rand() / RAND_MAX;
        if(x*x + y*y <= 1) {
            count++;
        }
    }
    double pi = 4 * (double)count / total;
    double r = 1;
    double volume = 4 * (double)pi * r * r * r / 3;
    double surface = 4 * (double)pi * r * r;
    double bound_volume = r * r * r;
    double bound_surface =  6 * r * r;


    printf("[+] total                       = %lld\n", total);
    printf("[+] count                       = %lld\n", count);
    printf("[+] pi                          = %f\n", pi);
    printf("[+] loss                        = %e\n", acos(-1) - pi);
    printf("[+] volume of the unit sphere   = %f\n", volume);
    printf("[+] surface of the unit sphere  = %f\n", surface);
    printf("[+] volume of the box           = %f\n", bound_volume);
    printf("[+] surface of the box          = %f\n", bound_surface);




    return 0;
}
# Introduction

This is a high-performance computation case using the Monte Carlo method to get pi and calculate the unit sphere surface and volume and the bounded box surface and volume. For multi-threaded high-performance computing, in this case I used my NVIDIA GeForce GTX 1660 Ti graphics card. At the same time, the accuracy of the result will be compared with the serial C code. A large number of Monte Carlo trials can run on the GPU, one trial per thread. There are 128 threads by default, and the number of blocks is determined by the total number of trials and the number of threads. Since I am using the external gpu, io between cpu and gpu is limited by the bandwidth of the thunderbolt3 cable which is 40Gbps maximun.

# Test and Test Result

## c 

(base) fbsh@fbsh-NUC8i5BEH:~/phys440/assignment_1$ gcc mc_pi_serial.c -o mc_pi_serial

### Test 1
(base) fbsh@fbsh-NUC8i5BEH:~/phys440/assignment_1$ time ./mc_pi_serial 
[+] total                       = 1000000
[+] count                       = 785825
[+] pi                          = 3.143300
[+] loss                        = -1.707346e-03
[+] volume of the unit sphere   = 4.191067
[+] surface of the unit sphere  = 12.573200
[+] volume of the box           = 1.000000
[+] surface of the box          = 6.000000

real    0m0.027s
user    0m0.023s
sys     0m0.004s

### Test 2
(base) fbsh@fbsh-NUC8i5BEH:~/phys440/assignment_1$ time ./mc_pi_serial 10000000
[+] total                       = 10000000
[+] count                       = 7853447
[+] pi                          = 3.141379
[+] loss                        = 2.138536e-04
[+] volume of the unit sphere   = 4.188505
[+] surface of the unit sphere  = 12.565515
[+] volume of the box           = 1.000000
[+] surface of the box          = 6.000000

real    0m0.190s
user    0m0.186s
sys     0m0.004s

### Test 3
(base) fbsh@fbsh-NUC8i5BEH:~/phys440/assignment_1$ time ./mc_pi_serial 100000000
[+] total                       = 100000000
[+] count                       = 78533917
[+] pi                          = 3.141357
[+] loss                        = 2.359736e-04
[+] volume of the unit sphere   = 4.188476
[+] surface of the unit sphere  = 12.565427
[+] volume of the box           = 1.000000
[+] surface of the box          = 6.000000

real    0m1.822s
user    0m1.822s
sys     0m0.000s

## cuda

(base) fbsh@fbsh-NUC8i5BEH:~/phys440/assignment_1$ nvcc mc_pi_cuda.cu -o mc_pi_cuda

### Test 4
(base) fbsh@fbsh-NUC8i5BEH:~/phys440/assignment_1$ time ./mc_pi_cuda
[+] total                       = 1000064
[+] count                       = 785470
[+] pi                          = 3.141679
[+] loss                        = -8.627896e-05
[+] volume of the unit sphere   = 4.188905
[+] surface of the unit sphere  = 12.566716
[+] volume of the box           = 1.000000
[+] surface of the box          = 6.000000

Blocks  = 7813
Threads = 128

real    0m0.208s
user    0m0.047s
sys     0m0.136s

### Test 5
(base) fbsh@fbsh-NUC8i5BEH:~/phys440/assignment_1$ time ./mc_pi_cuda 10000000
[+] total                       = 10000000
[+] count                       = 7852825
[+] pi                          = 3.141130
[+] loss                        = 4.626536e-04
[+] volume of the unit sphere   = 4.188173
[+] surface of the unit sphere  = 12.564520
[+] volume of the box           = 1.000000
[+] surface of the box          = 6.000000

Blocks  = 78125
Threads = 128

real    0m0.508s
user    0m0.313s
sys     0m0.172s

### Test 6
(base) fbsh@fbsh-NUC8i5BEH:~/phys440/assignment_1$ ./mc_pi_cuda 100000000
[+] total                       = 100000000
[+] count                       = 78542448
[+] pi                          = 3.141698
[+] loss                        = -1.052664e-04
[+] volume of the unit sphere   = 4.188931
[+] surface of the unit sphere  = 12.566792
[+] volume of the box           = 1.000000
[+] surface of the box          = 6.000000

Blocks  = 781250
Threads = 128

real    0m3.171s
user    0m2.634s
sys     0m0.517s
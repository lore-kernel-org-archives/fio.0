Return-Path: <rebecca@bluestop.org>
From: Rebecca Cran <rebecca@bluestop.org>
Subject: memcpy test: results from adding sse and avx tests
Message-ID: <04b051c0-85a6-d6c5-e20e-c9a765a8e22d@bluestop.org>
Date: Thu, 18 Jan 2018 10:38:39 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
To: fio@vger.kernel.org, axboe@kernel.dk
List-ID: <fio@vger.kernel.org>

I added code to lib/memcpy.c to test sse and avx performance, and found 
that on modern systems memcpy outperforms both by quite some margin 
(GB/s) on the larger block sizes: the only place sse/avx is an 
improvement was on an older SandyBridge EP system - I've copied the 
output below.

Should I work on a patch to commit the changes, or just abandon them 
since it seems the current memcpy implementation used in the mmap engine 
is the best solution on modern machines?

memcpy
         8 bytes:         1591.58 MiB/sec
         16 bytes:        3047.34 MiB/sec
         96 bytes:        5071.65 MiB/sec
         128 bytes:       5632.66 MiB/sec
         256 bytes:       4969.02 MiB/sec
         512 bytes:       4767.54 MiB/sec
         2048 bytes:      4908.89 MiB/sec
         8192 bytes:      6008.83 MiB/sec
         131072 bytes:    6490.50 MiB/sec
         262144 bytes:    6521.61 MiB/sec
         524288 bytes:    6527.18 MiB/sec
memmove
         8 bytes:         1935.53 MiB/sec
         16 bytes:        3393.45 MiB/sec
         96 bytes:        5458.51 MiB/sec
         128 bytes:       5833.40 MiB/sec
         256 bytes:       5679.88 MiB/sec
         512 bytes:       5881.02 MiB/sec
         2048 bytes:      5863.07 MiB/sec
         8192 bytes:      6208.45 MiB/sec
         131072 bytes:    6781.48 MiB/sec
         262144 bytes:    6793.20 MiB/sec
         524288 bytes:    6788.83 MiB/sec
simple
         8 bytes:         1340.18 MiB/sec
         16 bytes:        1516.03 MiB/sec
         96 bytes:        6484.69 MiB/sec
         128 bytes:       6583.03 MiB/sec
         256 bytes:       6617.02 MiB/sec
         512 bytes:       6602.64 MiB/sec
         2048 bytes:      6577.07 MiB/sec
         8192 bytes:      6574.87 MiB/sec
         131072 bytes:    6580.19 MiB/sec
         262144 bytes:    6580.26 MiB/sec
         524288 bytes:    6580.13 MiB/sec
hybrid
         8 bytes:         1608.89 MiB/sec
         16 bytes:        3047.78 MiB/sec
         96 bytes:        6494.02 MiB/sec
         128 bytes:       6586.65 MiB/sec
         256 bytes:       6622.07 MiB/sec
         512 bytes:       6604.19 MiB/sec
         2048 bytes:      6578.36 MiB/sec
         8192 bytes:      6572.59 MiB/sec
         131072 bytes:    6577.24 MiB/sec
         262144 bytes:    6576.45 MiB/sec
         524288 bytes:    6577.00 MiB/sec
sse
         16 bytes:        5949.11 MiB/sec
         96 bytes:        6588.66 MiB/sec
         128 bytes:       6592.54 MiB/sec
         256 bytes:       6576.18 MiB/sec
         512 bytes:       6564.48 MiB/sec
         2048 bytes:      6565.39 MiB/sec
         8192 bytes:      6586.33 MiB/sec
         131072 bytes:    6605.39 MiB/sec
         262144 bytes:    6613.17 MiB/sec
         524288 bytes:    6607.05 MiB/sec
avx
         96 bytes:        6528.18 MiB/sec
         128 bytes:       6539.18 MiB/sec
         256 bytes:       6529.86 MiB/sec
         512 bytes:       6523.17 MiB/sec
         2048 bytes:      6519.51 MiB/sec
         8192 bytes:      6524.95 MiB/sec
         131072 bytes:    6523.06 MiB/sec
         262144 bytes:    6521.05 MiB/sec
         524288 bytes:    6522.46 MiB/sec

-- 

Rebecca



Return-Path: <axboe@kernel.dk>
Subject: Re: fio 3.2
References: <TU4PR8401MB099112614914A9232A07490DEC270@TU4PR8401MB0991.NAMPRD84.PROD.OUTLOOK.COM>
 <CALjAwxiQU=C4ye2gN4-9S6D75f3HQ7q7w2TpE0O+fH6C+MXLHg@mail.gmail.com>
 <b9bce0b0-9683-59b6-4c08-62f29d80935a@bluestop.org>
 <TU4PR8401MB0991F4C4CAD9858A3BF2AE9DEC3A0@TU4PR8401MB0991.NAMPRD84.PROD.OUTLOOK.COM>
 <AT5PR8401MB0387489EC42684D7FACF3E1EAB3A0@AT5PR8401MB0387.NAMPRD84.PROD.OUTLOOK.COM>
 <TU4PR8401MB0991EBEF27D16271CD5361AAEC3B0@TU4PR8401MB0991.NAMPRD84.PROD.OUTLOOK.COM>
 <AT5PR8401MB03875F6DB61311D1D8B40419AB3B0@AT5PR8401MB0387.NAMPRD84.PROD.OUTLOOK.COM>
 <aa9efb3f-9fd5-5322-7614-aa8c773dfa29@kernel.dk>
 <TU4PR8401MB099144F611F2DA95262312F4EC380@TU4PR8401MB0991.NAMPRD84.PROD.OUTLOOK.COM>
 <0e2efc36-3c1b-ac51-4baf-044276cc51e9@kernel.dk>
 <TU4PR8401MB0991226E41D378F0373CBE42EC3C0@TU4PR8401MB0991.NAMPRD84.PROD.OUTLOOK.COM>
 <AT5PR8401MB0387A1F5A8EA5A0B614FC3CDAB3C0@AT5PR8401MB0387.NAMPRD84.PROD.OUTLOOK.COM>
 <TU4PR8401MB0991C9F5A29FFDA3FB05B315EC3C0@TU4PR8401MB0991.NAMPRD84.PROD.OUTLOOK.COM>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <3e4ea31d-b7ff-f696-207d-76c478406421@kernel.dk>
Date: Mon, 4 Dec 2017 11:50:57 -0700
MIME-Version: 1.0
In-Reply-To: <TU4PR8401MB0991C9F5A29FFDA3FB05B315EC3C0@TU4PR8401MB0991.NAMPRD84.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: "Gavriliuk, Anton (HPS Ukraine)" <anton.gavriliuk@hpe.com>, "Robert Elliott (Persistent Memory)" <elliott@hpe.com>, Rebecca Cran <rebecca@bluestop.org>, Sitsofe Wheeler <sitsofe@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, "Kani, Toshimitsu" <toshi.kani@hpe.com>
List-ID: <fio@vger.kernel.org>

On 12/04/2017 11:25 AM, Gavriliuk, Anton (HPS Ukraine) wrote:
> Ok, now test for 10 minutes with the same I/O latencies .  So there is no startup overhead.
> 
> dl560g10spmem01:~ # perf record /usr/local/bin/fio --filename=/dev/dax0.0 --rw=randrw --refill_buffers --norandommap --randrepeat=0 --ioengine=mmap --bssplit=4k/4:8k/7:16k/7:32k/15:64k/65:128k/1:256k/1 --rwmixread=5 --iodepth=1 --numjobs=16 --runtime=600 --group_reporting --name=4-rand-rw-3xx --size=290g --numa_cpu_nodes=0 --time_based=1
> 4-rand-rw-3xx: (g=0): rw=randrw, bs=(R) 4096B-256KiB, (W) 4096B-256KiB, (T) 4096B-256KiB, ioengine=mmap, iodepth=1
> ...
> fio-3.2-64-gaf7fb
> Starting 16 processes
> 
>    read: IOPS=36.7k, BW=1865MiB/s (1956MB/s)(1093GiB/600002msec)
>     clat (nsec): min=120, max=16029k, avg=6897.44, stdev=5503.68
>      lat (nsec): min=144, max=16029k, avg=6932.35, stdev=5504.08
>   write: IOPS=697k, BW=34.6GiB/s (37.2GB/s)(20.3TiB/600002msec)
>     clat (nsec): min=111, max=72027k, avg=12546.82, stdev=9845.85
>      lat (nsec): min=132, max=72027k, avg=12592.74, stdev=9851.98
> 
> Samples: 38M of event 'cycles:ppp', Event count (approx.): 182321387032131
> Overhead  Command  Shared Object       Symbol
>   77.20%  fio      fio                 [.] clock_thread_fn
>    8.32%  fio      libc-2.22.so        [.] __memcpy_avx_unaligned
>    6.07%  fio      fio                 [.] fill_random_buf
>    4.82%  fio      [kernel.kallsyms]   [k] page_remove_rmap
>    3.02%  fio      [kernel.kallsyms]   [k] native_write_msr_safe
>    0.10%  fio      fio                 [.] get_io_u

That seems so odd, it makes no sense. --no-children added to perf report?
I think this is skewed because the code is so hot for startup.

-- 
Jens Axboe



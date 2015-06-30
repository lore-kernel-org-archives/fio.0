Return-Path: <axboe@kernel.dk>
Message-ID: <559203A1.7000202@kernel.dk>
Date: Mon, 29 Jun 2015 20:49:05 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Percentage/ETA progress indicator faulty with examples/tiobench-example.fio
References: <5591D2EB.8050309@cran.org.uk>
In-Reply-To: <5591D2EB.8050309@cran.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Bruce Cran <bruce@cran.org.uk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 06/29/2015 05:21 PM, Bruce Cran wrote:
> On Linux, using the latest fio sources, "fio
> examples/tiobench-example.fio" results in the progress indicator
> (percentage and ETA) displaying odd values.  Percentage rises to about
> 70% before dropping to 20%, getting to 25% and then the test finishes.
> The ETA starts out about 4 minutes, falls to 1m and then jumps to 12.
>
> $ ./fio examples/tiobench-example.fio
> [snip]
> f4: Laying out IO file(s) (1 file(s) / 512MB)
> Jobs: 4 (f=4): [_(12),r(4)] [25.1% done] [887KB/0KB/0KB /s] [221/0/0
> iops] [eta 12m:00s]
> f1: (groupid=0, jobs=1): err= 0: pid=9730: Mon Jun 29 17:17:01 2015
>    write: io=388340KB, bw=6453.7KB/s, iops=1613, runt= 60174msec
>      clat (usec): min=144, max=704183, avg=616.69, stdev=7110.74
>       lat (usec): min=145, max=704184, avg=617.10, stdev=7110.74
>      clat percentiles (usec):
>       |  1.00th=[  354],  5.00th=[  378], 10.00th=[  394], 20.00th=[ 410],
>       | 30.00th=[  422], 40.00th=[  434], 50.00th=[  442], 60.00th=[ 450],
>       | 70.00th=[  466], 80.00th=[  478], 90.00th=[  506], 95.00th=[ 564],
>       | 99.00th=[ 1416], 99.50th=[ 1448], 99.90th=[24960], 99.95th=[56576],
>       | 99.99th=[544768]
>      bw (KB  /s): min= 2067, max= 9432, per=26.50%, avg=6839.64,
> stdev=1755.81
>      lat (usec) : 250=0.01%, 500=88.36%, 750=7.53%, 1000=0.02%
>      lat (msec) : 2=3.91%, 4=0.03%, 10=0.01%, 20=0.01%, 50=0.06%
>      lat (msec) : 100=0.03%, 250=0.01%, 750=0.01%

I'll take a look at this. Is this a regression?

-- 
Jens Axboe



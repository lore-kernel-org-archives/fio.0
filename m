Return-Path: <axboe@kernel.dk>
Subject: Re: Ramp Time Bug
References: <CAF+0mv=_hmqdhUg_1Oq7gbHkLi4ZUQdPd7var7uSSZrHVuP-Og@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <edd16cac-edae-f933-b27e-d2f2f1a32160@kernel.dk>
Date: Fri, 14 Dec 2018 14:38:28 -0700
MIME-Version: 1.0
In-Reply-To: <CAF+0mv=_hmqdhUg_1Oq7gbHkLi4ZUQdPd7var7uSSZrHVuP-Og@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Matthew Eaton <m.eaton82@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 12/13/18 3:19 PM, Matthew Eaton wrote:
> Using ramp_time is causing all min values (slat/clat/lat/bw/iops) to report 0.
> Removing ramp_time fixes the issue.
> 
> Job file:
> [rnd-8020]
> ioengine=libaio
> direct=1
> bs=4k
> rw=randrw
> rwmixread=80
> numjobs=1
> iodepth=32
> runtime=10
> time_based
> norandommap
> randrepeat=0
> filename=/dev/sdb
> #ramp_time=10
> 
> Fio output with min values zeroed:
> rnd-8020: (g=0): rw=randrw, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T)
> 4096B-4096B, ioengine=libaio, iodepth=32
> fio-3.12-45-g771c
> Starting 1 process
> Jobs: 1 (f=1): [m(1)][100.0%][r=149MiB/s,w=37.4MiB/s][r=38.1k,w=9562
> IOPS][eta 00m:00s]
> rnd-8020: (groupid=0, jobs=1): err= 0: pid=4701: Thu Dec 13 14:14:36 2018
>   read: IOPS=33.6k, BW=131MiB/s (138MB/s)(1313MiB/10002msec)
>     slat (nsec): min=0, max=14301, avg=1880.55, stdev=242.49
>     clat (nsec): min=0, max=9948.1k, avg=633109.98, stdev=597207.47
>      lat (nsec): min=0, max=9950.0k, avg=635050.69, stdev=597212.18
>     clat percentiles (usec):
>      |  1.00th=[  135],  5.00th=[  165], 10.00th=[  178], 20.00th=[  202],
>      | 30.00th=[  227], 40.00th=[  251], 50.00th=[  285], 60.00th=[  379],
>      | 70.00th=[  873], 80.00th=[ 1270], 90.00th=[ 1565], 95.00th=[ 1762],
>      | 99.00th=[ 2212], 99.50th=[ 2606], 99.90th=[ 3851], 99.95th=[ 4015],
>      | 99.99th=[ 5211]
>    bw (  KiB/s): min=    0, max=164608, per=100.00%, avg=134473.20,
> stdev=12836.10, samples=20
>    iops        : min=    0, max=41152, avg=33618.30, stdev=3209.03, samples=20
>   write: IOPS=8419, BW=32.9MiB/s (34.5MB/s)(329MiB/10002msec); 0 zone resets
>     slat (nsec): min=0, max=13697, avg=2059.16, stdev=383.41
>     clat (nsec): min=0, max=10090k, avg=1261001.47, stdev=575428.55
>      lat (nsec): min=0, max=10092k, avg=1263121.22, stdev=575424.23
>     clat percentiles (usec):
>      |  1.00th=[  474],  5.00th=[  635], 10.00th=[  709], 20.00th=[  807],
>      | 30.00th=[  898], 40.00th=[  996], 50.00th=[ 1106], 60.00th=[ 1237],
>      | 70.00th=[ 1418], 80.00th=[ 1680], 90.00th=[ 2089], 95.00th=[ 2376],
>      | 99.00th=[ 3064], 99.50th=[ 3523], 99.90th=[ 4424], 99.95th=[ 4752],
>      | 99.99th=[ 5866]
>    bw (  KiB/s): min=    0, max=40240, per=100.00%, avg=33682.40,
> stdev=3069.64, samples=20
>    iops        : min=    0, max=10060, avg=8420.60, stdev=767.41, samples=20
>   lat (usec)   : 100=0.20%, 250=31.37%, 500=20.39%, 750=5.34%, 1000=8.79%
>   lat (msec)   : 2=30.07%, 4=3.76%, 10=0.08%, 20=0.01%
>   cpu          : usr=9.58%, sys=12.38%, ctx=406871, majf=0, minf=15
>   IO depths    : 1=0.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=100.0%, >=64=0.0%
>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.1%, 64=0.0%, >=64=0.0%
>      issued rwts: total=336181,84209,0,0 short=0,0,0,0 dropped=0,0,0,0
>      latency   : target=0, window=0, percentile=100.00%, depth=32

Huh, that's no good. Pushed a fix:

http://git.kernel.dk/cgit/fio/commit/?id=5b8f19b7afe0cabc002c453a1a4abd7a494880bb

-- 
Jens Axboe



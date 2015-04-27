Return-Path: <axboe@kernel.dk>
Message-ID: <553E4A22.2040800@kernel.dk>
Date: Mon, 27 Apr 2015 08:39:30 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: FIO - dedup checksums or specified blocksize does not match.
References: <CABtFm2VavXTA5zsPE7VQSqq+zJKBa=1Emb1vNShi45n1oNnv7g@mail.gmail.com>
In-Reply-To: <CABtFm2VavXTA5zsPE7VQSqq+zJKBa=1Emb1vNShi45n1oNnv7g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Srinivasa Chamarthy <chamarthy.raju@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 04/27/2015 07:18 AM, Srinivasa Chamarthy wrote:
> I was just verifying if i could generate 100% duplicable data with
> FIO. I have configured small workload with bs of 256k and writing 2MB
> of file. I tried to get the checksum of each of 256k blocks of data
> from the file and the checksums do not match. If i am not wrong, when
> i specify data as 100% deduppable, my checksums should match isn't it?
>
> # cat ddp_file.fio
> [dedupe]
> filename=test.tmp
> bs=256k
> rw=write
> size=2m
> dedupe_percentage=100
> write_iolog=test.tmp.log
>
> # fio ddp_file.fio
> dedupe: (g=0): rw=write, bs=256K-256K/256K-256K/256K-256K,
> ioengine=sync, iodepth=1
> fio-2.2.7-24-g7c30
> Starting 1 process
> dedupe: Laying out IO file(s) (1 file(s) / 2MB)
>
> dedupe: (groupid=0, jobs=1): err= 0: pid=31497: Mon Apr 27 09:13:35 2015
>    write: io=2048.0KB, bw=2000.0MB/s, iops=8000, runt=     1msec
>      clat (usec): min=123, max=183, avg=150.50, stdev=22.35
>       lat (usec): min=125, max=184, avg=152.38, stdev=22.08
>      clat percentiles (usec):
>       |  1.00th=[  123],  5.00th=[  123], 10.00th=[  123], 20.00th=[  124],
>       | 30.00th=[  139], 40.00th=[  145], 50.00th=[  145], 60.00th=[  155],
>       | 70.00th=[  159], 80.00th=[  177], 90.00th=[  183], 95.00th=[  183],
>       | 99.00th=[  183], 99.50th=[  183], 99.90th=[  183], 99.95th=[  183],
>       | 99.99th=[  183]
>      lat (usec) : 250=100.00%
>    cpu          : usr=0.00%, sys=0.00%, ctx=1, majf=0, minf=28
>    IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
>       submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>       complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>       issued    : total=r=0/w=8/d=0, short=r=0/w=0/d=0, drop=r=0/w=0/d=0
>       latency   : target=0, window=0, percentile=100.00%, depth=1
>
> Run status group 0 (all jobs):
>    WRITE: io=2048KB, aggrb=2000.0MB/s, minb=2000.0MB/s,
> maxb=2000.0MB/s, mint=1msec, maxt=1msec
>
> Disk stats (read/write):
>    sda: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%
>
> # ls -lh test.tmp
> -rw-r--r-- 1 root root 2.0M Apr 27 09:13 test.tmp
>
> # cat test.tmp.log
> fio version 2 iolog
> test.tmp add
> test.tmp open
> test.tmp write 0 262144
> test.tmp write 262144 262144
> test.tmp write 524288 262144
> test.tmp write 786432 262144
> test.tmp write 1048576 262144
> test.tmp write 1310720 262144
> test.tmp write 1572864 262144
> test.tmp write 1835008 262144
> test.tmp close
>
> # for each in {0..7}; do dd if=test.tmp bs=262144 count=1 skip=$each
> 2>/dev/null | hexdump -C | md5sum; done
> 71a1660503bcff7c4e20a763d569d069  -
> 9c9bb7ec1020b4d4249028aecc896e6b  -
> 68b9685812d47c822532854201c9b352  -
> e5c8ef471a27ba92b86893ee5ded654b  -
> 14e0e798a8af3f4e6abdaf022ddf91c3  -
> 85528ae970bd25dde8c39ecaaffa4cf3  -
> 60b8ccf0e0793094b9356544fb541f3a  -
> ef736cc9cbf7588cb7b84467cb37c44e  -
>
> # fio -v
> fio-2.2.7-24-g7c30

Can you try with current -git? The corner cases of being 100% dedupable 
was broken.

-- 
Jens Axboe



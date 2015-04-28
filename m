Return-Path: <chamarthy.raju@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CABtFm2Uq2HvyKpc25nfcS2Le-g5YRVeTTiCpZe=_1qo_QtGmzA@mail.gmail.com>
References: <CABtFm2VavXTA5zsPE7VQSqq+zJKBa=1Emb1vNShi45n1oNnv7g@mail.gmail.com>
	<553E4A22.2040800@kernel.dk>
	<CABtFm2Uq2HvyKpc25nfcS2Le-g5YRVeTTiCpZe=_1qo_QtGmzA@mail.gmail.com>
Date: Tue, 28 Apr 2015 15:03:08 +0800
Message-ID: <CABtFm2UAdGTXx0V=DpaCzQnvLS+d8e2FEVh1E7c5TACPwuBHKw@mail.gmail.com>
Subject: Re: FIO - dedup checksums or specified blocksize does not match.
From: Srinivasa Chamarthy <chamarthy.raju@gmail.com>
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

There seems to be one more issue with dedup for data that is not 100%
dedupable. I tried with 50% and 80% and it give only 35 for 50 and 60
for 80.

# cat ddp_file.fio
[dedupe]
filename=test.tmp.comp
bs=256k
rw=write
size=10m
dedupe_percentage=80
write_iolog=test.tmp.log.comp

# fio ddp_file.fio
dedupe: (g=0): rw=write, bs=256K-256K/256K-256K/256K-256K,
ioengine=sync, iodepth=1
fio-2.2.7-26-g9451b
Starting 1 process
dedupe: Laying out IO file(s) (1 file(s) / 10MB)

dedupe: (groupid=0, jobs=1): err= 0: pid=13376: Tue Apr 28 02:54:02 2015
  write: io=10240KB, bw=731429KB/s, iops=2857, runt=    14msec
    clat (usec): min=170, max=374, avg=235.80, stdev=41.11
     lat (usec): min=173, max=378, avg=239.10, stdev=41.75
    clat percentiles (usec):
     |  1.00th=[  171],  5.00th=[  175], 10.00th=[  197], 20.00th=[  213],
     | 30.00th=[  217], 40.00th=[  221], 50.00th=[  231], 60.00th=[  235],
     | 70.00th=[  239], 80.00th=[  253], 90.00th=[  262], 95.00th=[  318],
     | 99.00th=[  374], 99.50th=[  374], 99.90th=[  374], 99.95th=[  374],
     | 99.99th=[  374]
    lat (usec) : 250=77.50%, 500=22.50%
  cpu          : usr=57.14%, sys=28.57%, ctx=1, majf=0, minf=27
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=0/w=40/d=0, short=r=0/w=0/d=0, drop=r=0/w=0/d=0
     latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
  WRITE: io=10240KB, aggrb=731428KB/s, minb=731428KB/s,
maxb=731428KB/s, mint=14msec, maxt=14msec

Disk stats (read/write):
  sda: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%

# fio/t/fio-dedupe -b 262144 test.tmp.comp
Will check <test.tmp.comp>, size <10485760>, using 8 threads
Threads(8): 40 items processed
Extents=40, Unique extents=15
De-dupe ratio: 1:1.67
Fio setting: dedupe_percentage=63

I also confirmed the same by taking checksum of the data file by
individual blocks of size bs.

# for each in {0..39}; do dd if=test.tmp.comp bs=262144 count=1
skip=$each 2>/dev/null | hexdump -C | md5sum; done | wc -l
40  <<< have 40 blocks as expected.

# for each in {0..39}; do dd if=test.tmp.comp bs=262144 count=1
skip=$each 2>/dev/null | hexdump -C | md5sum; done | sort | uniq | wc
-l
16 <<< returns 16 unique blocks

In a 80% dedupable size, i would expect around 8 unique blocks. Is that true.?
Also, from the fio/t/fio-dedupe output, it shows that there are only
15 unique extents. Checking manually returns 16.

Thanks,
Srinivasa Chamarthy
Srinivasa R Chamarthy


On Tue, Apr 28, 2015 at 1:15 PM, Srinivasa Chamarthy
<chamarthy.raju@gmail.com> wrote:
> Seems working now. Thanks for the great support.
>
> for each in {0..7}; do dd if=test.tmp.comp bs=262144 count=1
> skip=$each 2>/dev/null | hexdump -C | md5sum; done
> e1d3c034e3fc15481e5c8610333ad9cd  -
> e1d3c034e3fc15481e5c8610333ad9cd  -
> e1d3c034e3fc15481e5c8610333ad9cd  -
> e1d3c034e3fc15481e5c8610333ad9cd  -
> e1d3c034e3fc15481e5c8610333ad9cd  -
> e1d3c034e3fc15481e5c8610333ad9cd  -
> e1d3c034e3fc15481e5c8610333ad9cd  -
> e1d3c034e3fc15481e5c8610333ad9cd  -
> Srinivasa R Chamarthy
>
>
> On Mon, Apr 27, 2015 at 10:39 PM, Jens Axboe <axboe@kernel.dk> wrote:
>> On 04/27/2015 07:18 AM, Srinivasa Chamarthy wrote:
>>>
>>> I was just verifying if i could generate 100% duplicable data with
>>> FIO. I have configured small workload with bs of 256k and writing 2MB
>>> of file. I tried to get the checksum of each of 256k blocks of data
>>> from the file and the checksums do not match. If i am not wrong, when
>>> i specify data as 100% deduppable, my checksums should match isn't it?
>>>
>>> # cat ddp_file.fio
>>> [dedupe]
>>> filename=test.tmp
>>> bs=256k
>>> rw=write
>>> size=2m
>>> dedupe_percentage=100
>>> write_iolog=test.tmp.log
>>>
>>> # fio ddp_file.fio
>>> dedupe: (g=0): rw=write, bs=256K-256K/256K-256K/256K-256K,
>>> ioengine=sync, iodepth=1
>>> fio-2.2.7-24-g7c30
>>> Starting 1 process
>>> dedupe: Laying out IO file(s) (1 file(s) / 2MB)
>>>
>>> dedupe: (groupid=0, jobs=1): err= 0: pid=31497: Mon Apr 27 09:13:35 2015
>>>    write: io=2048.0KB, bw=2000.0MB/s, iops=8000, runt=     1msec
>>>      clat (usec): min=123, max=183, avg=150.50, stdev=22.35
>>>       lat (usec): min=125, max=184, avg=152.38, stdev=22.08
>>>      clat percentiles (usec):
>>>       |  1.00th=[  123],  5.00th=[  123], 10.00th=[  123], 20.00th=[
>>> 124],
>>>       | 30.00th=[  139], 40.00th=[  145], 50.00th=[  145], 60.00th=[
>>> 155],
>>>       | 70.00th=[  159], 80.00th=[  177], 90.00th=[  183], 95.00th=[
>>> 183],
>>>       | 99.00th=[  183], 99.50th=[  183], 99.90th=[  183], 99.95th=[
>>> 183],
>>>       | 99.99th=[  183]
>>>      lat (usec) : 250=100.00%
>>>    cpu          : usr=0.00%, sys=0.00%, ctx=1, majf=0, minf=28
>>>    IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%,
>>> >=64=0.0%
>>>       submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%,
>>> >=64=0.0%
>>>       complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%,
>>> >=64=0.0%
>>>       issued    : total=r=0/w=8/d=0, short=r=0/w=0/d=0, drop=r=0/w=0/d=0
>>>       latency   : target=0, window=0, percentile=100.00%, depth=1
>>>
>>> Run status group 0 (all jobs):
>>>    WRITE: io=2048KB, aggrb=2000.0MB/s, minb=2000.0MB/s,
>>> maxb=2000.0MB/s, mint=1msec, maxt=1msec
>>>
>>> Disk stats (read/write):
>>>    sda: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%
>>>
>>> # ls -lh test.tmp
>>> -rw-r--r-- 1 root root 2.0M Apr 27 09:13 test.tmp
>>>
>>> # cat test.tmp.log
>>> fio version 2 iolog
>>> test.tmp add
>>> test.tmp open
>>> test.tmp write 0 262144
>>> test.tmp write 262144 262144
>>> test.tmp write 524288 262144
>>> test.tmp write 786432 262144
>>> test.tmp write 1048576 262144
>>> test.tmp write 1310720 262144
>>> test.tmp write 1572864 262144
>>> test.tmp write 1835008 262144
>>> test.tmp close
>>>
>>> # for each in {0..7}; do dd if=test.tmp bs=262144 count=1 skip=$each
>>> 2>/dev/null | hexdump -C | md5sum; done
>>> 71a1660503bcff7c4e20a763d569d069  -
>>> 9c9bb7ec1020b4d4249028aecc896e6b  -
>>> 68b9685812d47c822532854201c9b352  -
>>> e5c8ef471a27ba92b86893ee5ded654b  -
>>> 14e0e798a8af3f4e6abdaf022ddf91c3  -
>>> 85528ae970bd25dde8c39ecaaffa4cf3  -
>>> 60b8ccf0e0793094b9356544fb541f3a  -
>>> ef736cc9cbf7588cb7b84467cb37c44e  -
>>>
>>> # fio -v
>>> fio-2.2.7-24-g7c30
>>
>>
>> Can you try with current -git? The corner cases of being 100% dedupable was
>> broken.
>>
>> --
>> Jens Axboe
>>


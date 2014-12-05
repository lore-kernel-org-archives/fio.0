Return-Path: <karthick@pernixdata.com>
MIME-Version: 1.0
In-Reply-To: <5480E314.4070206@kernel.dk>
References: <CAGmU4NRCBQkPHQzMwK4hVrQwUF0ngYKsbzOcXbJYucNHbndRRg@mail.gmail.com>
 <547FCA1C.1000808@kernel.dk> <547FCBC7.20309@kernel.dk> <547FCDC0.3000005@kernel.dk>
 <CAGmU4NSC=7ZjjnieWxjFs8xqrVjY0gdMGWwJCTRogXKpUzBbcA@mail.gmail.com>
 <54807D4F.9080207@kernel.dk> <5480E314.4070206@kernel.dk>
From: Karthick Srinivasachary <karthick@pernixdata.com>
Date: Thu, 4 Dec 2014 23:25:26 -0800
Message-ID: <CAGmU4NR8fnz4869-9hjgWR4Za429WRjJHnvJE+-CwO-BF8VX4A@mail.gmail.com>
Subject: Re: Repeat given pattern with buffer_compress_percentage
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Hi Jens,

Awesome.. Thanks for the fix..!
With compress_percentage 80 or more, fio verify is failing. I don't
think there any issue with storage in my test environment. Do you
think we have a bug here. Complete command and output below.

/usr/local/bin/fio --name=global --ioengine=libaio --bsrange=16k-64k
--rw=randrw --iodepth=16 --direct=1 --verify=md5 --name=job0
--size=100m --filename=/fio/fio.dat --rw=randrw --rate=20m
--buffer_compress_percentage=80 --refill_buffers --buffer_pattern=123
--verify_dump=1

job0: (g=0): rw=randrw, bs=16K-64K/16K-64K/16K-64K, ioengine=libaio, iodepth=16
fio-2.1.14
Starting 1 process
verify: bad magic header a498, wanted acca at file /fio/fio.dat offset
3751936, length 16384ps] [eta 00m:01s]
fio: pid=2310, err=84/file:io_u.c:1803, func=io_u_queued_complete,
error=Invalid or incomplete multibyte or wide character

job0: (groupid=0, jobs=1): err=84 (file:io_u.c:1803,
func=io_u_queued_complete, error=Invalid or incomplete multibyte or
wide character): pid=2310: Thu Dec  4 23:21:24 2014
  read : io=52768KB, bw=21485KB/s, iops=654, runt=  2456msec
    slat (usec): min=13, max=16556, avg=397.53, stdev=1965.21
    clat (usec): min=807, max=10720, avg=3090.70, stdev=1278.73
     lat (usec): min=822, max=18879, avg=3489.21, stdev=2323.61
    clat percentiles (usec):
     |  1.00th=[ 1272],  5.00th=[ 1624], 10.00th=[ 1784], 20.00th=[ 2064],
     | 30.00th=[ 2288], 40.00th=[ 2512], 50.00th=[ 2800], 60.00th=[ 3152],
     | 70.00th=[ 3536], 80.00th=[ 4048], 90.00th=[ 4704], 95.00th=[ 5344],
     | 99.00th=[ 7392], 99.50th=[ 8384], 99.90th=[ 9536], 99.95th=[10688],
     | 99.99th=[10688]
    bw (KB  /s): min=20336, max=20963, per=95.66%, avg=20552.75, stdev=282.50
  write: io=51920KB, bw=21270KB/s, iops=648, runt=  2441msec
    slat (usec): min=18, max=259, avg=31.17, stdev=16.34
    clat (usec): min=827, max=6207, avg=2740.55, stdev=998.80
     lat (usec): min=858, max=6243, avg=2772.83, stdev=998.17
    clat percentiles (usec):
     |  1.00th=[ 1144],  5.00th=[ 1432], 10.00th=[ 1608], 20.00th=[ 1864],
     | 30.00th=[ 2064], 40.00th=[ 2288], 50.00th=[ 2544], 60.00th=[ 2832],
     | 70.00th=[ 3216], 80.00th=[ 3664], 90.00th=[ 4192], 95.00th=[ 4576],
     | 99.00th=[ 5408], 99.50th=[ 5856], 99.90th=[ 6176], 99.95th=[ 6176],
     | 99.99th=[ 6176]
    bw (KB  /s): min=18843, max=22700, per=99.54%, avg=21170.50, stdev=1853.97
    lat (usec) : 1000=0.22%
    lat (msec) : 2=21.29%, 4=61.79%, 10=16.68%, 20=0.03%
  cpu          : usr=10.42%, sys=2.77%, ctx=792, majf=0, minf=120
  IO depths    : 1=1.3%, 2=2.5%, 4=5.0%, 8=10.0%, 16=81.2%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=99.9%, 8=0.0%, 16=0.1%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=1608/w=1582/d=0, short=r=0/w=0/d=0, drop=r=0/w=0/d=0
     latency   : target=0, window=0, percentile=100.00%, depth=16

Run status group 0 (all jobs):
   READ: io=52768KB, aggrb=21485KB/s, minb=21485KB/s, maxb=21485KB/s,
mint=2456msec, maxt=2456msec
  WRITE: io=51920KB, aggrb=21269KB/s, minb=21269KB/s, maxb=21269KB/s,
mint=2441msec, maxt=2441msec

Disk stats (read/write):
    dm-0: ios=1521/1553, merge=0/0, ticks=4392/3884, in_queue=8276,
util=26.68%, aggrios=1608/1588, aggrmerge=0/6, aggrticks=4640/3944,
aggrin_queue=8584, aggrutil=27.16%
  sda: ios=1608/1588, merge=0/6, ticks=4640/3944, in_queue=8584, util=27.16%

Regards,
Karthick

On Thu, Dec 4, 2014 at 2:41 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On 12/04/2014 08:27 AM, Jens Axboe wrote:
>>
>> On 12/04/2014 12:53 AM, Karthick Srinivasachary wrote:
>>>
>>> Hi Jens,
>>>
>>> Thanks for your response and quick fix.. Much appreciated.
>>> Tried few things and saw couple issues, summarizing below. Please let
>>> me know if I am missing something.
>>>
>>> 1. Looks like buffer_compress_percentage with verify option is not
>>> giving expected compression percentage
>>>
>>> fio --name=global --rw=write --buffer_compress_percentage=50
>>> --name=job1 --filename=/root/test1 --size=100m --refill_buffers
>>> --verify=md5
>>>
>>> lz4 could compress fio data file
>>>
>>> lz4 /root/test1
>>> Compressed 104857600 bytes into 104857715 bytes ==> 100.00%
>>
>>
>> The verify buffers are filled differently. It will take a bit more code
>> juggling to make that honor the buffer_pattern as a fill pattern. I'll
>> take a look at it.
>
>
> Try current -git, should do the right thing for this case now too. And it
> works for the buffer content regeneration, when corruption is detected and
> verify_dump=1 is set.
>
> --
> Jens Axboe
>


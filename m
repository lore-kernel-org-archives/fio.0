Return-Path: <axboe@kernel.dk>
Message-ID: <52FA992D.6050507@kernel.dk>
Date: Tue, 11 Feb 2014 14:42:05 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Fio 2.1.5 release upcoming
References: <20140206192135.GB3950@kernel.dk>	<CAF+0mvnBvLVqijP+Atbh9SEjt0p6-e3hy4Q3QRMtb+swp72bTQ@mail.gmail.com>	<20140209205744.GB2750@kernel.dk>	<CAF+0mvk+h3Hb5-KyQr7fqfmrUN6V4-HvKx4M0AYHC6mTUQu0+Q@mail.gmail.com>	<20140210221420.GD4096@kernel.dk>	<CAF+0mvmhEBaYSmLh99MST9MCg3rHan339rQkQb2Nw3fvStUfTg@mail.gmail.com>	<52F95D7B.1000002@kernel.dk>	<CAF+0mvkg4sD4r75G6+warH0UtMOzYWm29-=MVQx5MDGiRk3sPA@mail.gmail.com>	<20140211152721.GA19057@kernel.dk>	<CAF+0mvmRUiPo7ZQQTUnUimDzJJ-rO+rkuKmRcUwKcwtvaBQfLw@mail.gmail.com>	<52FA7A32.1090307@kernel.dk>	<CAF+0mvnGA9a3qMNcH06eOXg8B_rSqGCgDdOfCq1A1_uagZn_9g@mail.gmail.com>	<52FA9442.3090309@kernel.dk> <CAF+0mv=MifZvs6Nj72x0=ed5+cOKKsNJaLGn+PHEzhAAn6xWXQ@mail.gmail.com>
In-Reply-To: <CAF+0mv=MifZvs6Nj72x0=ed5+cOKKsNJaLGn+PHEzhAAn6xWXQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Matthew Eaton <m.eaton82@gmail.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 2014-02-11 14:38, Matthew Eaton wrote:
>> Try and delete the output files and re-run it.
>
> Ok, but got the same result.  Here is the output.
>
> matt@matt-work:~/fiogit/fio$ rm -r ~/temp/*
> matt@matt-work:~/fiogit/fio$ ls -l ~/temp
> total 0
> matt@matt-work:~/fiogit/fio$ ./fio ~/fio.job
> job: (g=0): rw=write, bs=1M-1M/1M-1M/1M-1M, ioengine=sync, iodepth=1
> fio-2.1.4-51-geb0c7
> Starting 1 process
> job: Laying out IO file(s) (50 file(s) / 1023MB)
> Jobs: 1 (f=10)
> job: (groupid=0, jobs=1): err= 0: pid=18777: Tue Feb 11 13:37:19 2014
>    write: io=1000.0MB, bw=562947KB/s, iops=549, runt=  1819msec
>      clat (usec): min=331, max=18299, avg=1790.14, stdev=3952.06
>       lat (usec): min=342, max=18310, avg=1804.84, stdev=3952.43
>      clat percentiles (usec):
>       |  1.00th=[  338],  5.00th=[  346], 10.00th=[  354], 20.00th=[  374],
>       | 30.00th=[  398], 40.00th=[  434], 50.00th=[  442], 60.00th=[  482],
>       | 70.00th=[  644], 80.00th=[  660], 90.00th=[ 9408], 95.00th=[13632],
>       | 99.00th=[16512], 99.50th=[17792], 99.90th=[18048], 99.95th=[18304],
>       | 99.99th=[18304]
>      bw (KB  /s): min=387072, max=1038307, per=100.00%, avg=606881.00,
> stdev=373648.33
>      lat (usec) : 500=61.20%, 750=28.70%
>      lat (msec) : 10=0.20%, 20=9.90%
>    cpu          : usr=2.20%, sys=25.91%, ctx=261, majf=0, minf=33
>    IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
>       submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>       complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>       issued    : total=r=0/w=1000/d=0, short=r=0/w=0/d=0
>       latency   : target=0, window=0, percentile=100.00%, depth=1
>
> Run status group 0 (all jobs):
>    WRITE: io=1000.0MB, aggrb=562946KB/s, minb=562946KB/s,
> maxb=562946KB/s, mint=1819msec, maxt=1819msec
>
> Disk stats (read/write):
>    sda: ios=0/1005, merge=0/0, ticks=0/191632, in_queue=207380, util=83.30%

Weird, this is what I get with your config file:

[...]
Run status group 0 (all jobs):
   WRITE: io=1023.9MB, aggrb=130026KB/s, minb=130026KB/s, 
maxb=130026KB/s, mint=8063msec, maxt=8063msec

and each file in temp/ is 21474836, which should give us 1023.99MB of IO.

-- 
Jens Axboe



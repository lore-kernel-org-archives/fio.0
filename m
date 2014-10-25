Return-Path: <mark.kirkwood@catalyst.net.nz>
Message-ID: <544B0C7F.4080109@catalyst.net.nz>
Date: Sat, 25 Oct 2014 15:35:43 +1300
From: Mark Kirkwood <mark.kirkwood@catalyst.net.nz>
MIME-Version: 1.0
Subject: Re: fio rbd hang for block sizes > 1M
References: <5449BBB3.7090109@catalyst.net.nz> <5449E50E.7000808@kernel.dk> <5449EEF1.1060407@catalyst.net.nz> <544A51C7.40803@gmail.com> <544A5DA6.2010709@gmail.com> <544AD67D.4030603@catalyst.net.nz> <544AEAE7.6080603@redhat.com> <544AF0D2.1050405@catalyst.net.nz>
In-Reply-To: <544AF0D2.1050405@catalyst.net.nz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Mark Nelson <mark.nelson@inktank.com>, Mark Nelson <mark.a.nelson@gmail.com>, Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
Cc: "d.gollub@telekom.de >> Daniel Gollub" <d.gollub@telekom.de>, "xan.peng" <xanpeng@gmail.com>, "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Patched client machine *only* - re-running fio from there works fine 
with (default - i.e no [client' section at all) cache settings:

$ fio read-test.fio
rbd_thread: (g=0): rw=read, bs=4M-4M/4M-4M/4M-4M, ioengine=rbd, iodepth=32
fio-2.1.13-88-gb2ee7
Starting 1 process
rbd engine: RBD version: 0.1.8
Jobs: 1 (f=1): [R(1)] [75.0% done] [1165MB/0KB/0KB /s] [291/0/0 iops] 
[eta 00m:0Jobs: 1 (f=1): [R(1)] [83.3% done] [447.4MB/0KB/0KB /s] 
[111/0/0 iops] [eta 00m:Jobs: 1 (f=1): [R(1)] [100.0% done] 
[268.0MB/0KB/0KB /s] [67/0/0 iops] [eta 00m:Jobs: 1 (f=1): [R(1)] 
[100.0% done] [336.1MB/0KB/0KB /s] [84/0/0 iops] [eta 00m:00s]
rbd_thread: (groupid=0, jobs=1): err= 0: pid=5980: Sat Oct 25 15:32:16 2014
   read : io=4096.0MB, bw=623410KB/s, iops=152, runt=  6728msec
     slat (usec): min=7, max=230691, avg=5664.46, stdev=14434.46
     clat (msec): min=11, max=1589, avg=193.03, stdev=246.84
      lat (msec): min=13, max=1606, avg=198.70, stdev=248.62
     clat percentiles (msec):
      |  1.00th=[   17],  5.00th=[   30], 10.00th=[   43], 20.00th=[   60],
      | 30.00th=[   78], 40.00th=[   93], 50.00th=[  109], 60.00th=[  124],
      | 70.00th=[  147], 80.00th=[  210], 90.00th=[  498], 95.00th=[  758],
      | 99.00th=[ 1237], 99.50th=[ 1467], 99.90th=[ 1565], 99.95th=[ 1598],
      | 99.99th=[ 1598]
     bw (KB  /s): min=178086, max=1193644, per=100.00%, avg=637349.58, 
stdev=397329.85
     lat (msec) : 20=2.15%, 50=12.11%, 100=30.08%, 250=38.09%, 500=7.62%
     lat (msec) : 750=4.79%, 1000=2.64%, 2000=2.54%
   cpu          : usr=1.69%, sys=0.28%, ctx=6234, majf=0, minf=78
   IO depths    : 1=0.1%, 2=0.2%, 4=0.4%, 8=1.7%, 16=58.6%, 32=39.1%, 
 >=64=0.0%
      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
 >=64=0.0%
      complete  : 0=0.0%, 4=94.3%, 8=5.0%, 16=0.4%, 32=0.3%, 64=0.0%, 
 >=64=0.0%
      issued    : total=r=1024/w=0/d=0, short=r=0/w=0/d=0, drop=r=0/w=0/d=0
      latency   : target=0, window=0, percentile=100.00%, depth=32

Run status group 0 (all jobs):
    READ: io=4096.0MB, aggrb=623410KB/s, minb=623410KB/s, 
maxb=623410KB/s, mint=6728msec, maxt=6728msec


On 25/10/14 13:37, Mark Kirkwood wrote:
> Righty, building now.
>
> On 25/10/14 13:12, Mark Nelson wrote:
>> Hi Mark,
>>
>> Try the latest giant branch.  I believe we've fixed this with 7272bb8.
>> My test cluster is passing read tests now.



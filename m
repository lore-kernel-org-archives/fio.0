Return-Path: <bart.vanassche@gmail.com>
MIME-Version: 1.0
Sender: bart.vanassche@gmail.com
In-Reply-To: <20100202074135.GX13771@kernel.dk>
References: <e2e108261002012338j62fd1983x7f4a0122d3fd97a4@mail.gmail.com>
	 <20100202074135.GX13771@kernel.dk>
Date: Tue, 2 Feb 2010 09:01:33 +0100
Message-ID: <e2e108261002020001sbbf4123p8c0f505858c505b5@mail.gmail.com>
Subject: Re: Writing to /dev/null with fio
From: Bart Van Assche <bvanassche@acm.org>
Content-Type: text/plain; charset=ISO-8859-1
To: Jens Axboe <jens.axboe@oracle.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On Tue, Feb 2, 2010 at 8:41 AM, Jens Axboe <jens.axboe@oracle.com> wrote:
> On Tue, Feb 02 2010, Bart Van Assche wrote:
>> I noticed that writing with fio to /dev/null takes much more time (220
>> times more for the test below) than with dd. Did I specify the correct
>> arguments to fio ? If so, is this known behavior of fio ?
>>
>> $ dd if=/dev/zero of=/dev/null bs=1M count=1024
>> 1024+0 records in
>> 1024+0 records out
>> 1073741824 bytes (1.1 GB) copied, 0.121485 s, 8.8 GB/s
>>
>> $ fio --bs=1M --size=1G --buffered=1 --rw=write --verify=0
>> --name=dev-null /dev/null
>
> You are writing to a file named dev-null and /dev/null is being ignored
> as an argument. You want a --filename=/dev/null at the end instead.

Sorry for this mistake.

The reason I started running such silly tests is because I noticed
that tests with dd and a small block size complete in a shorter time
than tests with fio for a fast storage device (e.g. remote RAM disk
accessed via SRP or iSER). Do the two tests below trigger similar
system calls ? The ratio of fio time / dd time is about 1.50 for block
size 512 and about 1.15 for block size 4096.

$ dd if=/dev/zero of=/dev/null bs=512 count=$((2**34/512))
33554432+0 records in
33554432+0 records out
17179869184 bytes (17 GB) copied, 22.1956 s, 774 MB/s

$ fio --bs=512 --size=$((2**34)) --buffered=1 --rw=write --verify=0
--name=dev-null --filename=/dev/null
dev-null: (g=0): rw=write, bs=512-512/512-512, ioengine=sync, iodepth=1
Starting 1 process
Jobs: 1 (f=1): [W] [100.0% done] [0K/496M /s] [0/992K iops] [eta 00m:00s]
dev-null: (groupid=0, jobs=1): err= 0: pid=15978
  write: io=16,384MB, bw=483MB/s, iops=989K, runt= 33931msec
    clat (usec): min=0, max=182, avg= 0.38, stdev= 0.50
    bw (KB/s) : min=408342, max=496691, per=100.00%, avg=494450.67,
stdev=10697.23
  cpu          : usr=62.81%, sys=37.15%, ctx=491, majf=0, minf=20
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued r/w: total=0/33554432, short=0/0
     lat (usec): 2=99.96%, 4=0.04%, 10=0.01%, 20=0.01%, 50=0.01%
     lat (usec): 100=0.01%, 250=0.01%

Run status group 0 (all jobs):
  WRITE: io=16,384MB, aggrb=483MB/s, minb=494MB/s, maxb=494MB/s,
mint=33931msec, maxt=33931msec

$ dd if=/dev/zero of=/dev/null bs=4096 count=$((2**34/4096))
4194304+0 records in
4194304+0 records out
17179869184 bytes (17 GB) copied, 3.72608 s, 4.6 GB/s

$ fio --bs=4096 --size=$((2**34)) --buffered=1 --rw=write --verify=0
--name=dev-null --filename=/dev/null
dev-null: (g=0): rw=write, bs=4K-4K/4K-4K, ioengine=sync, iodepth=1
Starting 1 process
Jobs: 1 (f=1): [W] [100.0% done] [0K/4,005M /s] [0/1M iops] [eta 00m:00s]
dev-null: (groupid=0, jobs=1): err= 0: pid=16600
  write: io=16,384MB, bw=3,809MB/s, iops=975K, runt=  4301msec
    clat (usec): min=0, max=644, avg= 0.39, stdev= 0.60
    bw (KB/s) : min=3146072, max=4002800, per=99.81%, avg=3893298.00,
stdev=301949.65
  cpu          : usr=61.86%, sys=38.09%, ctx=121, majf=0, minf=20
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued r/w: total=0/4194304, short=0/0
     lat (usec): 2=99.96%, 4=0.04%, 10=0.01%, 20=0.01%, 50=0.01%
     lat (usec): 100=0.01%, 250=0.01%, 750=0.01%

Run status group 0 (all jobs):
  WRITE: io=16,384MB, aggrb=3,809MB/s, minb=3,901MB/s, maxb=3,901MB/s,
mint=4301msec, maxt=4301msec

Bart.


Return-Path: <renyufei83@gmail.com>
MIME-Version: 1.0
From: Yufei Ren <renyufei83@gmail.com>
Date: Mon, 1 Aug 2011 12:56:42 -0600
Subject: Re: rdma ioengine
Message-ID: 
 <CAG5pYQd_y=jMDfir8AXj0bqXB4aVLn9MPE79AqNx1J+XY0Vh2g@mail.gmail.com>
Content-Language: en-US
Content-Type: multipart/mixed;
	boundary="_002_CAG5pYQdyjMDfir8AXj0bqXB4aVLn9MPE79AqNx1JXY0Vh2gmailgma_"
To: Jens Axboe <JAxboe@fusionio.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

--_002_CAG5pYQdyjMDfir8AXj0bqXB4aVLn9MPE79AqNx1JXY0Vh2gmailgma_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Thanks, Jens. That works. I did a little more code alignment for more
comfortable reading, and it's attached. (Yahoo mail replaced the
previous patch some white spaces :-)

Here is some sample test result. RDMA memory semantic is one side
operation which means the remote side doesn't know what's the
throughput without extra notification. Now, the client only send the
finish message to the server side after transfer completion, so the
server side statistics for memory semantic are empty.


Memory semantic: RDMA_WRITE

---
Client job file:
# Example rdma client job

[global]
ioengine=3Drdma
filename=3D192.168.2.4/18301/RDMA_WRITE
bs=3D1m
size=3D100g

[sender]
rw=3Dwrite
iodepth=3D1
iodepth_batch_complete=3D1


$ ./fio examples/rdmaio-client

sender: (g=3D0): rw=3Dwrite, bs=3D1M-1M/1M-1M, ioengine=3Drdma, iodepth=3D1
fio 1.57
Starting 1 process
Jobs: 1 (f=3D1): [W] [100.0% done] [0K/2984M /s] [0 /2914  iops] [eta 00m:0=
0s]
sender: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D16035
  write: io=3D102400MB, bw=3D3016.5MB/s, iops=3D3016 , runt=3D 33947msec
    slat (usec): min=3D0 , max=3D9 , avg=3D 0.65, stdev=3D 0.50
    clat (usec): min=3D313 , max=3D36473 , avg=3D328.97, stdev=3D533.22
     lat (usec): min=3D316 , max=3D36474 , avg=3D329.83, stdev=3D533.22
    bw (KB/s) : min=3D2693120, max=3D3190784, per=3D100.00%, avg=3D3088837.=
25,
stdev=3D122970.35
  cpu          : usr=3D1.41%, sys=3D0.38%, ctx=3D102435, majf=3D0, minf=3D1=
1
  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     issued r/w/d: total=3D0/102400/0, short=3D0/0/0
     lat (usec): 500=3D99.96%, 750=3D0.01%
     lat (msec): 4=3D0.01%, 10=3D0.01%, 20=3D0.01%, 50=3D0.03%

Run status group 0 (all jobs):
  WRITE: io=3D102400MB, aggrb=3D3016.5MB/s, minb=3D3088.9MB/s,
maxb=3D3088.9MB/s, mint=3D33947msec, maxt=3D33947msec


Server job file:# Example rdma server job

[global]
ioengine=3Drdma
filename=3D192.168.2.4/18301
bs=3D1m
size=3D100g

[receiver]
rw=3Dread
iodepth=3D16

$ ./fio examples/rdmaio-server
receiver: (g=3D0): rw=3Dread, bs=3D1M-1M/1M-1M, ioengine=3Drdma, iodepth=3D=
16
fio 1.57
Starting 1 process
Jobs: 1 (f=3D1): [R] [477.8% done] [0K/0K /s] [0 /0  iops] [eta
1158050441d:06h:59m:42s]
receiver: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D4852
  cpu          : usr=3D0.00%, sys=3D0.00%, ctx=3D0, majf=3D0, minf=3D0
  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=3D0=
.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=3D0=
.0%, >=3D64=3D0.0%
     issued r/w/d: total=3D1/0/0, short=3D0/0/0



Run status group 0 (all jobs):



Memory semantic: RDMA_READ

---
Client job file:

# Example rdma client job

[global]
ioengine=3Drdma
filename=3D192.168.2.4/18301/RDMA_READ
bs=3D1m
size=3D100g

[sender]
rw=3Dwrite
iodepth=3D1
iodepth_batch_complete=3D1


$ ./fio examples/rdmaio-client
sender: (g=3D0): rw=3Dwrite, bs=3D1M-1M/1M-1M, ioengine=3Drdma, iodepth=3D1
fio 1.57
Starting 1 process
Jobs: 1 (f=3D1): [W] [100.0% done] [0K/3049M /s] [0 /2977  iops] [eta 00m:0=
0s]
sender: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D28516
  write: io=3D102400MB, bw=3D2968.2MB/s, iops=3D2968 , runt=3D 34500msec
    slat (usec): min=3D0 , max=3D8 , avg=3D 0.68, stdev=3D 0.49
    clat (usec): min=3D314 , max=3D37021 , avg=3D334.32, stdev=3D123.70
     lat (usec): min=3D315 , max=3D37028 , avg=3D335.20, stdev=3D123.72
    bw (KB/s) : min=3D2738176, max=3D3049472, per=3D100.03%, avg=3D3040225.=
88,
stdev=3D38989.13
  cpu          : usr=3D1.15%, sys=3D0.43%, ctx=3D102437, majf=3D0, minf=3D1=
1
  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     issued r/w/d: total=3D0/102400/0, short=3D0/0/0
     lat (usec): 500=3D99.98%, 750=3D0.01%, 1000=3D0.01%
     lat (msec): 2=3D0.01%, 10=3D0.01%, 20=3D0.01%, 50=3D0.01%

Run status group 0 (all jobs):
  WRITE: io=3D102400MB, aggrb=3D2968.2MB/s, minb=3D3039.4MB/s,
maxb=3D3039.4MB/s, mint=3D34500msec, maxt=3D34500msec



Server job file is the same as RDMA_WRITE.
$ ./fio examples/rdmaio-server
receiver: (g=3D0): rw=3Dread, bs=3D1M-1M/1M-1M, ioengine=3Drdma, iodepth=3D=
16
fio 1.57
Starting 1 process
Jobs: 1 (f=3D1): [R] [683.3% done] [0K/0K /s] [0 /0  iops] [eta
1158050441d:06h:59m:41s]
receiver: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D6036
  cpu          : usr=3D0.00%, sys=3D0.00%, ctx=3D0, majf=3D0, minf=3D0
  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=3D0=
.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=3D0=
.0%, >=3D64=3D0.0%
     issued r/w/d: total=3D1/0/0, short=3D0/0/0



Run status group 0 (all jobs):



Channel Semantic: SEND/RECV

----

Client job file:

# Example rdma client job

[global]
ioengine=3Drdma
filename=3D192.168.2.4/18301/SEND
bs=3D1m
size=3D100g

[sender]
rw=3Dwrite
iodepth=3D1
iodepth_batch_complete=3D1
$ ./fio examples/rdmaio-client
sender: (g=3D0): rw=3Dwrite, bs=3D1M-1M/1M-1M, ioengine=3Drdma, iodepth=3D1
fio 1.57
Starting 1 process
Jobs: 1 (f=3D1): [W] [100.0% done] [0K/3099M /s] [0 /3025  iops] [eta 00m:0=
0s]
sender: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D29015
  write: io=3D102400MB, bw=3D2995.7MB/s, iops=3D2995 , runt=3D 34183msec
    slat (usec): min=3D0 , max=3D6 , avg=3D 0.54, stdev=3D 0.51
    clat (usec): min=3D313 , max=3D36231 , avg=3D331.38, stdev=3D573.03
     lat (usec): min=3D317 , max=3D36232 , avg=3D332.13, stdev=3D573.04
    bw (KB/s) : min=3D2536864, max=3D3178496, per=3D100.02%, avg=3D3068169.=
09,
stdev=3D146953.37
  cpu          : usr=3D1.40%, sys=3D0.46%, ctx=3D102446, majf=3D0, minf=3D1=
0
  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     issued r/w/d: total=3D0/102400/0, short=3D0/0/0
     lat (usec): 500=3D99.95%, 750=3D0.01%, 1000=3D0.01%
     lat (msec): 2=3D0.01%, 20=3D0.01%, 50=3D0.04%

Run status group 0 (all jobs):
  WRITE: io=3D102400MB, aggrb=3D2995.7MB/s, minb=3D3067.6MB/s,
maxb=3D3067.6MB/s, mint=3D34183msec, maxt=3D34183msec


Server job file is the same as RDMA_WRITE.
$ ./fio examples/rdmaio-server
receiver: (g=3D0): rw=3Dread, bs=3D1M-1M/1M-1M, ioengine=3Drdma, iodepth=3D=
16
fio 1.57
Starting 1 process
Jobs: 1 (f=3D1): [R] [100.0% done] [3012M/0K /s] [2941 /0  iops] [eta 00m:0=
0s]
receiver: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D6065
  read : io=3D102400MB, bw=3D2996.9MB/s, iops=3D2996 , runt=3D 34178msec
    slat (usec): min=3D0 , max=3D6 , avg=3D 0.42, stdev=3D 0.50
    clat (usec): min=3D346 , max=3D72370 , avg=3D5337.87, stdev=3D2383.69
     lat (usec): min=3D354 , max=3D72370 , avg=3D5338.50, stdev=3D2383.69
    bw (KB/s) : min=3D2534552, max=3D3178496, per=3D100.02%, avg=3D3068616.=
97,
stdev=3D146695.33
  cpu          : usr=3D0.99%, sys=3D0.39%, ctx=3D102428, majf=3D0, minf=3D1=
1
  IO depths    : 1=3D0.1%, 2=3D0.1%, 4=3D0.1%, 8=3D0.1%, 16=3D100.0%, 32=3D=
0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.1%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     issued r/w/d: total=3D102400/0/0, short=3D0/0/0
     lat (usec): 500=3D0.01%, 750=3D0.01%
     lat (msec): 2=3D0.01%, 4=3D0.01%, 10=3D99.36%, 50=3D0.61%, 100=3D0.02%

Run status group 0 (all jobs):
   READ: io=3D102400MB, aggrb=3D2996.9MB/s, minb=3D3067.2MB/s,
maxb=3D3067.2MB/s, mint=3D34178msec, maxt=3D34178msec


Yufei
..

----- Original Message -----
From: Jens Axboe <jaxboe@fusionio.com>
To: ren yufei <renyufei83@yahoo.com.cn>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
Sent: Monday, August 1, 2011 4:03 AM
Subject: Re: rdma ioengine

On 2011-08-01 09:35, Jens Axboe wrote:
> On 2011-08-01 03:47, ren yufei wrote:
>> Hi Jens,
>>
>> I have hacked an rdma ioengine based on OFED for fio which could test bo=
th rdma memory semantic (rdma_write/rdma_read) and channel semantic (send/r=
ecv). Would you like to merge this engine into fio?
>>
>> notes
>> 1) RDMA engine works in IB, iWarp and RoCE.
>> 2) RDMA engine is disable by default. To enable it, execute the followin=
g before compile:
>> $ export EXTFLAGS=3D"-DFIO_HAVE_RDMA"
>> $ export EXTLIBS=3D"-libverbs -lrdmacm"
>
> Exciting! I'd love to apply this, but somewhere along the way the patch
> has been white space damaged. Can you resend this patch gzip'ed or
> something like that, to ensure that it doesn't get modified along the
> way? Bonus points if you re-indent, fio uses real tabs and not 4 spaces.
> Not a huge problem, I'll just lindent it as-is if need be.
>
> It'd be great to have a small job file included as well for testing, and
> an example of a result using that job file.

And you already did include example job files, excellent. I applied your
patch, the mangling wasn't too bad. I also re-indented it with indent,
so it conforms to the fio coding style. Please double check the result!
Thanks.

--=20
Jens Axboe

--_002_CAG5pYQdyjMDfir8AXj0bqXB4aVLn9MPE79AqNx1JXY0Vh2gmailgma_
Content-Type: application/x-gzip; name="rdma-indent.patch.tar.gz"
Content-Description: rdma-indent.patch.tar.gz
Content-Disposition: attachment; filename="rdma-indent.patch.tar.gz";
	size=1607; creation-date="Mon, 01 Aug 2011 12:57:04 GMT";
	modification-date="Mon, 01 Aug 2011 12:57:04 GMT"
Content-Transfer-Encoding: base64

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
ACgAAA==

--_002_CAG5pYQdyjMDfir8AXj0bqXB4aVLn9MPE79AqNx1JXY0Vh2gmailgma_--



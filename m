Return-Path: <renyufei83@yahoo.com.cn>
MIME-Version: 1.0
From: ren yufei <renyufei83@yahoo.com.cn>
Date: Mon, 1 Aug 2011 11:02:38 -0600
Subject: Re: rdma ioengine
Message-ID: <1312218158.31979.YahooMailNeo@web15804.mail.cnb.yahoo.com>
References: <1312163269.12654.YahooMailNeo@web15806.mail.cnb.yahoo.com>
 <4E365754.7030603@fusionio.com> <4E365DC9.8040301@fusionio.com>
In-Reply-To: <4E365DC9.8040301@fusionio.com>
Reply-To: ren yufei <renyufei83@yahoo.com.cn>
Content-Language: en-US
Content-Type: multipart/mixed;
	boundary="_002_131221815831979YahooMailNeoweb15804mailcnbyahoocom_"
To: Jens Axboe <JAxboe@fusionio.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

--_002_131221815831979YahooMailNeoweb15804mailcnbyahoocom_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Thanks, Jens. That works. I did a little more code alignment for more comfo=
rtable reading, and it's attached. (Yahoo mail replaced the previous patch =
some white spaces --_--).=0A=
=0A=
RDMA memory semantic is one side operation which means the remote side does=
n't know what's the throughput without extra notification. Now, the client =
only send the finish message to the server side after transfer completion, =
and the statistics of the server side for memory semantic are empty.=0A=
=0A=
=0A=
Here is some sample test result.=0A=
=0A=
Memory semantic: RDMA_WRITE=0A=
=0A=
---=0A=
Client job file:=0A=
# Example rdma client job=0A=
=0A=
[global]=0A=
ioengine=3Drdma=0A=
filename=3D192.168.2.4/18301/RDMA_WRITE=0A=
bs=3D1m=0A=
size=3D100g=0A=
=0A=
[sender]=0A=
rw=3Dwrite=0A=
iodepth=3D1=0A=
iodepth_batch_complete=3D1=0A=
=0A=
=0A=
$ ./fio examples/rdmaio-client=0A=
=0A=
sender: (g=3D0): rw=3Dwrite, bs=3D1M-1M/1M-1M, ioengine=3Drdma, iodepth=3D1=
=0A=
fio 1.57=0A=
Starting 1 process=0A=
Jobs: 1 (f=3D1): [W] [100.0% done] [0K/2984M /s] [0 /2914=A0 iops] [eta 00m=
:00s]=0A=
sender: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D16035=0A=
=A0 write: io=3D102400MB, bw=3D3016.5MB/s, iops=3D3016 , runt=3D 33947msec=
=0A=
=A0=A0=A0 slat (usec): min=3D0 , max=3D9 , avg=3D 0.65, stdev=3D 0.50=0A=
=A0=A0=A0 clat (usec): min=3D313 , max=3D36473 , avg=3D328.97, stdev=3D533.=
22=0A=
=A0=A0=A0=A0 lat (usec): min=3D316 , max=3D36474 , avg=3D329.83, stdev=3D53=
3.22=0A=
=A0=A0=A0 bw (KB/s) : min=3D2693120, max=3D3190784, per=3D100.00%, avg=3D30=
88837.25, stdev=3D122970.35=0A=
=A0 cpu=A0=A0=A0=A0=A0=A0=A0=A0=A0 : usr=3D1.41%, sys=3D0.38%, ctx=3D102435=
, majf=3D0, minf=3D11=0A=
=A0 IO depths=A0=A0=A0 : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0=
%, 32=3D0.0%, >=3D64=3D0.0%=0A=
=A0=A0=A0=A0 submit=A0=A0=A0 : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 3=
2=3D0.0%, 64=3D0.0%, >=3D64=3D0.0%=0A=
=A0=A0=A0=A0 complete=A0 : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%, 64=3D0.0%, >=3D64=3D0.0%=0A=
=A0=A0=A0=A0 issued r/w/d: total=3D0/102400/0, short=3D0/0/0=0A=
=A0=A0=A0=A0 lat (usec): 500=3D99.96%, 750=3D0.01%=0A=
=A0=A0=A0=A0 lat (msec): 4=3D0.01%, 10=3D0.01%, 20=3D0.01%, 50=3D0.03%=0A=
=0A=
Run status group 0 (all jobs):=0A=
=A0 WRITE: io=3D102400MB, aggrb=3D3016.5MB/s, minb=3D3088.9MB/s, maxb=3D308=
8.9MB/s, mint=3D33947msec, maxt=3D33947msec=0A=
=0A=
=0A=
Server job file:# Example rdma server job=0A=
=0A=
[global]=0A=
ioengine=3Drdma=0A=
filename=3D192.168.2.4/18301=0A=
bs=3D1m=0A=
size=3D100g=0A=
=0A=
[receiver]=0A=
rw=3Dread=0A=
iodepth=3D16=0A=
=0A=
$ ./fio examples/rdmaio-server=0A=
receiver: (g=3D0): rw=3Dread, bs=3D1M-1M/1M-1M, ioengine=3Drdma, iodepth=3D=
16=0A=
fio 1.57=0A=
Starting 1 process=0A=
Jobs: 1 (f=3D1): [R] [477.8% done] [0K/0K /s] [0 /0=A0 iops] [eta 115805044=
1d:06h:59m:42s]=0A=
receiver: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D4852=0A=
=A0 cpu=A0=A0=A0=A0=A0=A0=A0=A0=A0 : usr=3D0.00%, sys=3D0.00%, ctx=3D0, maj=
f=3D0, minf=3D0=0A=
=A0 IO depths=A0=A0=A0 : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0=
%, 32=3D0.0%, >=3D64=3D0.0%=0A=
=A0=A0=A0=A0 submit=A0=A0=A0 : 0=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=
=3D0.0%, 64=3D0.0%, >=3D64=3D0.0%=0A=
=A0=A0=A0=A0 complete=A0 : 0=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.=
0%, 64=3D0.0%, >=3D64=3D0.0%=0A=
=A0=A0=A0=A0 issued r/w/d: total=3D1/0/0, short=3D0/0/0=0A=
=0A=
=0A=
=0A=
Run status group 0 (all jobs):=0A=
=0A=
=0A=
=0A=
Memory semantic: RDMA_READ=0A=
=0A=
---=0A=
Client job file:=0A=
=0A=
# Example rdma client job=0A=
=0A=
[global]=0A=
ioengine=3Drdma=0A=
filename=3D192.168.2.4/18301/RDMA_READ=0A=
bs=3D1m=0A=
size=3D100g=0A=
=0A=
[sender]=0A=
rw=3Dwrite=0A=
iodepth=3D1=0A=
iodepth_batch_complete=3D1=0A=
=0A=
=0A=
$ ./fio examples/rdmaio-client=0A=
sender: (g=3D0): rw=3Dwrite, bs=3D1M-1M/1M-1M, ioengine=3Drdma, iodepth=3D1=
=0A=
fio 1.57=0A=
Starting 1 process=0A=
Jobs: 1 (f=3D1): [W] [100.0% done] [0K/3049M /s] [0 /2977=A0 iops] [eta 00m=
:00s]=0A=
sender: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D28516=0A=
=A0 write: io=3D102400MB, bw=3D2968.2MB/s, iops=3D2968 , runt=3D 34500msec=
=0A=
=A0=A0=A0 slat (usec): min=3D0 , max=3D8 , avg=3D 0.68, stdev=3D 0.49=0A=
=A0=A0=A0 clat (usec): min=3D314 , max=3D37021 , avg=3D334.32, stdev=3D123.=
70=0A=
=A0=A0=A0=A0 lat (usec): min=3D315 , max=3D37028 , avg=3D335.20, stdev=3D12=
3.72=0A=
=A0=A0=A0 bw (KB/s) : min=3D2738176, max=3D3049472, per=3D100.03%, avg=3D30=
40225.88, stdev=3D38989.13=0A=
=A0 cpu=A0=A0=A0=A0=A0=A0=A0=A0=A0 : usr=3D1.15%, sys=3D0.43%, ctx=3D102437=
, majf=3D0, minf=3D11=0A=
=A0 IO depths=A0=A0=A0 : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0=
%, 32=3D0.0%, >=3D64=3D0.0%=0A=
=A0=A0=A0=A0 submit=A0=A0=A0 : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 3=
2=3D0.0%, 64=3D0.0%, >=3D64=3D0.0%=0A=
=A0=A0=A0=A0 complete=A0 : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%, 64=3D0.0%, >=3D64=3D0.0%=0A=
=A0=A0=A0=A0 issued r/w/d: total=3D0/102400/0, short=3D0/0/0=0A=
=A0=A0=A0=A0 lat (usec): 500=3D99.98%, 750=3D0.01%, 1000=3D0.01%=0A=
=A0=A0=A0=A0 lat (msec): 2=3D0.01%, 10=3D0.01%, 20=3D0.01%, 50=3D0.01%=0A=
=0A=
Run status group 0 (all jobs):=0A=
=A0 WRITE: io=3D102400MB, aggrb=3D2968.2MB/s, minb=3D3039.4MB/s, maxb=3D303=
9.4MB/s, mint=3D34500msec, maxt=3D34500msec=0A=
=0A=
=0A=
=0A=
Server job file is the same as RDMA_WRITE.=0A=
$ ./fio examples/rdmaio-server=0A=
receiver: (g=3D0): rw=3Dread, bs=3D1M-1M/1M-1M, ioengine=3Drdma, iodepth=3D=
16=0A=
fio 1.57=0A=
Starting 1 process=0A=
Jobs: 1 (f=3D1): [R] [683.3% done] [0K/0K /s] [0 /0=A0 iops] [eta 115805044=
1d:06h:59m:41s]=0A=
receiver: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D6036=0A=
=A0 cpu=A0=A0=A0=A0=A0=A0=A0=A0=A0 : usr=3D0.00%, sys=3D0.00%, ctx=3D0, maj=
f=3D0, minf=3D0=0A=
=A0 IO depths=A0=A0=A0 : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0=
%, 32=3D0.0%, >=3D64=3D0.0%=0A=
=A0=A0=A0=A0 submit=A0=A0=A0 : 0=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=
=3D0.0%, 64=3D0.0%, >=3D64=3D0.0%=0A=
=A0=A0=A0=A0 complete=A0 : 0=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.=
0%, 64=3D0.0%, >=3D64=3D0.0%=0A=
=A0=A0=A0=A0 issued r/w/d: total=3D1/0/0, short=3D0/0/0=0A=
=0A=
=0A=
=0A=
Run status group 0 (all jobs):=0A=
=0A=
=0A=
=0A=
Channel Semantic: SEND/RECV=0A=
=0A=
----=0A=
=0A=
Client job file:=0A=
=0A=
# Example rdma client job=0A=
=0A=
[global]=0A=
ioengine=3Drdma=0A=
filename=3D192.168.2.4/18301/SEND=0A=
bs=3D1m=0A=
size=3D100g=0A=
=0A=
[sender]=0A=
rw=3Dwrite=0A=
iodepth=3D1=0A=
iodepth_batch_complete=3D1=0A=
$ ./fio examples/rdmaio-client=0A=
sender: (g=3D0): rw=3Dwrite, bs=3D1M-1M/1M-1M, ioengine=3Drdma, iodepth=3D1=
=0A=
fio 1.57=0A=
Starting 1 process=0A=
Jobs: 1 (f=3D1): [W] [100.0% done] [0K/3099M /s] [0 /3025=A0 iops] [eta 00m=
:00s]=0A=
sender: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D29015=0A=
=A0 write: io=3D102400MB, bw=3D2995.7MB/s, iops=3D2995 , runt=3D 34183msec=
=0A=
=A0=A0=A0 slat (usec): min=3D0 , max=3D6 , avg=3D 0.54, stdev=3D 0.51=0A=
=A0=A0=A0 clat (usec): min=3D313 , max=3D36231 , avg=3D331.38, stdev=3D573.=
03=0A=
=A0=A0=A0=A0 lat (usec): min=3D317 , max=3D36232 , avg=3D332.13, stdev=3D57=
3.04=0A=
=A0=A0=A0 bw (KB/s) : min=3D2536864, max=3D3178496, per=3D100.02%, avg=3D30=
68169.09, stdev=3D146953.37=0A=
=A0 cpu=A0=A0=A0=A0=A0=A0=A0=A0=A0 : usr=3D1.40%, sys=3D0.46%, ctx=3D102446=
, majf=3D0, minf=3D10=0A=
=A0 IO depths=A0=A0=A0 : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0=
%, 32=3D0.0%, >=3D64=3D0.0%=0A=
=A0=A0=A0=A0 submit=A0=A0=A0 : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 3=
2=3D0.0%, 64=3D0.0%, >=3D64=3D0.0%=0A=
=A0=A0=A0=A0 complete=A0 : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%, 64=3D0.0%, >=3D64=3D0.0%=0A=
=A0=A0=A0=A0 issued r/w/d: total=3D0/102400/0, short=3D0/0/0=0A=
=A0=A0=A0=A0 lat (usec): 500=3D99.95%, 750=3D0.01%, 1000=3D0.01%=0A=
=A0=A0=A0=A0 lat (msec): 2=3D0.01%, 20=3D0.01%, 50=3D0.04%=0A=
=0A=
Run status group 0 (all jobs):=0A=
=A0 WRITE: io=3D102400MB, aggrb=3D2995.7MB/s, minb=3D3067.6MB/s, maxb=3D306=
7.6MB/s, mint=3D34183msec, maxt=3D34183msec=0A=
=0A=
=0A=
Server job file is the same as RDMA_WRITE.$ ./fio examples/rdmaio-server=0A=
receiver: (g=3D0): rw=3Dread, bs=3D1M-1M/1M-1M, ioengine=3Drdma, iodepth=3D=
16=0A=
fio 1.57=0A=
Starting 1 process=0A=
Jobs: 1 (f=3D1): [R] [100.0% done] [3012M/0K /s] [2941 /0=A0 iops] [eta 00m=
:00s]=0A=
receiver: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D6065=0A=
=A0 read : io=3D102400MB, bw=3D2996.9MB/s, iops=3D2996 , runt=3D 34178msec=
=0A=
=A0=A0=A0 slat (usec): min=3D0 , max=3D6 , avg=3D 0.42, stdev=3D 0.50=0A=
=A0=A0=A0 clat (usec): min=3D346 , max=3D72370 , avg=3D5337.87, stdev=3D238=
3.69=0A=
=A0=A0=A0=A0 lat (usec): min=3D354 , max=3D72370 , avg=3D5338.50, stdev=3D2=
383.69=0A=
=A0=A0=A0 bw (KB/s) : min=3D2534552, max=3D3178496, per=3D100.02%, avg=3D30=
68616.97, stdev=3D146695.33=0A=
=A0 cpu=A0=A0=A0=A0=A0=A0=A0=A0=A0 : usr=3D0.99%, sys=3D0.39%, ctx=3D102428=
, majf=3D0, minf=3D11=0A=
=A0 IO depths=A0=A0=A0 : 1=3D0.1%, 2=3D0.1%, 4=3D0.1%, 8=3D0.1%, 16=3D100.0=
%, 32=3D0.0%, >=3D64=3D0.0%=0A=
=A0=A0=A0=A0 submit=A0=A0=A0 : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 3=
2=3D0.0%, 64=3D0.0%, >=3D64=3D0.0%=0A=
=A0=A0=A0=A0 complete=A0 : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.1%, 32=3D=
0.0%, 64=3D0.0%, >=3D64=3D0.0%=0A=
=A0=A0=A0=A0 issued r/w/d: total=3D102400/0/0, short=3D0/0/0=0A=
=A0=A0=A0=A0 lat (usec): 500=3D0.01%, 750=3D0.01%=0A=
=A0=A0=A0=A0 lat (msec): 2=3D0.01%, 4=3D0.01%, 10=3D99.36%, 50=3D0.61%, 100=
=3D0.02%=0A=
=0A=
Run status group 0 (all jobs):=0A=
=A0=A0 READ: io=3D102400MB, aggrb=3D2996.9MB/s, minb=3D3067.2MB/s, maxb=3D3=
067.2MB/s, mint=3D34178msec, maxt=3D34178msec=0A=
=0A=
=0A=
Yufei=0A=
.=0A=
=0A=
----- Original Message -----=0A=
From: Jens Axboe <jaxboe@fusionio.com>=0A=
To: ren yufei <renyufei83@yahoo.com.cn>=0A=
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>=0A=
Sent: Monday, August 1, 2011 4:03 AM=0A=
Subject: Re: rdma ioengine=0A=
=0A=
On 2011-08-01 09:35, Jens Axboe wrote:=0A=
> On 2011-08-01 03:47, ren yufei wrote:=0A=
>> Hi Jens,=0A=
>>=0A=
>> I have hacked an rdma ioengine based on OFED for fio which could test bo=
th rdma memory semantic (rdma_write/rdma_read) and channel semantic (send/r=
ecv). Would you like to merge this engine into fio?=0A=
>>=0A=
>> notes=0A=
>> 1) RDMA engine works in IB, iWarp and RoCE.=0A=
>> 2) RDMA engine is disable by default. To enable it, execute the followin=
g before compile:=0A=
>> $ export EXTFLAGS=3D"-DFIO_HAVE_RDMA"=0A=
>> $ export EXTLIBS=3D"-libverbs -lrdmacm"=0A=
> =0A=
> Exciting! I'd love to apply this, but somewhere along the way the patch=
=0A=
> has been white space damaged. Can you resend this patch gzip'ed or=0A=
> something like that, to ensure that it doesn't get modified along the=0A=
> way? Bonus points if you re-indent, fio uses real tabs and not 4 spaces.=
=0A=
> Not a huge problem, I'll just lindent it as-is if need be.=0A=
> =0A=
> It'd be great to have a small job file included as well for testing, and=
=0A=
> an example of a result using that job file.=0A=
=0A=
And you already did include example job files, excellent. I applied your=0A=
patch, the mangling wasn't too bad. I also re-indented it with indent,=0A=
so it conforms to the fio coding style. Please double check the result!=0A=
Thanks.=0A=
=0A=
-- =0A=
Jens Axboe=

--_002_131221815831979YahooMailNeoweb15804mailcnbyahoocom_
Content-Type: application/x-gzip; name="rdma-indent.patch.tar.gz"
Content-Description: rdma-indent.patch.tar.gz
Content-Disposition: attachment; filename="rdma-indent.patch.tar.gz";
	size=1607; creation-date="Mon, 01 Aug 2011 11:02:42 GMT";
	modification-date="Mon, 01 Aug 2011 11:02:42 GMT"
Content-Transfer-Encoding: base64

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
ACgAAA==

--_002_131221815831979YahooMailNeoweb15804mailcnbyahoocom_--



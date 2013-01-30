Return-Path: <Antonio.Jose.Rodrigues.Neto@netapp.com>
From: "Neto, Antonio Jose Rodrigues" <Antonio.Jose.Rodrigues.Neto@netapp.com>
Subject: Re: Group reporting with latency and IOPS
Date: Wed, 30 Jan 2013 03:54:31 +0000
Message-ID: <843E15216120C047928F6879B0E2D9240F6D496C@SACEXCMBX02-PRD.hq.netapp.com>
In-Reply-To: <20130129203239.GJ8800@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <20F17A64B38E9C4381F7A311A9E8840B@tahoe.netapp.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 1/29/13 3:32 PM, "Jens Axboe" <axboe@kernel.dk> wrote:

>On Tue, Jan 29 2013, Neto, Antonio Jose Rodrigues wrote:
>> Jens, sorry to bother you again, but I am trying to apply the I've got
>>this=3D
>>  error. Could you please help me how to fix it?
>
>I forgot to push a previous change out. Pull again and try applying,
>should apply without fuzz.
>
>--=20
>Jens Axboe
>

Hi Jens,

This is neto from Brazil

How are you?

I applied the patch and everything is working. Here is one example:

Thank you very much

neto

-- Output file

workload: (groupid=3D0, jobs=3D20): err=3D 0: pid=3D2348: Tue Jan 29 22:51:=
43 2013
  mixed: io=3D879352KB, bw=3D168902KB/s, iops=3D21112 , runt=3D 30039msec
    slat (usec): min=3D3 , max=3D2296 , avg=3D 6.81, stdev=3D 4.62
    clat (usec): min=3D138 , max=3D248843 , avg=3D3619.87, stdev=3D7906.03
     lat (usec): min=3D145 , max=3D248863 , avg=3D3626.68, stdev=3D7905.91
    clat percentiles (usec):
     |  1.00th=3D[  350],  5.00th=3D[  454], 10.00th=3D[  516], 20.00th=3D[=
  724],
     | 30.00th=3D[  780], 40.00th=3D[  820], 50.00th=3D[  868], 60.00th=3D[=
  924],
     | 70.00th=3D[ 1048], 80.00th=3D[ 3760], 90.00th=3D[11584], 95.00th=3D[=
18304],
     | 99.00th=3D[39680], 99.50th=3D[50432], 99.90th=3D[76288], 99.95th=3D[=
90624],
     | 99.99th=3D[123392]
    bw (KB/s)  : min=3D  864, max=3D 9088, per=3D2.43%, avg=3D4100.05,
stdev=3D2630.65
    lat (usec) : 250=3D0.56%, 500=3D7.90%, 750=3D14.84%, 1000=3D44.16%
    lat (msec) : 2=3D9.40%, 4=3D3.46%, 10=3D7.59%, 20=3D7.80%, 50=3D3.77%
    lat (msec) : 100=3D0.48%, 250=3D0.03%
  cpu          : usr=3D0.00%, sys=3D0.00%, ctx=3D0, majf=3D0, minf=3D0
  IO depths    : 1=3D0.1%, 2=3D0.1%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%,
>=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%,
>=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%,
>=3D64=3D0.0%
     issued    : total=3Dr=3D634207/w=3D0/d=3D0, short=3Dr=3D0/w=3D0/d=3D0

Run status group 0 (all jobs):
  MIXED: io=3D4954.8MB, aggrb=3D168902KB/s, minb=3D168902KB/s, maxb=3D16890=
2KB/s,
mint=3D3
0039msec, maxt=3D30039msec




-- Config File

[workload]
bs=3D8k
ioengine=3Dwindowsaio
iodepth=3D4
size=3D1024g
numjobs=3D20
direct=3D1
runtime=3D30
filename=3D\\.\PhysicalDrive1
filename=3D\\.\PhysicalDrive2
filename=3D\\.\PhysicalDrive3
filename=3D\\.\PhysicalDrive4
filename=3D\\.\PhysicalDrive5
filename=3D\\.\PhysicalDrive6
filename=3D\\.\PhysicalDrive7
filename=3D\\.\PhysicalDrive8
rw=3Drandrw
rwmixread=3D80
rwmixwrite=3D20
thread
unified_rw_reporting=3D1
group_reporting=3D1
randrepeat=3D0



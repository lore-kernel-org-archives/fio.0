Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-io1-f44.google.com ([209.85.166.44]:33023 "EHLO
        mail-io1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727302AbeIPDet (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 15 Sep 2018 23:34:49 -0400
Received: by mail-io1-f44.google.com with SMTP id r196-v6so8747361iod.0
        for <fio@vger.kernel.org>; Sat, 15 Sep 2018 15:14:16 -0700 (PDT)
MIME-Version: 1.0
From: smitha sunder <sundersmitha@gmail.com>
Date: Sat, 15 Sep 2018 15:14:04 -0700
Message-ID: <CA+zhgFRR_SMf=CEhU8imgM+F_3hmGJV9+h_yU6qR9yQG6br48w@mail.gmail.com>
Subject: No I/O performed by windowsaio/get_io_u: zero buflen
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello all,

I have a 30TB drive and I am running into an issue with random writes.
I went through this thread :
https://www.spinics.net/lists/fio/msg06294.html that seems to be fixed
already.
I see the same issue with random reads as well.
So not sure what is the issue here in my case; any help is greatly apprecia=
ted.


Read Capacity results:
   Protection: prot_en=3D1, p_type=3D1, p_i_exponent=3D0 [type 2 protection=
]
   Logical block provisioning: lbpme=3D1, lbprz=3D1
   Last logical block address=3D58781073407 (0xdaf9fffff), Number of
logical blocks=3D58781073408
   Logical block length=3D512 bytes
   Logical blocks per physical block exponent=3D3 [so physical block
length=3D4096 bytes]
   Lowest aligned logical block address=3D0
Hence:
   Device size: 30095909584896 bytes, 2.87017e+007 MiB, 30095.9 GB


C:\Program Files (x86)\fio>fio --ioengine=3Dwindowsaio --group_reporting
--direct=3D1 --size=3D100% --bs=3D4K --thread --filename=3D\\.\PhysicalDriv=
e1
--name=3Dprecond --rw=3Drandwrite --iodepth=3D1 --numjobs=3D1
--debug=3Dio,random
fio: set debug option io
fio: set debug option random
precond: (g=3D0): rw=3Drandwrite, bs=3D(R) 4096B-4096B, (W) 4096B-4096B, (T=
)
4096B-4096B, ioengine=3Dwindowsaio, iodepth=3D1
fio-3.6
Starting 1 thread
fio: file \\.\PhysicalDrive1 exceeds 32-bit tausworthe random generator.
fio: Switching to tausworthe64. Use the random_generator=3D option to
get rid of this warning.
io       3372  drop page cache \\.\PhysicalDrive1
random   3372  off rand 259043585
io       3372  fill: io_u 0A458780:
off=3D0x1a6a158f000,len=3D0x1000,ddir=3D1,file=3D\\.\PhysicalDrive1
io       3372  prep: io_u 0A458780:
off=3D0x1a6a158f000,len=3D0x1000,ddir=3D1,file=3D\\.\PhysicalDrive1
io       3372  queue: io_u 0A458780:
off=3D0x1a6a158f000,len=3D0x1000,ddir=3D1,file=3D\\.\PhysicalDrive1
io       3372  calling ->commit(), depth 1
io       3372  io_u_queued_complete: min=3D1
io       3372  getevents: 1
io       3372  complete: io_u 0A458780:
off=3D0x1a6a158f000,len=3D0x1000,ddir=3D1,file=3D\\.\PhysicalDrive1
random   3372  off rand 3179521932
io       3372  fill: io_u 0A458780:
off=3D0x144365e7d000,len=3D0x0,ddir=3D1,file=3D\\.\PhysicalDrive1
io       3372  get_io_u: zero buflen on 0A458780
io       3372  get_io_u failed
io       3372  drop page cache \\.\PhysicalDrive1
random   3372  off rand 17311067694306724737
io       3372  fill: io_u 0A458780:
off=3D0x19afd9012000,len=3D0x0,ddir=3D1,file=3D\\.\PhysicalDrive1
io       3372  get_io_u: zero buflen on 0A458780
io       3372  get_io_u failed
precond: No I/O performed by windowsaio, perhaps try --debug=3Dio option
for details?
io       3372  close ioengine windowsaio
io       3372  free ioengine windowsaio

precond: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D3372: Sat Sep 15 13:58:46=
 2018
  write: IOPS=3D15, BW=3D60.6KiB/s (62.1kB/s)(4096B/66msec)
    slat (nsec): min=3D832488, max=3D832488, avg=3D832488.00, stdev=3D 0.00
    clat (nsec): min=3D790958, max=3D790958, avg=3D790958.00, stdev=3D 0.00
     lat (nsec): min=3D1623.4k, max=3D1623.4k, avg=3D1623446.00, stdev=3D 0=
.00
    clat percentiles (usec):
     |  1.00th=3D[  791],  5.00th=3D[  791], 10.00th=3D[  791], 20.00th=3D[=
  791],
     | 30.00th=3D[  791], 40.00th=3D[  791], 50.00th=3D[  791], 60.00th=3D[=
  791],
     | 70.00th=3D[  791], 80.00th=3D[  791], 90.00th=3D[  791], 95.00th=3D[=
  791],
     | 99.00th=3D[  791], 99.50th=3D[  791], 99.90th=3D[  791], 99.95th=3D[=
  791],
     | 99.99th=3D[  791]
  lat (usec)   : 1000=3D100.00%
  cpu          : usr=3D0.00%, sys=3D0.00%, ctx=3D0, majf=3D0, minf=3D0
  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     issued rwts: total=3D0,1,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D1

Run status group 0 (all jobs):
  WRITE: bw=3D60.6KiB/s (62.1kB/s), 60.6KiB/s-60.6KiB/s
(62.1kB/s-62.1kB/s), io=3D4096B (4096B), run=3D66-66msec
io       3944  ioengine cpuio unregistered
io       3944  ioengine mmap unregistered
io       3944  ioengine sync unregistered
io       3944  ioengine psync unregistered
io       3944  ioengine vsync unregistered
io       3944  ioengine null unregistered
io       3944  ioengine net unregistered
io       3944  ioengine ftruncate unregistered
io       3944  ioengine filecreate unregistered
io       3944  ioengine windowsaio unregistered

C:\Program Files (x86)\fio>

I don=E2=80=99t see this issue if I use bs=3D8K or I use ba=3D512,8K, etc.

Thanks
smitha


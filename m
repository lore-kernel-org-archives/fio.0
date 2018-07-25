Return-Path: <fio-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:37851 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728492AbeGYNrS (ORCPT
        <rfc822;fio@vger.kernel.org>); Wed, 25 Jul 2018 09:47:18 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id 726A8214E0
        for <fio@vger.kernel.org>; Wed, 25 Jul 2018 08:35:40 -0400 (EDT)
Message-Id: <1532522139.3603237.1452331920.220D1ABD@webmail.messagingengine.com>
From: Aravindh Sampathkumar <aravindh@fastmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: multipart/alternative; boundary="_----------=_153252213936032370"
Date: Wed, 25 Jul 2018 14:35:39 +0200
Subject: Understanding  fio results on a new ZFS server
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

This is a multi-part message in MIME format.

--_----------=_153252213936032370
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"

Hello fio users.

This is my first attempt at using fio, and I'm puzzled by the results I
obtained while running fio on a ZFS server I built recently. I'm running
these commands mostly out of curiosity, and just to understand what the
server is capable of in a ballpark range.
Here goes my naive attempts and results. 

Context: FreeBSD 11.2, ZFS, Compression enabled, Deduplication disabled, 120 X 10TB SAS HDD disks, no SSD caching, 768GB of DDR4 memory, 2X intel Xeon silver 4110 processors.All commands were run directly on the FreeBSD server.
Running fio-3.8

*_Test # 1:_*
Use dd to create a 16 GiB file with random contents.

root@delorean:/sec_stor/backup/fiotest # time dd if=/dev/random
of=./test_file bs=128k count=131072131072+0 records in
131072+0 records out
17179869184 bytes transferred in 137.402721 secs (125032962 bytes/sec)
0.031u 136.915s 2:17.40 99.6% 30+172k 4+131072io 0pf+0w

This shows that I was able to create a 16GiB file with random data in
137 secs with a throughput of approx. *117 MiB/s.*
*_Test # 2:_*
Use fio to perform seq_writes on a 16 GiB file with default
random contents.
root@delorean:/sec_stor/backup/fiotest/fio-master # ./fio --
name=seqwrite --rw=write --bs=128k --numjobs=1 --size=16G --runtime=60
--iodepth=1 --group_reportingseqwrite: (g=0): rw=write, bs=(R) 128KiB-128KiB, (W) 128KiB-128KiB, (T) 128KiB-128KiB, ioengine=psync, iodepth=1fio-3.8


Starting 1 process


Jobs: 1 (f=1): [W(1)][100.0%][r=0KiB/s,w=2188MiB/s][r=0,w=17.5k IOPS][eta 00m:00s]seqwrite: (groupid=0, jobs=1): err= 0: pid=8693: Wed Jul 25 14:11:54 2018  write: IOPS=16.5k, BW=2065MiB/s (2165MB/s)(16.0GiB/7935msec)


    clat (usec): min=18, max=17174, avg=58.18, stdev=285.68


     lat (usec): min=18, max=17180, avg=59.94, stdev=285.88


    clat percentiles (usec):


     |  1.00th=[   23],  5.00th=[   39], 10.00th=[   41],
     |    20.00th=[   42],     | 30.00th=[   43], 40.00th=[   44], 50.00th=[   45],
     |    60.00th=[   47],     | 70.00th=[   51], 80.00th=[   57], 90.00th=[   73],
     |    95.00th=[   89],     | 99.00th=[  135], 99.50th=[  165], 99.90th=[  396],
     |    99.95th=[10421],     | 99.99th=[14877]


   bw (  MiB/s): min= 1648, max= 2388, per=99.00%, avg=2044.07,
   stdev=218.90, samples=15   iops        : min=13185, max=19108, avg=16352.07, stdev=1751.17,
   samples=15  lat (usec)   : 20=0.33%, 50=67.57%, 100=28.78%, 250=3.12%, 500=0.13%  lat (usec)   : 750=0.01%, 1000=0.01%


  lat (msec)   : 2=0.01%, 4=0.01%, 20=0.05%


  cpu          : usr=5.08%, sys=90.27%, ctx=40602, majf=0, minf=0


  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%,
  32=0.0%, >=64=0.0%     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%,
     64=0.0%, >=64=0.0%     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%,
     64=0.0%, >=64=0.0%     issued rwts: total=0,131072,0,0 short=0,0,0,0 dropped=0,0,0,0


     latency   : target=0, window=0, percentile=100.00%, depth=1





Run status group 0 (all jobs):


  WRITE: bw=2065MiB/s (2165MB/s), 2065MiB/s-2065MiB/s (2165MB/s-
  2165MB/s), io=16.0GiB (17.2GB), run=7935-7935msecroot@delorean:/sec_stor/backup/fiotest/fio-master # du -sh seqwrite.0.0
16G seqwrite.0.0
As you can see, it hits a throughput of 2065 MiB/s.
Question: Why such a drastic difference between dd and this? 
My understanding is that dd command must have used createcall to create
a file, then issue open, and write calls to write the random data into
the open file. Finally closethe file. I chose block size of 128 K to
match with ZFS default record size.The fio test should be measuring just the write calls, but everything
else, the same. Why is there so much difference in throughput?While that question is still open in mind, I ventured into testing with
compressible data.
*_Test # 3:_*
Run fio with buffer_compress_percent=0 (0% compression) - My expectation
is this to match the results of test #2. But, it didnt actually create
0% compressible data. More like 100% compressible data!
root@delorean:/sec_stor/backup/fiotest/fio-master # ./fio --
name=seqwrite --rw=write --bs=128k --numjobs=1 --size=16G --runtime=60
--iodepth=1 --buffer_compress_percentage=0 --buffer_pattern=0xdeadbeef
--refill_buffers --group_reportingseqwrite: (g=0): rw=write, bs=(R) 128KiB-128KiB, (W) 128KiB-128KiB, (T) 128KiB-128KiB, ioengine=psync, iodepth=1fio-3.8


Starting 1 process


Jobs: 1 (f=1): [W(1)][100.0%][r=0KiB/s,w=2470MiB/s][r=0,w=19.8k IOPS][eta 00m:00s]seqwrite: (groupid=0, jobs=1): err= 0: pid=10204: Wed Jul 25 14:14:22 2018  write: IOPS=19.8k, BW=2477MiB/s (2597MB/s)(16.0GiB/6615msec)


    clat (usec): min=25, max=529, avg=45.34, stdev= 7.71


     lat (usec): min=25, max=532, avg=45.39, stdev= 7.73


    clat percentiles (usec):


     |  1.00th=[   34],  5.00th=[   39], 10.00th=[   41],
     |    20.00th=[   42],     | 30.00th=[   42], 40.00th=[   43], 50.00th=[   44],
     |    60.00th=[   45],     | 70.00th=[   46], 80.00th=[   49], 90.00th=[   54],
     |    95.00th=[   59],     | 99.00th=[   71], 99.50th=[   77], 99.90th=[  106], 99.95th=[
     |    121],     | 99.99th=[  239]


   bw (  MiB/s): min= 2404, max= 2513, per=99.54%, avg=2465.45,
   stdev=34.80, samples=13   iops        : min=19235, max=20109, avg=19723.23, stdev=278.34,
   samples=13  lat (usec)   : 50=83.01%, 100=16.84%, 250=0.15%, 500=0.01%, 750=0.01%  cpu          : usr=13.09%, sys=86.82%, ctx=305, majf=0, minf=0


  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%,
  32=0.0%, >=64=0.0%     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%,
     64=0.0%, >=64=0.0%     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%,
     64=0.0%, >=64=0.0%     issued rwts: total=0,131072,0,0 short=0,0,0,0 dropped=0,0,0,0


     latency   : target=0, window=0, percentile=100.00%, depth=1





Run status group 0 (all jobs):


  WRITE: bw=2477MiB/s (2597MB/s), 2477MiB/s-2477MiB/s (2597MB/s-
  2597MB/s), io=16.0GiB (17.2GB), run=6615-6615msecroot@delorean:/sec_stor/backup/fiotest/fio-master # du -sh seqwrite.0.0
1.1G seqwrite.0.0
As you see, this test created a 1.1GiB file when I was expecting a 16
GiB file. Why? What options did I miss or specify wrong?
I just couldn't stop, so I went on with another test,

*_Test # 4:_*
 Run fio with buffer_compress_percent=50 (50% compression). It looks
 like it did create a 50% compressible dataset. But, yielded relatively
 low throughput.
root@delorean:/sec_stor/backup/fiotest/fio-master # ./fio --
name=seqwrite --rw=write --bs=128k --numjobs=1 --size=16G --runtime=60
--iodepth=1 --buffer_compress_percentage=50 --buffer_pattern=0xdeadbeef
--refill_buffers --group_reportingseqwrite: (g=0): rw=write, bs=(R) 128KiB-128KiB, (W) 128KiB-128KiB, (T) 128KiB-128KiB, ioengine=psync, iodepth=1fio-3.8


Starting 1 process


Jobs: 1 (f=1): [W(1)][95.7%][r=0KiB/s,w=715MiB/s][r=0,w=5721 IOPS][eta 00m:01s]seqwrite: (groupid=0, jobs=1): err= 0: pid=13543: Wed Jul 25 14:18:41 2018  write: IOPS=5729, BW=716MiB/s (751MB/s)(16.0GiB/22876msec)


    clat (usec): min=26, max=1228, avg=46.59, stdev=19.26


     lat (usec): min=26, max=1229, avg=46.79, stdev=19.73


    clat percentiles (usec):


     |  1.00th=[   35],  5.00th=[   39], 10.00th=[   40],
     |    20.00th=[   42],     | 30.00th=[   42], 40.00th=[   43], 50.00th=[   44],
     |    60.00th=[   44],     | 70.00th=[   45], 80.00th=[   47], 90.00th=[   52],
     |    95.00th=[   64],     | 99.00th=[  120], 99.50th=[  153], 99.90th=[  269], 99.95th=[
     |    359],     | 99.99th=[  627]


   bw (  KiB/s): min=689820, max=748346, per=99.16%, avg=727266.49,
   stdev=13577.99, samples=45   iops        : min= 5389, max= 5846, avg=5681.29, stdev=106.15,
   samples=45  lat (usec)   : 50=88.05%, 100=10.38%, 250=1.45%, 500=0.10%, 750=0.02%  lat (usec)   : 1000=0.01%


  lat (msec)   : 2=0.01%


  cpu          : usr=70.79%, sys=27.64%, ctx=24546, majf=0, minf=0


  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%,
  32=0.0%, >=64=0.0%     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%,
     64=0.0%, >=64=0.0%     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%,
     64=0.0%, >=64=0.0%     issued rwts: total=0,131072,0,0 short=0,0,0,0 dropped=0,0,0,0


     latency   : target=0, window=0, percentile=100.00%, depth=1





Run status group 0 (all jobs):


  WRITE: bw=716MiB/s (751MB/s), 716MiB/s-716MiB/s (751MB/s-751MB/s),
  io=16.0GiB (17.2GB), run=22876-22876msecroot@delorean:/sec_stor/backup/fiotest/fio-master # du -sh seqwrite.0.0
9.2G seqwrite.0.0
As you see, 9.2G file seems reasonable at 50% compression. But, why 716
MiB/s when compared to test #2(no compression) - 2065 MiB/s? At 50%
compression, I understand there is work for the CPUs to compress the
data inline, but, would'nt that cost be negated by the reduction in
amount of data to be written to disks? Is this kind of drop in
throughput reasonable in the field for enabling compression?
Apologies in advance if I missed anything obvious in the documentation.
This is my first use of fio.
Thanks,
--
  Aravindh Sampathkumar
  aravindh@fastmail.com



--_----------=_153252213936032370
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="utf-8"

<!DOCTYPE html>
<html>
<head>
<title></title>
<style type=3D"text/css">p.MsoNormal,p.MsoNoSpacing{margin:0}</style>
</head>
<body><div style=3D"font-size:16px;">Hello fio users.<br></div>
<div style=3D"font-size:16px;"><br></div>
<div style=3D"font-size:16px;">This is my first attempt at using fio, and I=
'm puzzled by the results I obtained while running fio on a ZFS server I bu=
ilt recently. I'm running these commands mostly out of curiosity, and just =
to understand what the server is capable of in a ballpark range.<br></div>
<div style=3D"font-size:16px;"><br></div>
<div style=3D"font-size:16px;">Here goes my naive attempts and results.&nbs=
p;<br></div>
<div style=3D"font-size:16px;"><br></div>
<div style=3D"font-size:16px;">Context: FreeBSD 11.2, ZFS, Compression enab=
led, Deduplication disabled, 120 X 10TB SAS HDD disks, no SSD caching, 768G=
B of DDR4 memory, 2X intel Xeon silver 4110 processors.<br></div>
<div style=3D"font-size:16px;">All commands were run directly on the FreeBS=
D server.<br></div>
<div style=3D"font-size:16px;">Running&nbsp;<span class=3D"font" style=3D"f=
ont-family:&quot;Andale Mono&quot;"><span class=3D"size" style=3D"font-size=
:12px"><span style=3D"font-variant-ligatures: no-common-ligatures"><span cl=
ass=3D"highlight" style=3D"background-color:#ffffff"><span class=3D"colour"=
 style=3D"color:#000000">fio-3.8</span></span></span></span></span><br></di=
v>
<div style=3D"font-size:16px;"><br></div>
<div style=3D"font-size:16px;"><b><u>Test # 1:</u></b><br></div>
<div style=3D"font-size:16px;">Use dd to create a 16 GiB file with random c=
ontents.<br></div>
<div style=3D"font-size:16px;"><br></div>
<div style=3D"font-size:16px;"><span class=3D"font" style=3D"font-family: m=
enlo, consolas, monospace, sans-serif;"><span class=3D"size" style=3D"font-=
size: 13px">root@delorean:/sec_stor/backup/fiotest # time dd if=3D/dev/rand=
om of=3D./test_file bs=3D128k count=3D131072<br></span></span></div>
<div style=3D"font-size:16px;"><span class=3D"font" style=3D"font-family: m=
enlo, consolas, monospace, sans-serif;"><span class=3D"size" style=3D"font-=
size: 13px">131072+0 records in<br></span></span></div>
<div style=3D"font-size:16px;"><span class=3D"font" style=3D"font-family: m=
enlo, consolas, monospace, sans-serif;"><span class=3D"size" style=3D"font-=
size: 13px">131072+0 records out<br></span></span></div>
<div style=3D"font-size:16px;"><span class=3D"font" style=3D"font-family: m=
enlo, consolas, monospace, sans-serif;"><span class=3D"size" style=3D"font-=
size: 13px">17179869184 bytes transferred in 137.402721 secs (125032962 byt=
es/sec)<br></span></span></div>
<div style=3D"font-size:16px;"><span class=3D"font" style=3D"font-family: m=
enlo, consolas, monospace, sans-serif;"><span class=3D"size" style=3D"font-=
size: 13px">0.031u 136.915s 2:17.40 99.6%	30+172k 4+131072io 0pf+0w</span><=
/span><br></div>
<div style=3D"font-size:16px;"><br></div>
<div style=3D"font-size:16px;"><span class=3D"highlight" style=3D"backgroun=
d-color:rgb(255, 255, 255)"><span class=3D"colour" style=3D"color:rgb(36, 3=
9, 41)"><span class=3D"font" style=3D"font-family:Arial, &quot;Helvetica Ne=
ue&quot;, Helvetica, sans-serif"><span class=3D"size" style=3D"font-size:15=
px">This shows that I was able to create a 16GiB file with random data in 1=
37 secs with a throughput of approx. <b>117 MiB/s.</b></span></span></span>=
</span><br></div>
<div style=3D"font-size:16px;"><br></div>
<div style=3D"font-size:16px;"><span class=3D"highlight" style=3D"backgroun=
d-color:rgb(255, 255, 255)"><span class=3D"colour" style=3D"color:rgb(36, 3=
9, 41)"><span class=3D"font" style=3D"font-family:Arial, &quot;Helvetica Ne=
ue&quot;, Helvetica, sans-serif"><span class=3D"size" style=3D"font-size:15=
px"><b><u>Test # 2:</u></b></span></span></span></span><br></div>
<div style=3D"font-size:16px;"><span class=3D"highlight" style=3D"backgroun=
d-color:rgb(255, 255, 255)"><span class=3D"colour" style=3D"color:rgb(36, 3=
9, 41)"><span class=3D"font" style=3D"font-family:Arial, &quot;Helvetica Ne=
ue&quot;, Helvetica, sans-serif"><span class=3D"size" style=3D"font-size:15=
px">Use fio to perform seq_writes on a 16 GiB file with default random cont=
ents.</span></span></span></span><br></div>
<div style=3D"font-size:16px;"><br></div>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; fon=
t-weight: normal; font-stretch: normal; line-height: normal;"><span style=
=3D"font-variant-ligatures: no-common-ligatures"><span class=3D"font" style=
=3D"font-family: menlo, consolas, monospace, sans-serif;"><span class=3D"si=
ze" style=3D"font-size: 13px"><span class=3D"colour" style=3D"color:#000000=
"><span class=3D"highlight" style=3D"background-color:#ffffff">root@delorea=
n:/sec_stor/backup/fiotest/fio-master # ./fio --name=3Dseqwrite --rw=3Dwrit=
e --bs=3D128k --numjobs=3D1 --size=3D16G --runtime=3D60 --iodepth=3D1 --gro=
up_reporting</span></span></span></span></span><span class=3D"font" style=
=3D"font-family: menlo, consolas, monospace, sans-serif;"><span class=3D"si=
ze" style=3D"font-size: 13px"><span class=3D"colour" style=3D"color:#000000=
"><span class=3D"highlight" style=3D"background-color:#ffffff"><br></span><=
/span></span></span></p><p style=3D"margin: 0px; font-style: normal; font-v=
ariant-caps: normal; font-weight: normal; font-stretch: normal; line-height=
: normal;"><span style=3D"font-variant-ligatures: no-common-ligatures"><spa=
n class=3D"font" style=3D"font-family: menlo, consolas, monospace, sans-ser=
if;"><span class=3D"size" style=3D"font-size: 13px"><span class=3D"colour" =
style=3D"color:#000000"><span class=3D"highlight" style=3D"background-color=
:#ffffff">seqwrite: (g=3D0): rw=3Dwrite, bs=3D(R) 128KiB-128KiB, (W) 128KiB=
-128KiB, (T) 128KiB-128KiB, ioengine=3Dpsync, iodepth=3D1</span></span></sp=
an></span></span><span class=3D"font" style=3D"font-family: menlo, consolas=
, monospace, sans-serif;"><span class=3D"size" style=3D"font-size: 13px"><s=
pan class=3D"colour" style=3D"color:#000000"><span class=3D"highlight" styl=
e=3D"background-color:#ffffff"><br></span></span></span></span></p><p style=
=3D"margin: 0px; font-style: normal; font-variant-caps: normal; font-weight=
: normal; font-stretch: normal; line-height: normal;"><span style=3D"font-v=
ariant-ligatures: no-common-ligatures"><span class=3D"font" style=3D"font-f=
amily: menlo, consolas, monospace, sans-serif;"><span class=3D"size" style=
=3D"font-size: 13px"><span class=3D"colour" style=3D"color:#000000"><span c=
lass=3D"highlight" style=3D"background-color:#ffffff">fio-3.8</span></span>=
</span></span></span><span class=3D"font" style=3D"font-family: menlo, cons=
olas, monospace, sans-serif;"><span class=3D"size" style=3D"font-size: 13px=
"><span class=3D"colour" style=3D"color:#000000"><span class=3D"highlight" =
style=3D"background-color:#ffffff"><br></span></span></span></span></p><p s=
tyle=3D"margin: 0px; font-style: normal; font-variant-caps: normal; font-we=
ight: normal; font-stretch: normal; line-height: normal;"><span style=3D"fo=
nt-variant-ligatures: no-common-ligatures"><span class=3D"font" style=3D"fo=
nt-family: menlo, consolas, monospace, sans-serif;"><span class=3D"size" st=
yle=3D"font-size: 13px"><span class=3D"colour" style=3D"color:#000000"><spa=
n class=3D"highlight" style=3D"background-color:#ffffff">Starting 1 process=
</span></span></span></span></span><span class=3D"font" style=3D"font-famil=
y: menlo, consolas, monospace, sans-serif;"><span class=3D"size" style=3D"f=
ont-size: 13px"><span class=3D"colour" style=3D"color:#000000"><span class=
=3D"highlight" style=3D"background-color:#ffffff"><br></span></span></span>=
</span></p><p style=3D"margin: 0px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; font-stretch: normal; line-height: normal;"><s=
pan style=3D"font-variant-ligatures: no-common-ligatures"><span class=3D"fo=
nt" style=3D"font-family: menlo, consolas, monospace, sans-serif;"><span cl=
ass=3D"size" style=3D"font-size: 13px"><span class=3D"colour" style=3D"colo=
r:#000000"><span class=3D"highlight" style=3D"background-color:#ffffff">Job=
s: 1 (f=3D1): [W(1)][100.0%][r=3D0KiB/s,w=3D2188MiB/s][r=3D0,w=3D17.5k IOPS=
][eta 00m:00s]</span></span></span></span></span><span class=3D"font" style=
=3D"font-family: menlo, consolas, monospace, sans-serif;"><span class=3D"si=
ze" style=3D"font-size: 13px"><span class=3D"colour" style=3D"color:#000000=
"><span class=3D"highlight" style=3D"background-color:#ffffff"><br></span><=
/span></span></span></p><p style=3D"margin: 0px; font-style: normal; font-v=
ariant-caps: normal; font-weight: normal; font-stretch: normal; line-height=
: normal;"><span style=3D"font-variant-ligatures: no-common-ligatures"><spa=
n class=3D"font" style=3D"font-family: menlo, consolas, monospace, sans-ser=
if;"><span class=3D"size" style=3D"font-size: 13px"><span class=3D"colour" =
style=3D"color:#000000"><span class=3D"highlight" style=3D"background-color=
:#ffffff">seqwrite: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D8693: Wed Jul =
25 14:11:54 2018</span></span></span></span></span><span class=3D"font" sty=
le=3D"font-family: menlo, consolas, monospace, sans-serif;"><span class=3D"=
size" style=3D"font-size: 13px"><span class=3D"colour" style=3D"color:#0000=
00"><span class=3D"highlight" style=3D"background-color:#ffffff"><br></span=
></span></span></span></p><p style=3D"margin: 0px; font-style: normal; font=
-variant-caps: normal; font-weight: normal; font-stretch: normal; line-heig=
ht: normal;"><span style=3D"font-variant-ligatures: no-common-ligatures"><s=
pan class=3D"Apple-converted-space"><span class=3D"font" style=3D"font-fami=
ly: menlo, consolas, monospace, sans-serif;"><span class=3D"size" style=3D"=
font-size: 13px"><span class=3D"colour" style=3D"color:#000000"><span class=
=3D"highlight" style=3D"background-color:#ffffff">&nbsp; </span></span></sp=
an></span></span><span class=3D"font" style=3D"font-family: menlo, consolas=
, monospace, sans-serif;"><span class=3D"size" style=3D"font-size: 13px"><s=
pan class=3D"colour" style=3D"color:#000000"><span class=3D"highlight" styl=
e=3D"background-color:#ffffff">write: IOPS=3D16.5k, BW=3D2065MiB/s (2165MB/=
s)(16.0GiB/7935msec)</span></span></span></span></span><span class=3D"font"=
 style=3D"font-family: menlo, consolas, monospace, sans-serif;"><span class=
=3D"size" style=3D"font-size: 13px"><span class=3D"colour" style=3D"color:#=
000000"><span class=3D"highlight" style=3D"background-color:#ffffff"><br></=
span></span></span></span></p><p style=3D"margin: 0px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; font-stretch: normal; line-=
height: normal;"><span style=3D"font-variant-ligatures: no-common-ligatures=
"><span class=3D"Apple-converted-space"><span class=3D"font" style=3D"font-=
family: menlo, consolas, monospace, sans-serif;"><span class=3D"size" style=
=3D"font-size: 13px"><span class=3D"colour" style=3D"color:#000000"><span c=
lass=3D"highlight" style=3D"background-color:#ffffff">&nbsp; &nbsp; </span>=
</span></span></span></span><span class=3D"font" style=3D"font-family: menl=
o, consolas, monospace, sans-serif;"><span class=3D"size" style=3D"font-siz=
e: 13px"><span class=3D"colour" style=3D"color:#000000"><span class=3D"high=
light" style=3D"background-color:#ffffff">clat (usec): min=3D18, max=3D1717=
4, avg=3D58.18, stdev=3D285.68</span></span></span></span></span><span clas=
s=3D"font" style=3D"font-family: menlo, consolas, monospace, sans-serif;"><=
span class=3D"size" style=3D"font-size: 13px"><span class=3D"colour" style=
=3D"color:#000000"><span class=3D"highlight" style=3D"background-color:#fff=
fff"><br></span></span></span></span></p><p style=3D"margin: 0px; font-styl=
e: normal; font-variant-caps: normal; font-weight: normal; font-stretch: no=
rmal; line-height: normal;"><span style=3D"font-variant-ligatures: no-commo=
n-ligatures"><span class=3D"Apple-converted-space"><span class=3D"font" sty=
le=3D"font-family: menlo, consolas, monospace, sans-serif;"><span class=3D"=
size" style=3D"font-size: 13px"><span class=3D"colour" style=3D"color:#0000=
00"><span class=3D"highlight" style=3D"background-color:#ffffff">&nbsp;&nbs=
p; &nbsp; </span></span></span></span></span><span class=3D"font" style=3D"=
font-family: menlo, consolas, monospace, sans-serif;"><span class=3D"size" =
style=3D"font-size: 13px"><span class=3D"colour" style=3D"color:#000000"><s=
pan class=3D"highlight" style=3D"background-color:#ffffff">lat (usec): min=
=3D18, max=3D17180, avg=3D59.94, stdev=3D285.88</span></span></span></span>=
</span><span class=3D"font" style=3D"font-family: menlo, consolas, monospac=
e, sans-serif;"><span class=3D"size" style=3D"font-size: 13px"><span class=
=3D"colour" style=3D"color:#000000"><span class=3D"highlight" style=3D"back=
ground-color:#ffffff"><br></span></span></span></span></p><p style=3D"margi=
n: 0px; font-style: normal; font-variant-caps: normal; font-weight: normal;=
 font-stretch: normal; line-height: normal;"><span style=3D"font-variant-li=
gatures: no-common-ligatures"><span class=3D"Apple-converted-space"><span c=
lass=3D"font" style=3D"font-family: menlo, consolas, monospace, sans-serif;=
"><span class=3D"size" style=3D"font-size: 13px"><span class=3D"colour" sty=
le=3D"color:#000000"><span class=3D"highlight" style=3D"background-color:#f=
fffff">&nbsp; &nbsp; </span></span></span></span></span><span class=3D"font=
" style=3D"font-family: menlo, consolas, monospace, sans-serif;"><span clas=
s=3D"size" style=3D"font-size: 13px"><span class=3D"colour" style=3D"color:=
#000000"><span class=3D"highlight" style=3D"background-color:#ffffff">clat =
percentiles (usec):</span></span></span></span></span><span class=3D"font" =
style=3D"font-family: menlo, consolas, monospace, sans-serif;"><span class=
=3D"size" style=3D"font-size: 13px"><span class=3D"colour" style=3D"color:#=
000000"><span class=3D"highlight" style=3D"background-color:#ffffff"><br></=
span></span></span></span></p><p style=3D"margin: 0px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; font-stretch: normal; line-=
height: normal;"><span style=3D"font-variant-ligatures: no-common-ligatures=
"><span class=3D"Apple-converted-space"><span class=3D"font" style=3D"font-=
family: menlo, consolas, monospace, sans-serif;"><span class=3D"size" style=
=3D"font-size: 13px"><span class=3D"colour" style=3D"color:#000000"><span c=
lass=3D"highlight" style=3D"background-color:#ffffff">&nbsp;&nbsp; &nbsp; <=
/span></span></span></span></span><span class=3D"font" style=3D"font-family=
: menlo, consolas, monospace, sans-serif;"><span class=3D"size" style=3D"fo=
nt-size: 13px"><span class=3D"colour" style=3D"color:#000000"><span class=
=3D"highlight" style=3D"background-color:#ffffff">|</span></span></span></s=
pan><span class=3D"Apple-converted-space"><span class=3D"font" style=3D"fon=
t-family: menlo, consolas, monospace, sans-serif;"><span class=3D"size" sty=
le=3D"font-size: 13px"><span class=3D"colour" style=3D"color:#000000"><span=
 class=3D"highlight" style=3D"background-color:#ffffff">&nbsp; </span></spa=
n></span></span></span><span class=3D"font" style=3D"font-family: menlo, co=
nsolas, monospace, sans-serif;"><span class=3D"size" style=3D"font-size: 13=
px"><span class=3D"colour" style=3D"color:#000000"><span class=3D"highlight=
" style=3D"background-color:#ffffff">1.00th=3D[ </span></span></span></span=
><span class=3D"Apple-converted-space"><span class=3D"font" style=3D"font-f=
amily: menlo, consolas, monospace, sans-serif;"><span class=3D"size" style=
=3D"font-size: 13px"><span class=3D"colour" style=3D"color:#000000"><span c=
lass=3D"highlight" style=3D"background-color:#ffffff">&nbsp; </span></span>=
</span></span></span><span class=3D"font" style=3D"font-family: menlo, cons=
olas, monospace, sans-serif;"><span class=3D"size" style=3D"font-size: 13px=
"><span class=3D"colour" style=3D"color:#000000"><span class=3D"highlight" =
style=3D"background-color:#ffffff">23],</span></span></span></span><span cl=
ass=3D"Apple-converted-space"><span class=3D"font" style=3D"font-family: me=
nlo, consolas, monospace, sans-serif;"><span class=3D"size" style=3D"font-s=
ize: 13px"><span class=3D"colour" style=3D"color:#000000"><span class=3D"hi=
ghlight" style=3D"background-color:#ffffff">&nbsp; </span></span></span></s=
pan></span><span class=3D"font" style=3D"font-family: menlo, consolas, mono=
space, sans-serif;"><span class=3D"size" style=3D"font-size: 13px"><span cl=
ass=3D"colour" style=3D"color:#000000"><span class=3D"highlight" style=3D"b=
ackground-color:#ffffff">5.00th=3D[ </span></span></span></span><span class=
=3D"Apple-converted-space"><span class=3D"font" style=3D"font-family: menlo=
, consolas, monospace, sans-serif;"><span class=3D"size" style=3D"font-size=
: 13px"><span class=3D"colour" style=3D"color:#000000"><span class=3D"highl=
ight" style=3D"background-color:#ffffff">&nbsp; </span></span></span></span=
></span><span class=3D"font" style=3D"font-family: menlo, consolas, monospa=
ce, sans-serif;"><span class=3D"size" style=3D"font-size: 13px"><span class=
=3D"colour" style=3D"color:#000000"><span class=3D"highlight" style=3D"back=
ground-color:#ffffff">39], 10.00th=3D[ </span></span></span></span><span cl=
ass=3D"Apple-converted-space"><span class=3D"font" style=3D"font-family: me=
nlo, consolas, monospace, sans-serif;"><span class=3D"size" style=3D"font-s=
ize: 13px"><span class=3D"colour" style=3D"color:#000000"><span class=3D"hi=
ghlight" style=3D"background-color:#ffffff">&nbsp; </span></span></span></s=
pan></span><span class=3D"font" style=3D"font-family: menlo, consolas, mono=
space, sans-serif;"><span class=3D"size" style=3D"font-size: 13px"><span cl=
ass=3D"colour" style=3D"color:#000000"><span class=3D"highlight" style=3D"b=
ackground-color:#ffffff">41], 20.00th=3D[ </span></span></span></span><span=
 class=3D"Apple-converted-space"><span class=3D"font" style=3D"font-family:=
 menlo, consolas, monospace, sans-serif;"><span class=3D"size" style=3D"fon=
t-size: 13px"><span class=3D"colour" style=3D"color:#000000"><span class=3D=
"highlight" style=3D"background-color:#ffffff">&nbsp; </span></span></span>=
</span></span><span class=3D"font" style=3D"font-family: menlo, consolas, m=
onospace, sans-serif;"><span class=3D"size" style=3D"font-size: 13px"><span=
 class=3D"colour" style=3D"color:#000000"><span class=3D"highlight" style=
=3D"background-color:#ffffff">42],</span></span></span></span></span><span =
class=3D"font" style=3D"font-family: menlo, consolas, monospace, sans-serif=
;"><span class=3D"size" style=3D"font-size: 13px"><span class=3D"colour" st=
yle=3D"color:#000000"><span class=3D"highlight" style=3D"background-color:#=
ffffff"><br></span></span></span></span></p><p style=3D"margin: 0px; font-s=
tyle: normal; font-variant-caps: normal; font-weight: normal; font-stretch:=
 normal; line-height: normal;"><span style=3D"font-variant-ligatures: no-co=
mmon-ligatures"><span class=3D"Apple-converted-space"><span class=3D"font" =
style=3D"font-family: menlo, consolas, monospace, sans-serif;"><span class=
=3D"size" style=3D"font-size: 13px"><span class=3D"colour" style=3D"color:#=
000000"><span class=3D"highlight" style=3D"background-color:#ffffff">&nbsp;=
&nbsp; &nbsp; </span></span></span></span></span><span class=3D"font" style=
=3D"font-family: menlo, consolas, monospace, sans-serif;"><span class=3D"si=
ze" style=3D"font-size: 13px"><span class=3D"colour" style=3D"color:#000000=
"><span class=3D"highlight" style=3D"background-color:#ffffff">| 30.00th=3D=
[ </span></span></span></span><span class=3D"Apple-converted-space"><span c=
lass=3D"font" style=3D"font-family: menlo, consolas, monospace, sans-serif;=
"><span class=3D"size" style=3D"font-size: 13px"><span class=3D"colour" sty=
le=3D"color:#000000"><span class=3D"highlight" style=3D"background-color:#f=
fffff">&nbsp; </span></span></span></span></span><span class=3D"font" style=
=3D"font-family: menlo, consolas, monospace, sans-serif;"><span class=3D"si=
ze" style=3D"font-size: 13px"><span class=3D"colour" style=3D"color:#000000=
"><span class=3D"highlight" style=3D"background-color:#ffffff">43], 40.00th=
=3D[ </span></span></span></span><span class=3D"Apple-converted-space"><spa=
n class=3D"font" style=3D"font-family: menlo, consolas, monospace, sans-ser=
if;"><span class=3D"size" style=3D"font-size: 13px"><span class=3D"colour" =
style=3D"color:#000000"><span class=3D"highlight" style=3D"background-color=
:#ffffff">&nbsp; </span></span></span></span></span><span class=3D"font" st=
yle=3D"font-family: menlo, consolas, monospace, sans-serif;"><span class=3D=
"size" style=3D"font-size: 13px"><span class=3D"colour" style=3D"color:#000=
000"><span class=3D"highlight" style=3D"background-color:#ffffff">44], 50.0=
0th=3D[ </span></span></span></span><span class=3D"Apple-converted-space"><=
span class=3D"font" style=3D"font-family: menlo, consolas, monospace, sans-=
serif;"><span class=3D"size" style=3D"font-size: 13px"><span class=3D"colou=
r" style=3D"color:#000000"><span class=3D"highlight" style=3D"background-co=
lor:#ffffff">&nbsp; </span></span></span></span></span><span class=3D"font"=
 style=3D"font-family: menlo, consolas, monospace, sans-serif;"><span class=
=3D"size" style=3D"font-size: 13px"><span class=3D"colour" style=3D"color:#=
000000"><span class=3D"highlight" style=3D"background-color:#ffffff">45], 6=
0.00th=3D[ </span></span></span></span><span class=3D"Apple-converted-space=
"><span class=3D"font" style=3D"font-family: menlo, consolas, monospace, sa=
ns-serif;"><span class=3D"size" style=3D"font-size: 13px"><span class=3D"co=
lour" style=3D"color:#000000"><span class=3D"highlight" style=3D"background=
-color:#ffffff">&nbsp; </span></span></span></span></span><span class=3D"fo=
nt" style=3D"font-family: menlo, consolas, monospace, sans-serif;"><span cl=
ass=3D"size" style=3D"font-size: 13px"><span class=3D"colour" style=3D"colo=
r:#000000"><span class=3D"highlight" style=3D"background-color:#ffffff">47]=
,</span></span></span></span></span><span class=3D"font" style=3D"font-fami=
ly: menlo, consolas, monospace, sans-serif;"><span class=3D"size" style=3D"=
font-size: 13px"><span class=3D"colour" style=3D"color:#000000"><span class=
=3D"highlight" style=3D"background-color:#ffffff"><br></span></span></span>=
</span></p><p style=3D"margin: 0px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; font-stretch: normal; line-height: normal;"><s=
pan style=3D"font-variant-ligatures: no-common-ligatures"><span class=3D"Ap=
ple-converted-space"><span class=3D"font" style=3D"font-family: menlo, cons=
olas, monospace, sans-serif;"><span class=3D"size" style=3D"font-size: 13px=
"><span class=3D"colour" style=3D"color:#000000"><span class=3D"highlight" =
style=3D"background-color:#ffffff">&nbsp;&nbsp; &nbsp; </span></span></span=
></span></span><span class=3D"font" style=3D"font-family: menlo, consolas, =
monospace, sans-serif;"><span class=3D"size" style=3D"font-size: 13px"><spa=
n class=3D"colour" style=3D"color:#000000"><span class=3D"highlight" style=
=3D"background-color:#ffffff">| 70.00th=3D[ </span></span></span></span><sp=
an class=3D"Apple-converted-space"><span class=3D"font" style=3D"font-famil=
y: menlo, consolas, monospace, sans-serif;"><span class=3D"size" style=3D"f=
ont-size: 13px"><span class=3D"colour" style=3D"color:#000000"><span class=
=3D"highlight" style=3D"background-color:#ffffff">&nbsp; </span></span></sp=
an></span></span><span class=3D"font" style=3D"font-family: menlo, consolas=
, monospace, sans-serif;"><span class=3D"size" style=3D"font-size: 13px"><s=
pan class=3D"colour" style=3D"color:#000000"><span class=3D"highlight" styl=
e=3D"background-color:#ffffff">51], 80.00th=3D[ </span></span></span></span=
><span class=3D"Apple-converted-space"><span class=3D"font" style=3D"font-f=
amily: menlo, consolas, monospace, sans-serif;"><span class=3D"size" style=
=3D"font-size: 13px"><span class=3D"colour" style=3D"color:#000000"><span c=
lass=3D"highlight" style=3D"background-color:#ffffff">&nbsp; </span></span>=
</span></span></span><span class=3D"font" style=3D"font-family: menlo, cons=
olas, monospace, sans-serif;"><span class=3D"size" style=3D"font-size: 13px=
"><span class=3D"colour" style=3D"color:#000000"><span class=3D"highlight" =
style=3D"background-color:#ffffff">57], 90.00th=3D[ </span></span></span></=
span><span class=3D"Apple-converted-space"><span class=3D"font" style=3D"fo=
nt-family: menlo, consolas, monospace, sans-serif;"><span class=3D"size" st=
yle=3D"font-size: 13px"><span class=3D"colour" style=3D"color:#000000"><spa=
n class=3D"highlight" style=3D"background-color:#ffffff">&nbsp; </span></sp=
an></span></span></span><span class=3D"font" style=3D"font-family: menlo, c=
onsolas, monospace, sans-serif;"><span class=3D"size" style=3D"font-size: 1=
3px"><span class=3D"colour" style=3D"color:#000000"><span class=3D"highligh=
t" style=3D"background-color:#ffffff">73], 95.00th=3D[ </span></span></span=
></span><span class=3D"Apple-converted-space"><span class=3D"font" style=3D=
"font-family: menlo, consolas, monospace, sans-serif;"><span class=3D"size"=
 style=3D"font-size: 13px"><span class=3D"colour" style=3D"color:#000000"><=
span class=3D"highlight" style=3D"background-color:#ffffff">&nbsp; </span><=
/span></span></span></span><span class=3D"font" style=3D"font-family: menlo=
, consolas, monospace, sans-serif;"><span class=3D"size" style=3D"font-size=
: 13px"><span class=3D"colour" style=3D"color:#000000"><span class=3D"highl=
ight" style=3D"background-color:#ffffff">89],</span></span></span></span></=
span><span class=3D"font" style=3D"font-family: menlo, consolas, monospace,=
 sans-serif;"><span class=3D"size" style=3D"font-size: 13px"><span class=3D=
"colour" style=3D"color:#000000"><span class=3D"highlight" style=3D"backgro=
und-color:#ffffff"><br></span></span></span></span></p><p style=3D"margin: =
0px; font-style: normal; font-variant-caps: normal; font-weight: normal; fo=
nt-stretch: normal; line-height: normal;"><span style=3D"font-variant-ligat=
ures: no-common-ligatures"><span class=3D"Apple-converted-space"><span clas=
s=3D"font" style=3D"font-family: menlo, consolas, monospace, sans-serif;"><=
span class=3D"size" style=3D"font-size: 13px"><span class=3D"colour" style=
=3D"color:#000000"><span class=3D"highlight" style=3D"background-color:#fff=
fff">&nbsp;&nbsp; &nbsp; </span></span></span></span></span><span class=3D"=
font" style=3D"font-family: menlo, consolas, monospace, sans-serif;"><span =
class=3D"size" style=3D"font-size: 13px"><span class=3D"colour" style=3D"co=
lor:#000000"><span class=3D"highlight" style=3D"background-color:#ffffff">|=
 99.00th=3D[</span></span></span></span><span class=3D"Apple-converted-spac=
e"><span class=3D"font" style=3D"font-family: menlo, consolas, monospace, s=
ans-serif;"><span class=3D"size" style=3D"font-size: 13px"><span class=3D"c=
olour" style=3D"color:#000000"><span class=3D"highlight" style=3D"backgroun=
d-color:#ffffff">&nbsp; </span></span></span></span></span><span class=3D"f=
ont" style=3D"font-family: menlo, consolas, monospace, sans-serif;"><span c=
lass=3D"size" style=3D"font-size: 13px"><span class=3D"colour" style=3D"col=
or:#000000"><span class=3D"highlight" style=3D"background-color:#ffffff">13=
5], 99.50th=3D[</span></span></span></span><span class=3D"Apple-converted-s=
pace"><span class=3D"font" style=3D"font-family: menlo, consolas, monospace=
, sans-serif;"><span class=3D"size" style=3D"font-size: 13px"><span class=
=3D"colour" style=3D"color:#000000"><span class=3D"highlight" style=3D"back=
ground-color:#ffffff">&nbsp; </span></span></span></span></span><span class=
=3D"font" style=3D"font-family: menlo, consolas, monospace, sans-serif;"><s=
pan class=3D"size" style=3D"font-size: 13px"><span class=3D"colour" style=
=3D"color:#000000"><span class=3D"highlight" style=3D"background-color:#fff=
fff">165], 99.90th=3D[</span></span></span></span><span class=3D"Apple-conv=
erted-space"><span class=3D"font" style=3D"font-family: menlo, consolas, mo=
nospace, sans-serif;"><span class=3D"size" style=3D"font-size: 13px"><span =
class=3D"colour" style=3D"color:#000000"><span class=3D"highlight" style=3D=
"background-color:#ffffff">&nbsp; </span></span></span></span></span><span =
class=3D"font" style=3D"font-family: menlo, consolas, monospace, sans-serif=
;"><span class=3D"size" style=3D"font-size: 13px"><span class=3D"colour" st=
yle=3D"color:#000000"><span class=3D"highlight" style=3D"background-color:#=
ffffff">396], 99.95th=3D[10421],</span></span></span></span></span><span cl=
ass=3D"font" style=3D"font-family: menlo, consolas, monospace, sans-serif;"=
><span class=3D"size" style=3D"font-size: 13px"><span class=3D"colour" styl=
e=3D"color:#000000"><span class=3D"highlight" style=3D"background-color:#ff=
ffff"><br></span></span></span></span></p><p style=3D"margin: 0px; font-sty=
le: normal; font-variant-caps: normal; font-weight: normal; font-stretch: n=
ormal; line-height: normal;"><span style=3D"font-variant-ligatures: no-comm=
on-ligatures"><span class=3D"Apple-converted-space"><span class=3D"font" st=
yle=3D"font-family: menlo, consolas, monospace, sans-serif;"><span class=3D=
"size" style=3D"font-size: 13px"><span class=3D"colour" style=3D"color:#000=
000"><span class=3D"highlight" style=3D"background-color:#ffffff">&nbsp;&nb=
sp; &nbsp; </span></span></span></span></span><span class=3D"font" style=3D=
"font-family: menlo, consolas, monospace, sans-serif;"><span class=3D"size"=
 style=3D"font-size: 13px"><span class=3D"colour" style=3D"color:#000000"><=
span class=3D"highlight" style=3D"background-color:#ffffff">| 99.99th=3D[14=
877]</span></span></span></span></span><span class=3D"font" style=3D"font-f=
amily: menlo, consolas, monospace, sans-serif;"><span class=3D"size" style=
=3D"font-size: 13px"><span class=3D"colour" style=3D"color:#000000"><span c=
lass=3D"highlight" style=3D"background-color:#ffffff"><br></span></span></s=
pan></span></p><p style=3D"margin: 0px; font-style: normal; font-variant-ca=
ps: normal; font-weight: normal; font-stretch: normal; line-height: normal;=
"><span style=3D"font-variant-ligatures: no-common-ligatures"><span class=
=3D"Apple-converted-space"><span class=3D"font" style=3D"font-family: menlo=
, consolas, monospace, sans-serif;"><span class=3D"size" style=3D"font-size=
: 13px"><span class=3D"colour" style=3D"color:#000000"><span class=3D"highl=
ight" style=3D"background-color:#ffffff">&nbsp;&nbsp; </span></span></span>=
</span></span><span class=3D"font" style=3D"font-family: menlo, consolas, m=
onospace, sans-serif;"><span class=3D"size" style=3D"font-size: 13px"><span=
 class=3D"colour" style=3D"color:#000000"><span class=3D"highlight" style=
=3D"background-color:#ffffff">bw (</span></span></span></span><span class=
=3D"Apple-converted-space"><span class=3D"font" style=3D"font-family: menlo=
, consolas, monospace, sans-serif;"><span class=3D"size" style=3D"font-size=
: 13px"><span class=3D"colour" style=3D"color:#000000"><span class=3D"highl=
ight" style=3D"background-color:#ffffff">&nbsp; </span></span></span></span=
></span><span class=3D"font" style=3D"font-family: menlo, consolas, monospa=
ce, sans-serif;"><span class=3D"size" style=3D"font-size: 13px"><span class=
=3D"colour" style=3D"color:#000000"><span class=3D"highlight" style=3D"back=
ground-color:#ffffff">MiB/s): min=3D 1648, max=3D 2388, per=3D99.00%, avg=
=3D2044.07, stdev=3D218.90, samples=3D15</span></span></span></span></span>=
<span class=3D"font" style=3D"font-family: menlo, consolas, monospace, sans=
-serif;"><span class=3D"size" style=3D"font-size: 13px"><span class=3D"colo=
ur" style=3D"color:#000000"><span class=3D"highlight" style=3D"background-c=
olor:#ffffff"><br></span></span></span></span></p><p style=3D"margin: 0px; =
font-style: normal; font-variant-caps: normal; font-weight: normal; font-st=
retch: normal; line-height: normal;"><span style=3D"font-variant-ligatures:=
 no-common-ligatures"><span class=3D"Apple-converted-space"><span class=3D"=
font" style=3D"font-family: menlo, consolas, monospace, sans-serif;"><span =
class=3D"size" style=3D"font-size: 13px"><span class=3D"colour" style=3D"co=
lor:#000000"><span class=3D"highlight" style=3D"background-color:#ffffff">&=
nbsp;&nbsp; </span></span></span></span></span><span class=3D"font" style=
=3D"font-family: menlo, consolas, monospace, sans-serif;"><span class=3D"si=
ze" style=3D"font-size: 13px"><span class=3D"colour" style=3D"color:#000000=
"><span class=3D"highlight" style=3D"background-color:#ffffff">iops</span><=
/span></span></span><span class=3D"Apple-converted-space"><span class=3D"fo=
nt" style=3D"font-family: menlo, consolas, monospace, sans-serif;"><span cl=
ass=3D"size" style=3D"font-size: 13px"><span class=3D"colour" style=3D"colo=
r:#000000"><span class=3D"highlight" style=3D"background-color:#ffffff">&nb=
sp; &nbsp; &nbsp; &nbsp; </span></span></span></span></span><span class=3D"=
font" style=3D"font-family: menlo, consolas, monospace, sans-serif;"><span =
class=3D"size" style=3D"font-size: 13px"><span class=3D"colour" style=3D"co=
lor:#000000"><span class=3D"highlight" style=3D"background-color:#ffffff">:=
 min=3D13185, max=3D19108, avg=3D16352.07, stdev=3D1751.17, samples=3D15</s=
pan></span></span></span></span><span class=3D"font" style=3D"font-family: =
menlo, consolas, monospace, sans-serif;"><span class=3D"size" style=3D"font=
-size: 13px"><span class=3D"colour" style=3D"color:#000000"><span class=3D"=
highlight" style=3D"background-color:#ffffff"><br></span></span></span></sp=
an></p><p style=3D"margin: 0px; font-style: normal; font-variant-caps: norm=
al; font-weight: normal; font-stretch: normal; line-height: normal;"><span =
style=3D"font-variant-ligatures: no-common-ligatures"><span class=3D"Apple-=
converted-space"><span class=3D"font" style=3D"font-family: menlo, consolas=
, monospace, sans-serif;"><span class=3D"size" style=3D"font-size: 13px"><s=
pan class=3D"colour" style=3D"color:#000000"><span class=3D"highlight" styl=
e=3D"background-color:#ffffff">&nbsp; </span></span></span></span></span><s=
pan class=3D"font" style=3D"font-family: menlo, consolas, monospace, sans-s=
erif;"><span class=3D"size" style=3D"font-size: 13px"><span class=3D"colour=
" style=3D"color:#000000"><span class=3D"highlight" style=3D"background-col=
or:#ffffff">lat (usec) </span></span></span></span><span class=3D"Apple-con=
verted-space"><span class=3D"font" style=3D"font-family: menlo, consolas, m=
onospace, sans-serif;"><span class=3D"size" style=3D"font-size: 13px"><span=
 class=3D"colour" style=3D"color:#000000"><span class=3D"highlight" style=
=3D"background-color:#ffffff">&nbsp; </span></span></span></span></span><sp=
an class=3D"font" style=3D"font-family: menlo, consolas, monospace, sans-se=
rif;"><span class=3D"size" style=3D"font-size: 13px"><span class=3D"colour"=
 style=3D"color:#000000"><span class=3D"highlight" style=3D"background-colo=
r:#ffffff">: 20=3D0.33%, 50=3D67.57%, 100=3D28.78%, 250=3D3.12%, 500=3D0.13=
%</span></span></span></span></span><span class=3D"font" style=3D"font-fami=
ly: menlo, consolas, monospace, sans-serif;"><span class=3D"size" style=3D"=
font-size: 13px"><span class=3D"colour" style=3D"color:#000000"><span class=
=3D"highlight" style=3D"background-color:#ffffff"><br></span></span></span>=
</span></p><p style=3D"margin: 0px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; font-stretch: normal; line-height: normal;"><s=
pan style=3D"font-variant-ligatures: no-common-ligatures"><span class=3D"Ap=
ple-converted-space"><span class=3D"font" style=3D"font-family: menlo, cons=
olas, monospace, sans-serif;"><span class=3D"size" style=3D"font-size: 13px=
"><span class=3D"colour" style=3D"color:#000000"><span class=3D"highlight" =
style=3D"background-color:#ffffff">&nbsp; </span></span></span></span></spa=
n><span class=3D"font" style=3D"font-family: menlo, consolas, monospace, sa=
ns-serif;"><span class=3D"size" style=3D"font-size: 13px"><span class=3D"co=
lour" style=3D"color:#000000"><span class=3D"highlight" style=3D"background=
-color:#ffffff">lat (usec) </span></span></span></span><span class=3D"Apple=
-converted-space"><span class=3D"font" style=3D"font-family: menlo, consola=
s, monospace, sans-serif;"><span class=3D"size" style=3D"font-size: 13px"><=
span class=3D"colour" style=3D"color:#000000"><span class=3D"highlight" sty=
le=3D"background-color:#ffffff">&nbsp; </span></span></span></span></span><=
span class=3D"font" style=3D"font-family: menlo, consolas, monospace, sans-=
serif;"><span class=3D"size" style=3D"font-size: 13px"><span class=3D"colou=
r" style=3D"color:#000000"><span class=3D"highlight" style=3D"background-co=
lor:#ffffff">: 750=3D0.01%, 1000=3D0.01%</span></span></span></span></span>=
<span class=3D"font" style=3D"font-family: menlo, consolas, monospace, sans=
-serif;"><span class=3D"size" style=3D"font-size: 13px"><span class=3D"colo=
ur" style=3D"color:#000000"><span class=3D"highlight" style=3D"background-c=
olor:#ffffff"><br></span></span></span></span></p><p style=3D"margin: 0px; =
font-style: normal; font-variant-caps: normal; font-weight: normal; font-st=
retch: normal; line-height: normal;"><span style=3D"font-variant-ligatures:=
 no-common-ligatures"><span class=3D"Apple-converted-space"><span class=3D"=
font" style=3D"font-family: menlo, consolas, monospace, sans-serif;"><span =
class=3D"size" style=3D"font-size: 13px"><span class=3D"colour" style=3D"co=
lor:#000000"><span class=3D"highlight" style=3D"background-color:#ffffff">&=
nbsp; </span></span></span></span></span><span class=3D"font" style=3D"font=
-family: menlo, consolas, monospace, sans-serif;"><span class=3D"size" styl=
e=3D"font-size: 13px"><span class=3D"colour" style=3D"color:#000000"><span =
class=3D"highlight" style=3D"background-color:#ffffff">lat (msec) </span></=
span></span></span><span class=3D"Apple-converted-space"><span class=3D"fon=
t" style=3D"font-family: menlo, consolas, monospace, sans-serif;"><span cla=
ss=3D"size" style=3D"font-size: 13px"><span class=3D"colour" style=3D"color=
:#000000"><span class=3D"highlight" style=3D"background-color:#ffffff">&nbs=
p; </span></span></span></span></span><span class=3D"font" style=3D"font-fa=
mily: menlo, consolas, monospace, sans-serif;"><span class=3D"size" style=
=3D"font-size: 13px"><span class=3D"colour" style=3D"color:#000000"><span c=
lass=3D"highlight" style=3D"background-color:#ffffff">: 2=3D0.01%, 4=3D0.01=
%, 20=3D0.05%</span></span></span></span></span><span class=3D"font" style=
=3D"font-family: menlo, consolas, monospace, sans-serif;"><span class=3D"si=
ze" style=3D"font-size: 13px"><span class=3D"colour" style=3D"color:#000000=
"><span class=3D"highlight" style=3D"background-color:#ffffff"><br></span><=
/span></span></span></p><p style=3D"margin: 0px; font-style: normal; font-v=
ariant-caps: normal; font-weight: normal; font-stretch: normal; line-height=
: normal;"><span style=3D"font-variant-ligatures: no-common-ligatures"><spa=
n class=3D"Apple-converted-space"><span class=3D"font" style=3D"font-family=
: menlo, consolas, monospace, sans-serif;"><span class=3D"size" style=3D"fo=
nt-size: 13px"><span class=3D"colour" style=3D"color:#000000"><span class=
=3D"highlight" style=3D"background-color:#ffffff">&nbsp; </span></span></sp=
an></span></span><span class=3D"font" style=3D"font-family: menlo, consolas=
, monospace, sans-serif;"><span class=3D"size" style=3D"font-size: 13px"><s=
pan class=3D"colour" style=3D"color:#000000"><span class=3D"highlight" styl=
e=3D"background-color:#ffffff">cpu</span></span></span></span><span class=
=3D"Apple-converted-space"><span class=3D"font" style=3D"font-family: menlo=
, consolas, monospace, sans-serif;"><span class=3D"size" style=3D"font-size=
: 13px"><span class=3D"colour" style=3D"color:#000000"><span class=3D"highl=
ight" style=3D"background-color:#ffffff">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;=
 </span></span></span></span></span><span class=3D"font" style=3D"font-fami=
ly: menlo, consolas, monospace, sans-serif;"><span class=3D"size" style=3D"=
font-size: 13px"><span class=3D"colour" style=3D"color:#000000"><span class=
=3D"highlight" style=3D"background-color:#ffffff">: usr=3D5.08%, sys=3D90.2=
7%, ctx=3D40602, majf=3D0, minf=3D0</span></span></span></span></span><span=
 class=3D"font" style=3D"font-family: menlo, consolas, monospace, sans-seri=
f;"><span class=3D"size" style=3D"font-size: 13px"><span class=3D"colour" s=
tyle=3D"color:#000000"><span class=3D"highlight" style=3D"background-color:=
#ffffff"><br></span></span></span></span></p><p style=3D"margin: 0px; font-=
style: normal; font-variant-caps: normal; font-weight: normal; font-stretch=
: normal; line-height: normal;"><span style=3D"font-variant-ligatures: no-c=
ommon-ligatures"><span class=3D"Apple-converted-space"><span class=3D"font"=
 style=3D"font-family: menlo, consolas, monospace, sans-serif;"><span class=
=3D"size" style=3D"font-size: 13px"><span class=3D"colour" style=3D"color:#=
000000"><span class=3D"highlight" style=3D"background-color:#ffffff">&nbsp;=
 </span></span></span></span></span><span class=3D"font" style=3D"font-fami=
ly: menlo, consolas, monospace, sans-serif;"><span class=3D"size" style=3D"=
font-size: 13px"><span class=3D"colour" style=3D"color:#000000"><span class=
=3D"highlight" style=3D"background-color:#ffffff">IO depths</span></span></=
span></span><span class=3D"Apple-converted-space"><span class=3D"font" styl=
e=3D"font-family: menlo, consolas, monospace, sans-serif;"><span class=3D"s=
ize" style=3D"font-size: 13px"><span class=3D"colour" style=3D"color:#00000=
0"><span class=3D"highlight" style=3D"background-color:#ffffff">&nbsp; &nbs=
p; </span></span></span></span></span><span class=3D"font" style=3D"font-fa=
mily: menlo, consolas, monospace, sans-serif;"><span class=3D"size" style=
=3D"font-size: 13px"><span class=3D"colour" style=3D"color:#000000"><span c=
lass=3D"highlight" style=3D"background-color:#ffffff">: 1=3D100.0%, 2=3D0.0=
%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, &gt;=3D64=3D0.0%</span></span>=
</span></span></span><span class=3D"font" style=3D"font-family: menlo, cons=
olas, monospace, sans-serif;"><span class=3D"size" style=3D"font-size: 13px=
"><span class=3D"colour" style=3D"color:#000000"><span class=3D"highlight" =
style=3D"background-color:#ffffff"><br></span></span></span></span></p><p s=
tyle=3D"margin: 0px; font-style: normal; font-variant-caps: normal; font-we=
ight: normal; font-stretch: normal; line-height: normal;"><span style=3D"fo=
nt-variant-ligatures: no-common-ligatures"><span class=3D"Apple-converted-s=
pace"><span class=3D"font" style=3D"font-family: menlo, consolas, monospace=
, sans-serif;"><span class=3D"size" style=3D"font-size: 13px"><span class=
=3D"colour" style=3D"color:#000000"><span class=3D"highlight" style=3D"back=
ground-color:#ffffff">&nbsp;&nbsp; &nbsp; </span></span></span></span></spa=
n><span class=3D"font" style=3D"font-family: menlo, consolas, monospace, sa=
ns-serif;"><span class=3D"size" style=3D"font-size: 13px"><span class=3D"co=
lour" style=3D"color:#000000"><span class=3D"highlight" style=3D"background=
-color:#ffffff">submit</span></span></span></span><span class=3D"Apple-conv=
erted-space"><span class=3D"font" style=3D"font-family: menlo, consolas, mo=
nospace, sans-serif;"><span class=3D"size" style=3D"font-size: 13px"><span =
class=3D"colour" style=3D"color:#000000"><span class=3D"highlight" style=3D=
"background-color:#ffffff">&nbsp; &nbsp; </span></span></span></span></span=
><span class=3D"font" style=3D"font-family: menlo, consolas, monospace, san=
s-serif;"><span class=3D"size" style=3D"font-size: 13px"><span class=3D"col=
our" style=3D"color:#000000"><span class=3D"highlight" style=3D"background-=
color:#ffffff">: 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, &gt;=3D64=3D0.0%</span></span></span></span></span><span class=3D"=
font" style=3D"font-family: menlo, consolas, monospace, sans-serif;"><span =
class=3D"size" style=3D"font-size: 13px"><span class=3D"colour" style=3D"co=
lor:#000000"><span class=3D"highlight" style=3D"background-color:#ffffff"><=
br></span></span></span></span></p><p style=3D"margin: 0px; font-style: nor=
mal; font-variant-caps: normal; font-weight: normal; font-stretch: normal; =
line-height: normal;"><span style=3D"font-variant-ligatures: no-common-liga=
tures"><span class=3D"Apple-converted-space"><span class=3D"font" style=3D"=
font-family: menlo, consolas, monospace, sans-serif;"><span class=3D"size" =
style=3D"font-size: 13px"><span class=3D"colour" style=3D"color:#000000"><s=
pan class=3D"highlight" style=3D"background-color:#ffffff">&nbsp;&nbsp; &nb=
sp; </span></span></span></span></span><span class=3D"font" style=3D"font-f=
amily: menlo, consolas, monospace, sans-serif;"><span class=3D"size" style=
=3D"font-size: 13px"><span class=3D"colour" style=3D"color:#000000"><span c=
lass=3D"highlight" style=3D"background-color:#ffffff">complete</span></span=
></span></span><span class=3D"Apple-converted-space"><span class=3D"font" s=
tyle=3D"font-family: menlo, consolas, monospace, sans-serif;"><span class=
=3D"size" style=3D"font-size: 13px"><span class=3D"colour" style=3D"color:#=
000000"><span class=3D"highlight" style=3D"background-color:#ffffff">&nbsp;=
 </span></span></span></span></span><span class=3D"font" style=3D"font-fami=
ly: menlo, consolas, monospace, sans-serif;"><span class=3D"size" style=3D"=
font-size: 13px"><span class=3D"colour" style=3D"color:#000000"><span class=
=3D"highlight" style=3D"background-color:#ffffff">: 0=3D0.0%, 4=3D100.0%, 8=
=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=3D0.0%, &gt;=3D64=3D0.0%</span></span></s=
pan></span></span><span class=3D"font" style=3D"font-family: menlo, consola=
s, monospace, sans-serif;"><span class=3D"size" style=3D"font-size: 13px"><=
span class=3D"colour" style=3D"color:#000000"><span class=3D"highlight" sty=
le=3D"background-color:#ffffff"><br></span></span></span></span></p><p styl=
e=3D"margin: 0px; font-style: normal; font-variant-caps: normal; font-weigh=
t: normal; font-stretch: normal; line-height: normal;"><span style=3D"font-=
variant-ligatures: no-common-ligatures"><span class=3D"Apple-converted-spac=
e"><span class=3D"font" style=3D"font-family: menlo, consolas, monospace, s=
ans-serif;"><span class=3D"size" style=3D"font-size: 13px"><span class=3D"c=
olour" style=3D"color:#000000"><span class=3D"highlight" style=3D"backgroun=
d-color:#ffffff">&nbsp;&nbsp; &nbsp; </span></span></span></span></span><sp=
an class=3D"font" style=3D"font-family: menlo, consolas, monospace, sans-se=
rif;"><span class=3D"size" style=3D"font-size: 13px"><span class=3D"colour"=
 style=3D"color:#000000"><span class=3D"highlight" style=3D"background-colo=
r:#ffffff">issued rwts: total=3D0,131072,0,0 short=3D0,0,0,0 dropped=3D0,0,=
0,0</span></span></span></span></span><span class=3D"font" style=3D"font-fa=
mily: menlo, consolas, monospace, sans-serif;"><span class=3D"size" style=
=3D"font-size: 13px"><span class=3D"colour" style=3D"color:#000000"><span c=
lass=3D"highlight" style=3D"background-color:#ffffff"><br></span></span></s=
pan></span></p><p style=3D"margin: 0px; font-style: normal; font-variant-ca=
ps: normal; font-weight: normal; font-stretch: normal; line-height: normal;=
"><span style=3D"font-variant-ligatures: no-common-ligatures"><span class=
=3D"Apple-converted-space"><span class=3D"font" style=3D"font-family: menlo=
, consolas, monospace, sans-serif;"><span class=3D"size" style=3D"font-size=
: 13px"><span class=3D"colour" style=3D"color:#000000"><span class=3D"highl=
ight" style=3D"background-color:#ffffff">&nbsp;&nbsp; &nbsp; </span></span>=
</span></span></span><span class=3D"font" style=3D"font-family: menlo, cons=
olas, monospace, sans-serif;"><span class=3D"size" style=3D"font-size: 13px=
"><span class=3D"colour" style=3D"color:#000000"><span class=3D"highlight" =
style=3D"background-color:#ffffff">latency </span></span></span></span><spa=
n class=3D"Apple-converted-space"><span class=3D"font" style=3D"font-family=
: menlo, consolas, monospace, sans-serif;"><span class=3D"size" style=3D"fo=
nt-size: 13px"><span class=3D"colour" style=3D"color:#000000"><span class=
=3D"highlight" style=3D"background-color:#ffffff">&nbsp; </span></span></sp=
an></span></span><span class=3D"font" style=3D"font-family: menlo, consolas=
, monospace, sans-serif;"><span class=3D"size" style=3D"font-size: 13px"><s=
pan class=3D"colour" style=3D"color:#000000"><span class=3D"highlight" styl=
e=3D"background-color:#ffffff">: target=3D0, window=3D0, percentile=3D100.0=
0%, depth=3D1</span></span></span></span></span><span class=3D"font" style=
=3D"font-family: menlo, consolas, monospace, sans-serif;"><span class=3D"si=
ze" style=3D"font-size: 13px"><span class=3D"colour" style=3D"color:#000000=
"><span class=3D"highlight" style=3D"background-color:#ffffff"><br></span><=
/span></span></span></p><p style=3D"margin: 0px; font-style: normal; font-v=
ariant-caps: normal; font-weight: normal; font-stretch: normal; line-height=
: normal; min-height: 14px;"><span class=3D"font" style=3D"font-family: men=
lo, consolas, monospace, sans-serif;"><span class=3D"size" style=3D"font-si=
ze: 13px"><span class=3D"colour" style=3D"color:#000000"><span class=3D"hig=
hlight" style=3D"background-color:#ffffff"><br></span></span></span></span>=
</p><p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal;=
 font-weight: normal; font-stretch: normal; line-height: normal;"><span sty=
le=3D"font-variant-ligatures: no-common-ligatures"><span class=3D"font" sty=
le=3D"font-family: menlo, consolas, monospace, sans-serif;"><span class=3D"=
size" style=3D"font-size: 13px"><span class=3D"colour" style=3D"color:#0000=
00"><span class=3D"highlight" style=3D"background-color:#ffffff">Run status=
 group 0 (all jobs):</span></span></span></span></span><span class=3D"font"=
 style=3D"font-family: menlo, consolas, monospace, sans-serif;"><span class=
=3D"size" style=3D"font-size: 13px"><span class=3D"colour" style=3D"color:#=
000000"><span class=3D"highlight" style=3D"background-color:#ffffff"><br></=
span></span></span></span></p><p style=3D"margin: 0px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; font-stretch: normal; line-=
height: normal;"><span style=3D"font-variant-ligatures: no-common-ligatures=
"><span class=3D"Apple-converted-space"><span class=3D"font" style=3D"font-=
family: menlo, consolas, monospace, sans-serif;"><span class=3D"size" style=
=3D"font-size: 13px"><span class=3D"colour" style=3D"color:#000000"><span c=
lass=3D"highlight" style=3D"background-color:#ffffff">&nbsp; </span></span>=
</span></span></span><span class=3D"font" style=3D"font-family: menlo, cons=
olas, monospace, sans-serif;"><span class=3D"size" style=3D"font-size: 13px=
"><span class=3D"colour" style=3D"color:#000000"><span class=3D"highlight" =
style=3D"background-color:#ffffff">WRITE: bw=3D2065MiB/s (2165MB/s), 2065Mi=
B/s-2065MiB/s (2165MB/s-2165MB/s), io=3D16.0GiB (17.2GB), run=3D7935-7935ms=
ec</span></span></span></span></span><span class=3D"font" style=3D"font-fam=
ily: menlo, consolas, monospace, sans-serif;"><span class=3D"size" style=3D=
"font-size: 13px"><span class=3D"colour" style=3D"color:#000000"><span clas=
s=3D"highlight" style=3D"background-color:#ffffff"><br></span></span></span=
></span></p><p style=3D"margin: 0px; font-style: normal; font-variant-caps:=
 normal; font-weight: normal; font-stretch: normal; line-height: normal;"><=
span style=3D"font-variant-ligatures: no-common-ligatures"><span class=3D"f=
ont" style=3D"font-family: menlo, consolas, monospace, sans-serif;"><span c=
lass=3D"size" style=3D"font-size: 13px"><span class=3D"colour" style=3D"col=
or:#000000"><span class=3D"highlight" style=3D"background-color:#ffffff">ro=
ot@delorean:/sec_stor/backup/fiotest/fio-master # du -sh seqwrite.0.0</span=
></span></span></span><span class=3D"Apple-converted-space"><span class=3D"=
font" style=3D"font-family: menlo, consolas, monospace, sans-serif;"><span =
class=3D"size" style=3D"font-size: 13px"><span class=3D"colour" style=3D"co=
lor:#000000"><span class=3D"highlight" style=3D"background-color:#ffffff">&=
nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;=
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbs=
p; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &n=
bsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; </span></span></span></span></span><span class=3D"font" style=3D"font-f=
amily: menlo, consolas, monospace, sans-serif;"><span class=3D"size" style=
=3D"font-size: 13px"><span class=3D"colour" style=3D"color:#000000"><span c=
lass=3D"highlight" style=3D"background-color:#ffffff">16G</span></span></sp=
an></span><span style=3D"white-space:pre" class=3D"Apple-tab-span"><span cl=
ass=3D"font" style=3D"font-family: menlo, consolas, monospace, sans-serif;"=
><span class=3D"size" style=3D"font-size: 13px"><span class=3D"colour" styl=
e=3D"color:#000000"><span class=3D"highlight" style=3D"background-color:#ff=
ffff"> </span></span></span></span></span><span class=3D"font" style=3D"fon=
t-family: menlo, consolas, monospace, sans-serif;"><span class=3D"size" sty=
le=3D"font-size: 13px"><span class=3D"colour" style=3D"color:#000000"><span=
 class=3D"highlight" style=3D"background-color:#ffffff">seqwrite.0.0</span>=
</span></span></span></span><br></p><div style=3D"font-size:16px;"><br></di=
v>
<div style=3D"font-size:16px;">As you can see, it hits a throughput of 2065=
 MiB/s.<br></div>
<div style=3D"font-size:16px;"> <span class=3D"colour" style=3D"color:#0000=
ff">Question: Why such a drastic difference between dd and this?&nbsp;</spa=
n><br></div>
<p style=3D"font-style: normal; font-variant-caps: normal; font-weight: nor=
mal; letter-spacing: normal; text-indent: 0px; text-transform: none; white-=
space: normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; text-deco=
ration: none; margin: 0px 0px 1em; padding: 0px; border: 0px; font-stretch:=
 inherit; line-height: inherit; vertical-align: baseline; box-sizing: inher=
it; clear: both; caret-color: rgb(36, 39, 41); text-align: left;"><span cla=
ss=3D"colour" style=3D"color:rgb(36, 39, 41)"><span class=3D"font" style=3D=
"font-family:Arial, &quot;Helvetica Neue&quot;, Helvetica, sans-serif"><spa=
n class=3D"size" style=3D"font-size:15px">My understanding is that dd comma=
nd must have used<span class=3D"Apple-converted-space">&nbsp;</span><code s=
tyle=3D"margin: 0px; padding: 1px 5px; border: 0px; font-family: Consolas, =
Menlo, Monaco, &quot;Lucida Console&quot;, &quot;Liberation Mono&quot;, &qu=
ot;DejaVu Sans Mono&quot;, &quot;Bitstream Vera Sans Mono&quot;, &quot;Cour=
ier New&quot;, monospace, sans-serif; font-style: inherit; font-variant-cap=
s: inherit; font-weight: inherit; font-stretch: inherit; line-height: inher=
it; font-size: 13px; vertical-align: baseline; box-sizing: inherit; backgro=
und-color: rgb(239, 240, 241); white-space: pre-wrap;">create</code>call to=
 create a file, then issue<span class=3D"Apple-converted-space">&nbsp;</spa=
n><code style=3D"margin: 0px; padding: 1px 5px; border: 0px; font-family: C=
onsolas, Menlo, Monaco, &quot;Lucida Console&quot;, &quot;Liberation Mono&q=
uot;, &quot;DejaVu Sans Mono&quot;, &quot;Bitstream Vera Sans Mono&quot;, &=
quot;Courier New&quot;, monospace, sans-serif; font-style: inherit; font-va=
riant-caps: inherit; font-weight: inherit; font-stretch: inherit; line-heig=
ht: inherit; font-size: 13px; vertical-align: baseline; box-sizing: inherit=
; background-color: rgb(239, 240, 241); white-space: pre-wrap;">open</code>=
, and<span class=3D"Apple-converted-space">&nbsp;</span><code style=3D"marg=
in: 0px; padding: 1px 5px; border: 0px; font-family: Consolas, Menlo, Monac=
o, &quot;Lucida Console&quot;, &quot;Liberation Mono&quot;, &quot;DejaVu Sa=
ns Mono&quot;, &quot;Bitstream Vera Sans Mono&quot;, &quot;Courier New&quot=
;, monospace, sans-serif; font-style: inherit; font-variant-caps: inherit; =
font-weight: inherit; font-stretch: inherit; line-height: inherit; font-siz=
e: 13px; vertical-align: baseline; box-sizing: inherit; background-color: r=
gb(239, 240, 241); white-space: pre-wrap;">write</code><span class=3D"Apple=
-converted-space">&nbsp;</span>calls to write the random data into the open=
 file. Finally<span class=3D"Apple-converted-space">&nbsp;</span><code styl=
e=3D"margin: 0px; padding: 1px 5px; border: 0px; font-family: Consolas, Men=
lo, Monaco, &quot;Lucida Console&quot;, &quot;Liberation Mono&quot;, &quot;=
DejaVu Sans Mono&quot;, &quot;Bitstream Vera Sans Mono&quot;, &quot;Courier=
 New&quot;, monospace, sans-serif; font-style: inherit; font-variant-caps: =
inherit; font-weight: inherit; font-stretch: inherit; line-height: inherit;=
 font-size: 13px; vertical-align: baseline; box-sizing: inherit; background=
-color: rgb(239, 240, 241); white-space: pre-wrap;">close</code>the file. I=
 chose block size of 128 K to match with ZFS default record size.<span clas=
s=3D"Apple-converted-space">&nbsp;</span></span></span></span><br></p><p st=
yle=3D"font-style: normal; font-variant-caps: normal; font-weight: normal; =
letter-spacing: normal; text-indent: 0px; text-transform: none; white-space=
: normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoratio=
n: none; margin: 0px 0px 1em; padding: 0px; border: 0px; font-stretch: inhe=
rit; line-height: inherit; vertical-align: baseline; box-sizing: inherit; c=
lear: both; caret-color: rgb(36, 39, 41); text-align: left;"><span class=3D=
"colour" style=3D"color:rgb(36, 39, 41)"><span class=3D"font" style=3D"font=
-family:Arial, &quot;Helvetica Neue&quot;, Helvetica, sans-serif"><span cla=
ss=3D"size" style=3D"font-size:15px">The fio test should be measuring just =
the<span class=3D"Apple-converted-space">&nbsp;</span><code style=3D"margin=
: 0px; padding: 1px 5px; border: 0px; font-family: Consolas, Menlo, Monaco,=
 &quot;Lucida Console&quot;, &quot;Liberation Mono&quot;, &quot;DejaVu Sans=
 Mono&quot;, &quot;Bitstream Vera Sans Mono&quot;, &quot;Courier New&quot;,=
 monospace, sans-serif; font-style: inherit; font-variant-caps: inherit; fo=
nt-weight: inherit; font-stretch: inherit; line-height: inherit; font-size:=
 13px; vertical-align: baseline; box-sizing: inherit; background-color: rgb=
(239, 240, 241); white-space: pre-wrap;">write</code><span class=3D"Apple-c=
onverted-space">&nbsp;</span>calls, but everything else, the same. Why is t=
here so much difference in throughput?</span></span></span><br></p><div sty=
le=3D"font-size:16px;">While that question is still open in mind, I venture=
d into testing with compressible data.<br></div>
<div style=3D"font-size:16px;"><br></div>
<div style=3D"font-size:16px;"><b><u>Test # 3:</u></b></div>
<div style=3D"font-size:16px;">Run fio with buffer_compress_percent=3D0 (0%=
 compression) - My expectation is this to match the results of test #2. But=
, it didnt actually create 0% compressible data. More like 100% compressibl=
e data!&nbsp;<br></div>
<div style=3D"font-size:16px;"><br></div>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; fon=
t-weight: normal; font-stretch: normal; line-height: normal;"><span style=
=3D"font-variant-ligatures: no-common-ligatures"><span class=3D"font" style=
=3D"font-family: menlo, consolas, monospace, sans-serif;"><span class=3D"si=
ze" style=3D"font-size: 13px"><span class=3D"colour" style=3D"color:#000000=
"><span class=3D"highlight" style=3D"background-color:#ffffff">root@delorea=
n:/sec_stor/backup/fiotest/fio-master # ./fio --name=3Dseqwrite --rw=3Dwrit=
e --bs=3D128k --numjobs=3D1 --size=3D16G --runtime=3D60 --iodepth=3D1 --buf=
fer_compress_percentage=3D0 --buffer_pattern=3D0xdeadbeef --refill_buffers =
--group_reporting</span></span></span></span></span><span class=3D"font" st=
yle=3D"font-family: menlo, consolas, monospace, sans-serif;"><span class=3D=
"size" style=3D"font-size: 13px"><span class=3D"colour" style=3D"color:#000=
000"><span class=3D"highlight" style=3D"background-color:#ffffff"><br></spa=
n></span></span></span></p><p style=3D"margin: 0px; font-style: normal; fon=
t-variant-caps: normal; font-weight: normal; font-stretch: normal; line-hei=
ght: normal;"><span style=3D"font-variant-ligatures: no-common-ligatures"><=
span class=3D"font" style=3D"font-family: menlo, consolas, monospace, sans-=
serif;"><span class=3D"size" style=3D"font-size: 13px"><span class=3D"colou=
r" style=3D"color:#000000"><span class=3D"highlight" style=3D"background-co=
lor:#ffffff">seqwrite: (g=3D0): rw=3Dwrite, bs=3D(R) 128KiB-128KiB, (W) 128=
KiB-128KiB, (T) 128KiB-128KiB, ioengine=3Dpsync, iodepth=3D1</span></span><=
/span></span></span><span class=3D"font" style=3D"font-family: menlo, conso=
las, monospace, sans-serif;"><span class=3D"size" style=3D"font-size: 13px"=
><span class=3D"colour" style=3D"color:#000000"><span class=3D"highlight" s=
tyle=3D"background-color:#ffffff"><br></span></span></span></span></p><p st=
yle=3D"margin: 0px; font-style: normal; font-variant-caps: normal; font-wei=
ght: normal; font-stretch: normal; line-height: normal;"><span style=3D"fon=
t-variant-ligatures: no-common-ligatures"><span class=3D"font" style=3D"fon=
t-family: menlo, consolas, monospace, sans-serif;"><span class=3D"size" sty=
le=3D"font-size: 13px"><span class=3D"colour" style=3D"color:#000000"><span=
 class=3D"highlight" style=3D"background-color:#ffffff">fio-3.8</span></spa=
n></span></span></span><span class=3D"font" style=3D"font-family: menlo, co=
nsolas, monospace, sans-serif;"><span class=3D"size" style=3D"font-size: 13=
px"><span class=3D"colour" style=3D"color:#000000"><span class=3D"highlight=
" style=3D"background-color:#ffffff"><br></span></span></span></span></p><p=
 style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; font-=
weight: normal; font-stretch: normal; line-height: normal;"><span style=3D"=
font-variant-ligatures: no-common-ligatures"><span class=3D"font" style=3D"=
font-family: menlo, consolas, monospace, sans-serif;"><span class=3D"size" =
style=3D"font-size: 13px"><span class=3D"colour" style=3D"color:#000000"><s=
pan class=3D"highlight" style=3D"background-color:#ffffff">Starting 1 proce=
ss</span></span></span></span></span><span class=3D"font" style=3D"font-fam=
ily: menlo, consolas, monospace, sans-serif;"><span class=3D"size" style=3D=
"font-size: 13px"><span class=3D"colour" style=3D"color:#000000"><span clas=
s=3D"highlight" style=3D"background-color:#ffffff"><br></span></span></span=
></span></p><p style=3D"margin: 0px; font-style: normal; font-variant-caps:=
 normal; font-weight: normal; font-stretch: normal; line-height: normal;"><=
span style=3D"font-variant-ligatures: no-common-ligatures"><span class=3D"f=
ont" style=3D"font-family: menlo, consolas, monospace, sans-serif;"><span c=
lass=3D"size" style=3D"font-size: 13px"><span class=3D"colour" style=3D"col=
or:#000000"><span class=3D"highlight" style=3D"background-color:#ffffff">Jo=
bs: 1 (f=3D1): [W(1)][100.0%][r=3D0KiB/s,w=3D2470MiB/s][r=3D0,w=3D19.8k IOP=
S][eta 00m:00s]</span></span></span></span></span><span class=3D"font" styl=
e=3D"font-family: menlo, consolas, monospace, sans-serif;"><span class=3D"s=
ize" style=3D"font-size: 13px"><span class=3D"colour" style=3D"color:#00000=
0"><span class=3D"highlight" style=3D"background-color:#ffffff"><br></span>=
</span></span></span></p><p style=3D"margin: 0px; font-style: normal; font-=
variant-caps: normal; font-weight: normal; font-stretch: normal; line-heigh=
t: normal;"><span style=3D"font-variant-ligatures: no-common-ligatures"><sp=
an class=3D"font" style=3D"font-family: menlo, consolas, monospace, sans-se=
rif;"><span class=3D"size" style=3D"font-size: 13px"><span class=3D"colour"=
 style=3D"color:#000000"><span class=3D"highlight" style=3D"background-colo=
r:#ffffff">seqwrite: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D10204: Wed Ju=
l 25 14:14:22 2018</span></span></span></span></span><span class=3D"font" s=
tyle=3D"font-family: menlo, consolas, monospace, sans-serif;"><span class=
=3D"size" style=3D"font-size: 13px"><span class=3D"colour" style=3D"color:#=
000000"><span class=3D"highlight" style=3D"background-color:#ffffff"><br></=
span></span></span></span></p><p style=3D"margin: 0px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; font-stretch: normal; line-=
height: normal;"><span style=3D"font-variant-ligatures: no-common-ligatures=
"><span class=3D"Apple-converted-space"><span class=3D"font" style=3D"font-=
family: menlo, consolas, monospace, sans-serif;"><span class=3D"size" style=
=3D"font-size: 13px"><span class=3D"colour" style=3D"color:#000000"><span c=
lass=3D"highlight" style=3D"background-color:#ffffff">&nbsp; </span></span>=
</span></span></span><span class=3D"font" style=3D"font-family: menlo, cons=
olas, monospace, sans-serif;"><span class=3D"size" style=3D"font-size: 13px=
"><span class=3D"colour" style=3D"color:#000000"><span class=3D"highlight" =
style=3D"background-color:#ffffff">write: IOPS=3D19.8k, BW=3D2477MiB/s (259=
7MB/s)(16.0GiB/6615msec)</span></span></span></span></span><span class=3D"f=
ont" style=3D"font-family: menlo, consolas, monospace, sans-serif;"><span c=
lass=3D"size" style=3D"font-size: 13px"><span class=3D"colour" style=3D"col=
or:#000000"><span class=3D"highlight" style=3D"background-color:#ffffff"><b=
r></span></span></span></span></p><p style=3D"margin: 0px; font-style: norm=
al; font-variant-caps: normal; font-weight: normal; font-stretch: normal; l=
ine-height: normal;"><span style=3D"font-variant-ligatures: no-common-ligat=
ures"><span class=3D"Apple-converted-space"><span class=3D"font" style=3D"f=
ont-family: menlo, consolas, monospace, sans-serif;"><span class=3D"size" s=
tyle=3D"font-size: 13px"><span class=3D"colour" style=3D"color:#000000"><sp=
an class=3D"highlight" style=3D"background-color:#ffffff">&nbsp; &nbsp; </s=
pan></span></span></span></span><span class=3D"font" style=3D"font-family: =
menlo, consolas, monospace, sans-serif;"><span class=3D"size" style=3D"font=
-size: 13px"><span class=3D"colour" style=3D"color:#000000"><span class=3D"=
highlight" style=3D"background-color:#ffffff">clat (usec): min=3D25, max=3D=
529, avg=3D45.34, stdev=3D 7.71</span></span></span></span></span><span cla=
ss=3D"font" style=3D"font-family: menlo, consolas, monospace, sans-serif;">=
<span class=3D"size" style=3D"font-size: 13px"><span class=3D"colour" style=
=3D"color:#000000"><span class=3D"highlight" style=3D"background-color:#fff=
fff"><br></span></span></span></span></p><p style=3D"margin: 0px; font-styl=
e: normal; font-variant-caps: normal; font-weight: normal; font-stretch: no=
rmal; line-height: normal;"><span style=3D"font-variant-ligatures: no-commo=
n-ligatures"><span class=3D"Apple-converted-space"><span class=3D"font" sty=
le=3D"font-family: menlo, consolas, monospace, sans-serif;"><span class=3D"=
size" style=3D"font-size: 13px"><span class=3D"colour" style=3D"color:#0000=
00"><span class=3D"highlight" style=3D"background-color:#ffffff">&nbsp;&nbs=
p; &nbsp; </span></span></span></span></span><span class=3D"font" style=3D"=
font-family: menlo, consolas, monospace, sans-serif;"><span class=3D"size" =
style=3D"font-size: 13px"><span class=3D"colour" style=3D"color:#000000"><s=
pan class=3D"highlight" style=3D"background-color:#ffffff">lat (usec): min=
=3D25, max=3D532, avg=3D45.39, stdev=3D 7.73</span></span></span></span></s=
pan><span class=3D"font" style=3D"font-family: menlo, consolas, monospace, =
sans-serif;"><span class=3D"size" style=3D"font-size: 13px"><span class=3D"=
colour" style=3D"color:#000000"><span class=3D"highlight" style=3D"backgrou=
nd-color:#ffffff"><br></span></span></span></span></p><p style=3D"margin: 0=
px; font-style: normal; font-variant-caps: normal; font-weight: normal; fon=
t-stretch: normal; line-height: normal;"><span style=3D"font-variant-ligatu=
res: no-common-ligatures"><span class=3D"Apple-converted-space"><span class=
=3D"font" style=3D"font-family: menlo, consolas, monospace, sans-serif;"><s=
pan class=3D"size" style=3D"font-size: 13px"><span class=3D"colour" style=
=3D"color:#000000"><span class=3D"highlight" style=3D"background-color:#fff=
fff">&nbsp; &nbsp; </span></span></span></span></span><span class=3D"font" =
style=3D"font-family: menlo, consolas, monospace, sans-serif;"><span class=
=3D"size" style=3D"font-size: 13px"><span class=3D"colour" style=3D"color:#=
000000"><span class=3D"highlight" style=3D"background-color:#ffffff">clat p=
ercentiles (usec):</span></span></span></span></span><span class=3D"font" s=
tyle=3D"font-family: menlo, consolas, monospace, sans-serif;"><span class=
=3D"size" style=3D"font-size: 13px"><span class=3D"colour" style=3D"color:#=
000000"><span class=3D"highlight" style=3D"background-color:#ffffff"><br></=
span></span></span></span></p><p style=3D"margin: 0px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; font-stretch: normal; line-=
height: normal;"><span style=3D"font-variant-ligatures: no-common-ligatures=
"><span class=3D"Apple-converted-space"><span class=3D"font" style=3D"font-=
family: menlo, consolas, monospace, sans-serif;"><span class=3D"size" style=
=3D"font-size: 13px"><span class=3D"colour" style=3D"color:#000000"><span c=
lass=3D"highlight" style=3D"background-color:#ffffff">&nbsp;&nbsp; &nbsp; <=
/span></span></span></span></span><span class=3D"font" style=3D"font-family=
: menlo, consolas, monospace, sans-serif;"><span class=3D"size" style=3D"fo=
nt-size: 13px"><span class=3D"colour" style=3D"color:#000000"><span class=
=3D"highlight" style=3D"background-color:#ffffff">|</span></span></span></s=
pan><span class=3D"Apple-converted-space"><span class=3D"font" style=3D"fon=
t-family: menlo, consolas, monospace, sans-serif;"><span class=3D"size" sty=
le=3D"font-size: 13px"><span class=3D"colour" style=3D"color:#000000"><span=
 class=3D"highlight" style=3D"background-color:#ffffff">&nbsp; </span></spa=
n></span></span></span><span class=3D"font" style=3D"font-family: menlo, co=
nsolas, monospace, sans-serif;"><span class=3D"size" style=3D"font-size: 13=
px"><span class=3D"colour" style=3D"color:#000000"><span class=3D"highlight=
" style=3D"background-color:#ffffff">1.00th=3D[ </span></span></span></span=
><span class=3D"Apple-converted-space"><span class=3D"font" style=3D"font-f=
amily: menlo, consolas, monospace, sans-serif;"><span class=3D"size" style=
=3D"font-size: 13px"><span class=3D"colour" style=3D"color:#000000"><span c=
lass=3D"highlight" style=3D"background-color:#ffffff">&nbsp; </span></span>=
</span></span></span><span class=3D"font" style=3D"font-family: menlo, cons=
olas, monospace, sans-serif;"><span class=3D"size" style=3D"font-size: 13px=
"><span class=3D"colour" style=3D"color:#000000"><span class=3D"highlight" =
style=3D"background-color:#ffffff">34],</span></span></span></span><span cl=
ass=3D"Apple-converted-space"><span class=3D"font" style=3D"font-family: me=
nlo, consolas, monospace, sans-serif;"><span class=3D"size" style=3D"font-s=
ize: 13px"><span class=3D"colour" style=3D"color:#000000"><span class=3D"hi=
ghlight" style=3D"background-color:#ffffff">&nbsp; </span></span></span></s=
pan></span><span class=3D"font" style=3D"font-family: menlo, consolas, mono=
space, sans-serif;"><span class=3D"size" style=3D"font-size: 13px"><span cl=
ass=3D"colour" style=3D"color:#000000"><span class=3D"highlight" style=3D"b=
ackground-color:#ffffff">5.00th=3D[ </span></span></span></span><span class=
=3D"Apple-converted-space"><span class=3D"font" style=3D"font-family: menlo=
, consolas, monospace, sans-serif;"><span class=3D"size" style=3D"font-size=
: 13px"><span class=3D"colour" style=3D"color:#000000"><span class=3D"highl=
ight" style=3D"background-color:#ffffff">&nbsp; </span></span></span></span=
></span><span class=3D"font" style=3D"font-family: menlo, consolas, monospa=
ce, sans-serif;"><span class=3D"size" style=3D"font-size: 13px"><span class=
=3D"colour" style=3D"color:#000000"><span class=3D"highlight" style=3D"back=
ground-color:#ffffff">39], 10.00th=3D[ </span></span></span></span><span cl=
ass=3D"Apple-converted-space"><span class=3D"font" style=3D"font-family: me=
nlo, consolas, monospace, sans-serif;"><span class=3D"size" style=3D"font-s=
ize: 13px"><span class=3D"colour" style=3D"color:#000000"><span class=3D"hi=
ghlight" style=3D"background-color:#ffffff">&nbsp; </span></span></span></s=
pan></span><span class=3D"font" style=3D"font-family: menlo, consolas, mono=
space, sans-serif;"><span class=3D"size" style=3D"font-size: 13px"><span cl=
ass=3D"colour" style=3D"color:#000000"><span class=3D"highlight" style=3D"b=
ackground-color:#ffffff">41], 20.00th=3D[ </span></span></span></span><span=
 class=3D"Apple-converted-space"><span class=3D"font" style=3D"font-family:=
 menlo, consolas, monospace, sans-serif;"><span class=3D"size" style=3D"fon=
t-size: 13px"><span class=3D"colour" style=3D"color:#000000"><span class=3D=
"highlight" style=3D"background-color:#ffffff">&nbsp; </span></span></span>=
</span></span><span class=3D"font" style=3D"font-family: menlo, consolas, m=
onospace, sans-serif;"><span class=3D"size" style=3D"font-size: 13px"><span=
 class=3D"colour" style=3D"color:#000000"><span class=3D"highlight" style=
=3D"background-color:#ffffff">42],</span></span></span></span></span><span =
class=3D"font" style=3D"font-family: menlo, consolas, monospace, sans-serif=
;"><span class=3D"size" style=3D"font-size: 13px"><span class=3D"colour" st=
yle=3D"color:#000000"><span class=3D"highlight" style=3D"background-color:#=
ffffff"><br></span></span></span></span></p><p style=3D"margin: 0px; font-s=
tyle: normal; font-variant-caps: normal; font-weight: normal; font-stretch:=
 normal; line-height: normal;"><span style=3D"font-variant-ligatures: no-co=
mmon-ligatures"><span class=3D"Apple-converted-space"><span class=3D"font" =
style=3D"font-family: menlo, consolas, monospace, sans-serif;"><span class=
=3D"size" style=3D"font-size: 13px"><span class=3D"colour" style=3D"color:#=
000000"><span class=3D"highlight" style=3D"background-color:#ffffff">&nbsp;=
&nbsp; &nbsp; </span></span></span></span></span><span class=3D"font" style=
=3D"font-family: menlo, consolas, monospace, sans-serif;"><span class=3D"si=
ze" style=3D"font-size: 13px"><span class=3D"colour" style=3D"color:#000000=
"><span class=3D"highlight" style=3D"background-color:#ffffff">| 30.00th=3D=
[ </span></span></span></span><span class=3D"Apple-converted-space"><span c=
lass=3D"font" style=3D"font-family: menlo, consolas, monospace, sans-serif;=
"><span class=3D"size" style=3D"font-size: 13px"><span class=3D"colour" sty=
le=3D"color:#000000"><span class=3D"highlight" style=3D"background-color:#f=
fffff">&nbsp; </span></span></span></span></span><span class=3D"font" style=
=3D"font-family: menlo, consolas, monospace, sans-serif;"><span class=3D"si=
ze" style=3D"font-size: 13px"><span class=3D"colour" style=3D"color:#000000=
"><span class=3D"highlight" style=3D"background-color:#ffffff">42], 40.00th=
=3D[ </span></span></span></span><span class=3D"Apple-converted-space"><spa=
n class=3D"font" style=3D"font-family: menlo, consolas, monospace, sans-ser=
if;"><span class=3D"size" style=3D"font-size: 13px"><span class=3D"colour" =
style=3D"color:#000000"><span class=3D"highlight" style=3D"background-color=
:#ffffff">&nbsp; </span></span></span></span></span><span class=3D"font" st=
yle=3D"font-family: menlo, consolas, monospace, sans-serif;"><span class=3D=
"size" style=3D"font-size: 13px"><span class=3D"colour" style=3D"color:#000=
000"><span class=3D"highlight" style=3D"background-color:#ffffff">43], 50.0=
0th=3D[ </span></span></span></span><span class=3D"Apple-converted-space"><=
span class=3D"font" style=3D"font-family: menlo, consolas, monospace, sans-=
serif;"><span class=3D"size" style=3D"font-size: 13px"><span class=3D"colou=
r" style=3D"color:#000000"><span class=3D"highlight" style=3D"background-co=
lor:#ffffff">&nbsp; </span></span></span></span></span><span class=3D"font"=
 style=3D"font-family: menlo, consolas, monospace, sans-serif;"><span class=
=3D"size" style=3D"font-size: 13px"><span class=3D"colour" style=3D"color:#=
000000"><span class=3D"highlight" style=3D"background-color:#ffffff">44], 6=
0.00th=3D[ </span></span></span></span><span class=3D"Apple-converted-space=
"><span class=3D"font" style=3D"font-family: menlo, consolas, monospace, sa=
ns-serif;"><span class=3D"size" style=3D"font-size: 13px"><span class=3D"co=
lour" style=3D"color:#000000"><span class=3D"highlight" style=3D"background=
-color:#ffffff">&nbsp; </span></span></span></span></span><span class=3D"fo=
nt" style=3D"font-family: menlo, consolas, monospace, sans-serif;"><span cl=
ass=3D"size" style=3D"font-size: 13px"><span class=3D"colour" style=3D"colo=
r:#000000"><span class=3D"highlight" style=3D"background-color:#ffffff">45]=
,</span></span></span></span></span><span class=3D"font" style=3D"font-fami=
ly: menlo, consolas, monospace, sans-serif;"><span class=3D"size" style=3D"=
font-size: 13px"><span class=3D"colour" style=3D"color:#000000"><span class=
=3D"highlight" style=3D"background-color:#ffffff"><br></span></span></span>=
</span></p><p style=3D"margin: 0px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; font-stretch: normal; line-height: normal;"><s=
pan style=3D"font-variant-ligatures: no-common-ligatures"><span class=3D"Ap=
ple-converted-space"><span class=3D"font" style=3D"font-family: menlo, cons=
olas, monospace, sans-serif;"><span class=3D"size" style=3D"font-size: 13px=
"><span class=3D"colour" style=3D"color:#000000"><span class=3D"highlight" =
style=3D"background-color:#ffffff">&nbsp;&nbsp; &nbsp; </span></span></span=
></span></span><span class=3D"font" style=3D"font-family: menlo, consolas, =
monospace, sans-serif;"><span class=3D"size" style=3D"font-size: 13px"><spa=
n class=3D"colour" style=3D"color:#000000"><span class=3D"highlight" style=
=3D"background-color:#ffffff">| 70.00th=3D[ </span></span></span></span><sp=
an class=3D"Apple-converted-space"><span class=3D"font" style=3D"font-famil=
y: menlo, consolas, monospace, sans-serif;"><span class=3D"size" style=3D"f=
ont-size: 13px"><span class=3D"colour" style=3D"color:#000000"><span class=
=3D"highlight" style=3D"background-color:#ffffff">&nbsp; </span></span></sp=
an></span></span><span class=3D"font" style=3D"font-family: menlo, consolas=
, monospace, sans-serif;"><span class=3D"size" style=3D"font-size: 13px"><s=
pan class=3D"colour" style=3D"color:#000000"><span class=3D"highlight" styl=
e=3D"background-color:#ffffff">46], 80.00th=3D[ </span></span></span></span=
><span class=3D"Apple-converted-space"><span class=3D"font" style=3D"font-f=
amily: menlo, consolas, monospace, sans-serif;"><span class=3D"size" style=
=3D"font-size: 13px"><span class=3D"colour" style=3D"color:#000000"><span c=
lass=3D"highlight" style=3D"background-color:#ffffff">&nbsp; </span></span>=
</span></span></span><span class=3D"font" style=3D"font-family: menlo, cons=
olas, monospace, sans-serif;"><span class=3D"size" style=3D"font-size: 13px=
"><span class=3D"colour" style=3D"color:#000000"><span class=3D"highlight" =
style=3D"background-color:#ffffff">49], 90.00th=3D[ </span></span></span></=
span><span class=3D"Apple-converted-space"><span class=3D"font" style=3D"fo=
nt-family: menlo, consolas, monospace, sans-serif;"><span class=3D"size" st=
yle=3D"font-size: 13px"><span class=3D"colour" style=3D"color:#000000"><spa=
n class=3D"highlight" style=3D"background-color:#ffffff">&nbsp; </span></sp=
an></span></span></span><span class=3D"font" style=3D"font-family: menlo, c=
onsolas, monospace, sans-serif;"><span class=3D"size" style=3D"font-size: 1=
3px"><span class=3D"colour" style=3D"color:#000000"><span class=3D"highligh=
t" style=3D"background-color:#ffffff">54], 95.00th=3D[ </span></span></span=
></span><span class=3D"Apple-converted-space"><span class=3D"font" style=3D=
"font-family: menlo, consolas, monospace, sans-serif;"><span class=3D"size"=
 style=3D"font-size: 13px"><span class=3D"colour" style=3D"color:#000000"><=
span class=3D"highlight" style=3D"background-color:#ffffff">&nbsp; </span><=
/span></span></span></span><span class=3D"font" style=3D"font-family: menlo=
, consolas, monospace, sans-serif;"><span class=3D"size" style=3D"font-size=
: 13px"><span class=3D"colour" style=3D"color:#000000"><span class=3D"highl=
ight" style=3D"background-color:#ffffff">59],</span></span></span></span></=
span><span class=3D"font" style=3D"font-family: menlo, consolas, monospace,=
 sans-serif;"><span class=3D"size" style=3D"font-size: 13px"><span class=3D=
"colour" style=3D"color:#000000"><span class=3D"highlight" style=3D"backgro=
und-color:#ffffff"><br></span></span></span></span></p><p style=3D"margin: =
0px; font-style: normal; font-variant-caps: normal; font-weight: normal; fo=
nt-stretch: normal; line-height: normal;"><span style=3D"font-variant-ligat=
ures: no-common-ligatures"><span class=3D"Apple-converted-space"><span clas=
s=3D"font" style=3D"font-family: menlo, consolas, monospace, sans-serif;"><=
span class=3D"size" style=3D"font-size: 13px"><span class=3D"colour" style=
=3D"color:#000000"><span class=3D"highlight" style=3D"background-color:#fff=
fff">&nbsp;&nbsp; &nbsp; </span></span></span></span></span><span class=3D"=
font" style=3D"font-family: menlo, consolas, monospace, sans-serif;"><span =
class=3D"size" style=3D"font-size: 13px"><span class=3D"colour" style=3D"co=
lor:#000000"><span class=3D"highlight" style=3D"background-color:#ffffff">|=
 99.00th=3D[ </span></span></span></span><span class=3D"Apple-converted-spa=
ce"><span class=3D"font" style=3D"font-family: menlo, consolas, monospace, =
sans-serif;"><span class=3D"size" style=3D"font-size: 13px"><span class=3D"=
colour" style=3D"color:#000000"><span class=3D"highlight" style=3D"backgrou=
nd-color:#ffffff">&nbsp; </span></span></span></span></span><span class=3D"=
font" style=3D"font-family: menlo, consolas, monospace, sans-serif;"><span =
class=3D"size" style=3D"font-size: 13px"><span class=3D"colour" style=3D"co=
lor:#000000"><span class=3D"highlight" style=3D"background-color:#ffffff">7=
1], 99.50th=3D[ </span></span></span></span><span class=3D"Apple-converted-=
space"><span class=3D"font" style=3D"font-family: menlo, consolas, monospac=
e, sans-serif;"><span class=3D"size" style=3D"font-size: 13px"><span class=
=3D"colour" style=3D"color:#000000"><span class=3D"highlight" style=3D"back=
ground-color:#ffffff">&nbsp; </span></span></span></span></span><span class=
=3D"font" style=3D"font-family: menlo, consolas, monospace, sans-serif;"><s=
pan class=3D"size" style=3D"font-size: 13px"><span class=3D"colour" style=
=3D"color:#000000"><span class=3D"highlight" style=3D"background-color:#fff=
fff">77], 99.90th=3D[</span></span></span></span><span class=3D"Apple-conve=
rted-space"><span class=3D"font" style=3D"font-family: menlo, consolas, mon=
ospace, sans-serif;"><span class=3D"size" style=3D"font-size: 13px"><span c=
lass=3D"colour" style=3D"color:#000000"><span class=3D"highlight" style=3D"=
background-color:#ffffff">&nbsp; </span></span></span></span></span><span c=
lass=3D"font" style=3D"font-family: menlo, consolas, monospace, sans-serif;=
"><span class=3D"size" style=3D"font-size: 13px"><span class=3D"colour" sty=
le=3D"color:#000000"><span class=3D"highlight" style=3D"background-color:#f=
fffff">106], 99.95th=3D[</span></span></span></span><span class=3D"Apple-co=
nverted-space"><span class=3D"font" style=3D"font-family: menlo, consolas, =
monospace, sans-serif;"><span class=3D"size" style=3D"font-size: 13px"><spa=
n class=3D"colour" style=3D"color:#000000"><span class=3D"highlight" style=
=3D"background-color:#ffffff">&nbsp; </span></span></span></span></span><sp=
an class=3D"font" style=3D"font-family: menlo, consolas, monospace, sans-se=
rif;"><span class=3D"size" style=3D"font-size: 13px"><span class=3D"colour"=
 style=3D"color:#000000"><span class=3D"highlight" style=3D"background-colo=
r:#ffffff">121],</span></span></span></span></span><span class=3D"font" sty=
le=3D"font-family: menlo, consolas, monospace, sans-serif;"><span class=3D"=
size" style=3D"font-size: 13px"><span class=3D"colour" style=3D"color:#0000=
00"><span class=3D"highlight" style=3D"background-color:#ffffff"><br></span=
></span></span></span></p><p style=3D"margin: 0px; font-style: normal; font=
-variant-caps: normal; font-weight: normal; font-stretch: normal; line-heig=
ht: normal;"><span style=3D"font-variant-ligatures: no-common-ligatures"><s=
pan class=3D"Apple-converted-space"><span class=3D"font" style=3D"font-fami=
ly: menlo, consolas, monospace, sans-serif;"><span class=3D"size" style=3D"=
font-size: 13px"><span class=3D"colour" style=3D"color:#000000"><span class=
=3D"highlight" style=3D"background-color:#ffffff">&nbsp;&nbsp; &nbsp; </spa=
n></span></span></span></span><span class=3D"font" style=3D"font-family: me=
nlo, consolas, monospace, sans-serif;"><span class=3D"size" style=3D"font-s=
ize: 13px"><span class=3D"colour" style=3D"color:#000000"><span class=3D"hi=
ghlight" style=3D"background-color:#ffffff">| 99.99th=3D[</span></span></sp=
an></span><span class=3D"Apple-converted-space"><span class=3D"font" style=
=3D"font-family: menlo, consolas, monospace, sans-serif;"><span class=3D"si=
ze" style=3D"font-size: 13px"><span class=3D"colour" style=3D"color:#000000=
"><span class=3D"highlight" style=3D"background-color:#ffffff">&nbsp; </spa=
n></span></span></span></span><span class=3D"font" style=3D"font-family: me=
nlo, consolas, monospace, sans-serif;"><span class=3D"size" style=3D"font-s=
ize: 13px"><span class=3D"colour" style=3D"color:#000000"><span class=3D"hi=
ghlight" style=3D"background-color:#ffffff">239]</span></span></span></span=
></span><span class=3D"font" style=3D"font-family: menlo, consolas, monospa=
ce, sans-serif;"><span class=3D"size" style=3D"font-size: 13px"><span class=
=3D"colour" style=3D"color:#000000"><span class=3D"highlight" style=3D"back=
ground-color:#ffffff"><br></span></span></span></span></p><p style=3D"margi=
n: 0px; font-style: normal; font-variant-caps: normal; font-weight: normal;=
 font-stretch: normal; line-height: normal;"><span style=3D"font-variant-li=
gatures: no-common-ligatures"><span class=3D"Apple-converted-space"><span c=
lass=3D"font" style=3D"font-family: menlo, consolas, monospace, sans-serif;=
"><span class=3D"size" style=3D"font-size: 13px"><span class=3D"colour" sty=
le=3D"color:#000000"><span class=3D"highlight" style=3D"background-color:#f=
fffff">&nbsp;&nbsp; </span></span></span></span></span><span class=3D"font"=
 style=3D"font-family: menlo, consolas, monospace, sans-serif;"><span class=
=3D"size" style=3D"font-size: 13px"><span class=3D"colour" style=3D"color:#=
000000"><span class=3D"highlight" style=3D"background-color:#ffffff">bw (</=
span></span></span></span><span class=3D"Apple-converted-space"><span class=
=3D"font" style=3D"font-family: menlo, consolas, monospace, sans-serif;"><s=
pan class=3D"size" style=3D"font-size: 13px"><span class=3D"colour" style=
=3D"color:#000000"><span class=3D"highlight" style=3D"background-color:#fff=
fff">&nbsp; </span></span></span></span></span><span class=3D"font" style=
=3D"font-family: menlo, consolas, monospace, sans-serif;"><span class=3D"si=
ze" style=3D"font-size: 13px"><span class=3D"colour" style=3D"color:#000000=
"><span class=3D"highlight" style=3D"background-color:#ffffff">MiB/s): min=
=3D 2404, max=3D 2513, per=3D99.54%, avg=3D2465.45, stdev=3D34.80, samples=
=3D13</span></span></span></span></span><span class=3D"font" style=3D"font-=
family: menlo, consolas, monospace, sans-serif;"><span class=3D"size" style=
=3D"font-size: 13px"><span class=3D"colour" style=3D"color:#000000"><span c=
lass=3D"highlight" style=3D"background-color:#ffffff"><br></span></span></s=
pan></span></p><p style=3D"margin: 0px; font-style: normal; font-variant-ca=
ps: normal; font-weight: normal; font-stretch: normal; line-height: normal;=
"><span style=3D"font-variant-ligatures: no-common-ligatures"><span class=
=3D"Apple-converted-space"><span class=3D"font" style=3D"font-family: menlo=
, consolas, monospace, sans-serif;"><span class=3D"size" style=3D"font-size=
: 13px"><span class=3D"colour" style=3D"color:#000000"><span class=3D"highl=
ight" style=3D"background-color:#ffffff">&nbsp;&nbsp; </span></span></span>=
</span></span><span class=3D"font" style=3D"font-family: menlo, consolas, m=
onospace, sans-serif;"><span class=3D"size" style=3D"font-size: 13px"><span=
 class=3D"colour" style=3D"color:#000000"><span class=3D"highlight" style=
=3D"background-color:#ffffff">iops</span></span></span></span><span class=
=3D"Apple-converted-space"><span class=3D"font" style=3D"font-family: menlo=
, consolas, monospace, sans-serif;"><span class=3D"size" style=3D"font-size=
: 13px"><span class=3D"colour" style=3D"color:#000000"><span class=3D"highl=
ight" style=3D"background-color:#ffffff">&nbsp; &nbsp; &nbsp; &nbsp; </span=
></span></span></span></span><span class=3D"font" style=3D"font-family: men=
lo, consolas, monospace, sans-serif;"><span class=3D"size" style=3D"font-si=
ze: 13px"><span class=3D"colour" style=3D"color:#000000"><span class=3D"hig=
hlight" style=3D"background-color:#ffffff">: min=3D19235, max=3D20109, avg=
=3D19723.23, stdev=3D278.34, samples=3D13</span></span></span></span></span=
><span class=3D"font" style=3D"font-family: menlo, consolas, monospace, san=
s-serif;"><span class=3D"size" style=3D"font-size: 13px"><span class=3D"col=
our" style=3D"color:#000000"><span class=3D"highlight" style=3D"background-=
color:#ffffff"><br></span></span></span></span></p><p style=3D"margin: 0px;=
 font-style: normal; font-variant-caps: normal; font-weight: normal; font-s=
tretch: normal; line-height: normal;"><span style=3D"font-variant-ligatures=
: no-common-ligatures"><span class=3D"Apple-converted-space"><span class=3D=
"font" style=3D"font-family: menlo, consolas, monospace, sans-serif;"><span=
 class=3D"size" style=3D"font-size: 13px"><span class=3D"colour" style=3D"c=
olor:#000000"><span class=3D"highlight" style=3D"background-color:#ffffff">=
&nbsp; </span></span></span></span></span><span class=3D"font" style=3D"fon=
t-family: menlo, consolas, monospace, sans-serif;"><span class=3D"size" sty=
le=3D"font-size: 13px"><span class=3D"colour" style=3D"color:#000000"><span=
 class=3D"highlight" style=3D"background-color:#ffffff">lat (usec) </span><=
/span></span></span><span class=3D"Apple-converted-space"><span class=3D"fo=
nt" style=3D"font-family: menlo, consolas, monospace, sans-serif;"><span cl=
ass=3D"size" style=3D"font-size: 13px"><span class=3D"colour" style=3D"colo=
r:#000000"><span class=3D"highlight" style=3D"background-color:#ffffff">&nb=
sp; </span></span></span></span></span><span class=3D"font" style=3D"font-f=
amily: menlo, consolas, monospace, sans-serif;"><span class=3D"size" style=
=3D"font-size: 13px"><span class=3D"colour" style=3D"color:#000000"><span c=
lass=3D"highlight" style=3D"background-color:#ffffff">: 50=3D83.01%, 100=3D=
16.84%, 250=3D0.15%, 500=3D0.01%, 750=3D0.01%</span></span></span></span></=
span><span class=3D"font" style=3D"font-family: menlo, consolas, monospace,=
 sans-serif;"><span class=3D"size" style=3D"font-size: 13px"><span class=3D=
"colour" style=3D"color:#000000"><span class=3D"highlight" style=3D"backgro=
und-color:#ffffff"><br></span></span></span></span></p><p style=3D"margin: =
0px; font-style: normal; font-variant-caps: normal; font-weight: normal; fo=
nt-stretch: normal; line-height: normal;"><span style=3D"font-variant-ligat=
ures: no-common-ligatures"><span class=3D"Apple-converted-space"><span clas=
s=3D"font" style=3D"font-family: menlo, consolas, monospace, sans-serif;"><=
span class=3D"size" style=3D"font-size: 13px"><span class=3D"colour" style=
=3D"color:#000000"><span class=3D"highlight" style=3D"background-color:#fff=
fff">&nbsp; </span></span></span></span></span><span class=3D"font" style=
=3D"font-family: menlo, consolas, monospace, sans-serif;"><span class=3D"si=
ze" style=3D"font-size: 13px"><span class=3D"colour" style=3D"color:#000000=
"><span class=3D"highlight" style=3D"background-color:#ffffff">cpu</span></=
span></span></span><span class=3D"Apple-converted-space"><span class=3D"fon=
t" style=3D"font-family: menlo, consolas, monospace, sans-serif;"><span cla=
ss=3D"size" style=3D"font-size: 13px"><span class=3D"colour" style=3D"color=
:#000000"><span class=3D"highlight" style=3D"background-color:#ffffff">&nbs=
p; &nbsp; &nbsp; &nbsp; &nbsp; </span></span></span></span></span><span cla=
ss=3D"font" style=3D"font-family: menlo, consolas, monospace, sans-serif;">=
<span class=3D"size" style=3D"font-size: 13px"><span class=3D"colour" style=
=3D"color:#000000"><span class=3D"highlight" style=3D"background-color:#fff=
fff">: usr=3D13.09%, sys=3D86.82%, ctx=3D305, majf=3D0, minf=3D0</span></sp=
an></span></span></span><span class=3D"font" style=3D"font-family: menlo, c=
onsolas, monospace, sans-serif;"><span class=3D"size" style=3D"font-size: 1=
3px"><span class=3D"colour" style=3D"color:#000000"><span class=3D"highligh=
t" style=3D"background-color:#ffffff"><br></span></span></span></span></p><=
p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; font=
-weight: normal; font-stretch: normal; line-height: normal;"><span style=3D=
"font-variant-ligatures: no-common-ligatures"><span class=3D"Apple-converte=
d-space"><span class=3D"font" style=3D"font-family: menlo, consolas, monosp=
ace, sans-serif;"><span class=3D"size" style=3D"font-size: 13px"><span clas=
s=3D"colour" style=3D"color:#000000"><span class=3D"highlight" style=3D"bac=
kground-color:#ffffff">&nbsp; </span></span></span></span></span><span clas=
s=3D"font" style=3D"font-family: menlo, consolas, monospace, sans-serif;"><=
span class=3D"size" style=3D"font-size: 13px"><span class=3D"colour" style=
=3D"color:#000000"><span class=3D"highlight" style=3D"background-color:#fff=
fff">IO depths</span></span></span></span><span class=3D"Apple-converted-sp=
ace"><span class=3D"font" style=3D"font-family: menlo, consolas, monospace,=
 sans-serif;"><span class=3D"size" style=3D"font-size: 13px"><span class=3D=
"colour" style=3D"color:#000000"><span class=3D"highlight" style=3D"backgro=
und-color:#ffffff">&nbsp; &nbsp; </span></span></span></span></span><span c=
lass=3D"font" style=3D"font-family: menlo, consolas, monospace, sans-serif;=
"><span class=3D"size" style=3D"font-size: 13px"><span class=3D"colour" sty=
le=3D"color:#000000"><span class=3D"highlight" style=3D"background-color:#f=
fffff">: 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, &g=
t;=3D64=3D0.0%</span></span></span></span></span><span class=3D"font" style=
=3D"font-family: menlo, consolas, monospace, sans-serif;"><span class=3D"si=
ze" style=3D"font-size: 13px"><span class=3D"colour" style=3D"color:#000000=
"><span class=3D"highlight" style=3D"background-color:#ffffff"><br></span><=
/span></span></span></p><p style=3D"margin: 0px; font-style: normal; font-v=
ariant-caps: normal; font-weight: normal; font-stretch: normal; line-height=
: normal;"><span style=3D"font-variant-ligatures: no-common-ligatures"><spa=
n class=3D"Apple-converted-space"><span class=3D"font" style=3D"font-family=
: menlo, consolas, monospace, sans-serif;"><span class=3D"size" style=3D"fo=
nt-size: 13px"><span class=3D"colour" style=3D"color:#000000"><span class=
=3D"highlight" style=3D"background-color:#ffffff">&nbsp;&nbsp; &nbsp; </spa=
n></span></span></span></span><span class=3D"font" style=3D"font-family: me=
nlo, consolas, monospace, sans-serif;"><span class=3D"size" style=3D"font-s=
ize: 13px"><span class=3D"colour" style=3D"color:#000000"><span class=3D"hi=
ghlight" style=3D"background-color:#ffffff">submit</span></span></span></sp=
an><span class=3D"Apple-converted-space"><span class=3D"font" style=3D"font=
-family: menlo, consolas, monospace, sans-serif;"><span class=3D"size" styl=
e=3D"font-size: 13px"><span class=3D"colour" style=3D"color:#000000"><span =
class=3D"highlight" style=3D"background-color:#ffffff">&nbsp; &nbsp; </span=
></span></span></span></span><span class=3D"font" style=3D"font-family: men=
lo, consolas, monospace, sans-serif;"><span class=3D"size" style=3D"font-si=
ze: 13px"><span class=3D"colour" style=3D"color:#000000"><span class=3D"hig=
hlight" style=3D"background-color:#ffffff">: 0=3D0.0%, 4=3D100.0%, 8=3D0.0%=
, 16=3D0.0%, 32=3D0.0%, 64=3D0.0%, &gt;=3D64=3D0.0%</span></span></span></s=
pan></span><span class=3D"font" style=3D"font-family: menlo, consolas, mono=
space, sans-serif;"><span class=3D"size" style=3D"font-size: 13px"><span cl=
ass=3D"colour" style=3D"color:#000000"><span class=3D"highlight" style=3D"b=
ackground-color:#ffffff"><br></span></span></span></span></p><p style=3D"ma=
rgin: 0px; font-style: normal; font-variant-caps: normal; font-weight: norm=
al; font-stretch: normal; line-height: normal;"><span style=3D"font-variant=
-ligatures: no-common-ligatures"><span class=3D"Apple-converted-space"><spa=
n class=3D"font" style=3D"font-family: menlo, consolas, monospace, sans-ser=
if;"><span class=3D"size" style=3D"font-size: 13px"><span class=3D"colour" =
style=3D"color:#000000"><span class=3D"highlight" style=3D"background-color=
:#ffffff">&nbsp;&nbsp; &nbsp; </span></span></span></span></span><span clas=
s=3D"font" style=3D"font-family: menlo, consolas, monospace, sans-serif;"><=
span class=3D"size" style=3D"font-size: 13px"><span class=3D"colour" style=
=3D"color:#000000"><span class=3D"highlight" style=3D"background-color:#fff=
fff">complete</span></span></span></span><span class=3D"Apple-converted-spa=
ce"><span class=3D"font" style=3D"font-family: menlo, consolas, monospace, =
sans-serif;"><span class=3D"size" style=3D"font-size: 13px"><span class=3D"=
colour" style=3D"color:#000000"><span class=3D"highlight" style=3D"backgrou=
nd-color:#ffffff">&nbsp; </span></span></span></span></span><span class=3D"=
font" style=3D"font-family: menlo, consolas, monospace, sans-serif;"><span =
class=3D"size" style=3D"font-size: 13px"><span class=3D"colour" style=3D"co=
lor:#000000"><span class=3D"highlight" style=3D"background-color:#ffffff">:=
 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=3D0.0%, &gt;=3D64=
=3D0.0%</span></span></span></span></span><span class=3D"font" style=3D"fon=
t-family: menlo, consolas, monospace, sans-serif;"><span class=3D"size" sty=
le=3D"font-size: 13px"><span class=3D"colour" style=3D"color:#000000"><span=
 class=3D"highlight" style=3D"background-color:#ffffff"><br></span></span><=
/span></span></p><p style=3D"margin: 0px; font-style: normal; font-variant-=
caps: normal; font-weight: normal; font-stretch: normal; line-height: norma=
l;"><span style=3D"font-variant-ligatures: no-common-ligatures"><span class=
=3D"Apple-converted-space"><span class=3D"font" style=3D"font-family: menlo=
, consolas, monospace, sans-serif;"><span class=3D"size" style=3D"font-size=
: 13px"><span class=3D"colour" style=3D"color:#000000"><span class=3D"highl=
ight" style=3D"background-color:#ffffff">&nbsp;&nbsp; &nbsp; </span></span>=
</span></span></span><span class=3D"font" style=3D"font-family: menlo, cons=
olas, monospace, sans-serif;"><span class=3D"size" style=3D"font-size: 13px=
"><span class=3D"colour" style=3D"color:#000000"><span class=3D"highlight" =
style=3D"background-color:#ffffff">issued rwts: total=3D0,131072,0,0 short=
=3D0,0,0,0 dropped=3D0,0,0,0</span></span></span></span></span><span class=
=3D"font" style=3D"font-family: menlo, consolas, monospace, sans-serif;"><s=
pan class=3D"size" style=3D"font-size: 13px"><span class=3D"colour" style=
=3D"color:#000000"><span class=3D"highlight" style=3D"background-color:#fff=
fff"><br></span></span></span></span></p><p style=3D"margin: 0px; font-styl=
e: normal; font-variant-caps: normal; font-weight: normal; font-stretch: no=
rmal; line-height: normal;"><span style=3D"font-variant-ligatures: no-commo=
n-ligatures"><span class=3D"Apple-converted-space"><span class=3D"font" sty=
le=3D"font-family: menlo, consolas, monospace, sans-serif;"><span class=3D"=
size" style=3D"font-size: 13px"><span class=3D"colour" style=3D"color:#0000=
00"><span class=3D"highlight" style=3D"background-color:#ffffff">&nbsp;&nbs=
p; &nbsp; </span></span></span></span></span><span class=3D"font" style=3D"=
font-family: menlo, consolas, monospace, sans-serif;"><span class=3D"size" =
style=3D"font-size: 13px"><span class=3D"colour" style=3D"color:#000000"><s=
pan class=3D"highlight" style=3D"background-color:#ffffff">latency </span><=
/span></span></span><span class=3D"Apple-converted-space"><span class=3D"fo=
nt" style=3D"font-family: menlo, consolas, monospace, sans-serif;"><span cl=
ass=3D"size" style=3D"font-size: 13px"><span class=3D"colour" style=3D"colo=
r:#000000"><span class=3D"highlight" style=3D"background-color:#ffffff">&nb=
sp; </span></span></span></span></span><span class=3D"font" style=3D"font-f=
amily: menlo, consolas, monospace, sans-serif;"><span class=3D"size" style=
=3D"font-size: 13px"><span class=3D"colour" style=3D"color:#000000"><span c=
lass=3D"highlight" style=3D"background-color:#ffffff">: target=3D0, window=
=3D0, percentile=3D100.00%, depth=3D1</span></span></span></span></span><sp=
an class=3D"font" style=3D"font-family: menlo, consolas, monospace, sans-se=
rif;"><span class=3D"size" style=3D"font-size: 13px"><span class=3D"colour"=
 style=3D"color:#000000"><span class=3D"highlight" style=3D"background-colo=
r:#ffffff"><br></span></span></span></span></p><p style=3D"margin: 0px; fon=
t-style: normal; font-variant-caps: normal; font-weight: normal; font-stret=
ch: normal; line-height: normal; min-height: 14px;"><span class=3D"font" st=
yle=3D"font-family: menlo, consolas, monospace, sans-serif;"><span class=3D=
"size" style=3D"font-size: 13px"><span class=3D"colour" style=3D"color:#000=
000"><span class=3D"highlight" style=3D"background-color:#ffffff"><br></spa=
n></span></span></span></p><p style=3D"margin: 0px; font-style: normal; fon=
t-variant-caps: normal; font-weight: normal; font-stretch: normal; line-hei=
ght: normal;"><span style=3D"font-variant-ligatures: no-common-ligatures"><=
span class=3D"font" style=3D"font-family: menlo, consolas, monospace, sans-=
serif;"><span class=3D"size" style=3D"font-size: 13px"><span class=3D"colou=
r" style=3D"color:#000000"><span class=3D"highlight" style=3D"background-co=
lor:#ffffff">Run status group 0 (all jobs):</span></span></span></span></sp=
an><span class=3D"font" style=3D"font-family: menlo, consolas, monospace, s=
ans-serif;"><span class=3D"size" style=3D"font-size: 13px"><span class=3D"c=
olour" style=3D"color:#000000"><span class=3D"highlight" style=3D"backgroun=
d-color:#ffffff"><br></span></span></span></span></p><p style=3D"margin: 0p=
x; font-style: normal; font-variant-caps: normal; font-weight: normal; font=
-stretch: normal; line-height: normal;"><span style=3D"font-variant-ligatur=
es: no-common-ligatures"><span class=3D"Apple-converted-space"><span class=
=3D"font" style=3D"font-family: menlo, consolas, monospace, sans-serif;"><s=
pan class=3D"size" style=3D"font-size: 13px"><span class=3D"colour" style=
=3D"color:#000000"><span class=3D"highlight" style=3D"background-color:#fff=
fff">&nbsp; </span></span></span></span></span><span class=3D"font" style=
=3D"font-family: menlo, consolas, monospace, sans-serif;"><span class=3D"si=
ze" style=3D"font-size: 13px"><span class=3D"colour" style=3D"color:#000000=
"><span class=3D"highlight" style=3D"background-color:#ffffff">WRITE: bw=3D=
2477MiB/s (2597MB/s), 2477MiB/s-2477MiB/s (2597MB/s-2597MB/s), io=3D16.0GiB=
 (17.2GB), run=3D6615-6615msec</span></span></span></span></span><span clas=
s=3D"font" style=3D"font-family: menlo, consolas, monospace, sans-serif;"><=
span class=3D"size" style=3D"font-size: 13px"><span class=3D"colour" style=
=3D"color:#000000"><span class=3D"highlight" style=3D"background-color:#fff=
fff"><br></span></span></span></span></p><p style=3D"margin: 0px; font-styl=
e: normal; font-variant-caps: normal; font-weight: normal; font-stretch: no=
rmal; line-height: normal;"><span style=3D"font-variant-ligatures: no-commo=
n-ligatures"><span class=3D"font" style=3D"font-family: menlo, consolas, mo=
nospace, sans-serif;"><span class=3D"size" style=3D"font-size: 13px"><span =
class=3D"colour" style=3D"color:#000000"><span class=3D"highlight" style=3D=
"background-color:#ffffff">root@delorean:/sec_stor/backup/fiotest/fio-maste=
r # du -sh seqwrite.0.0 </span></span></span></span><span class=3D"Apple-co=
nverted-space"><span class=3D"font" style=3D"font-family: menlo, consolas, =
monospace, sans-serif;"><span class=3D"size" style=3D"font-size: 13px"><spa=
n class=3D"colour" style=3D"color:#000000"><span class=3D"highlight" style=
=3D"background-color:#ffffff">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &=
nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;=
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbs=
p; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &n=
bsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; </span></span></span></span></span><span class=
=3D"font" style=3D"font-family: menlo, consolas, monospace, sans-serif;"><s=
pan class=3D"size" style=3D"font-size: 13px"><span class=3D"colour" style=
=3D"color:#000000"><span class=3D"highlight" style=3D"background-color:#fff=
fff">1.1G</span></span></span></span><span style=3D"white-space:pre" class=
=3D"Apple-tab-span"><span class=3D"font" style=3D"font-family: menlo, conso=
las, monospace, sans-serif;"><span class=3D"size" style=3D"font-size: 13px"=
><span class=3D"colour" style=3D"color:#000000"><span class=3D"highlight" s=
tyle=3D"background-color:#ffffff"> </span></span></span></span></span><span=
 class=3D"font" style=3D"font-family: menlo, consolas, monospace, sans-seri=
f;"><span class=3D"size" style=3D"font-size: 13px"><span class=3D"colour" s=
tyle=3D"color:#000000"><span class=3D"highlight" style=3D"background-color:=
#ffffff">seqwrite.0.0</span></span></span></span></span><br></p><div style=
=3D"font-size:16px;"><br></div>
<div style=3D"font-size:16px;">As you see, this test created a 1.1GiB file =
when I was expecting a 16 GiB file. <span class=3D"colour" style=3D"color:#=
0000ff">Why? What options did I miss or specify wrong?</span><br></div>
<div style=3D"font-size:16px;"><br></div>
<div style=3D"font-size:16px;">I just couldn't stop, so I went on with anot=
her test,<br></div>
<div style=3D"font-size:16px;"><br></div>
<div style=3D"font-size:16px;"><b><u>Test # 4:</u></b><br></div>
<div style=3D"font-size:16px;">&nbsp;Run fio with buffer_compress_percent=
=3D50 (50% compression). It looks like it did create a 50% compressible dat=
aset. But, yielded relatively low throughput.<br></div>
<div style=3D"font-size:16px;"><br></div>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; fon=
t-weight: normal; font-stretch: normal; line-height: normal;"><span style=
=3D"font-variant-ligatures: no-common-ligatures"><span class=3D"font" style=
=3D"font-family: menlo, consolas, monospace, sans-serif;"><span class=3D"si=
ze" style=3D"font-size: 13px"><span class=3D"highlight" style=3D"background=
-color:#ffffff"><span class=3D"colour" style=3D"color:#000000">root@delorea=
n:/sec_stor/backup/fiotest/fio-master # ./fio --name=3Dseqwrite --rw=3Dwrit=
e --bs=3D128k --numjobs=3D1 --size=3D16G --runtime=3D60 --iodepth=3D1 --buf=
fer_compress_percentage=3D50 --buffer_pattern=3D0xdeadbeef --refill_buffers=
 --group_reporting</span></span></span></span></span><span class=3D"font" s=
tyle=3D"font-family: menlo, consolas, monospace, sans-serif;"><span class=
=3D"size" style=3D"font-size: 13px"><span class=3D"highlight" style=3D"back=
ground-color:#ffffff"><span class=3D"colour" style=3D"color:#000000"><br></=
span></span></span></span></p><p style=3D"margin: 0px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; font-stretch: normal; line-=
height: normal;"><span style=3D"font-variant-ligatures: no-common-ligatures=
"><span class=3D"font" style=3D"font-family: menlo, consolas, monospace, sa=
ns-serif;"><span class=3D"size" style=3D"font-size: 13px"><span class=3D"hi=
ghlight" style=3D"background-color:#ffffff"><span class=3D"colour" style=3D=
"color:#000000">seqwrite: (g=3D0): rw=3Dwrite, bs=3D(R) 128KiB-128KiB, (W) =
128KiB-128KiB, (T) 128KiB-128KiB, ioengine=3Dpsync, iodepth=3D1</span></spa=
n></span></span></span><span class=3D"font" style=3D"font-family: menlo, co=
nsolas, monospace, sans-serif;"><span class=3D"size" style=3D"font-size: 13=
px"><span class=3D"highlight" style=3D"background-color:#ffffff"><span clas=
s=3D"colour" style=3D"color:#000000"><br></span></span></span></span></p><p=
 style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; font-=
weight: normal; font-stretch: normal; line-height: normal;"><span style=3D"=
font-variant-ligatures: no-common-ligatures"><span class=3D"font" style=3D"=
font-family: menlo, consolas, monospace, sans-serif;"><span class=3D"size" =
style=3D"font-size: 13px"><span class=3D"highlight" style=3D"background-col=
or:#ffffff"><span class=3D"colour" style=3D"color:#000000">fio-3.8</span></=
span></span></span></span><span class=3D"font" style=3D"font-family: menlo,=
 consolas, monospace, sans-serif;"><span class=3D"size" style=3D"font-size:=
 13px"><span class=3D"highlight" style=3D"background-color:#ffffff"><span c=
lass=3D"colour" style=3D"color:#000000"><br></span></span></span></span></p=
><p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; fo=
nt-weight: normal; font-stretch: normal; line-height: normal;"><span style=
=3D"font-variant-ligatures: no-common-ligatures"><span class=3D"font" style=
=3D"font-family: menlo, consolas, monospace, sans-serif;"><span class=3D"si=
ze" style=3D"font-size: 13px"><span class=3D"highlight" style=3D"background=
-color:#ffffff"><span class=3D"colour" style=3D"color:#000000">Starting 1 p=
rocess</span></span></span></span></span><span class=3D"font" style=3D"font=
-family: menlo, consolas, monospace, sans-serif;"><span class=3D"size" styl=
e=3D"font-size: 13px"><span class=3D"highlight" style=3D"background-color:#=
ffffff"><span class=3D"colour" style=3D"color:#000000"><br></span></span></=
span></span></p><p style=3D"margin: 0px; font-style: normal; font-variant-c=
aps: normal; font-weight: normal; font-stretch: normal; line-height: normal=
;"><span style=3D"font-variant-ligatures: no-common-ligatures"><span class=
=3D"font" style=3D"font-family: menlo, consolas, monospace, sans-serif;"><s=
pan class=3D"size" style=3D"font-size: 13px"><span class=3D"highlight" styl=
e=3D"background-color:#ffffff"><span class=3D"colour" style=3D"color:#00000=
0">Jobs: 1 (f=3D1): [W(1)][95.7%][r=3D0KiB/s,w=3D715MiB/s][r=3D0,w=3D5721 I=
OPS][eta 00m:01s]</span></span></span></span></span><span class=3D"font" st=
yle=3D"font-family: menlo, consolas, monospace, sans-serif;"><span class=3D=
"size" style=3D"font-size: 13px"><span class=3D"highlight" style=3D"backgro=
und-color:#ffffff"><span class=3D"colour" style=3D"color:#000000"><br></spa=
n></span></span></span></p><p style=3D"margin: 0px; font-style: normal; fon=
t-variant-caps: normal; font-weight: normal; font-stretch: normal; line-hei=
ght: normal;"><span style=3D"font-variant-ligatures: no-common-ligatures"><=
span class=3D"font" style=3D"font-family: menlo, consolas, monospace, sans-=
serif;"><span class=3D"size" style=3D"font-size: 13px"><span class=3D"highl=
ight" style=3D"background-color:#ffffff"><span class=3D"colour" style=3D"co=
lor:#000000">seqwrite: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D13543: Wed =
Jul 25 14:18:41 2018</span></span></span></span></span><span class=3D"font"=
 style=3D"font-family: menlo, consolas, monospace, sans-serif;"><span class=
=3D"size" style=3D"font-size: 13px"><span class=3D"highlight" style=3D"back=
ground-color:#ffffff"><span class=3D"colour" style=3D"color:#000000"><br></=
span></span></span></span></p><p style=3D"margin: 0px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; font-stretch: normal; line-=
height: normal;"><span style=3D"font-variant-ligatures: no-common-ligatures=
"><span class=3D"Apple-converted-space"><span class=3D"font" style=3D"font-=
family: menlo, consolas, monospace, sans-serif;"><span class=3D"size" style=
=3D"font-size: 13px"><span class=3D"highlight" style=3D"background-color:#f=
fffff"><span class=3D"colour" style=3D"color:#000000">&nbsp; </span></span>=
</span></span></span><span class=3D"font" style=3D"font-family: menlo, cons=
olas, monospace, sans-serif;"><span class=3D"size" style=3D"font-size: 13px=
"><span class=3D"highlight" style=3D"background-color:#ffffff"><span class=
=3D"colour" style=3D"color:#000000">write: IOPS=3D5729, BW=3D716MiB/s (751M=
B/s)(16.0GiB/22876msec)</span></span></span></span></span><span class=3D"fo=
nt" style=3D"font-family: menlo, consolas, monospace, sans-serif;"><span cl=
ass=3D"size" style=3D"font-size: 13px"><span class=3D"highlight" style=3D"b=
ackground-color:#ffffff"><span class=3D"colour" style=3D"color:#000000"><br=
></span></span></span></span></p><p style=3D"margin: 0px; font-style: norma=
l; font-variant-caps: normal; font-weight: normal; font-stretch: normal; li=
ne-height: normal;"><span style=3D"font-variant-ligatures: no-common-ligatu=
res"><span class=3D"Apple-converted-space"><span class=3D"font" style=3D"fo=
nt-family: menlo, consolas, monospace, sans-serif;"><span class=3D"size" st=
yle=3D"font-size: 13px"><span class=3D"highlight" style=3D"background-color=
:#ffffff"><span class=3D"colour" style=3D"color:#000000">&nbsp; &nbsp; </sp=
an></span></span></span></span><span class=3D"font" style=3D"font-family: m=
enlo, consolas, monospace, sans-serif;"><span class=3D"size" style=3D"font-=
size: 13px"><span class=3D"highlight" style=3D"background-color:#ffffff"><s=
pan class=3D"colour" style=3D"color:#000000">clat (usec): min=3D26, max=3D1=
228, avg=3D46.59, stdev=3D19.26</span></span></span></span></span><span cla=
ss=3D"font" style=3D"font-family: menlo, consolas, monospace, sans-serif;">=
<span class=3D"size" style=3D"font-size: 13px"><span class=3D"highlight" st=
yle=3D"background-color:#ffffff"><span class=3D"colour" style=3D"color:#000=
000"><br></span></span></span></span></p><p style=3D"margin: 0px; font-styl=
e: normal; font-variant-caps: normal; font-weight: normal; font-stretch: no=
rmal; line-height: normal;"><span style=3D"font-variant-ligatures: no-commo=
n-ligatures"><span class=3D"Apple-converted-space"><span class=3D"font" sty=
le=3D"font-family: menlo, consolas, monospace, sans-serif;"><span class=3D"=
size" style=3D"font-size: 13px"><span class=3D"highlight" style=3D"backgrou=
nd-color:#ffffff"><span class=3D"colour" style=3D"color:#000000">&nbsp;&nbs=
p; &nbsp; </span></span></span></span></span><span class=3D"font" style=3D"=
font-family: menlo, consolas, monospace, sans-serif;"><span class=3D"size" =
style=3D"font-size: 13px"><span class=3D"highlight" style=3D"background-col=
or:#ffffff"><span class=3D"colour" style=3D"color:#000000">lat (usec): min=
=3D26, max=3D1229, avg=3D46.79, stdev=3D19.73</span></span></span></span></=
span><span class=3D"font" style=3D"font-family: menlo, consolas, monospace,=
 sans-serif;"><span class=3D"size" style=3D"font-size: 13px"><span class=3D=
"highlight" style=3D"background-color:#ffffff"><span class=3D"colour" style=
=3D"color:#000000"><br></span></span></span></span></p><p style=3D"margin: =
0px; font-style: normal; font-variant-caps: normal; font-weight: normal; fo=
nt-stretch: normal; line-height: normal;"><span style=3D"font-variant-ligat=
ures: no-common-ligatures"><span class=3D"Apple-converted-space"><span clas=
s=3D"font" style=3D"font-family: menlo, consolas, monospace, sans-serif;"><=
span class=3D"size" style=3D"font-size: 13px"><span class=3D"highlight" sty=
le=3D"background-color:#ffffff"><span class=3D"colour" style=3D"color:#0000=
00">&nbsp; &nbsp; </span></span></span></span></span><span class=3D"font" s=
tyle=3D"font-family: menlo, consolas, monospace, sans-serif;"><span class=
=3D"size" style=3D"font-size: 13px"><span class=3D"highlight" style=3D"back=
ground-color:#ffffff"><span class=3D"colour" style=3D"color:#000000">clat p=
ercentiles (usec):</span></span></span></span></span><span class=3D"font" s=
tyle=3D"font-family: menlo, consolas, monospace, sans-serif;"><span class=
=3D"size" style=3D"font-size: 13px"><span class=3D"highlight" style=3D"back=
ground-color:#ffffff"><span class=3D"colour" style=3D"color:#000000"><br></=
span></span></span></span></p><p style=3D"margin: 0px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; font-stretch: normal; line-=
height: normal;"><span style=3D"font-variant-ligatures: no-common-ligatures=
"><span class=3D"Apple-converted-space"><span class=3D"font" style=3D"font-=
family: menlo, consolas, monospace, sans-serif;"><span class=3D"size" style=
=3D"font-size: 13px"><span class=3D"highlight" style=3D"background-color:#f=
fffff"><span class=3D"colour" style=3D"color:#000000">&nbsp;&nbsp; &nbsp; <=
/span></span></span></span></span><span class=3D"font" style=3D"font-family=
: menlo, consolas, monospace, sans-serif;"><span class=3D"size" style=3D"fo=
nt-size: 13px"><span class=3D"highlight" style=3D"background-color:#ffffff"=
><span class=3D"colour" style=3D"color:#000000">|</span></span></span></spa=
n><span class=3D"Apple-converted-space"><span class=3D"font" style=3D"font-=
family: menlo, consolas, monospace, sans-serif;"><span class=3D"size" style=
=3D"font-size: 13px"><span class=3D"highlight" style=3D"background-color:#f=
fffff"><span class=3D"colour" style=3D"color:#000000">&nbsp; </span></span>=
</span></span></span><span class=3D"font" style=3D"font-family: menlo, cons=
olas, monospace, sans-serif;"><span class=3D"size" style=3D"font-size: 13px=
"><span class=3D"highlight" style=3D"background-color:#ffffff"><span class=
=3D"colour" style=3D"color:#000000">1.00th=3D[ </span></span></span></span>=
<span class=3D"Apple-converted-space"><span class=3D"font" style=3D"font-fa=
mily: menlo, consolas, monospace, sans-serif;"><span class=3D"size" style=
=3D"font-size: 13px"><span class=3D"highlight" style=3D"background-color:#f=
fffff"><span class=3D"colour" style=3D"color:#000000">&nbsp; </span></span>=
</span></span></span><span class=3D"font" style=3D"font-family: menlo, cons=
olas, monospace, sans-serif;"><span class=3D"size" style=3D"font-size: 13px=
"><span class=3D"highlight" style=3D"background-color:#ffffff"><span class=
=3D"colour" style=3D"color:#000000">35],</span></span></span></span><span c=
lass=3D"Apple-converted-space"><span class=3D"font" style=3D"font-family: m=
enlo, consolas, monospace, sans-serif;"><span class=3D"size" style=3D"font-=
size: 13px"><span class=3D"highlight" style=3D"background-color:#ffffff"><s=
pan class=3D"colour" style=3D"color:#000000">&nbsp; </span></span></span></=
span></span><span class=3D"font" style=3D"font-family: menlo, consolas, mon=
ospace, sans-serif;"><span class=3D"size" style=3D"font-size: 13px"><span c=
lass=3D"highlight" style=3D"background-color:#ffffff"><span class=3D"colour=
" style=3D"color:#000000">5.00th=3D[ </span></span></span></span><span clas=
s=3D"Apple-converted-space"><span class=3D"font" style=3D"font-family: menl=
o, consolas, monospace, sans-serif;"><span class=3D"size" style=3D"font-siz=
e: 13px"><span class=3D"highlight" style=3D"background-color:#ffffff"><span=
 class=3D"colour" style=3D"color:#000000">&nbsp; </span></span></span></spa=
n></span><span class=3D"font" style=3D"font-family: menlo, consolas, monosp=
ace, sans-serif;"><span class=3D"size" style=3D"font-size: 13px"><span clas=
s=3D"highlight" style=3D"background-color:#ffffff"><span class=3D"colour" s=
tyle=3D"color:#000000">39], 10.00th=3D[ </span></span></span></span><span c=
lass=3D"Apple-converted-space"><span class=3D"font" style=3D"font-family: m=
enlo, consolas, monospace, sans-serif;"><span class=3D"size" style=3D"font-=
size: 13px"><span class=3D"highlight" style=3D"background-color:#ffffff"><s=
pan class=3D"colour" style=3D"color:#000000">&nbsp; </span></span></span></=
span></span><span class=3D"font" style=3D"font-family: menlo, consolas, mon=
ospace, sans-serif;"><span class=3D"size" style=3D"font-size: 13px"><span c=
lass=3D"highlight" style=3D"background-color:#ffffff"><span class=3D"colour=
" style=3D"color:#000000">40], 20.00th=3D[ </span></span></span></span><spa=
n class=3D"Apple-converted-space"><span class=3D"font" style=3D"font-family=
: menlo, consolas, monospace, sans-serif;"><span class=3D"size" style=3D"fo=
nt-size: 13px"><span class=3D"highlight" style=3D"background-color:#ffffff"=
><span class=3D"colour" style=3D"color:#000000">&nbsp; </span></span></span=
></span></span><span class=3D"font" style=3D"font-family: menlo, consolas, =
monospace, sans-serif;"><span class=3D"size" style=3D"font-size: 13px"><spa=
n class=3D"highlight" style=3D"background-color:#ffffff"><span class=3D"col=
our" style=3D"color:#000000">42],</span></span></span></span></span><span c=
lass=3D"font" style=3D"font-family: menlo, consolas, monospace, sans-serif;=
"><span class=3D"size" style=3D"font-size: 13px"><span class=3D"highlight" =
style=3D"background-color:#ffffff"><span class=3D"colour" style=3D"color:#0=
00000"><br></span></span></span></span></p><p style=3D"margin: 0px; font-st=
yle: normal; font-variant-caps: normal; font-weight: normal; font-stretch: =
normal; line-height: normal;"><span style=3D"font-variant-ligatures: no-com=
mon-ligatures"><span class=3D"Apple-converted-space"><span class=3D"font" s=
tyle=3D"font-family: menlo, consolas, monospace, sans-serif;"><span class=
=3D"size" style=3D"font-size: 13px"><span class=3D"highlight" style=3D"back=
ground-color:#ffffff"><span class=3D"colour" style=3D"color:#000000">&nbsp;=
&nbsp; &nbsp; </span></span></span></span></span><span class=3D"font" style=
=3D"font-family: menlo, consolas, monospace, sans-serif;"><span class=3D"si=
ze" style=3D"font-size: 13px"><span class=3D"highlight" style=3D"background=
-color:#ffffff"><span class=3D"colour" style=3D"color:#000000">| 30.00th=3D=
[ </span></span></span></span><span class=3D"Apple-converted-space"><span c=
lass=3D"font" style=3D"font-family: menlo, consolas, monospace, sans-serif;=
"><span class=3D"size" style=3D"font-size: 13px"><span class=3D"highlight" =
style=3D"background-color:#ffffff"><span class=3D"colour" style=3D"color:#0=
00000">&nbsp; </span></span></span></span></span><span class=3D"font" style=
=3D"font-family: menlo, consolas, monospace, sans-serif;"><span class=3D"si=
ze" style=3D"font-size: 13px"><span class=3D"highlight" style=3D"background=
-color:#ffffff"><span class=3D"colour" style=3D"color:#000000">42], 40.00th=
=3D[ </span></span></span></span><span class=3D"Apple-converted-space"><spa=
n class=3D"font" style=3D"font-family: menlo, consolas, monospace, sans-ser=
if;"><span class=3D"size" style=3D"font-size: 13px"><span class=3D"highligh=
t" style=3D"background-color:#ffffff"><span class=3D"colour" style=3D"color=
:#000000">&nbsp; </span></span></span></span></span><span class=3D"font" st=
yle=3D"font-family: menlo, consolas, monospace, sans-serif;"><span class=3D=
"size" style=3D"font-size: 13px"><span class=3D"highlight" style=3D"backgro=
und-color:#ffffff"><span class=3D"colour" style=3D"color:#000000">43], 50.0=
0th=3D[ </span></span></span></span><span class=3D"Apple-converted-space"><=
span class=3D"font" style=3D"font-family: menlo, consolas, monospace, sans-=
serif;"><span class=3D"size" style=3D"font-size: 13px"><span class=3D"highl=
ight" style=3D"background-color:#ffffff"><span class=3D"colour" style=3D"co=
lor:#000000">&nbsp; </span></span></span></span></span><span class=3D"font"=
 style=3D"font-family: menlo, consolas, monospace, sans-serif;"><span class=
=3D"size" style=3D"font-size: 13px"><span class=3D"highlight" style=3D"back=
ground-color:#ffffff"><span class=3D"colour" style=3D"color:#000000">44], 6=
0.00th=3D[ </span></span></span></span><span class=3D"Apple-converted-space=
"><span class=3D"font" style=3D"font-family: menlo, consolas, monospace, sa=
ns-serif;"><span class=3D"size" style=3D"font-size: 13px"><span class=3D"hi=
ghlight" style=3D"background-color:#ffffff"><span class=3D"colour" style=3D=
"color:#000000">&nbsp; </span></span></span></span></span><span class=3D"fo=
nt" style=3D"font-family: menlo, consolas, monospace, sans-serif;"><span cl=
ass=3D"size" style=3D"font-size: 13px"><span class=3D"highlight" style=3D"b=
ackground-color:#ffffff"><span class=3D"colour" style=3D"color:#000000">44]=
,</span></span></span></span></span><span class=3D"font" style=3D"font-fami=
ly: menlo, consolas, monospace, sans-serif;"><span class=3D"size" style=3D"=
font-size: 13px"><span class=3D"highlight" style=3D"background-color:#fffff=
f"><span class=3D"colour" style=3D"color:#000000"><br></span></span></span>=
</span></p><p style=3D"margin: 0px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; font-stretch: normal; line-height: normal;"><s=
pan style=3D"font-variant-ligatures: no-common-ligatures"><span class=3D"Ap=
ple-converted-space"><span class=3D"font" style=3D"font-family: menlo, cons=
olas, monospace, sans-serif;"><span class=3D"size" style=3D"font-size: 13px=
"><span class=3D"highlight" style=3D"background-color:#ffffff"><span class=
=3D"colour" style=3D"color:#000000">&nbsp;&nbsp; &nbsp; </span></span></spa=
n></span></span><span class=3D"font" style=3D"font-family: menlo, consolas,=
 monospace, sans-serif;"><span class=3D"size" style=3D"font-size: 13px"><sp=
an class=3D"highlight" style=3D"background-color:#ffffff"><span class=3D"co=
lour" style=3D"color:#000000">| 70.00th=3D[ </span></span></span></span><sp=
an class=3D"Apple-converted-space"><span class=3D"font" style=3D"font-famil=
y: menlo, consolas, monospace, sans-serif;"><span class=3D"size" style=3D"f=
ont-size: 13px"><span class=3D"highlight" style=3D"background-color:#ffffff=
"><span class=3D"colour" style=3D"color:#000000">&nbsp; </span></span></spa=
n></span></span><span class=3D"font" style=3D"font-family: menlo, consolas,=
 monospace, sans-serif;"><span class=3D"size" style=3D"font-size: 13px"><sp=
an class=3D"highlight" style=3D"background-color:#ffffff"><span class=3D"co=
lour" style=3D"color:#000000">45], 80.00th=3D[ </span></span></span></span>=
<span class=3D"Apple-converted-space"><span class=3D"font" style=3D"font-fa=
mily: menlo, consolas, monospace, sans-serif;"><span class=3D"size" style=
=3D"font-size: 13px"><span class=3D"highlight" style=3D"background-color:#f=
fffff"><span class=3D"colour" style=3D"color:#000000">&nbsp; </span></span>=
</span></span></span><span class=3D"font" style=3D"font-family: menlo, cons=
olas, monospace, sans-serif;"><span class=3D"size" style=3D"font-size: 13px=
"><span class=3D"highlight" style=3D"background-color:#ffffff"><span class=
=3D"colour" style=3D"color:#000000">47], 90.00th=3D[ </span></span></span><=
/span><span class=3D"Apple-converted-space"><span class=3D"font" style=3D"f=
ont-family: menlo, consolas, monospace, sans-serif;"><span class=3D"size" s=
tyle=3D"font-size: 13px"><span class=3D"highlight" style=3D"background-colo=
r:#ffffff"><span class=3D"colour" style=3D"color:#000000">&nbsp; </span></s=
pan></span></span></span><span class=3D"font" style=3D"font-family: menlo, =
consolas, monospace, sans-serif;"><span class=3D"size" style=3D"font-size: =
13px"><span class=3D"highlight" style=3D"background-color:#ffffff"><span cl=
ass=3D"colour" style=3D"color:#000000">52], 95.00th=3D[ </span></span></spa=
n></span><span class=3D"Apple-converted-space"><span class=3D"font" style=
=3D"font-family: menlo, consolas, monospace, sans-serif;"><span class=3D"si=
ze" style=3D"font-size: 13px"><span class=3D"highlight" style=3D"background=
-color:#ffffff"><span class=3D"colour" style=3D"color:#000000">&nbsp; </spa=
n></span></span></span></span><span class=3D"font" style=3D"font-family: me=
nlo, consolas, monospace, sans-serif;"><span class=3D"size" style=3D"font-s=
ize: 13px"><span class=3D"highlight" style=3D"background-color:#ffffff"><sp=
an class=3D"colour" style=3D"color:#000000">64],</span></span></span></span=
></span><span class=3D"font" style=3D"font-family: menlo, consolas, monospa=
ce, sans-serif;"><span class=3D"size" style=3D"font-size: 13px"><span class=
=3D"highlight" style=3D"background-color:#ffffff"><span class=3D"colour" st=
yle=3D"color:#000000"><br></span></span></span></span></p><p style=3D"margi=
n: 0px; font-style: normal; font-variant-caps: normal; font-weight: normal;=
 font-stretch: normal; line-height: normal;"><span style=3D"font-variant-li=
gatures: no-common-ligatures"><span class=3D"Apple-converted-space"><span c=
lass=3D"font" style=3D"font-family: menlo, consolas, monospace, sans-serif;=
"><span class=3D"size" style=3D"font-size: 13px"><span class=3D"highlight" =
style=3D"background-color:#ffffff"><span class=3D"colour" style=3D"color:#0=
00000">&nbsp;&nbsp; &nbsp; </span></span></span></span></span><span class=
=3D"font" style=3D"font-family: menlo, consolas, monospace, sans-serif;"><s=
pan class=3D"size" style=3D"font-size: 13px"><span class=3D"highlight" styl=
e=3D"background-color:#ffffff"><span class=3D"colour" style=3D"color:#00000=
0">| 99.00th=3D[</span></span></span></span><span class=3D"Apple-converted-=
space"><span class=3D"font" style=3D"font-family: menlo, consolas, monospac=
e, sans-serif;"><span class=3D"size" style=3D"font-size: 13px"><span class=
=3D"highlight" style=3D"background-color:#ffffff"><span class=3D"colour" st=
yle=3D"color:#000000">&nbsp; </span></span></span></span></span><span class=
=3D"font" style=3D"font-family: menlo, consolas, monospace, sans-serif;"><s=
pan class=3D"size" style=3D"font-size: 13px"><span class=3D"highlight" styl=
e=3D"background-color:#ffffff"><span class=3D"colour" style=3D"color:#00000=
0">120], 99.50th=3D[</span></span></span></span><span class=3D"Apple-conver=
ted-space"><span class=3D"font" style=3D"font-family: menlo, consolas, mono=
space, sans-serif;"><span class=3D"size" style=3D"font-size: 13px"><span cl=
ass=3D"highlight" style=3D"background-color:#ffffff"><span class=3D"colour"=
 style=3D"color:#000000">&nbsp; </span></span></span></span></span><span cl=
ass=3D"font" style=3D"font-family: menlo, consolas, monospace, sans-serif;"=
><span class=3D"size" style=3D"font-size: 13px"><span class=3D"highlight" s=
tyle=3D"background-color:#ffffff"><span class=3D"colour" style=3D"color:#00=
0000">153], 99.90th=3D[</span></span></span></span><span class=3D"Apple-con=
verted-space"><span class=3D"font" style=3D"font-family: menlo, consolas, m=
onospace, sans-serif;"><span class=3D"size" style=3D"font-size: 13px"><span=
 class=3D"highlight" style=3D"background-color:#ffffff"><span class=3D"colo=
ur" style=3D"color:#000000">&nbsp; </span></span></span></span></span><span=
 class=3D"font" style=3D"font-family: menlo, consolas, monospace, sans-seri=
f;"><span class=3D"size" style=3D"font-size: 13px"><span class=3D"highlight=
" style=3D"background-color:#ffffff"><span class=3D"colour" style=3D"color:=
#000000">269], 99.95th=3D[</span></span></span></span><span class=3D"Apple-=
converted-space"><span class=3D"font" style=3D"font-family: menlo, consolas=
, monospace, sans-serif;"><span class=3D"size" style=3D"font-size: 13px"><s=
pan class=3D"highlight" style=3D"background-color:#ffffff"><span class=3D"c=
olour" style=3D"color:#000000">&nbsp; </span></span></span></span></span><s=
pan class=3D"font" style=3D"font-family: menlo, consolas, monospace, sans-s=
erif;"><span class=3D"size" style=3D"font-size: 13px"><span class=3D"highli=
ght" style=3D"background-color:#ffffff"><span class=3D"colour" style=3D"col=
or:#000000">359],</span></span></span></span></span><span class=3D"font" st=
yle=3D"font-family: menlo, consolas, monospace, sans-serif;"><span class=3D=
"size" style=3D"font-size: 13px"><span class=3D"highlight" style=3D"backgro=
und-color:#ffffff"><span class=3D"colour" style=3D"color:#000000"><br></spa=
n></span></span></span></p><p style=3D"margin: 0px; font-style: normal; fon=
t-variant-caps: normal; font-weight: normal; font-stretch: normal; line-hei=
ght: normal;"><span style=3D"font-variant-ligatures: no-common-ligatures"><=
span class=3D"Apple-converted-space"><span class=3D"font" style=3D"font-fam=
ily: menlo, consolas, monospace, sans-serif;"><span class=3D"size" style=3D=
"font-size: 13px"><span class=3D"highlight" style=3D"background-color:#ffff=
ff"><span class=3D"colour" style=3D"color:#000000">&nbsp;&nbsp; &nbsp; </sp=
an></span></span></span></span><span class=3D"font" style=3D"font-family: m=
enlo, consolas, monospace, sans-serif;"><span class=3D"size" style=3D"font-=
size: 13px"><span class=3D"highlight" style=3D"background-color:#ffffff"><s=
pan class=3D"colour" style=3D"color:#000000">| 99.99th=3D[</span></span></s=
pan></span><span class=3D"Apple-converted-space"><span class=3D"font" style=
=3D"font-family: menlo, consolas, monospace, sans-serif;"><span class=3D"si=
ze" style=3D"font-size: 13px"><span class=3D"highlight" style=3D"background=
-color:#ffffff"><span class=3D"colour" style=3D"color:#000000">&nbsp; </spa=
n></span></span></span></span><span class=3D"font" style=3D"font-family: me=
nlo, consolas, monospace, sans-serif;"><span class=3D"size" style=3D"font-s=
ize: 13px"><span class=3D"highlight" style=3D"background-color:#ffffff"><sp=
an class=3D"colour" style=3D"color:#000000">627]</span></span></span></span=
></span><span class=3D"font" style=3D"font-family: menlo, consolas, monospa=
ce, sans-serif;"><span class=3D"size" style=3D"font-size: 13px"><span class=
=3D"highlight" style=3D"background-color:#ffffff"><span class=3D"colour" st=
yle=3D"color:#000000"><br></span></span></span></span></p><p style=3D"margi=
n: 0px; font-style: normal; font-variant-caps: normal; font-weight: normal;=
 font-stretch: normal; line-height: normal;"><span style=3D"font-variant-li=
gatures: no-common-ligatures"><span class=3D"Apple-converted-space"><span c=
lass=3D"font" style=3D"font-family: menlo, consolas, monospace, sans-serif;=
"><span class=3D"size" style=3D"font-size: 13px"><span class=3D"highlight" =
style=3D"background-color:#ffffff"><span class=3D"colour" style=3D"color:#0=
00000">&nbsp;&nbsp; </span></span></span></span></span><span class=3D"font"=
 style=3D"font-family: menlo, consolas, monospace, sans-serif;"><span class=
=3D"size" style=3D"font-size: 13px"><span class=3D"highlight" style=3D"back=
ground-color:#ffffff"><span class=3D"colour" style=3D"color:#000000">bw (</=
span></span></span></span><span class=3D"Apple-converted-space"><span class=
=3D"font" style=3D"font-family: menlo, consolas, monospace, sans-serif;"><s=
pan class=3D"size" style=3D"font-size: 13px"><span class=3D"highlight" styl=
e=3D"background-color:#ffffff"><span class=3D"colour" style=3D"color:#00000=
0">&nbsp; </span></span></span></span></span><span class=3D"font" style=3D"=
font-family: menlo, consolas, monospace, sans-serif;"><span class=3D"size" =
style=3D"font-size: 13px"><span class=3D"highlight" style=3D"background-col=
or:#ffffff"><span class=3D"colour" style=3D"color:#000000">KiB/s): min=3D68=
9820, max=3D748346, per=3D99.16%, avg=3D727266.49, stdev=3D13577.99, sample=
s=3D45</span></span></span></span></span><span class=3D"font" style=3D"font=
-family: menlo, consolas, monospace, sans-serif;"><span class=3D"size" styl=
e=3D"font-size: 13px"><span class=3D"highlight" style=3D"background-color:#=
ffffff"><span class=3D"colour" style=3D"color:#000000"><br></span></span></=
span></span></p><p style=3D"margin: 0px; font-style: normal; font-variant-c=
aps: normal; font-weight: normal; font-stretch: normal; line-height: normal=
;"><span style=3D"font-variant-ligatures: no-common-ligatures"><span class=
=3D"Apple-converted-space"><span class=3D"font" style=3D"font-family: menlo=
, consolas, monospace, sans-serif;"><span class=3D"size" style=3D"font-size=
: 13px"><span class=3D"highlight" style=3D"background-color:#ffffff"><span =
class=3D"colour" style=3D"color:#000000">&nbsp;&nbsp; </span></span></span>=
</span></span><span class=3D"font" style=3D"font-family: menlo, consolas, m=
onospace, sans-serif;"><span class=3D"size" style=3D"font-size: 13px"><span=
 class=3D"highlight" style=3D"background-color:#ffffff"><span class=3D"colo=
ur" style=3D"color:#000000">iops</span></span></span></span><span class=3D"=
Apple-converted-space"><span class=3D"font" style=3D"font-family: menlo, co=
nsolas, monospace, sans-serif;"><span class=3D"size" style=3D"font-size: 13=
px"><span class=3D"highlight" style=3D"background-color:#ffffff"><span clas=
s=3D"colour" style=3D"color:#000000">&nbsp; &nbsp; &nbsp; &nbsp; </span></s=
pan></span></span></span><span class=3D"font" style=3D"font-family: menlo, =
consolas, monospace, sans-serif;"><span class=3D"size" style=3D"font-size: =
13px"><span class=3D"highlight" style=3D"background-color:#ffffff"><span cl=
ass=3D"colour" style=3D"color:#000000">: min=3D 5389, max=3D 5846, avg=3D56=
81.29, stdev=3D106.15, samples=3D45</span></span></span></span></span><span=
 class=3D"font" style=3D"font-family: menlo, consolas, monospace, sans-seri=
f;"><span class=3D"size" style=3D"font-size: 13px"><span class=3D"highlight=
" style=3D"background-color:#ffffff"><span class=3D"colour" style=3D"color:=
#000000"><br></span></span></span></span></p><p style=3D"margin: 0px; font-=
style: normal; font-variant-caps: normal; font-weight: normal; font-stretch=
: normal; line-height: normal;"><span style=3D"font-variant-ligatures: no-c=
ommon-ligatures"><span class=3D"Apple-converted-space"><span class=3D"font"=
 style=3D"font-family: menlo, consolas, monospace, sans-serif;"><span class=
=3D"size" style=3D"font-size: 13px"><span class=3D"highlight" style=3D"back=
ground-color:#ffffff"><span class=3D"colour" style=3D"color:#000000">&nbsp;=
 </span></span></span></span></span><span class=3D"font" style=3D"font-fami=
ly: menlo, consolas, monospace, sans-serif;"><span class=3D"size" style=3D"=
font-size: 13px"><span class=3D"highlight" style=3D"background-color:#fffff=
f"><span class=3D"colour" style=3D"color:#000000">lat (usec) </span></span>=
</span></span><span class=3D"Apple-converted-space"><span class=3D"font" st=
yle=3D"font-family: menlo, consolas, monospace, sans-serif;"><span class=3D=
"size" style=3D"font-size: 13px"><span class=3D"highlight" style=3D"backgro=
und-color:#ffffff"><span class=3D"colour" style=3D"color:#000000">&nbsp; </=
span></span></span></span></span><span class=3D"font" style=3D"font-family:=
 menlo, consolas, monospace, sans-serif;"><span class=3D"size" style=3D"fon=
t-size: 13px"><span class=3D"highlight" style=3D"background-color:#ffffff">=
<span class=3D"colour" style=3D"color:#000000">: 50=3D88.05%, 100=3D10.38%,=
 250=3D1.45%, 500=3D0.10%, 750=3D0.02%</span></span></span></span></span><s=
pan class=3D"font" style=3D"font-family: menlo, consolas, monospace, sans-s=
erif;"><span class=3D"size" style=3D"font-size: 13px"><span class=3D"highli=
ght" style=3D"background-color:#ffffff"><span class=3D"colour" style=3D"col=
or:#000000"><br></span></span></span></span></p><p style=3D"margin: 0px; fo=
nt-style: normal; font-variant-caps: normal; font-weight: normal; font-stre=
tch: normal; line-height: normal;"><span style=3D"font-variant-ligatures: n=
o-common-ligatures"><span class=3D"Apple-converted-space"><span class=3D"fo=
nt" style=3D"font-family: menlo, consolas, monospace, sans-serif;"><span cl=
ass=3D"size" style=3D"font-size: 13px"><span class=3D"highlight" style=3D"b=
ackground-color:#ffffff"><span class=3D"colour" style=3D"color:#000000">&nb=
sp; </span></span></span></span></span><span class=3D"font" style=3D"font-f=
amily: menlo, consolas, monospace, sans-serif;"><span class=3D"size" style=
=3D"font-size: 13px"><span class=3D"highlight" style=3D"background-color:#f=
fffff"><span class=3D"colour" style=3D"color:#000000">lat (usec) </span></s=
pan></span></span><span class=3D"Apple-converted-space"><span class=3D"font=
" style=3D"font-family: menlo, consolas, monospace, sans-serif;"><span clas=
s=3D"size" style=3D"font-size: 13px"><span class=3D"highlight" style=3D"bac=
kground-color:#ffffff"><span class=3D"colour" style=3D"color:#000000">&nbsp=
; </span></span></span></span></span><span class=3D"font" style=3D"font-fam=
ily: menlo, consolas, monospace, sans-serif;"><span class=3D"size" style=3D=
"font-size: 13px"><span class=3D"highlight" style=3D"background-color:#ffff=
ff"><span class=3D"colour" style=3D"color:#000000">: 1000=3D0.01%</span></s=
pan></span></span></span><span class=3D"font" style=3D"font-family: menlo, =
consolas, monospace, sans-serif;"><span class=3D"size" style=3D"font-size: =
13px"><span class=3D"highlight" style=3D"background-color:#ffffff"><span cl=
ass=3D"colour" style=3D"color:#000000"><br></span></span></span></span></p>=
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; fon=
t-weight: normal; font-stretch: normal; line-height: normal;"><span style=
=3D"font-variant-ligatures: no-common-ligatures"><span class=3D"Apple-conve=
rted-space"><span class=3D"font" style=3D"font-family: menlo, consolas, mon=
ospace, sans-serif;"><span class=3D"size" style=3D"font-size: 13px"><span c=
lass=3D"highlight" style=3D"background-color:#ffffff"><span class=3D"colour=
" style=3D"color:#000000">&nbsp; </span></span></span></span></span><span c=
lass=3D"font" style=3D"font-family: menlo, consolas, monospace, sans-serif;=
"><span class=3D"size" style=3D"font-size: 13px"><span class=3D"highlight" =
style=3D"background-color:#ffffff"><span class=3D"colour" style=3D"color:#0=
00000">lat (msec) </span></span></span></span><span class=3D"Apple-converte=
d-space"><span class=3D"font" style=3D"font-family: menlo, consolas, monosp=
ace, sans-serif;"><span class=3D"size" style=3D"font-size: 13px"><span clas=
s=3D"highlight" style=3D"background-color:#ffffff"><span class=3D"colour" s=
tyle=3D"color:#000000">&nbsp; </span></span></span></span></span><span clas=
s=3D"font" style=3D"font-family: menlo, consolas, monospace, sans-serif;"><=
span class=3D"size" style=3D"font-size: 13px"><span class=3D"highlight" sty=
le=3D"background-color:#ffffff"><span class=3D"colour" style=3D"color:#0000=
00">: 2=3D0.01%</span></span></span></span></span><span class=3D"font" styl=
e=3D"font-family: menlo, consolas, monospace, sans-serif;"><span class=3D"s=
ize" style=3D"font-size: 13px"><span class=3D"highlight" style=3D"backgroun=
d-color:#ffffff"><span class=3D"colour" style=3D"color:#000000"><br></span>=
</span></span></span></p><p style=3D"margin: 0px; font-style: normal; font-=
variant-caps: normal; font-weight: normal; font-stretch: normal; line-heigh=
t: normal;"><span style=3D"font-variant-ligatures: no-common-ligatures"><sp=
an class=3D"Apple-converted-space"><span class=3D"font" style=3D"font-famil=
y: menlo, consolas, monospace, sans-serif;"><span class=3D"size" style=3D"f=
ont-size: 13px"><span class=3D"highlight" style=3D"background-color:#ffffff=
"><span class=3D"colour" style=3D"color:#000000">&nbsp; </span></span></spa=
n></span></span><span class=3D"font" style=3D"font-family: menlo, consolas,=
 monospace, sans-serif;"><span class=3D"size" style=3D"font-size: 13px"><sp=
an class=3D"highlight" style=3D"background-color:#ffffff"><span class=3D"co=
lour" style=3D"color:#000000">cpu</span></span></span></span><span class=3D=
"Apple-converted-space"><span class=3D"font" style=3D"font-family: menlo, c=
onsolas, monospace, sans-serif;"><span class=3D"size" style=3D"font-size: 1=
3px"><span class=3D"highlight" style=3D"background-color:#ffffff"><span cla=
ss=3D"colour" style=3D"color:#000000">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; </=
span></span></span></span></span><span class=3D"font" style=3D"font-family:=
 menlo, consolas, monospace, sans-serif;"><span class=3D"size" style=3D"fon=
t-size: 13px"><span class=3D"highlight" style=3D"background-color:#ffffff">=
<span class=3D"colour" style=3D"color:#000000">: usr=3D70.79%, sys=3D27.64%=
, ctx=3D24546, majf=3D0, minf=3D0</span></span></span></span></span><span c=
lass=3D"font" style=3D"font-family: menlo, consolas, monospace, sans-serif;=
"><span class=3D"size" style=3D"font-size: 13px"><span class=3D"highlight" =
style=3D"background-color:#ffffff"><span class=3D"colour" style=3D"color:#0=
00000"><br></span></span></span></span></p><p style=3D"margin: 0px; font-st=
yle: normal; font-variant-caps: normal; font-weight: normal; font-stretch: =
normal; line-height: normal;"><span style=3D"font-variant-ligatures: no-com=
mon-ligatures"><span class=3D"Apple-converted-space"><span class=3D"font" s=
tyle=3D"font-family: menlo, consolas, monospace, sans-serif;"><span class=
=3D"size" style=3D"font-size: 13px"><span class=3D"highlight" style=3D"back=
ground-color:#ffffff"><span class=3D"colour" style=3D"color:#000000">&nbsp;=
 </span></span></span></span></span><span class=3D"font" style=3D"font-fami=
ly: menlo, consolas, monospace, sans-serif;"><span class=3D"size" style=3D"=
font-size: 13px"><span class=3D"highlight" style=3D"background-color:#fffff=
f"><span class=3D"colour" style=3D"color:#000000">IO depths</span></span></=
span></span><span class=3D"Apple-converted-space"><span class=3D"font" styl=
e=3D"font-family: menlo, consolas, monospace, sans-serif;"><span class=3D"s=
ize" style=3D"font-size: 13px"><span class=3D"highlight" style=3D"backgroun=
d-color:#ffffff"><span class=3D"colour" style=3D"color:#000000">&nbsp; &nbs=
p; </span></span></span></span></span><span class=3D"font" style=3D"font-fa=
mily: menlo, consolas, monospace, sans-serif;"><span class=3D"size" style=
=3D"font-size: 13px"><span class=3D"highlight" style=3D"background-color:#f=
fffff"><span class=3D"colour" style=3D"color:#000000">: 1=3D100.0%, 2=3D0.0=
%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, &gt;=3D64=3D0.0%</span></span>=
</span></span></span><span class=3D"font" style=3D"font-family: menlo, cons=
olas, monospace, sans-serif;"><span class=3D"size" style=3D"font-size: 13px=
"><span class=3D"highlight" style=3D"background-color:#ffffff"><span class=
=3D"colour" style=3D"color:#000000"><br></span></span></span></span></p><p =
style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; font-w=
eight: normal; font-stretch: normal; line-height: normal;"><span style=3D"f=
ont-variant-ligatures: no-common-ligatures"><span class=3D"Apple-converted-=
space"><span class=3D"font" style=3D"font-family: menlo, consolas, monospac=
e, sans-serif;"><span class=3D"size" style=3D"font-size: 13px"><span class=
=3D"highlight" style=3D"background-color:#ffffff"><span class=3D"colour" st=
yle=3D"color:#000000">&nbsp;&nbsp; &nbsp; </span></span></span></span></spa=
n><span class=3D"font" style=3D"font-family: menlo, consolas, monospace, sa=
ns-serif;"><span class=3D"size" style=3D"font-size: 13px"><span class=3D"hi=
ghlight" style=3D"background-color:#ffffff"><span class=3D"colour" style=3D=
"color:#000000">submit</span></span></span></span><span class=3D"Apple-conv=
erted-space"><span class=3D"font" style=3D"font-family: menlo, consolas, mo=
nospace, sans-serif;"><span class=3D"size" style=3D"font-size: 13px"><span =
class=3D"highlight" style=3D"background-color:#ffffff"><span class=3D"colou=
r" style=3D"color:#000000">&nbsp; &nbsp; </span></span></span></span></span=
><span class=3D"font" style=3D"font-family: menlo, consolas, monospace, san=
s-serif;"><span class=3D"size" style=3D"font-size: 13px"><span class=3D"hig=
hlight" style=3D"background-color:#ffffff"><span class=3D"colour" style=3D"=
color:#000000">: 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, &gt;=3D64=3D0.0%</span></span></span></span></span><span class=3D"=
font" style=3D"font-family: menlo, consolas, monospace, sans-serif;"><span =
class=3D"size" style=3D"font-size: 13px"><span class=3D"highlight" style=3D=
"background-color:#ffffff"><span class=3D"colour" style=3D"color:#000000"><=
br></span></span></span></span></p><p style=3D"margin: 0px; font-style: nor=
mal; font-variant-caps: normal; font-weight: normal; font-stretch: normal; =
line-height: normal;"><span style=3D"font-variant-ligatures: no-common-liga=
tures"><span class=3D"Apple-converted-space"><span class=3D"font" style=3D"=
font-family: menlo, consolas, monospace, sans-serif;"><span class=3D"size" =
style=3D"font-size: 13px"><span class=3D"highlight" style=3D"background-col=
or:#ffffff"><span class=3D"colour" style=3D"color:#000000">&nbsp;&nbsp; &nb=
sp; </span></span></span></span></span><span class=3D"font" style=3D"font-f=
amily: menlo, consolas, monospace, sans-serif;"><span class=3D"size" style=
=3D"font-size: 13px"><span class=3D"highlight" style=3D"background-color:#f=
fffff"><span class=3D"colour" style=3D"color:#000000">complete</span></span=
></span></span><span class=3D"Apple-converted-space"><span class=3D"font" s=
tyle=3D"font-family: menlo, consolas, monospace, sans-serif;"><span class=
=3D"size" style=3D"font-size: 13px"><span class=3D"highlight" style=3D"back=
ground-color:#ffffff"><span class=3D"colour" style=3D"color:#000000">&nbsp;=
 </span></span></span></span></span><span class=3D"font" style=3D"font-fami=
ly: menlo, consolas, monospace, sans-serif;"><span class=3D"size" style=3D"=
font-size: 13px"><span class=3D"highlight" style=3D"background-color:#fffff=
f"><span class=3D"colour" style=3D"color:#000000">: 0=3D0.0%, 4=3D100.0%, 8=
=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=3D0.0%, &gt;=3D64=3D0.0%</span></span></s=
pan></span></span><span class=3D"font" style=3D"font-family: menlo, consola=
s, monospace, sans-serif;"><span class=3D"size" style=3D"font-size: 13px"><=
span class=3D"highlight" style=3D"background-color:#ffffff"><span class=3D"=
colour" style=3D"color:#000000"><br></span></span></span></span></p><p styl=
e=3D"margin: 0px; font-style: normal; font-variant-caps: normal; font-weigh=
t: normal; font-stretch: normal; line-height: normal;"><span style=3D"font-=
variant-ligatures: no-common-ligatures"><span class=3D"Apple-converted-spac=
e"><span class=3D"font" style=3D"font-family: menlo, consolas, monospace, s=
ans-serif;"><span class=3D"size" style=3D"font-size: 13px"><span class=3D"h=
ighlight" style=3D"background-color:#ffffff"><span class=3D"colour" style=
=3D"color:#000000">&nbsp;&nbsp; &nbsp; </span></span></span></span></span><=
span class=3D"font" style=3D"font-family: menlo, consolas, monospace, sans-=
serif;"><span class=3D"size" style=3D"font-size: 13px"><span class=3D"highl=
ight" style=3D"background-color:#ffffff"><span class=3D"colour" style=3D"co=
lor:#000000">issued rwts: total=3D0,131072,0,0 short=3D0,0,0,0 dropped=3D0,=
0,0,0</span></span></span></span></span><span class=3D"font" style=3D"font-=
family: menlo, consolas, monospace, sans-serif;"><span class=3D"size" style=
=3D"font-size: 13px"><span class=3D"highlight" style=3D"background-color:#f=
fffff"><span class=3D"colour" style=3D"color:#000000"><br></span></span></s=
pan></span></p><p style=3D"margin: 0px; font-style: normal; font-variant-ca=
ps: normal; font-weight: normal; font-stretch: normal; line-height: normal;=
"><span style=3D"font-variant-ligatures: no-common-ligatures"><span class=
=3D"Apple-converted-space"><span class=3D"font" style=3D"font-family: menlo=
, consolas, monospace, sans-serif;"><span class=3D"size" style=3D"font-size=
: 13px"><span class=3D"highlight" style=3D"background-color:#ffffff"><span =
class=3D"colour" style=3D"color:#000000">&nbsp;&nbsp; &nbsp; </span></span>=
</span></span></span><span class=3D"font" style=3D"font-family: menlo, cons=
olas, monospace, sans-serif;"><span class=3D"size" style=3D"font-size: 13px=
"><span class=3D"highlight" style=3D"background-color:#ffffff"><span class=
=3D"colour" style=3D"color:#000000">latency </span></span></span></span><sp=
an class=3D"Apple-converted-space"><span class=3D"font" style=3D"font-famil=
y: menlo, consolas, monospace, sans-serif;"><span class=3D"size" style=3D"f=
ont-size: 13px"><span class=3D"highlight" style=3D"background-color:#ffffff=
"><span class=3D"colour" style=3D"color:#000000">&nbsp; </span></span></spa=
n></span></span><span class=3D"font" style=3D"font-family: menlo, consolas,=
 monospace, sans-serif;"><span class=3D"size" style=3D"font-size: 13px"><sp=
an class=3D"highlight" style=3D"background-color:#ffffff"><span class=3D"co=
lour" style=3D"color:#000000">: target=3D0, window=3D0, percentile=3D100.00=
%, depth=3D1</span></span></span></span></span><span class=3D"font" style=
=3D"font-family: menlo, consolas, monospace, sans-serif;"><span class=3D"si=
ze" style=3D"font-size: 13px"><span class=3D"highlight" style=3D"background=
-color:#ffffff"><span class=3D"colour" style=3D"color:#000000"><br></span><=
/span></span></span></p><p style=3D"margin: 0px; font-style: normal; font-v=
ariant-caps: normal; font-weight: normal; font-stretch: normal; line-height=
: normal; min-height: 14px;"><span class=3D"font" style=3D"font-family: men=
lo, consolas, monospace, sans-serif;"><span class=3D"size" style=3D"font-si=
ze: 13px"><span class=3D"highlight" style=3D"background-color:#ffffff"><spa=
n class=3D"colour" style=3D"color:#000000"><br></span></span></span></span>=
</p><p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal;=
 font-weight: normal; font-stretch: normal; line-height: normal;"><span sty=
le=3D"font-variant-ligatures: no-common-ligatures"><span class=3D"font" sty=
le=3D"font-family: menlo, consolas, monospace, sans-serif;"><span class=3D"=
size" style=3D"font-size: 13px"><span class=3D"highlight" style=3D"backgrou=
nd-color:#ffffff"><span class=3D"colour" style=3D"color:#000000">Run status=
 group 0 (all jobs):</span></span></span></span></span><span class=3D"font"=
 style=3D"font-family: menlo, consolas, monospace, sans-serif;"><span class=
=3D"size" style=3D"font-size: 13px"><span class=3D"highlight" style=3D"back=
ground-color:#ffffff"><span class=3D"colour" style=3D"color:#000000"><br></=
span></span></span></span></p><p style=3D"margin: 0px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; font-stretch: normal; line-=
height: normal;"><span style=3D"font-variant-ligatures: no-common-ligatures=
"><span class=3D"Apple-converted-space"><span class=3D"font" style=3D"font-=
family: menlo, consolas, monospace, sans-serif;"><span class=3D"size" style=
=3D"font-size: 13px"><span class=3D"highlight" style=3D"background-color:#f=
fffff"><span class=3D"colour" style=3D"color:#000000">&nbsp; </span></span>=
</span></span></span><span class=3D"font" style=3D"font-family: menlo, cons=
olas, monospace, sans-serif;"><span class=3D"size" style=3D"font-size: 13px=
"><span class=3D"highlight" style=3D"background-color:#ffffff"><span class=
=3D"colour" style=3D"color:#000000">WRITE: bw=3D716MiB/s (751MB/s), 716MiB/=
s-716MiB/s (751MB/s-751MB/s), io=3D16.0GiB (17.2GB), run=3D22876-22876msec<=
/span></span></span></span></span><span class=3D"font" style=3D"font-family=
: menlo, consolas, monospace, sans-serif;"><span class=3D"size" style=3D"fo=
nt-size: 13px"><span class=3D"highlight" style=3D"background-color:#ffffff"=
><span class=3D"colour" style=3D"color:#000000"><br></span></span></span></=
span></p><p style=3D"margin: 0px; font-style: normal; font-variant-caps: no=
rmal; font-weight: normal; font-stretch: normal; line-height: normal;"><spa=
n style=3D"font-variant-ligatures: no-common-ligatures"><span class=3D"font=
" style=3D"font-family: menlo, consolas, monospace, sans-serif;"><span clas=
s=3D"size" style=3D"font-size: 13px"><span class=3D"highlight" style=3D"bac=
kground-color:#ffffff"><span class=3D"colour" style=3D"color:#000000">root@=
delorean:/sec_stor/backup/fiotest/fio-master # du -sh seqwrite.0.0 </span><=
/span></span></span><span class=3D"Apple-converted-space"><span class=3D"fo=
nt" style=3D"font-family: menlo, consolas, monospace, sans-serif;"><span cl=
ass=3D"size" style=3D"font-size: 13px"><span class=3D"highlight" style=3D"b=
ackground-color:#ffffff"><span class=3D"colour" style=3D"color:#000000">&nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &=
nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;=
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbs=
p; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &n=
bsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; </spa=
n></span></span></span></span><span class=3D"font" style=3D"font-family: me=
nlo, consolas, monospace, sans-serif;"><span class=3D"size" style=3D"font-s=
ize: 13px"><span class=3D"highlight" style=3D"background-color:#ffffff"><sp=
an class=3D"colour" style=3D"color:#000000">9.2G</span></span></span></span=
><span style=3D"white-space:pre" class=3D"Apple-tab-span"><span class=3D"fo=
nt" style=3D"font-family: menlo, consolas, monospace, sans-serif;"><span cl=
ass=3D"size" style=3D"font-size: 13px"><span class=3D"highlight" style=3D"b=
ackground-color:#ffffff"><span class=3D"colour" style=3D"color:#000000"> </=
span></span></span></span></span><span class=3D"font" style=3D"font-family:=
 menlo, consolas, monospace, sans-serif;"><span class=3D"size" style=3D"fon=
t-size: 13px"><span class=3D"highlight" style=3D"background-color:#ffffff">=
<span class=3D"colour" style=3D"color:#000000">seqwrite.0.0</span></span></=
span></span></span><br></p><div style=3D"font-size:16px;"><br></div>
<div style=3D"font-size:16px;">As you see, 9.2G file seems reasonable at 50=
% compression. But, <span class=3D"colour" style=3D"color:#0000ff">why 716 =
MiB/s when compared to test #2(no compression) - 2065 MiB/s? </span>At 50% =
compression, I understand there is work for the CPUs to compress the data i=
nline, but, would'nt that cost be negated by the reduction in amount of dat=
a to be written to disks? Is this kind of drop in throughput reasonable in =
the field for enabling compression?<br></div>
<div style=3D"font-size:16px;"><br></div>
<div style=3D"font-size:16px;">Apologies in advance if I missed anything ob=
vious in the documentation. This is my first use of fio.<br></div>
<div style=3D"font-size:16px;"><br></div>
<div style=3D"font-size:16px;">Thanks,</div>
<div style=3D"font-size:16px;">--<br></div>
<div style=3D"font-size:16px;">&nbsp; Aravindh Sampathkumar<br></div>
<div style=3D"font-size:16px;">&nbsp; aravindh@fastmail.com<br></div>
<div style=3D"font-size:16px;"><br></div>
<div style=3D"font-size:16px;"><br></div>
</body>
</html>

--_----------=_153252213936032370--


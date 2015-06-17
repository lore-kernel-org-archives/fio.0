Return-Path: <fio-owner@vger.kernel.org>
Received: from mx0a-00003501.pphosted.com ([67.231.144.15]:15853 "EHLO
	mx0a-00003501.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754519AbbFQOqS (ORCPT
	<rfc822;fio@vger.kernel.org>); Wed, 17 Jun 2015 10:46:18 -0400
Received: from pps.filterd (m0075555.ppops.net [127.0.0.1])
	by mx0a-00003501.pphosted.com (8.14.5/8.14.5) with SMTP id t5HEhue5020054
	for <fio@vger.kernel.org>; Wed, 17 Jun 2015 10:46:17 -0400
Received: from mail-oi0-f41.google.com (mail-oi0-f41.google.com [209.85.218.41])
	by mx0a-00003501.pphosted.com with ESMTP id 1v3agr8b7e-2
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <fio@vger.kernel.org>; Wed, 17 Jun 2015 10:46:17 -0400
Received: by mail-oi0-f41.google.com with SMTP id y130so18689766oiy.0
        for <fio@vger.kernel.org>; Wed, 17 Jun 2015 07:46:17 -0700 (PDT)
MIME-Version: 1.0
From: Gavin Martin <gavin.martin@seagate.com>
Date: Wed, 17 Jun 2015 15:45:52 +0100
Message-ID: <CAFSgMbgY7LHJdaVNb=7Eub=vNohVPemjmSNs_SOFmb8y8eK7Aw@mail.gmail.com>
Subject: Verify concentrated on first few drives
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

Running FIO (2.2.8) with the verify option I see that it seems to
concentrate the Reads (from the Verify) on the first few drives and
tails off as you run more drives, as reported in the Disk Stats.

Is this normal? Does the Verify follow the Round-Robin approach of
normal workloads?

Config file:-
[global]
ioengine=libaio
iodepth=2
direct=1
runtime=30s
time_based
bs=64K
verify=meta
verify_backlog=32
verify_state_save=0
stonewall
norandommap
atomic=1

filename=/dev/sdb
filename=/dev/sdc
filename=/dev/sdd
filename=/dev/sde
filename=/dev/sdf
filename=/dev/sdg
filename=/dev/sdh
filename=/dev/sdi
filename=/dev/sdj
filename=/dev/sdk
filename=/dev/sdl
filename=/dev/sdm
filename=/dev/sdn
filename=/dev/sdo
filename=/dev/sdp
filename=/dev/sdq
filename=/dev/sdr
filename=/dev/sds
filename=/dev/sdt
filename=/dev/sdu
filename=/dev/sdv
filename=/dev/sdw
filename=/dev/sdx
filename=/dev/sdy

[RUN01]
rw=randwrite
do_verify=1

Output:-
RUN01: (g=0): rw=randwrite, bs=64K-64K/64K-64K/64K-64K,
ioengine=libaio, iodepth=2
fio-2.2.8
Starting 1 process
Jobs: 1 (f=24): [w(1)] [100.0% done] [10199KB/9816KB/0KB /s]
[159/153/0 iops] [eta 00m:00s]
RUN01: (groupid=0, jobs=1): err= 0: pid=22749: Wed Jun 17 10:28:23 2015
  write: io=296000KB, bw=9862.5KB/s, iops=154, runt= 30013msec
    slat (usec): min=10, max=86, avg=32.74, stdev= 8.18
    clat (msec): min=1, max=50, avg=11.80, stdev= 3.94
     lat (msec): min=2, max=50, avg=11.83, stdev= 3.94
    clat percentiles (usec):
     |  1.00th=[ 3120],  5.00th=[ 9408], 10.00th=[10432], 20.00th=[10816],
     | 30.00th=[10944], 40.00th=[11072], 50.00th=[11200], 60.00th=[11328],
     | 70.00th=[11456], 80.00th=[11584], 90.00th=[12480], 95.00th=[19328],
     | 99.00th=[30336], 99.50th=[33024], 99.90th=[44288], 99.95th=[44800],
     | 99.99th=[50432]
    bw (KB  /s): min= 8431, max=11241, per=100.00%, avg=9876.58, stdev=453.15
    lat (usec) : 250=6.93%, 500=36.19%, 750=3.56%, 1000=0.17%
    lat (msec) : 2=0.19%, 4=1.19%, 10=4.42%, 20=44.42%, 50=2.91%
    lat (msec) : 100=0.01%
  cpu          : usr=0.68%, sys=0.99%, ctx=9001, majf=0, minf=87
  IO depths    : 1=0.1%, 2=100.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=4608/w=4625/d=0, short=r=0/w=0/d=0, drop=r=0/w=0/d=0
     latency   : target=0, window=0, percentile=100.00%, depth=2

Run status group 0 (all jobs):
  WRITE: io=296000KB, aggrb=9862KB/s, minb=9862KB/s, maxb=9862KB/s,
mint=30013msec, maxt=30013msec

Disk stats (read/write):
  sdb: ios=274/192, merge=0/0, ticks=305/2299, in_queue=2604, util=8.65%
  sdc: ios=225/192, merge=0/0, ticks=359/2232, in_queue=2591, util=8.61%
  sdd: ios=191/192, merge=0/0, ticks=222/2278, in_queue=2500, util=8.31%
  sde: ios=217/192, merge=0/0, ticks=509/2235, in_queue=2744, util=9.12%
  sdf: ios=191/192, merge=0/0, ticks=199/2209, in_queue=2408, util=8.01%
  sdg: ios=191/192, merge=0/0, ticks=390/2254, in_queue=2644, util=8.80%
  sdh: ios=191/192, merge=0/0, ticks=122/2339, in_queue=2461, util=8.19%
  sdi: ios=191/192, merge=0/0, ticks=123/2270, in_queue=2393, util=7.95%
  sdj: ios=191/191, merge=0/0, ticks=107/2188, in_queue=2302, util=7.64%
  sdk: ios=191/191, merge=0/0, ticks=82/2168, in_queue=2255, util=7.51%
  sdl: ios=191/191, merge=0/0, ticks=134/2322, in_queue=2456, util=8.17%
  sdm: ios=191/191, merge=0/0, ticks=131/2152, in_queue=2283, util=7.61%
  sdn: ios=191/191, merge=0/0, ticks=127/2288, in_queue=2415, util=8.05%
  sdo: ios=191/191, merge=0/0, ticks=134/2312, in_queue=2446, util=8.13%
  sdp: ios=191/191, merge=0/0, ticks=128/2258, in_queue=2386, util=7.95%
  sdq: ios=191/191, merge=0/0, ticks=292/2296, in_queue=2587, util=8.49%
  sdr: ios=191/191, merge=0/0, ticks=189/2341, in_queue=2530, util=8.27%
  sds: ios=191/191, merge=0/0, ticks=167/2379, in_queue=2545, util=8.47%
  sdt: ios=191/191, merge=0/0, ticks=297/2286, in_queue=2583, util=8.39%
  sdu: ios=191/191, merge=0/0, ticks=284/2182, in_queue=2465, util=8.15%
  sdv: ios=189/191, merge=0/0, ticks=191/2134, in_queue=2325, util=7.72%
  sdw: ios=189/191, merge=0/0, ticks=189/2337, in_queue=2526, util=8.36%
  sdx: ios=189/191, merge=0/0, ticks=122/2291, in_queue=2413, util=8.06%
  sdy: ios=189/191, merge=0/0, ticks=195/2164, in_queue=2359, util=7.86%

If I increase the iodepth to 8 it gets even worse. The Writes
and utilisation
 has increased, but the last few drives are not going through any verification:-

Disk stats (read/write):
  sdb: ios=970/899, merge=0/0, ticks=624/9107, in_queue=9736, util=32.25%
  sdc: ios=901/899, merge=0/0, ticks=622/8927, in_queue=9549, util=31.58%
  sdd: ios=899/899, merge=0/0, ticks=679/9151, in_queue=9831, util=32.60%
  sde: ios=899/899, merge=0/0, ticks=657/8991, in_queue=9652, util=32.02%
  sdf: ios=899/900, merge=0/0, ticks=591/9044, in_queue=9634, util=31.96%
  sdg: ios=899/899, merge=0/0, ticks=543/9260, in_queue=9805, util=32.56%
  sdh: ios=899/899, merge=0/0, ticks=547/9435, in_queue=9982, util=32.82%
  sdi: ios=899/899, merge=0/0, ticks=488/9365, in_queue=9853, util=32.68%
  sdj: ios=899/899, merge=0/0, ticks=422/9349, in_queue=9771, util=32.46%
  sdk: ios=899/899, merge=0/0, ticks=577/9414, in_queue=9991, util=33.11%
  sdl: ios=899/899, merge=0/0, ticks=507/9199, in_queue=9703, util=32.19%
  sdm: ios=899/899, merge=0/0, ticks=495/9125, in_queue=9619, util=31.92%
  sdn: ios=899/899, merge=0/0, ticks=485/9103, in_queue=9587, util=31.82%
  sdo: ios=899/899, merge=0/0, ticks=501/9240, in_queue=9741, util=32.23%
  sdp: ios=899/899, merge=0/0, ticks=477/9110, in_queue=9586, util=31.76%
  sdq: ios=899/899, merge=0/0, ticks=557/9169, in_queue=9726, util=32.11%
  sdr: ios=899/899, merge=0/0, ticks=545/11115, in_queue=11656, util=35.65%
  sds: ios=899/899, merge=0/0, ticks=1266/11542, in_queue=12808, util=36.97%
  sdt: ios=330/899, merge=0/0, ticks=363/9283, in_queue=9644, util=31.43%
  sdu: ios=0/899, merge=0/0, ticks=0/9211, in_queue=9209, util=30.77%
  sdv: ios=0/899, merge=0/0, ticks=0/9232, in_queue=9231, util=30.86%
  sdw: ios=0/899, merge=0/0, ticks=0/9470, in_queue=9470, util=31.68%
  sdx: ios=0/899, merge=0/0, ticks=0/9342, in_queue=9342, util=31.26%
  sdy: ios=0/898, merge=0/0, ticks=0/9174, in_queue=9181, util=30.74%

Have I missed an option or have the wrong one in my config file that
could be causing this?

Thanks,

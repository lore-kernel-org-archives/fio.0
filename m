Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:38558 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756959AbbDWIgI (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 23 Apr 2015 04:36:08 -0400
Received: by igbhj9 with SMTP id hj9so18067639igb.1
        for <fio@vger.kernel.org>; Thu, 23 Apr 2015 01:36:07 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 23 Apr 2015 16:36:07 +0800
Message-ID: <CABtFm2WXHC5=PxeoDQicUU2FkLauvuvQ+BpUGiv5mP+yh-mVxQ@mail.gmail.com>
Subject: fio writing only around 50% of LUN capacity for fill_device=1
From: Srinivasa Chamarthy <chamarthy.raju@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

First... thank you for the great tool.

I have the following config for a readwrite workload at 70% read and
30% write with a dedup profile. I am having individual profiles for
each of the disk.
From the run stats i see only 42139MB written on 8 disks each with capacity 12G.

Thanks for the support.

FIO Version: fio-2.2.7-11-g1d6d

[global]
ioengine=libaio
rw=rw
rwmixread=70
rwmixwrite=30
dedupe_percentage=50
loops=1
fill_device=1
refill_buffers
scramble_buffers=1

[sdb_10g_8k_qd16_iops2k]
filename=/dev/sdb
write_iolog=sdb_10g_8k_qd8_iops1k.write.log
bs=8k,8k
bssplit=8k,8k/100
blockalign=8k,8k
rate_iops=2k,2k
iodepth=16
iodepth_batch=8
numjobs=1

[sdc_10g_16k_qd8_iops900]
filename=/dev/sdc
write_iolog=sdc_10g_16k_qd7_iops900.write.log
bs=16k,16k
bssplit=16k,16k/100
blockalign=16k,16k
rate_iops=900,900
iodepth=8
iodepth_batch=4
numjobs=1

[sdd_10g_32k_qd6_iops800]
filename=/dev/sdd
write_iolog=sdd_10g_32k_qd6_iops800.write.log
bs=32k,32k
bssplit=32k,32k/100
blockalign=32k,32k
rate_iops=800,800
iodepth=6
iodepth_batch=4
numjobs=1

[sde_10g_64k_qd6_iops400]
filename=/dev/sde
write_iolog=sde_10g_64k_qd6_iops400.write.log
bs=64k,64k
bssplit=64k,64k/100
blockalign=64k,64k
rate_iops=400,400
iodepth=6
iodepth_batch=4
numjobs=1

[sdf_10g_128k_qd4_iops400]
filename=/dev/sdf
write_iolog=sdf_10g_128k_qd4_iops400.write.log
bs=128k,128k
bssplit=128k,128k/100
blockalign=128k,128k
rate_iops=400,400
iodepth=4
iodepth_batch=4
numjobs=1

[sdg_10g_256k_qd2_iops200]
filename=/dev/sdg
write_iolog=sdg_10g_256k_qd2_iops200.write.log
bs=256k,256k
bssplit=256k,256k/100
blockalign=256k,256k
rate_iops=200,200
iodepth=2
iodepth_batch=2
numjobs=1

[sdh_10g_512k_qd2_iops200]
filename=/dev/sdh
write_iolog=sdh_10g_512k_qd2_iops200.write.log
bs=512k,512k
bssplit=512k,512k/100
blockalign=512k,512k
rate_iops=200,200
iodepth=2
iodepth_batch=2
numjobs=1

[sdi_10g_1024k_qd1_iops100]
filename=/dev/sdi
write_iolog=sdi_10g_1024k_qd1_iops100.write.log
bs=1024k,1024k
bssplit=1024k,1024k/100
blockalign=1024k,1024k
rate_iops=100,100
iodepth=1
iodepth_batch=1
numjobs=1

RUN Stats:
# fio ./dedup_fio_profiles/profile1_dedup50_rw_seq_8_luns_bs8k21m.fio
sdb_10g_8k_qd16_iops2k: (g=0): rw=rw, bs=8K-8K/8K-8K/8K-8K,
ioengine=libaio, iodepth=16
sdc_10g_16k_qd8_iops900: (g=0): rw=rw, bs=16K-16K/16K-16K/16K-16K,
ioengine=libaio, iodepth=8
sdd_10g_32k_qd6_iops800: (g=0): rw=rw, bs=32K-32K/32K-32K/32K-32K,
ioengine=libaio, iodepth=6
sde_10g_64k_qd6_iops400: (g=0): rw=rw, bs=64K-64K/64K-64K/64K-64K,
ioengine=libaio, iodepth=6
sdf_10g_128k_qd4_iops400: (g=0): rw=rw,
bs=128K-128K/128K-128K/128K-128K, ioengine=libaio, iodepth=4
sdg_10g_256k_qd2_iops200: (g=0): rw=rw,
bs=256K-256K/256K-256K/256K-256K, ioengine=libaio, iodepth=2
sdh_10g_512k_qd2_iops200: (g=0): rw=rw,
bs=512K-512K/512K-512K/512K-512K, ioengine=libaio, iodepth=2
sdi_10g_1024k_qd1_iops100: (g=0): rw=rw, bs=1M-1M/1M-1M/1M-1M,
ioengine=libaio, iodepth=1
fio-2.2.7-11-g1d6d
Starting 8 processes
Jobs: 1 (f=1), CR=200/0 IOPS: [_(7),M(1)] [100.0% done] [0KB/0KB/0KB
/s] [0/0/0 iops] [eta 00m:00s]             ]
.....
.....
Run status group 0 (all jobs):
   READ: io=98304MB, aggrb=75001KB/s, minb=9375KB/s, maxb=11993KB/s,
mint=1049106msec, maxt=1342144msec
  WRITE: io=42139MB, aggrb=32150KB/s, minb=3975KB/s, maxb=5190KB/s,
mint=1049106msec, maxt=1342144msec

Disk stats (read/write):
  sdb: ios=22495/4752, merge=3119625/1249809, ticks=1673160/137019420,
in_queue=139755908, util=100.00%
  sdc: ios=22567/5025, merge=3122233/1319321, ticks=1670216/120071444,
in_queue=123439248, util=100.00%
  sdd: ios=22468/4997, merge=3122972/1312832, ticks=1652320/135392680,
in_queue=138821776, util=100.00%
  sde: ios=22484/5024, merge=3122812/1314061, ticks=1647288/139493784,
in_queue=142811108, util=100.00%
  sdf: ios=22596/5076, merge=3122796/1331034, ticks=1639280/118593472,
in_queue=121701668, util=100.00%
  sdg: ios=22910/5078, merge=3122928/1334637, ticks=1671076/138113608,
in_queue=142180400, util=100.00%
  sdh: ios=23058/5162, merge=3122773/1339386, ticks=1640104/119058784,
in_queue=122368872, util=100.00%
  sdi: ios=12900/5101, merge=3132543/1296659, ticks=1299392/42530288,
in_queue=43829676, util=99.29%



-- 
Srinivasa R Chamarthy

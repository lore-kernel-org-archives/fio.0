Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ie0-f169.google.com ([209.85.223.169]:36028 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbbDHLow (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 8 Apr 2015 07:44:52 -0400
Received: by iebrs15 with SMTP id rs15so71330135ieb.3
        for <fio@vger.kernel.org>; Wed, 08 Apr 2015 04:44:51 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 8 Apr 2015 19:44:51 +0800
Message-ID: <CABtFm2V2E2sZAhebJzxfxifcBJ95FzE8gTdQd+97CGJu2eNntQ@mail.gmail.com>
Subject: Generating random data with FIO on directories returning null
From: Srinivasa Chamarthy <chamarthy.raju@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Srinivasa Chamarthy <chamarthy.raju@gmail.com>

Hi,

This is my first post to FIO.

I have a issue with generating workload for a specific purpose. I have
a LVM volumes configured on raid devices with raid0 using 8 LUNs and
mounted all the volumes. I configured mdadm devices and LVM volumes as
follows:

# mdadm /dev/md0
/dev/md0: 31.97GiB raid0 4 devices, 0 spares. Use mdadm --detail for
more detail.
# mdadm /dev/md1
/dev/md1: 31.97GiB raid0 4 devices, 0 spares. Use mdadm --detail for
more detail.

# vgs
  VG   #PV #LV #SN Attr   VSize  VFree
  vg0    2   6   0 wz--n- 63.92g 5.33g
# pvs
  PV         VG   Fmt  Attr PSize  PFree
  /dev/md0   vg0  lvm2 a--  31.96g 2.66g
  /dev/md1   vg0  lvm2 a--  31.96g 2.66g
# vgs
  VG   #PV #LV #SN Attr   VSize  VFree
  vg0    2   6   0 wz--n- 63.92g 5.33g
# lvs
  LV      VG   Attr      LSize Pool Origin Data%  Move Log Cpy%Sync Convert
  lv0_vg0 vg0  -wi-a---- 9.77g
  lv1_vg0 vg0  -wi-a---- 9.77g
  lv2_vg0 vg0  -wi-a---- 9.77g
  lv3_vg0 vg0  -wi-a---- 9.77g
  lv4_vg0 vg0  -wi-a---- 9.77g
  lv5_vg0 vg0  -wi-a---- 9.77g

# mount | grep mapper
/dev/mapper/vg0-lv0_vg0 on /mnt/lv0 type ext4
(rw,relatime,stripe=512,data=ordered)
/dev/mapper/vg0-lv1_vg0 on /mnt/lv1 type ext4
(rw,relatime,stripe=512,data=ordered)
/dev/mapper/vg0-lv2_vg0 on /mnt/lv2 type ext4
(rw,relatime,stripe=512,data=ordered)
/dev/mapper/vg0-lv3_vg0 on /mnt/lv3 type ext4
(rw,relatime,stripe=512,data=ordered)
/dev/mapper/vg0-lv4_vg0 on /mnt/lv4 type ext4
(rw,relatime,stripe=512,data=ordered)
/dev/mapper/vg0-lv5_vg0 on /mnt/lv5 type ext4
(rw,relatime,stripe=512,data=ordered)

When i run FIO on the mounted volumes, and i check the file contents,
they all are seem to be written using /dev/zero (NULL)

# fio --output=fio_test.out_14 fileio.fio

# cat fio_test.out_14
fileio: (g=0): rw=write, bs=8K-124K/8K-124K/8K-124K, ioengine=libaio, iodepth=32
fio-2.2.6-2-g8549
Starting 1 process
fileio: Laying out IO file(s) (10 file(s) / 95MB)

fileio: (groupid=0, jobs=1): err= 0: pid=18607: Wed Apr  8 07:31:15 2015
  write: io=97672KB, bw=514063KB/s, iops=8068, runt=   190msec
    slat (usec): min=111, max=965, avg=345.74, stdev=124.49
    clat (usec): min=1, max=146671, avg=1916.25, stdev=14865.05
     lat (usec): min=214, max=146937, avg=2262.04, stdev=14850.48
    clat percentiles (usec):
     |  1.00th=[    5],  5.00th=[    6], 10.00th=[    7], 20.00th=[  195],
     | 30.00th=[  233], 40.00th=[  274], 50.00th=[  374], 60.00th=[  462],
     | 70.00th=[  580], 80.00th=[  644], 90.00th=[  724], 95.00th=[  804],
     | 99.00th=[146432], 99.50th=[146432], 99.90th=[146432], 99.95th=[146432],
     | 99.99th=[146432]
    lat (usec) : 2=0.85%, 10=13.83%, 20=2.61%, 50=0.26%, 250=15.66%
    lat (usec) : 500=30.27%, 750=28.31%, 1000=5.09%
    lat (msec) : 2=2.09%, 250=1.04%
  cpu          : usr=4.21%, sys=18.95%, ctx=22, majf=0, minf=32
  IO depths    : 1=0.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=65.8%, 32=33.4%, >=64=0.0%
     submit    : 0=0.0%, 4=0.0%, 8=48.8%, 16=51.2%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=99.9%, 8=0.0%, 16=0.0%, 32=0.1%, 64=0.0%, >=64=0.0%
     issued    : total=r=0/w=1533/d=0, short=r=0/w=0/d=0, drop=r=0/w=0/d=0
     latency   : target=0, window=0, percentile=100.00%, depth=32

Run status group 0 (all jobs):
  WRITE: io=97672KB, aggrb=514063KB/s, minb=514063KB/s,
maxb=514063KB/s, mint=190msec, maxt=190msec

Disk stats (read/write):
    dm-0: ios=0/22, merge=0/0, ticks=0/1328, in_queue=1808,
util=47.43%, aggrios=0/27, aggrmerge=0/0, aggrticks=0/0,
aggrin_queue=0, aggrutil=0.00%
    md0: ios=0/27, merge=0/0, ticks=0/0, in_queue=0, util=0.00%,
aggrios=0/3, aggrmerge=0/3, aggrticks=0/248, aggrin_queue=248,
aggrutil=43.50%
  sdb: ios=0/3, merge=0/3, ticks=0/348, in_queue=348, util=36.25%
  sdc: ios=0/5, merge=0/5, ticks=0/208, in_queue=208, util=27.79%
  sdd: ios=0/3, merge=0/2, ticks=0/348, in_queue=348, util=43.50%
  sde: ios=0/3, merge=0/2, ticks=0/88, in_queue=88, util=12.08%

/mnt/lv0 # for each in $(ls -U *); do dd if=$each bs=1024 2>/dev/null
| hexdump -C; done
00000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
009dc000
00000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
0034e000
00000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
006f0000
00000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
0030a000
00000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00b9e000
00000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
003ae000
00000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
01152000
00000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00aae000
00000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00bde000
00000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
01114000

My job file is:

# cat fileio.fio
; fio dedup workload

[fileio]
ioengine=libaio
rw=write
; directory=/mnt/lv0:/mnt/lv1:/mnt/lv2:/mnt/lv3:/mnt/lv4:/mnt/lv5
directory=/mnt/lv0
filesize=1m-20m
nrfiles=10
file_service_type=random:64
random_generator=tausworthe
; create_serialize=1
fallocate=posix
; rw_sequencer=sequential
; randrepeat=1
; allrandrepeat=1
bs=8k
numjobs=1
iodepth=32
blocksize_range=8k-124k
loops=1
percentage_random=100
overwrite=1
iodepth_low=8
iodepth_batch=16
fill_device=1
refill_buffers=1
fsync=1024
prio=0

# fio -v
fio-2.2.6-2-g8549

# lsb_release -a
LSB Version:    n/a
Distributor ID: SUSE LINUX
Description:    SUSE Linux Enterprise Server 12
Release:        12
Codename:       12

# uname -r
3.12.28-4-default

Am i doing something wrong here? My requirement is to generate random
io and multiple files with different sizes.

Thanks for any help.

--
Srinivasa R Chamarthy

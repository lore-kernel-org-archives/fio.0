Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ig0-f170.google.com ([209.85.213.170]:33891 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbbDIESF (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 9 Apr 2015 00:18:05 -0400
Received: by iget9 with SMTP id t9so41881508ige.1
        for <fio@vger.kernel.org>; Wed, 08 Apr 2015 21:18:05 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 9 Apr 2015 12:18:05 +0800
Message-ID: <CABtFm2VCPQUYukN+74snO6vOo__U1T1UG-p1HAkof5i+E3ax9A@mail.gmail.com>
Subject: FIO not generating multiple jobs for directories
From: Srinivasa Chamarthy <chamarthy.raju@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Srinivasa Chamarthy <chamarthy.raju@gmail.com>

I have 6 mounted LVM volumes on a RAID0. I was generating files using
FIO to fill up the volumes simultaneously. I see that FIO is using
only one thread even though i have specified numjobs=6 in the jobfile.
Its generating io with one thread sequentially from directory to
directory. Numjobs seems to be working ok when i run directly on block
devices using filename.

# fio -v
fio-2.2.6-25-g87f5

JobFile:

# cat fileio.fio
[fileio]
ioengine=libaio
rw=write
directory=/mnt/lv0:/mnt/lv1:/mnt/lv2:/mnt/lv3:/mnt/lv4:/mnt/lv5
filesize=1m-40m
nrfiles=1024
file_service_type=random:64
random_generator=tausworthe
rate=,400m
bs=8k
numjobs=6
iodepth=32
scramble_buffers=1
blocksize_unaligned
blocksize_range=8k-124k
loops=1
percentage_random=100
random_distribution=random
norandommap
overwrite=1
iodepth_low=8
iodepth_batch=16
fill_device=1
refill_buffers=1
fsync=1024
prio=0

# fio --output=fio_test.out_15 fileio.fio

Process tree:
root      1308  0.0  0.2  43256 23508 ?        Ss   Apr03   1:50 SCREEN -Aa
root      1309  0.0  0.0  14556  2632 pts/1    Ss+  Apr03   0:00  \_ bash
root      2860  0.0  0.0  29032   748 pts/1    T    Apr03   0:00  |
\_ vim fio_dedup.out_3
root      1517  0.0  0.0  14548  2964 pts/2    Ss   Apr03   0:00  \_ bash
root     24413 12.0  2.1 296064 178336 pts/2   Dl+  00:07   0:01  |
\_ fio --output=fio_test.out_15 fileio.fio
root      2768  0.0  0.0  14540  2208 pts/3    Ss   Apr03   0:00  \_ bash
root     24250  0.0  0.0   4512   868 pts/3    S+   Apr08   0:00  |
\_ iostat -dxm /dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/sdf /dev/sdg
/dev/sdh /dev/sdi 1
root     25483  0.0  0.0  14700  2948 pts/4    Ss   Apr06   0:00  \_ bash
root     24427  0.0  0.0  25560  1508 pts/4    R+   00:08   0:00  |   \_ ps auxf

After filling each device, one thread ends and the other starts
sequentially. There might be something wrong with tracking pid too.

# fio --output=fio_test.out_15 fileio.fio
fio: pid=0, err=28/file:filesetup.c:79, func=open, error=No space left on device
fio: pid=0, err=28/file:filesetup.c:79, func=open, error=No space left on device
fio: pid=0, err=28/file:filesetup.c:79, func=open, error=No space left on device
fio: pid=0, err=28/file:filesetup.c:79, func=open, error=No space left on device

Is there anything wrong with the parameters?

-- 
Srinivasa R Chamarthy

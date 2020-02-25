Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-oi1-f177.google.com ([209.85.167.177]:43029 "EHLO
        mail-oi1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729048AbgBYO4M (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 25 Feb 2020 09:56:12 -0500
Received: by mail-oi1-f177.google.com with SMTP id p125so12789642oif.10
        for <fio@vger.kernel.org>; Tue, 25 Feb 2020 06:56:11 -0800 (PST)
MIME-Version: 1.0
References: <CAKwxSemdenRxi_kEAphV566bjr-_67OXgDqyo92nt+CzTTQ+mg@mail.gmail.com>
In-Reply-To: <CAKwxSemdenRxi_kEAphV566bjr-_67OXgDqyo92nt+CzTTQ+mg@mail.gmail.com>
From: Shoshan Dagany <shoshan@lightbitslabs.com>
Date: Tue, 25 Feb 2020 16:56:00 +0200
Message-ID: <CAKwxSek0U73ONjGxJaKZgSDGoo58-JK1Ni5xuacRRyyAr-2qGg@mail.gmail.com>
Subject: False pass when changing rand_seed in verify_only.
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi

There is false pass when changing rand_seed in verify_only.
What have I missed in workloads? or it's a bug in fio 3.18?

I've run the following workloads:

1) write random, with a rand_seed.

[global]
ioengine=libaio
iodepth=32
runtime=0
cpus_allowed_policy=split
group_reporting=1
cpus_allowed=0-0
do_verify=1
verify=sha512
bs=4096
filename=/dev/nvme0n2
direct=1
loops=1
percentile_list=99:99.9:99.99:99.999:99.9999
norandommap
random_generator=lfsr
rw=randwrite
verify_fatal=1
allrandrepeat=0
randseed=44234

[job_0]
offset=0
size=52428800

test pass.

2) write random, with other rand_seed and verify_only=1.
job is expected to fail but it passed successfully.

[global]
ioengine=libaio
iodepth=32
runtime=0
cpus_allowed_policy=split
group_reporting=1
cpus_allowed=0-0
do_verify=1
verify=sha512
bs=4096
filename=/dev/nvme0n2
direct=1
loops=1
percentile_list=99:99.9:99.99:99.999:99.9999
norandommap
random_generator=lfsr
rw=randwrite
verify_fatal=1
allrandrepeat=0
randseed=99
verify_only=1
[job_0]
offset=0
size=52428800

output of second job:

job_0: (g=0): rw=randwrite, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T)
4096B-4096B, ioengine=libaio, iodepth=32
fio-3.18
Starting 1 process

job_0: (groupid=0, jobs=1): err= 0: pid=4165: Mon Feb 24 11:16:50 2020
  read: IOPS=6333, BW=24.7MiB/s (25.9MB/s)(50.0MiB/2021msec)
    slat (usec): min=4, max=111, avg=16.84, stdev= 4.66
    clat (usec): min=191, max=5939, avg=4885.49, stdev=194.57
     lat (usec): min=206, max=5954, avg=4902.81, stdev=194.61
    clat percentiles (usec):
     | 99.0000th=[ 5211], 99.9000th=[ 5604], 99.9900th=[ 5932],
     | 99.9990th=[ 5932], 99.9999th=[ 5932]
  lat (usec)   : 250=0.01%, 500=0.01%, 750=0.01%, 1000=0.01%
  lat (msec)   : 2=0.05%, 4=0.10%, 10=49.81%, >=2000=50.00%
  cpu          : usr=80.79%, sys=10.26%, ctx=22986, majf=0, minf=315
  IO depths    : 1=50.0%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=49.9%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.1%, 64=0.0%, >=64=0.0%
     issued rwts: total=12800,12800,0,0 short=0,0,0,0 dropped=0,0,0,0

Run status group 0 (all jobs):
   READ: bw=24.7MiB/s (25.9MB/s), 24.7MiB/s-24.7MiB/s
(25.9MB/s-25.9MB/s), io=50.0MiB (52.4MB), run=2021-2021msec

Disk stats (read/write):
  nvme0n2: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%`


-- 
Shoshan Dagany


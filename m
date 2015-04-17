Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ig0-f177.google.com ([209.85.213.177]:36106 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753631AbbDQJNv (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 17 Apr 2015 05:13:51 -0400
Received: by igblo3 with SMTP id lo3so6747156igb.1
        for <fio@vger.kernel.org>; Fri, 17 Apr 2015 02:13:51 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 17 Apr 2015 17:13:51 +0800
Message-ID: <CABtFm2Wh07GiQ4HAeOKzDHTNpPRpq+u=CU7xLnwej+HaESzn_w@mail.gmail.com>
Subject: crash reports while running IO on raid0 btrfs
From: Srinivasa Chamarthy <chamarthy.raju@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Received the following crash reports:

fio: pid=2847, got signal=6
Jobs: 3 (f=101), CR=1200MB/0B KB/s: [K(1),W(1),K(1),W(2),K(1)] [80.1%
done] [0KB/118.1MB/0KB /s] [0/1814/0 iopJobs: 3 (f=97), CR=1200MB/0B
KB/s: [K(1),W(1),K(1),W(2),K(1)] [80.2% done] [0KB/40312KB/0KB /s]
[0/583/0 iops]*** Error in `fio':
double free or corruption (!prev): 0x000000000114d7b0 ***
======= Backtrace: =========
/lib64/libc.so.6(+0x730bf)[0x7fcf25c7e0bf]
/lib64/libc.so.6(+0x7892e)[0x7fcf25c8392e]
/lib64/libc.so.6(+0x79636)[0x7fcf25c84636]
fio(free_io_mem+0x97)[0x42c3e7]
fio[0x44dc73]
fio[0x450fd9]
fio(fio_backend+0xfb)[0x45144b]
/lib64/libc.so.6(__libc_start_main+0xf5)[0x7fcf25c2cb05]
fio[0x40d3ec]

# fio -v
fio-2.2.7-9-g4da2

# fio --output=file_io.out ./fio_jobs/fio_file.fio

# cat ./fio_jobs/fio_file.fio
[fileio]
ioengine=libaio
rw=write
directory=/mnt/btr1:/mnt/btr2:/mnt/btr3
filesize=1m-40m
file_append=1
nrfiles=256
openfiles=50
fsync_on_close=1
rwmixread=40
file_service_type=random:64
random_generator=tausworthe
rate=,400m
bs=8k
numjobs=6
iodepth=8
blocksize_range=8k-124k
loops=1
fill_device=1
fsync=1024

# btrfs filesystem show
Label: none  uuid: ed55f47f-bf72-4c13-a130-cde927f49fd8
        Total devices 4 FS bytes used 4.12MiB
        devid    1 size 10.00GiB used 3.01GiB path /dev/sdb
        devid    2 size 10.00GiB used 3.00GiB path /dev/sdc
        devid    3 size 10.00GiB used 3.00GiB path /dev/sdd
        devid    4 size 10.00GiB used 3.00GiB path /dev/sde

Label: none  uuid: 60428549-a0b5-41f7-bf7f-6a6607b08925
        Total devices 4 FS bytes used 4.12MiB
        devid    1 size 10.00GiB used 2.01GiB path /dev/sdf
        devid    2 size 10.00GiB used 2.00GiB path /dev/sdg
        devid    3 size 10.00GiB used 2.00GiB path /dev/sdh
        devid    4 size 10.00GiB used 2.00GiB path /dev/sdi

Label: none  uuid: 6c9672ad-8940-42ed-a1d4-fa1c6b6d20e8
        Total devices 4 FS bytes used 4.12MiB
        devid    1 size 10.00GiB used 3.01GiB path /dev/sdj
        devid    2 size 10.00GiB used 3.00GiB path /dev/sdk
        devid    3 size 10.00GiB used 3.00GiB path /dev/sdl
        devid    4 size 10.00GiB used 3.00GiB path /dev/sdm

Btrfs v3.16+20140829

 # lsb_release -a
LSB Version:    n/a
Distributor ID: SUSE LINUX
Description:    SUSE Linux Enterprise Server 12
Release:        12
Codename:       12

# uname -r
3.12.39-47-default

I am running the workload again to get the core dumps.

-- 
Srinivasa R Chamarthy

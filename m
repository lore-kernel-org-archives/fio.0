Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-io0-f171.google.com ([209.85.223.171]:36689 "EHLO
	mail-io0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378AbbKOJHH (ORCPT <rfc822;fio@vger.kernel.org>);
	Sun, 15 Nov 2015 04:07:07 -0500
Received: by iofh3 with SMTP id h3so134629904iof.3
        for <fio@vger.kernel.org>; Sun, 15 Nov 2015 01:07:05 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 15 Nov 2015 17:07:05 +0800
Message-ID: <CABtFm2VEc6-LX4bFE8Nq=dsHqh33Y37e-xmW+4exdvr9bUF51g@mail.gmail.com>
Subject: Job hangs on a NFS share with shared workload
From: Srinivasa Chamarthy <chamarthy.raju@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following job is executed from two systems on the same NFS share.
From host-1 the job is readwrite and host-2 the job is only write. I
am trying to simulate writes to the same share from multiple clients.

# cat file_lock_nfs.fio
[global]
readwrite=readwrite
ioengine=libaio
refill_buffers
randrepeat=0
overwrite=0
end_fsync=1
lockfile=readwrite
iodepth=8
direct=1
;runtime=3600
;time_based
create_on_open=1

[shared_nfs_job1]
directory=/schamart
;opendir=/schamart
filename_format=parent.$jobnum.$filenum
numjobs=2
nrfiles=2500
size=100g
filesize=20m
blocksize=512k
openfiles=64
;file_service_type=random
fsync=1024
fsync_on_close=1
;rwmixread=30
norandommap

After writing approx 100G of data with 5000 files, Host-2 with write
exited as expectd, but the host-1 with readwrite workload seems to
hang.

# fio file_lock_nfs.fio
shared_nfs_job1: (g=0): rw=rw, bs=512K-512K/512K-512K/512K-512K,
ioengine=libaio, iodepth=8
...
fio-2.2.11-15-g236d
Starting 2 processes
Jobs: 2 (f=0): [F(2)] [100.0% done] [0KB/0KB/0KB /s] [0/0/0 iops] [eta
00m:00s]0s]

From strace, i see that is continuously opening and closing files sequentially.

open("/schamart/parent.0.1599", O_RDWR|O_CREAT|O_DIRECT, 0600) = 3
fadvise64(3, 0, 20971520, POSIX_FADV_DONTNEED) = 0
fadvise64(3, 0, 20971520, POSIX_FADV_SEQUENTIAL) = 0
fsync(3)                                = 0
close(3)                                = 0
open("/schamart/parent.0.1600", O_RDWR|O_CREAT|O_DIRECT, 0600) = 3
fadvise64(3, 0, 20971520, POSIX_FADV_DONTNEED) = 0
fadvise64(3, 0, 20971520, POSIX_FADV_SEQUENTIAL) = 0
fsync(3)                                = 0
close(3)                                = 0
open("/schamart/parent.0.1601", O_RDWR|O_CREAT|O_DIRECT, 0600) = 3
fadvise64(3, 0, 20971520, POSIX_FADV_DONTNEED) = 0
fadvise64(3, 0, 20971520, POSIX_FADV_SEQUENTIAL) = 0
fsync(3)                                = 0
close(3)                                = 0
open("/schamart/parent.0.1602", O_RDWR|O_CREAT|O_DIRECT, 0600) = 3
fadvise64(3, 0, 20971520, POSIX_FADV_DONTNEED) = 0
fadvise64(3, 0, 20971520, POSIX_FADV_SEQUENTIAL) = 0
fsync(3)                                = 0
close(3)                                = 0
open("/schamart/parent.0.1603", O_RDWR|O_CREAT|O_DIRECT, 0600) = 3
fadvise64(3, 0, 20971520, POSIX_FADV_DONTNEED) = 0
fadvise64(3, 0, 20971520, POSIX_FADV_SEQUENTIAL) = 0
fsync(3)                                = 0
close(3)                                = 0
open("/schamart/parent.0.1604", O_RDWR|O_CREAT|O_DIRECT, 0600) = 3
fadvise64(3, 0, 20971520, POSIX_FADV_DONTNEED) = 0
fadvise64(3, 0, 20971520, POSIX_FADV_SEQUENTIAL) = 0
fsync(3)                                = 0
close(3)                                = 0
open("/schamart/parent.0.1605", O_RDWR|O_CREAT|O_DIRECT, 0600) = 3
fadvise64(3, 0, 20971520, POSIX_FADV_DONTNEED) = 0
fadvise64(3, 0, 20971520, POSIX_FADV_SEQUENTIAL) = 0
fsync(3)                                = 0
close(3)                                = 0

Is there something wrong, or there is some problem with the job file?

Thanks for your support.

--
Srinivasa R Chamarthy

Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ie0-f177.google.com ([209.85.223.177]:35620 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485AbbDKJff (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 11 Apr 2015 05:35:35 -0400
Received: by iejt8 with SMTP id t8so34339901iej.2
        for <fio@vger.kernel.org>; Sat, 11 Apr 2015 02:35:35 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 11 Apr 2015 17:35:35 +0800
Message-ID: <CABtFm2WCiztf_hpr174Ei42WEqAzYRFe0Dud7TrCbHcDxwWCaw@mail.gmail.com>
Subject: FIO writes many empty files after ENOSPC from device.
From: Srinivasa Chamarthy <chamarthy.raju@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

When FIO is run against mounted disks, when the device reports no
space, FIO reports error and exits the respective threads. But it
leaves lots of empty files created on the filesystem
. Is this expected?

# ls -l | grep " 0 Apr 11"
-rw-r--r-- 1 root root        0 Apr 11 04:39 fileio.0.0
-rw-r--r-- 1 root root        0 Apr 11 04:39 fileio.0.1
-rw-r--r-- 1 root root        0 Apr 11 04:39 fileio.0.1003
-rw-r--r-- 1 root root        0 Apr 11 04:39 fileio.0.1004
-rw-r--r-- 1 root root        0 Apr 11 04:39 fileio.0.1005
-rw-r--r-- 1 root root        0 Apr 11 04:39 fileio.0.1007
-rw-r--r-- 1 root root        0 Apr 11 04:39 fileio.0.1008
-rw-r--r-- 1 root root        0 Apr 11 04:39 fileio.0.101
-rw-r--r-- 1 root root        0 Apr 11 04:39 fileio.0.1013
-rw-r--r-- 1 root root        0 Apr 11 04:39 fileio.0.1016
-rw-r--r-- 1 root root        0 Apr 11 04:39 fileio.0.1019
-rw-r--r-- 1 root root        0 Apr 11 04:39 fileio.0.102
-rw-r--r-- 1 root root        0 Apr 11 04:39 fileio.0.1022
-rw-r--r-- 1 root root        0 Apr 11 04:39 fileio.0.1023
-rw-r--r-- 1 root root        0 Apr 11 04:39 fileio.0.104

# ls -l | grep " 0 Apr 11" | wc -l
699

FIO Job File:

# cat fio_testjob.fio
[fileio]
ioengine=libaio
rw=write
directory=/mnt/sdb:/mnt/sdc:/mnt/sdd:/mnt/sde
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
iodepth_low=8
iodepth_batch=16
fill_device=1
refill_buffers=1
fsync=1024
prio=0

# fio -v
fio-2.2.6-25-g87f5

# uname -r
3.12.28-4-default

sles12-chamas4:~ # lsb_release  -a
LSB Version:    n/a
Distributor ID: SUSE LINUX
Description:    SUSE Linux Enterprise Server 12
Release:        12
Codename:       12

Thanks for the support.

-- 
Srinivasa R Chamarthy

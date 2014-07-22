Return-Path: <fio-owner@vger.kernel.org>
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:41380 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753810AbaGVVBR (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 22 Jul 2014 17:01:17 -0400
Received: from g2t2353.austin.hp.com (g2t2353.austin.hp.com [15.217.128.52])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by g9t1613g.houston.hp.com (Postfix) with ESMTPS id A9D4D63FEB
	for <fio@vger.kernel.org>; Tue, 22 Jul 2014 21:01:16 +0000 (UTC)
Received: from g2t2360.austin.hp.com (g2t2360.austin.hp.com [16.197.8.247])
	by g2t2353.austin.hp.com (Postfix) with ESMTP id 39A34A6
	for <fio@vger.kernel.org>; Tue, 22 Jul 2014 21:00:39 +0000 (UTC)
Received: from beardog.cce.hp.com (beardog.cce.hp.com [16.84.84.24])
	by g2t2360.austin.hp.com (Postfix) with ESMTP id 1C35D4B
	for <fio@vger.kernel.org>; Tue, 22 Jul 2014 21:00:39 +0000 (UTC)
Date: Tue, 22 Jul 2014 15:59:47 -0500
From: scameron@beardog.cce.hp.com
Subject: fio crash when using verify
Message-ID: <20140722205947.GD14599@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: scameron@beardog.cce.hp.com


Hi Jens,

I'm running into a crash with fio today, seems to be easily reproducible.

[root@msablackburn saperf]# fio --version
fio-2.1.11-2-g90811

(top of current git tree.)


[root@msablackburn saperf]# fio ./2drive_sdr_verify.fio
4_KiB_RR_drive_r: (g=0): rw=randwrite, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=170
4_KiB_RR_drive_s: (g=0): rw=randwrite, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=170
fio-2.1.11-2-g90811
Starting 2 threads
fio: io_u.c:1315: __get_io_u: Assertion `io_u->flags & IO_U_F_FREE' failed.a 58m:59s]
Aborted (core dumped)

my fio job file looks like this:

[root@msablackburn saperf]# cat 2drive_sdr_verify.fio
[global]
direct=1
ioengine=libaio
norandommap
randrepeat=0
bs=4096
iodepth=170
#iodepth=96
#numjobs=1
numjobs=1
#numjobs=24
# number_ios=1
# runtime=216000
runtime=3600
time_based=1
group_reporting
thread
gtod_reduce=1
iodepth_batch=4
iodepth_batch_complete=4
cpus_allowed=0-5
cpus_allowed_policy=split
rw=randwrite
verify=crc32c-intel
verify_backlog=1m
do_verify=1
verify_async=6
verify_async_cpus=0-5

[4_KiB_RR_drive_r]
filename=/dev/sdr

[4_KiB_RR_drive_s]
filename=/dev/sds


-- steve


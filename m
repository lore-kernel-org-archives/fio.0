Return-Path: <fio-owner@vger.kernel.org>
Received: from g1t0029.austin.hp.com ([15.216.28.36]:3381 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617Ab1KIWmd (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 9 Nov 2011 17:42:33 -0500
Received: from g5t0012.atlanta.hp.com (g5t0012.atlanta.hp.com [15.192.0.49])
	(using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by g1t0029.austin.hp.com (Postfix) with ESMTPS id B6DF838087
	for <fio@vger.kernel.org>; Wed,  9 Nov 2011 22:42:32 +0000 (UTC)
Received: from thumper.americas.hpqcorp.net (data.cce.hp.com [16.84.84.25])
	by g5t0012.atlanta.hp.com (Postfix) with ESMTPSA id 63B2310004
	for <fio@vger.kernel.org>; Wed,  9 Nov 2011 22:42:32 +0000 (UTC)
Message-ID: <4EBB01B8.5070801@hp.com>
Date: Wed, 09 Nov 2011 16:42:00 -0600
From: Mike Miller <mike.miller@hp.com>
MIME-Version: 1.0
Subject: fio: terminating on signal 15
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello,
I'm trying to benchmark random reads and I see some strange happenings 
on the server.
The idea was to have 128 processes randomly reading from a 10GB file and 
log bandwith and latencies. Here's my job file:
---------------------------
[global]
rw=randread
size=10g				; filesize = 10GB
bs=4k					; use block size of 4kB
numjobs=16				; 16 threads per job
ioengine=libaio				; use async IO
directory=/data				; use /data for testing
iodepth=32				; queue depth
direct=1				; to queue up multiple IOs
runtime=3600				; run for 1 hour
write_bw_log=/home/mikem/fio-logs	; gather bandwidth info
write_lat_log=/home/mikem/fio-logs	; gather latency info
disk_util=1				; generate disk useage stats
					; if supported on the platform
gtod_cpu=10				; get time of day on cpu 10

[job1]					; 10 jobs all doing the same thing as
					; desrcibed in global section
[job2]

[job3]

[job4]

[job5]

[job6]

[job7]

[job8]
---------------------------------------

What I got instead was 128 files of 10GB each with fio 128 processes 
running. After the writing of all the files I see

fio: terminating on signal 15

constantly scrolling in the window in which I started the fio job.

An strace -f -p pid shows:

kill(pid, SIGTERM) = 0

If I run `iostat -x /dev/sda1 5 5` the first line of output shows maybe 
400 MB/sec being read. Sometimes it spikes up to 800 MB/sec. Now it's 
showing 176 MB/sec being written. All subsequent lines show zero across 
the board. That's only with the writing phase. The reading phase does 
not exhibit that behavior. So I'm not sure if it's doing anything good.

Can someone tell me what I'm doing wrong? Again, my goal is to benchmark 
some number of processes or threads randomly reading from some large file.

Thanks,
mikem



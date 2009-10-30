Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:50789 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932310AbZJ3PUQ (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 30 Oct 2009 11:20:16 -0400
Received: by pwj9 with SMTP id 9so701987pwj.21
        for <fio@vger.kernel.org>; Fri, 30 Oct 2009 08:20:20 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 30 Oct 2009 09:20:20 -0600
Message-ID: <f3177b9e0910300820x37a19313te12f1ca48a085c3b@mail.gmail.com>
Subject: Every 13 hours sees a spike in fio CPU consumption, and a drop in   IOPS/throughput
From: Chris Worley <worleys@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I'm running fio benchmarks for 120 hours:

fio --rw=randrw --bs=4k --rwmixread=60 --numjobs=64 --iodepth=64
--sync=0 --direct=1 --randrepeat=0 --ioengine=libaio
--filename=/dev/sde --filename=/dev/sdf --name=test --loops=10000
--size=322122547200 --runtime=432000 --group_reporting

The fio threads are generally reporting 100K IOPS and each of the 64
fio threads uses less than 10% CPU.

But, every 13 hours (nearly to the minute), for ~200 seconds, the FIO
threads start consuming large amounts of CPU, and the IOPS drop to
~40K:

top - 07:36:59 up 8 days,  8:12,  0 users,  load average: 57.42,
58.54, 58.00Tasks: 352 total,  17 running, 335 sleeping,   0 stopped,
 0 zombie
Cpu(s):  1.2%us, 14.8%sy,  0.0%ni, 72.4%id, 10.1%wa,  1.3%hi,  0.2%si,
 0.0%stMem:  49449752k total,  6643996k used, 42805756k free,
205832k buffers
Swap:        0k total,        0k used,        0k free,  1432664k cached
  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+
COMMAND22108 root      18   0 86144  10m 9948 R 80.6  0.0 137:55.21
fio
22074 root      18   0 86144  10m 9952 R 70.8  0.0 138:07.68 fio
22101 root      18   0 86144  10m 9952 R 61.0  0.0 138:18.43 fio
22095 root      16   0 86144  10m 9948 D 51.1  0.0 137:54.02 fio
22134 root      16   0 86144  10m 9948 R 51.1  0.0 138:03.73 fio
22068 root      16   0 86144  10m 9952 R 49.2  0.0 138:04.16 fio
22083 root      16   0 86144  10m 9952 D 45.2  0.0 138:09.32 fio
22071 root      16   0 86144  10m 9948 D 29.5  0.0 137:37.75 fio
22128 root      16   0 86144  10m 9952 D 25.6  0.0 137:48.11 fio
22092 root      16   0 86144  10m 9948 D 11.8  0.0 137:54.14 fio
22097 root      16   0 86144  10m 9948 D  9.8  0.0 138:07.81 fio
...

There is nothing in the system to account for this (not occurring in
conjunction with i.e. logrotate or cron).

I've repeated this with 1.21 and 1.31, on RHEL 5.3 and RHEL 5.4.  The
1.31/RHEL5.4 case, the period was ~15 hours... this was also a slower
machine.

Any idea what's going on?

Thanks,

Chris

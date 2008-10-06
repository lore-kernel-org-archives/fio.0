Return-Path: <fio-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:29768 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754633AbYJFWES (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 6 Oct 2008 18:04:18 -0400
Received: from zps75.corp.google.com (zps75.corp.google.com [172.25.146.75])
	by smtp-out.google.com with ESMTP id m96M49fZ018446
	for <fio@vger.kernel.org>; Mon, 6 Oct 2008 23:04:09 +0100
Received: from yx-out-2324.google.com (yxb8.prod.google.com [10.190.1.72])
	by zps75.corp.google.com with ESMTP id m96M3odE025742
	for <fio@vger.kernel.org>; Mon, 6 Oct 2008 15:04:07 -0700
Received: by yx-out-2324.google.com with SMTP id 8so556413yxb.55
        for <fio@vger.kernel.org>; Mon, 06 Oct 2008 15:04:07 -0700 (PDT)
Message-ID: <7a2ad2470810061504x2b973b80v3caa136d6d883dd8@mail.gmail.com>
Date: Mon, 6 Oct 2008 15:04:06 -0700
From: "Shawn Lewis" <shawnlewis@google.com>
Subject: BUG: option runtime not working during a particular failure mode.
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio <fio@vger.kernel.org>

Hi,

I have a random read load in which fio hung on a machine. It is
time_based with runtime=60. A few of the disks in question experienced
errors at the same time so I would expect fio to fail or stop after
60- seconds.

I haven't tried to debug this in depth yet. Jens I thought an answer
might jump out at you. If not I'll take a look.

Full disclosure: I modified the config and the strace output to show
fewer disks then were actually being accessed.

Here is the config file:
[sda-randomaccess]
filename=/export/sda3/
datafile.tmp
rw=randread
bs=64k
ioengine=sync
time_based=1
runtime=3600
bwavgtime=5000
direct=1
thread=1

[sdb-randomaccess]
filename=/export/sdb3/datafile.tmp
rw=randread
bs=64k
ioengine=sync
time_based=1
runtime=3600
bwavgtime=5000
direct=1
thread=1

[sdc-randomaccess]
filename=/export/sdc3/datafile.tmp
rw=randread
bs=64k
ioengine=sync
time_based=1
runtime=3600
bwavgtime=5000
direct=1
thread=1

[sdd-randomaccess]
filename=/export/sdd3/datafile.tmp
rw=randread
bs=64k
ioengine=sync
time_based=1
runtime=3600
bwavgtime=5000
direct=1
thread=1


We get some hints from strace. It looks like we're just doing the
sig_alrm loop. But why aren't hitting runtime? Are the other threads
stopped already for some reason?

static void sig_alrm(int sig)
{
        if (threads) {
                update_io_ticks();
                print_thread_status();
                status_timer_arm();
        }
}


strace. This is repeated over and over:

--- SIGALRM (Alarm clock) @ 0 (0) ---
open("/sys/block/sdd/stat", O_RDONLY)   = 8
fstat(8, {st_mode=S_IFREG|0444, st_size=4096, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0x2aaaadf29000
read(8, "15490269   238448 1950476298  87"..., 4096) = 105
close(8)                                = 0
munmap(0x2aaaadf29000, 4096)            = 0
open("/sys/block/sdc/stat", O_RDONLY)   = 8
fstat(8, {st_mode=S_IFREG|0444, st_size=4096, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0x2aaaadf29000
read(8, "15489598   238450 1950388618  86"..., 4096) = 105
close(8)                                = 0
munmap(0x2aaaadf29000, 4096)            = 0
open("/sys/block/sda/stat", O_RDONLY)   = 8
fstat(8, {st_mode=S_IFREG|0444, st_size=4096, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0x2aaaadf29000
read(8, "15368259   237021 1934418422 103"..., 4096) = 105
close(8)                                = 0
munmap(0x2aaaadf29000, 4096)            = 0
open("/sys/block/sdb/stat", O_RDONLY)   = 8
fstat(8, {st_mode=S_IFREG|0444, st_size=4096, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0x2aaaadf29000
read(8, "15665652   241115 1972572554 101"..., 4096) = 105
close(8)                                = 0
munmap(0x2aaaadf29000, 4096)            = 0
setitimer(ITIMER_REAL, {it_interval={0, 0}, it_value={0, 250000}}, NULL) = 0
rt_sigreturn(0x5875e0)                  = -1 EINTR (Interrupted system call)
nanosleep({0, 10000000}, NULL)          = 0
nanosleep({0, 10000000}, NULL)          = 0
nanosleep({0, 10000000}, NULL)          = 0
nanosleep({0, 10000000}, NULL)          = 0
nanosleep({0, 10000000}, NULL)          = 0
nanosleep({0, 10000000}, NULL)          = 0
nanosleep({0, 10000000}, NULL)          = 0
nanosleep({0, 10000000}, NULL)          = 0
nanosleep({0, 10000000}, NULL)          = 0
nanosleep({0, 10000000}, NULL)          = 0
nanosleep({0, 10000000}, NULL)          = 0
nanosleep({0, 10000000}, NULL)          = 0
nanosleep({0, 10000000}, NULL)          = 0
nanosleep({0, 10000000}, NULL)          = 0
nanosleep({0, 10000000}, NULL)          = 0
nanosleep({0, 10000000}, NULL)          = 0
nanosleep({0, 10000000}, NULL)          = 0
nanosleep({0, 10000000}, NULL)          = 0
nanosleep({0, 10000000}, NULL)          = 0
nanosleep({0, 10000000}, NULL)          = 0
nanosleep({0, 10000000}, NULL)          = 0
nanosleep({0, 10000000}, NULL)          = 0
nanosleep({0, 10000000}, 0)             = ? ERESTART_RESTARTBLOCK (To
be restarted)


Thanks,
Shawn

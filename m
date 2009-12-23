Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:57827 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752765AbZLWHPe (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 23 Dec 2009 02:15:34 -0500
Received: by pwj9 with SMTP id 9so4234505pwj.21
        for <fio@vger.kernel.org>; Tue, 22 Dec 2009 23:15:33 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 22 Dec 2009 23:15:33 -0800
Message-ID: <e3e1c3ff0912222315s4d7fd27dr952343ca90b6fb71@mail.gmail.com>
Subject: fio jobs die with sigsegv if --filesize=1tb
From: Case van Rij <case.vanrij@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

fairly basic random write test over nfs, 1 job, directio enabled,
pre-existing 1TB file results in SIGSEGV,

tested on: CentOS 5.4 x86_64,  2.6.18-164.6.1.el5 kernel, fio from
git, last change: Tue, 22 Dec 2009 08:06:43 +0000

fio --name=rndwrs --ioengine=libaio --iodepth=4 --rw=randwrite
--bs=32k --direct=1 --size=1tb --numjobs=1 --filename=/mnt/nfs/1tb.vdb
random-writers: (g=0): rw=randwrite, bs=32K-32K/32K-32K,
ioengine=libaio, iodepth=4
Starting 1 process
fio: pid=24153, got signal=11

Run status group 0 (all jobs):
fio: file hash not empty on exit

strace:
[pid 23961] open("/sys/devices/system/cpu/cpu0/cache/index0/coherency_line_size",
O_RDONLY) = 8
[pid 23961] read(8, "64\n", 32)         = 3
[pid 23961] close(8)                    = 0
[pid 23961] getpriority(PRIO_PROCESS, 0) = 20
[pid 23961] setpriority(PRIO_PROCESS, 0, 0) = 0
[pid 23961] getpriority(PRIO_PROCESS, 0) = 20
[pid 23961] io_setup(4, {47657422389248}) = 0
[pid 23961] getrusage(RUSAGE_SELF, {ru_utime={0, 1999}, ru_stime={0,
0}, ...}) = 0
[pid 23961] open("/mnt/nfs/1tb.vdb", O_RDWR|O_CREAT|O_DIRECT, 0600) = 8
[pid 23961] fadvise64(8, 0, 1, POSIX_FADV_DONTNEED) = 0
[pid 23961] fadvise64(8, 0, 1, POSIX_FADV_RANDOM) = 0
[pid 23961] --- SIGSEGV (Segmentation fault) @ 0 (0) ---

but no core file, since reap_threads cleans up after the sigsegv (?)

with debug=all:
io       26954 invalidate cache /mnt/nfs/1tb.vdb: 0/1
file     26954 goodf=1, badf=2, ff=31
file     26954 get_next_file_rr: 0x2abe73d38028
file     26954 get_next_file: 0x2abe73d38028 [/mnt/nfs/1tb.vdb]
file     26954 get file /mnt/nfs/1tb.vdb, ref=1
random   26954 off rand 1425201762
random   26954 free: b=12242389915983151104, idx=536870912, bit=0
fio: pid=26954, got signal=11
process  26952 pid=26954: runstate 4 -> 9
process  26952 terminate group_id=-1
process  26952 setting terminate on random-writers/26954
diskutil    26952 update io ticks

the same test works if I replace --filesize=1tb with --filesize=1gb
(but makes for a far less interesting test).

Regards,
Case

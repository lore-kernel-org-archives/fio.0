Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f170.google.com ([209.85.217.170]:36794 "EHLO
        mail-ua0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752765AbcHTPTu (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 20 Aug 2016 11:19:50 -0400
MIME-Version: 1.0
From: Anatoly Pugachev <matorola@gmail.com>
Date: Sat, 20 Aug 2016 18:19:49 +0300
Message-ID: <CADxRZqwnO-UuLgAkDb4bvqVY9hMMSnFFcdkYdPnfwfJukN09yA@mail.gmail.com>
Subject: [sparc64] fio bus error
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: sparclinux@vger.kernel.org, debian-sparc <debian-sparc@lists.debian.org>

Hello!

I'm getting bus error on sparc64 debian sid linux with git compiled fio:

mator@nvg5120:~/fio.git$ git describe
fio-2.13-77-gd1f6fca

mator@nvg5120:~/fio.git$ cat /tmp/test.fio
[global]
bs=8k
iodepth=16
iodepth_batch=8
randrepeat=1
size=1m
directory=/home/mator/fio.dir
numjobs=5
[job1]
ioengine=sync
bs=1k
direct=1
rw=randread
filename=file1:file2


mator@nvg5120:~/fio.git$ gdb -q
(gdb) file ./fio
Reading symbols from ./fio...done.
(gdb) set args /tmp/test.fio
(gdb) run
Starting program: /home/mator/fio.git/fio /tmp/test.fio
[Thread debugging using libthread_db enabled]
Using host libthread_db library "/lib/sparc64-linux-gnu/libthread_db.so.1".
job1: (g=0): rw=randread, bs=1K-1K/1K-1K/1K-1K, ioengine=sync, iodepth=16
...
fio-2.13-77-gd1f6f
[New Thread 0xffff80011025b910 (LWP 15753)]
Starting 5 processes

Thread 2 "fio" received signal SIGBUS, Bus error.
[Switching to Thread 0xffff80011025b910 (LWP 15753)]
calc_log_samples () at stat.c:2461
2461                            tmp = add_bw_samples(td, &now);
(gdb) bt
#0  calc_log_samples () at stat.c:2461
#1  0x000000000018e944 in helper_thread_main (data=0xffff800100ac5670)
at helper_thread.c:121
#2  0xffff80010063ba04 in start_thread (arg=0xffff80011025b910) at
pthread_create.c:335
#3  0xffff800100944f58 in __thread_start () at
../sysdeps/unix/sysv/linux/sparc/sparc64/clone.S:93
Backtrace stopped: previous frame identical to this frame (corrupt stack?)
(gdb)

Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ot0-f175.google.com ([74.125.82.175]:36056 "EHLO
        mail-ot0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751143AbdFVJQU (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 22 Jun 2017 05:16:20 -0400
Received: by mail-ot0-f175.google.com with SMTP id 95so6814162ott.3
        for <fio@vger.kernel.org>; Thu, 22 Jun 2017 02:16:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAMHrwcQSQ+NO2Nd0Y8FkF9WQF=UYY7pM3cmQj_0TZbTH9oQyHA@mail.gmail.com>
References: <CAMHrwcQSQ+NO2Nd0Y8FkF9WQF=UYY7pM3cmQj_0TZbTH9oQyHA@mail.gmail.com>
From: Ido Ben-Tsion <idob@infinidat.com>
Date: Thu, 22 Jun 2017 12:15:59 +0300
Message-ID: <CAMHrwcTuHiYLFPYTg7ZGP_LNDOKisp4MUmGXJP+-vSHRUSRdyA@mail.gmail.com>
Subject: Fwd: segmentation fault in flist from workqueue.c
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

hi,

I'm using fio-2.21 built without optimization on Centos based distribution
Linux ... 3.10.0-... + #1 SMP Thu May 18 13:39:20 UTC 2017 x86_64
x86_64 x86_64 GNU/Linux

fio crashed on segmentation fault.
it happened several times, with a different set of parameters, always
with ioqueue depth higher than 1.

details from one of the crashes follow.

thanks,
Ido.

backtrace from gdb:
Program terminated with signal 11, Segmentation fault.
#0  0x0000000000479725 in __flist_splice (list=0x7f535a11dbd0,
prev=0x7f5337246ee0, next=0x7f5337246ee0) at os/../flist.h:123
123    os/../flist.h: No such file or directory.
(gdb) bt
#0  0x0000000000479725 in __flist_splice (list=0x7f535a11dbd0,
prev=0x7f5337246ee0, next=0x7f5337246ee0) at os/../flist.h:123
#1  0x0000000000479787 in flist_splice_init (list=0x7f535a11dbd0,
head=0x7f5337246ee0) at os/../flist.h:157
#2  0x0000000000479ef1 in worker_thread (data=0x7f535a11db70) at workqueue.c:198
#3  0x00007f535b6f3dc5 in start_thread () from /lib64/libpthread.so.0
#4  0x00007f535b21e73d in clone () from /lib64/libc.so.6
(gdb) p first
$1 = (struct flist_head *) 0x7f534000c9a0
(gdb) p last
$2 = (struct flist_head *) 0x7f534000c8e0
(gdb) p list
$3 = (const struct flist_head *) 0x7f535a11dbd0

4 processes failed, at different times (this is the output):
write-sg131-64k-para: (g=0): rw=write, bs=(R) 64.0KiB-64.0KiB, (W)
64.0KiB-64.0KiB, (T) 64.0KiB-64.0KiB, ioengine=sg, iodepth=16
randwrite-sg131-64k-para: (g=1): rw=randwrite, bs=(R) 64.0KiB-64.0KiB,
(W) 64.0KiB-64.0KiB, (T) 64.0KiB-64.0KiB, ioengine=sg, iodepth=16
read-sg131-64k-para: (g=2): rw=read, bs=(R) 64.0KiB-64.0KiB, (W)
64.0KiB-64.0KiB, (T) 64.0KiB-64.0KiB, ioengine=sg, iodepth=16
randread-sg131-64k-para: (g=3): rw=randread, bs=(R) 64.0KiB-64.0KiB,
(W) 64.0KiB-64.0KiB, (T) 64.0KiB-64.0KiB, ioengine=sg, iodepth=16
fio-2.21
Starting 4 processes
fio: pid=42510, got signal=118%][r=0KiB/s,w=0KiB/s][r=0,w=0 IOPS][eta
19m:22s]
Jobs: 1 (f=1): [K(1),w(1),P(2)][6.6%][r=0KiB/s,w=9031KiB/s][r=0,w=141
IOPS][eta 15m:57s]
fio: pid=42573, got signal=11)][11.3%][r=0KiB/s,w=1848KiB/s][r=0,w=28
IOPS][eta 15m:10s]
fio: pid=42635, got signal=11)][21.0%][r=0KiB/s,w=0KiB/s][r=0,w=0
IOPS][eta 10m:56s]
fio: pid=42696, got signal=11.3%][r=9315KiB/s,w=0KiB/s][r=145,w=0
IOPS][eta 06m:46s]


./fio X.fio (created with genfio, overriding io engine from libaio to sg):
[global]
ioengine=sg
invalidate=1
ramp_time=5
iodepth=16
runtime=300
time_based
log_avg_msec=50
log_compression=64k
#log_store_compressed=1

[write-sg13-64k-para]
bs=64k
stonewall
filename=/dev/sg13
rw=write
write_bw_log=ib43-64k-sg13-write-para.results
write_iops_log=ib43-64k-sg13-write-para.results

[randwrite-sg13-64k-para]
bs=64k
stonewall
filename=/dev/sg13
rw=randwrite
write_bw_log=ib43-64k-sg13-randwrite-para.results
write_iops_log=ib43-64k-sg13-randwrite-para.results

[read-sg13-64k-para]
bs=64k
stonewall
filename=/dev/sg13
rw=read
write_bw_log=ib43-64k-sg13-read-para.results
write_iops_log=ib43-64k-sg13-read-para.results

[randread-sg13-64k-para]
bs=64k
stonewall
filename=/dev/sg13
rw=randread
write_bw_log=ib43-64k-sg13-randread-para.results
write_iops_log=ib43-64k-sg13-randread-para.results

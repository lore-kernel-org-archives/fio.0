Return-Path: <fio-owner@vger.kernel.org>
Received: from legacy.ddn.com ([64.47.133.206]:7637 "EHLO legacy.ddn.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752091Ab3IJX3B convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Tue, 10 Sep 2013 19:29:01 -0400
From: Keith Pine <kpine@ddn.com>
Subject: segfaults/error with ioengine=sg
Date: Tue, 10 Sep 2013 23:23:55 +0000
Message-ID: <F391FB4F21BEC943926789308B8035907DD18BD0@LAX-EX-MB3.datadirect.datadirectnet.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

I've encountered a segfault and error when trying to use the sg ioengine with iodepth > 1. These crashes occur with both the packaged Centos6 version (2.0.13) and one from git I built yesterday.  Perhaps iodepth is not supported with the sg ioengine? I am trying to use an sg device for asynchronous io, and setting a higher iodepth in order to increase throughput.

First, output of sg_inq of drive being tested:

# sg_inq /dev/sg6
standard INQUIRY:
  PQual=0  Device_type=0  RMB=0  version=0x05  [SPC-3]
  [AERC=0]  [TrmTsk=0]  NormACA=0  HiSUP=0  Resp_data_format=2
  SCCS=0  ACC=0  TPGS=0  3PC=0  Protect=0  [BQue=0]
  EncServ=0  MultiP=1 (VS=0)  [MChngr=0]  [ACKREQQ=0]  Addr16=0
  [RelAdr=0]  WBus16=0  Sync=0  Linked=0  [TranDis=0]  CmdQue=1
  [SPI: Clocking=0x0  QAS=0  IUS=0]
    length=164 (0xa4)   Peripheral device type: disk
 Vendor identification: ATA
 Product identification: Hitachi HDS72303
 Product revision level: AA10
 Unit serial number:       MK0371YVGT69GK

Here is the job file:

[global]
filename=/dev/sg6
size=10g
thread=1
ioengine=sg
iodepth=64

[write-phase]
bs=1M
rw=write

Program output:

write-phase: (g=0): rw=write, bs=1M-1M/1M-1M/1M-1M, ioengine=sg, iodepth=64
fio-2.1.2-21-gf7133
Starting 1 thread
Segmentation fault (core dumped)

And stack trace:

Program terminated with signal 11, Segmentation fault.
#0  dprint_io_u (td=0x7fb452426000, io_u=0x0, icd=0x7fb451a22d00) at ioengine.h:214
214     ioengine.h: No such file or directory.
        in ioengine.h
Missing separate debuginfos, use: debuginfo-install glibc-2.12-1.80.el6_3.7.x86_64 libaio-0.3.107-10.el6.x86_64 zlib-1.2.3-27.el6.x86_64
(gdb) where
#0  dprint_io_u (td=0x7fb452426000, io_u=0x0, icd=0x7fb451a22d00) at ioengine.h:214
#1  io_completed (td=0x7fb452426000, io_u=0x0, icd=0x7fb451a22d00) at io_u.c:1436
#2  0x0000000000426030 in ios_completed (td=0x7fb452426000, min_evts=<value optimized out>, bytes=0x0) at io_u.c:1551
#3  io_u_queued_complete (td=0x7fb452426000, min_evts=<value optimized out>, bytes=0x0) at io_u.c:1611
#4  0x00000000004421b2 in cleanup_pending_aio (data=0x7fb452426000) at backend.c:267
#5  do_io (data=0x7fb452426000) at backend.c:859
#6  thread_main (data=0x7fb452426000) at backend.c:1314
#7  0x00007fb4559e8851 in start_thread () from /lib64/libpthread.so.0
#8  0x00007fb45553211d in clone () from /lib64/libc.so.6

When the 'thread' option is disabled, fio fails with an error instead of a crash:

write-phase: (g=0): rw=write, bs=1M-1M/1M-1M/1M-1M, ioengine=sg, iodepth=64
fio-2.1.2-21-gf7133
Starting 1 process
fio: pid=5701, got signal=11

write-phase: (groupid=0, jobs=1): err=33 (file:engines/sg.c:260, func=xfer, error=Numerical argument out of domain): pid=5701: Tue Sep 10 15:45:28 201
    lat (msec) : 50=5.88%, 100=5.88%
  cpu          : usr=0.00%, sys=0.00%, ctx=0, majf=0, minf=0
  IO depths    : 1=5.9%, 2=11.8%, 4=23.5%, 8=47.1%, 16=11.8%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=94.7%, 8=0.0%, 16=5.3%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=0/w=17/d=0, short=r=0/w=0/d=0

Run status group 0 (all jobs):
fio: file hash not empty on exit

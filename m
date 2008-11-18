Return-Path: <fio-owner@vger.kernel.org>
Received: from host-181-75-169-83.static.internet-fr.net ([83.169.75.181]:58508
	"EHLO seanodes.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751585AbYKRPat (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 18 Nov 2008 10:30:49 -0500
Message-ID: <4922DE15.9080009@seanodes.com>
Date: Tue, 18 Nov 2008 16:24:05 +0100
From: Erwan Velu <erwan@seanodes.com>
MIME-Version: 1.0
Subject: fio 1.22 segfaults when pressing ctrl-c
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I'm running fio with the surface scan example, and it just segfault and 
generate a core if I'm pressing CTRL-C during the test.

[root@max5 examples]# fio surface-scan
write-phase: (g=0): rw=write, bs=64K-64K/64K-64K, ioengine=sync, iodepth=1
verify-phase: (g=1): rw=read, bs=64K-64K/64K-64K, ioengine=sync, iodepth=1
Starting 2 threads
**** I'm pressing CTRL-C ****
fio: terminating on signal 2
Quit (core dumped)
[root@max5 examples]#


Then same from gdb:

[root@max5 examples]# gdb --args fio surface-scan
GNU gdb Red Hat Linux (6.5-25.el5_1.1rh)
Copyright (C) 2006 Free Software Foundation, Inc.
GDB is free software, covered by the GNU General Public License, and you are
welcome to change it and/or distribute copies of it under certain 
conditions.
Type "show copying" to see the conditions.
There is absolutely no warranty for GDB.  Type "show warranty" for details.
This GDB was configured as "x86_64-redhat-linux-gnu"...Using host 
libthread_db library "/lib64/libthread_db.so.1".

(gdb) run
Starting program: /usr/bin/fio surface-scan
[Thread debugging using libthread_db enabled]
[New Thread 46912498286832 (LWP 2158)]
write-phase: (g=0): rw=write, bs=64K-64K/64K-64K, ioengine=sync, iodepth=1
verify-phase: (g=1): rw=read, bs=64K-64K/64K-64K, ioengine=sync, iodepth=1
Starting 2 threads
[New Thread 1084229952 (LWP 2161)]
Jobs: 1 (f=1): [WP] [-.-% done] [     0/ 57822 kb/s] [eta 00m:00s]

**** I'm pressing CTRL-C ****

Program received signal SIGINT, Interrupt.
[Switching to Thread 46912498286832 (LWP 2158)]
0x0000003c23495511 in nanosleep () from /lib64/libc.so.6
(gdb) bt
#0  0x0000003c23495511 in nanosleep () from /lib64/libc.so.6
#1  0x0000003c234c8554 in usleep () from /lib64/libc.so.6
#2  0x0000000000408448 in main (argc=<value optimized out>, argv=<value 
optimized out>) at fio.c:1394
(gdb)

-- 
Erwan Velu
Pre-Sales Engineer
Seanodes
http://www.seanodes.com
+33 (0)1 41 22 13 83


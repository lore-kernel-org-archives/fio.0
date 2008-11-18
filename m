Return-Path: <fio-owner@vger.kernel.org>
Received: from pasmtpb.tele.dk ([80.160.77.98]:48208 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752450AbYKRSAV (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 18 Nov 2008 13:00:21 -0500
Date: Tue, 18 Nov 2008 18:58:33 +0100
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: fio 1.22 segfaults when pressing ctrl-c
Message-ID: <20081118175833.GC26308@kernel.dk>
References: <4922DE15.9080009@seanodes.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4922DE15.9080009@seanodes.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Erwan Velu <erwan@seanodes.com>
Cc: fio@vger.kernel.org

On Tue, Nov 18 2008, Erwan Velu wrote:
> I'm running fio with the surface scan example, and it just segfault and 
> generate a core if I'm pressing CTRL-C during the test.
> 
> [root@max5 examples]# fio surface-scan
> write-phase: (g=0): rw=write, bs=64K-64K/64K-64K, ioengine=sync, iodepth=1
> verify-phase: (g=1): rw=read, bs=64K-64K/64K-64K, ioengine=sync, iodepth=1
> Starting 2 threads
> **** I'm pressing CTRL-C ****
> fio: terminating on signal 2
> Quit (core dumped)
> [root@max5 examples]#
> 
> 
> Then same from gdb:
> 
> [root@max5 examples]# gdb --args fio surface-scan
> GNU gdb Red Hat Linux (6.5-25.el5_1.1rh)
> Copyright (C) 2006 Free Software Foundation, Inc.
> GDB is free software, covered by the GNU General Public License, and you are
> welcome to change it and/or distribute copies of it under certain 
> conditions.
> Type "show copying" to see the conditions.
> There is absolutely no warranty for GDB.  Type "show warranty" for details.
> This GDB was configured as "x86_64-redhat-linux-gnu"...Using host 
> libthread_db library "/lib64/libthread_db.so.1".
> 
> (gdb) run
> Starting program: /usr/bin/fio surface-scan
> [Thread debugging using libthread_db enabled]
> [New Thread 46912498286832 (LWP 2158)]
> write-phase: (g=0): rw=write, bs=64K-64K/64K-64K, ioengine=sync, iodepth=1
> verify-phase: (g=1): rw=read, bs=64K-64K/64K-64K, ioengine=sync, iodepth=1
> Starting 2 threads
> [New Thread 1084229952 (LWP 2161)]
> Jobs: 1 (f=1): [WP] [-.-% done] [     0/ 57822 kb/s] [eta 00m:00s]
> 
> **** I'm pressing CTRL-C ****
> 
> Program received signal SIGINT, Interrupt.
> [Switching to Thread 46912498286832 (LWP 2158)]
> 0x0000003c23495511 in nanosleep () from /lib64/libc.so.6
> (gdb) bt
> #0  0x0000003c23495511 in nanosleep () from /lib64/libc.so.6
> #1  0x0000003c234c8554 in usleep () from /lib64/libc.so.6
> #2  0x0000000000408448 in main (argc=<value optimized out>, argv=<value 
> optimized out>) at fio.c:1394
> (gdb)

Can you recreate with the -O2 removed in the Makefile? That'll get us
some better debug information. You probably also want to inspect the
thread that crashed, you are looking at the main process and that just
mainly sleeps and does status dumps every few seconds.

-- 
Jens Axboe


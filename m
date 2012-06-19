Return-Path: <fio-owner@vger.kernel.org>
Received: from pbit-mailserver.permabit.com ([204.246.225.83]:59763 "EHLO
	pbit-mailserver.permabit.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751111Ab2FSXMl convert rfc822-to-8bit
	(ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 19 Jun 2012 19:12:41 -0400
Received: from overpriced.permabit.com (overpriced.permabit.com [10.95.208.58])
	by pbit-mailserver.permabit.com (Postfix) with ESMTPSA id 716DE148E11A
	for <fio@vger.kernel.org>; Tue, 19 Jun 2012 19:05:21 -0400 (EDT)
From: Erik Lattimore <elatt@permabit.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: Race condition in fio atexit code
Date: Tue, 19 Jun 2012 19:05:20 -0400
Message-Id: <998AA462-26EC-421F-B005-B4B6C936A233@permabit.com>
Mime-Version: 1.0 (Apple Message framework v1278)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Lately it seems like we've been hitting this more frequently, so I figured I'd file a bug.  Fio starts up a thread running the function disk_thread_main, which periodically calls update_io_ticks, which calls update_io_tick_disk on each entry in a circular linked list. The function disk_thread_main returns when the global variable "threads" is set to null, but it's only checked a couple of times in the loop.

The main thread runs the test and exits, and has registered an atexit handler free_shm. This routine sets "threads" to null and frees up storage, including the storage where the linked list used by update_io_ticks is stored.

Occasionally, somehow, update_io_tick_disk winds up getting called with a null pointer and crashing. The problem may be exacerbated when memory is tight. Here's the backtrace of the core dump:

Program terminated with signal 11, Segmentation fault.
#0  update_io_tick_disk (du=<optimized out>) at diskutil.c:80
80              if (!du->users)
(gdb) t apply all bt

Thread 2 (Thread 0x7faab680b700 (LWP 23148)):
#0  0x00007faab58df377 in shmdt () from /lib64/libc.so.6
#1  0x000000000040b98d in free_shm () at init.c:231
#2  0x00007faab583b7f5 in __run_exit_handlers () from /lib64/libc.so.6
#3  0x00007faab583b845 in exit () from /lib64/libc.so.6
#4  0x00007faab5824c3d in __libc_start_main () from /lib64/libc.so.6
#5  0x0000000000408ed9 in _start ()

Thread 1 (Thread 0x7faab32dd700 (LWP 23149)):
#0  update_io_tick_disk (du=<optimized out>) at diskutil.c:80
#1  update_io_ticks () at diskutil.c:114
#2  0x000000000043b303 in disk_thread_main (data=<optimized out>) at backend.c:1589
#3  0x00007faab61907b6 in start_thread () from /lib64/libpthread.so.0
#4  0x00007faab58dd9cd in clone () from /lib64/libc.so.6
#5  0x0000000000000000 in ?? ()
(gdb) q
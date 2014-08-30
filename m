Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:35068 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390AbaH3OlW (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 30 Aug 2014 10:41:22 -0400
Received: by mail-we0-f173.google.com with SMTP id t60so3441388wes.4
        for <fio@vger.kernel.org>; Sat, 30 Aug 2014 07:41:21 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 30 Aug 2014 07:41:20 -0700
Message-ID: <CALKLVuJv4KqbKFU5fk0-TXw5fcXYmP55GA_RXdeA2+SXvantcg@mail.gmail.com>
Subject: deadlock in fio.. client/server
From: Castor Fu <castor@egocast.org>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I see what looks to me like a deadlock when running with multiple jobs
in client/server mode.
However, I'm not too used to debugging multithreaded code, so I
figured maybe some additional eyes would help.

This is on a Gen8 HP DL380 (dual socket x86_64) running CentOS EL6.

I haven't seen this when just running from the command line.

I start the daemon with:

fio --daemonize=/tmp/fio.pid.4987 --server=localhost,8098

and a client with
fio --client=localhost 8098 --output=test_blk.20140830Z1419 test_bad2.fio

#
[global]

ioengine=libaio
thread=1
bs=4k
filename=/dev/sdb
size=1M
do_verify=1
iodepth=8
stonewall

[writes]
rw=write
# 3 passes
# 4 fails
numjobs=4

and sometimes (50% or higher with num_jobs=4) it hangs.

If I look at it in GDB we see:
(gdb) info thread
  6 Thread 0x7f446644a700 (LWP 5017)  0x0000003ffa8acb8d in nanosleep
() from /lib64/libc.so.6
  5 Thread 0x7f4465a47700 (LWP 5023)  0x0000003ffac0e054 in
__lll_lock_wait () from /lib64/libpthread.so.0
  4 Thread 0x7f4465045700 (LWP 5024)  0x0000003ffac0e054 in
__lll_lock_wait () from /lib64/libpthread.so.0
  3 Thread 0x7f4464643700 (LWP 5025)  0x0000003ffac0e054 in
__lll_lock_wait () from /lib64/libpthread.so.0
  2 Thread 0x7f4463c41700 (LWP 5027)  0x0000003ffac0e054 in
__lll_lock_wait () from /lib64/libpthread.so.0
* 1 Thread 0x7f446f4fe720 (LWP 5016)  0x0000003ffa8acb8d in nanosleep
() from /lib64/libc.so.6
(gdb) p mp[0].lock
$1 = (struct fio_mutex *) 0x7f446f509000
(gdb) p *mp[0].lock
$2 = {
  lock = {
    __data = {
      __lock = 2,
      __count = 0,
      __owner = 5023,
      __nusers = 1,
      __kind = 128,
      __spins = 0,
      __list = {     __prev = 0x0,      __next = 0x0    }
    },
    __size = "\002\000\000\000\000\000\000\000\237\023\000\000\001\000\000\000\200",
'\000' <repeats 22 times>,
    __align = 2
  },
  cond = {
    __data = {
      __lock = 2,    __futex = 0,
      __total_seq = 18446744073709551615,
      __wakeup_seq = 0,     __woken_seq = 0,
      __mutex = 0xffffffffffffffff,
      __nwaiters = 0,    __broadcast_seq = 0
    },
    __size = "\002\000\000\000\000\000\000\000\377\377\377\377\377\377\377\377",
'\000' <repeats 16 times>"\377,
\377\377\377\377\377\377\377\000\000\000\000\000\000\000",
    __align = 2
  },
  value = 0,
  waiters = 1,
  magic = 1297437765
}

But if we look at lwp 5023 which is supposed to be the owner it looks
like it's waiting on the lock.

gdb) thread 5
[Switching to thread 5 (Thread 0x7f4465a47700 (LWP 5023))]#0
0x0000003ffac0e054 in __lll_lock_wait ()
   from /lib64/libpthread.so.0
(gdb) bt
#0  0x0000003ffac0e054 in __lll_lock_wait () from /lib64/libpthread.so.0
#1  0x0000003ffac0b4fc in pthread_cond_wait@@GLIBC_2.3.2 () from
/lib64/libpthread.so.0
#2  0x000000000043fe81 in fio_mutex_down (mutex=0x7f446f509000) at
util/fio/mutex.c:155
#3  0x000000000044a7c1 in pool_lock (ptr=0x7f446ecf51f0) at
util/fio/smalloc.c:60
#4  sfree_pool (ptr=0x7f446ecf51f0) at util/fio/smalloc.c:328
#5  sfree (ptr=0x7f446ecf51f0) at util/fio/smalloc.c:356
#6  0x00000000004284f2 in close_and_free_files (td=0x7f4466450000) at
util/fio/filesetup.c:1122
#7  0x000000000040b495 in thread_main (data=0x7f4466450000) at
util/fio/backend.c:1548
#8  0x0000003ffac07851 in start_thread () from /lib64/libpthread.so.0
#9  0x0000003ffa8e890d in clone () from /lib64/libc.so.6

And all threads....

Thread 6 (Thread 0x7f446644a700 (LWP 5017)):
#0  0x0000003ffa8acb8d in nanosleep () from /lib64/libc.so.6
#1  0x0000003ffa8e1d64 in usleep () from /lib64/libc.so.6
#2  0x000000000040a558 in disk_thread_main (data=Unhandled dwarf
expression opcode 0xf3
) at util/fio/backend.c:1992
#3  0x0000003ffac07851 in start_thread () from /lib64/libpthread.so.0
#4  0x0000003ffa8e890d in clone () from /lib64/libc.so.6

Thread 5 (Thread 0x7f4465a47700 (LWP 5023)):
#0  0x0000003ffac0e054 in __lll_lock_wait () from /lib64/libpthread.so.0
#1  0x0000003ffac0b4fc in pthread_cond_wait@@GLIBC_2.3.2 () from
/lib64/libpthread.so.0
#2  0x000000000043fe81 in fio_mutex_down (mutex=0x7f446f509000) at
util/fio/mutex.c:155
#3  0x000000000044a7c1 in pool_lock (ptr=0x7f446ecf51f0) at
util/fio/smalloc.c:60
#4  sfree_pool (ptr=0x7f446ecf51f0) at util/fio/smalloc.c:328
#5  sfree (ptr=0x7f446ecf51f0) at util/fio/smalloc.c:356
#6  0x00000000004284f2 in close_and_free_files (td=0x7f4466450000) at
util/fio/filesetup.c:1122
#7  0x000000000040b495 in thread_main (data=0x7f4466450000) at
util/fio/backend.c:1548
#8  0x0000003ffac07851 in start_thread () from /lib64/libpthread.so.0
#9  0x0000003ffa8e890d in clone () from /lib64/libc.so.6

Thread 4 (Thread 0x7f4465045700 (LWP 5024)):
#0  0x0000003ffac0e054 in __lll_lock_wait () from /lib64/libpthread.so.0
#1  0x0000003ffac09388 in _L_lock_854 () from /lib64/libpthread.so.0
#2  0x0000003ffac09257 in pthread_mutex_lock () from /lib64/libpthread.so.0
#3  0x000000000043fe58 in fio_mutex_down (mutex=0x7f446f509000) at
util/fio/mutex.c:151
#4  0x000000000044a7c1 in pool_lock (ptr=0x7f446ecf5390) at
util/fio/smalloc.c:60
#5  sfree_pool (ptr=0x7f446ecf5390) at util/fio/smalloc.c:328
#6  sfree (ptr=0x7f446ecf5390) at util/fio/smalloc.c:356
#7  0x00000000004284f2 in close_and_free_files (td=0x7f44664553b8) at
util/fio/filesetup.c:1122
#8  0x000000000040b495 in thread_main (data=0x7f44664553b8) at
util/fio/backend.c:1548
#9  0x0000003ffac07851 in start_thread () from /lib64/libpthread.so.0
#10 0x0000003ffa8e890d in clone () from /lib64/libc.so.6

Thread 3 (Thread 0x7f4464643700 (LWP 5025)):
#0  0x0000003ffac0e054 in __lll_lock_wait () from /lib64/libpthread.so.0
#1  0x0000003ffac09388 in _L_lock_854 () from /lib64/libpthread.so.0
#2  0x0000003ffac09257 in pthread_mutex_lock () from /lib64/libpthread.so.0
#3  0x000000000043fe58 in fio_mutex_down (mutex=0x7f446f509000) at
util/fio/mutex.c:151
#4  0x000000000044a7c1 in pool_lock (ptr=0x7f446ecf5690) at
util/fio/smalloc.c:60
#5  sfree_pool (ptr=0x7f446ecf5690) at util/fio/smalloc.c:328
#6  sfree (ptr=0x7f446ecf5690) at util/fio/smalloc.c:356
#7  0x00000000004284c7 in close_and_free_files (td=0x7f446645a770) at
util/fio/filesetup.c:1118
#8  0x000000000040b495 in thread_main (data=0x7f446645a770) at
util/fio/backend.c:1548
#9  0x0000003ffac07851 in start_thread () from /lib64/libpthread.so.0
#10 0x0000003ffa8e890d in clone () from /lib64/libc.so.6

Thread 2 (Thread 0x7f4463c41700 (LWP 5027)):
#0  0x0000003ffac0e054 in __lll_lock_wait () from /lib64/libpthread.so.0
#1  0x0000003ffac09388 in _L_lock_854 () from /lib64/libpthread.so.0
#2  0x0000003ffac09257 in pthread_mutex_lock () from /lib64/libpthread.so.0
#3  0x000000000043feda in fio_mutex_up (mutex=0x7f446f509000) at
util/fio/mutex.c:169
#4  0x00000000004284c7 in close_and_free_files (td=0x7f446645fb28) at
util/fio/filesetup.c:1118
#5  0x000000000040b495 in thread_main (data=0x7f446645fb28) at
util/fio/backend.c:1548
#6  0x0000003ffac07851 in start_thread () from /lib64/libpthread.so.0
#7  0x0000003ffa8e890d in clone () from /lib64/libc.so.6

Thread 1 (Thread 0x7f446f4fe720 (LWP 5016)):
#0  0x0000003ffa8acb8d in nanosleep () from /lib64/libc.so.6
#1  0x0000003ffa8e1d64 in usleep () from /lib64/libc.so.6
#2  0x000000000040e343 in do_usleep () at util/fio/backend.c:1727
#3  run_threads () at util/fio/backend.c:1965
#4  0x000000000040e6ed in fio_backend () at util/fio/backend.c:2068
#5  0x000000000044a1f9 in handle_run_cmd () at util/fio/server.c:567
#6  handle_command () at util/fio/server.c:763
#7  handle_connection () at util/fio/server.c:829
#8  accept_loop () at util/fio/server.c:915
#9  fio_server () at util/fio/server.c:1614
#10 0x000000000044a329 in fio_start_server (pidfile=0x268f000
"/tmp/fio.pid.4987") at util/fio/server.c:1724
#11 0x0000000000430574 in parse_cmd_line (argc=Unhandled dwarf
expression opcode 0xf3
) at util/fio/init.c:2154
#12 0x0000000000430b23 in parse_options (argc=3, argv=0x7fff62b22be8)
at util/fio/init.c:2208
#13 0x000000000042974c in main (argc=3, argv=0x7fff62b22be8,
envp=Unhandled dwarf expression opcode 0xf3
) at util/fio/fio.c:40
(

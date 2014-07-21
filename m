Return-Path: <axboe@kernel.dk>
Message-ID: <53CCCA96.7010703@kernel.dk>
Date: Mon, 21 Jul 2014 10:08:54 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: fio hangs with --status-interval
References: <CAE56cDuAUkhEnjMqCSWDcWrdwJrbffMcDG+FeCw6+7GN+jrWUg@mail.gmail.com>	<53BE5286.2060203@kernel.dk>	<CAE56cDvPKq31NrawN_KZF2+eDHiMY2A7azsx8z_DQfG1=-_cnw@mail.gmail.com>	<53BEF29E.3040500@kernel.dk>	<CAE56cDv7UmeGN=1rwyhbv7v5LfUkv+ueOoi+6KhnaXZYNx_7Fg@mail.gmail.com>	<53BFCF22.8020407@kernel.dk>	<CAE56cDtO9v3h2TkiyXQQ8dakmPiE+e-+wSazAc=XESOWA954Tg@mail.gmail.com>	<53C0F4EC.9010107@kernel.dk> <CAFTzLMPFs0E4XphF5o155GiFaae0gGqJySswXpKUPPokPWoebw@mail.gmail.com>
In-Reply-To: <CAFTzLMPFs0E4XphF5o155GiFaae0gGqJySswXpKUPPokPWoebw@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------050804010609010301020906"
To: Vasily Tarasov <tarasov@vasily.name>
Cc: Michael Mattsson <michael.mattsson@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

This is a multi-part message in MIME format.
--------------050804010609010301020906
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2014-07-16 18:58, Vasily Tarasov wrote:
> I started to observe similar behavior on one of my workloads. Also,
> with periodic statistics output and also on RHEL 6.5. Here is gdb
> output in my case:
>
>
> # ps axu | grep fio
> root      4489  0.0  0.0 322040 52816 pts/1    Sl+  08:31   0:03 fio
> --status-interval 10 --minimal fios/1.fio
> root      5547  0.0  0.0 103256   860 pts/0    S+   09:56   0:00 grep fio
>
> # cat /proc/4489/wchan
> futex_wait_queue_me
>
> # gdb
> GNU gdb (GDB) Red Hat Enterprise Linux (7.2-60.el6_4.1)
> Copyright (C) 2010 Free Software Foundation, Inc.
> License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
> This is free software: you are free to change and redistribute it.
> There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
> and "show warranty" for details.
> This GDB was configured as "x86_64-redhat-linux-gnu".
> For bug reporting instructions, please see:
> <http://www.gnu.org/software/gdb/bugs/>.
> (gdb) attach 4489
> Attaching to process 4489
> Reading symbols from /usr/local/bin/fio...done.
> Reading symbols from /usr/lib64/librdmacm.so.1...(no debugging symbols
> found)...done.
> Loaded symbols for /usr/lib64/librdmacm.so.1
> Reading symbols from /usr/lib64/libibverbs.so.1...(no debugging
> symbols found)...done.
> Loaded symbols for /usr/lib64/libibverbs.so.1
> Reading symbols from /lib64/librt.so.1...(no debugging symbols found)...done.
> Loaded symbols for /lib64/librt.so.1
> Reading symbols from /lib64/libaio.so.1...(no debugging symbols found)...done.
> Loaded symbols for /lib64/libaio.so.1
> Reading symbols from /lib64/libz.so.1...(no debugging symbols found)...done.
> Loaded symbols for /lib64/libz.so.1
> Reading symbols from /lib64/libm.so.6...(no debugging symbols found)...done.
> Loaded symbols for /lib64/libm.so.6
> Reading symbols from /lib64/libpthread.so.0...(no debugging symbols
> found)...done.
> [New LWP 4768]
> [New LWP 4491]
> [Thread debugging using libthread_db enabled]
> Loaded symbols for /lib64/libpthread.so.0
> Reading symbols from /lib64/libdl.so.2...(no debugging symbols found)...done.
> Loaded symbols for /lib64/libdl.so.2
> Reading symbols from /lib64/libc.so.6...(no debugging symbols found)...done.
> Loaded symbols for /lib64/libc.so.6
> Reading symbols from /lib64/ld-linux-x86-64.so.2...(no debugging
> symbols found)...done.
> Loaded symbols for /lib64/ld-linux-x86-64.so.2
> 0x000000376f60b5bc in pthread_cond_wait@@GLIBC_2.3.2 () from
> /lib64/libpthread.so.0
> Missing separate debuginfos, use: debuginfo-install
> glibc-2.12-1.132.el6.x86_64 libaio-0.3.107-10.el6.x86_64
> libibverbs-1.1.7-1.el6.x86_64 librdmacm-1.0.17-1.el6.x86_64
> zlib-1.2.3-29.el6.x86_64
> (gdb) bt
> #0  0x000000376f60b5bc in pthread_cond_wait@@GLIBC_2.3.2 () from
> /lib64/libpthread.so.0
> #1  0x000000000042ea39 in fio_mutex_down (mutex=0x7f08b4e9f000) at mutex.c:155
> #2  0x000000000041b680 in show_run_stats () at stat.c:1409
> #3  0x0000000000449c85 in fio_backend () at backend.c:2042
> #4  0x000000376ee1ed1d in __libc_start_main () from /lib64/libc.so.6
> #5  0x000000000040a4b9 in _start ()
> (gdb)

Are there other threads alive, would be interesting to see a backtrace 
from them. In any case, I think it'd be better to move the stat mutex 
grab to the stat thread itself. I can't reproduce this, so can you check 
if the attached patch makes a difference?

-- 
Jens Axboe


--------------050804010609010301020906
Content-Type: text/x-patch;
 name="stat.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="stat.patch"

diff --git a/stat.c b/stat.c
index 979c8100d378..d8365811b25f 100644
--- a/stat.c
+++ b/stat.c
@@ -1411,13 +1411,15 @@ void show_run_stats(void)
 	fio_mutex_up(stat_mutex);
 }
 
-static void *__show_running_run_stats(void fio_unused *arg)
+static void *__show_running_run_stats(void *arg)
 {
 	struct thread_data *td;
 	unsigned long long *rt;
 	struct timeval tv;
 	int i;
 
+	fio_mutex_down(stat_mutex);
+
 	rt = malloc(thread_number * sizeof(unsigned long long));
 	fio_gettime(&tv, NULL);
 
@@ -1458,6 +1460,7 @@ static void *__show_running_run_stats(void fio_unused *arg)
 
 	free(rt);
 	fio_mutex_up(stat_mutex);
+	free(arg);
 	return NULL;
 }
 
@@ -1468,21 +1471,23 @@ static void *__show_running_run_stats(void fio_unused *arg)
  */
 void show_running_run_stats(void)
 {
-	pthread_t thread;
+	pthread_t *thread;
 
-	fio_mutex_down(stat_mutex);
+	thread = calloc(1, sizeof(*thread));
+	if (!thread)
+		return;
 
-	if (!pthread_create(&thread, NULL, __show_running_run_stats, NULL)) {
+	if (!pthread_create(thread, NULL, __show_running_run_stats, thread)) {
 		int err;
 
-		err = pthread_detach(thread);
+		err = pthread_detach(*thread);
 		if (err)
 			log_err("fio: DU thread detach failed: %s\n", strerror(err));
 
 		return;
 	}
 
-	fio_mutex_up(stat_mutex);
+	free(thread);
 }
 
 static int status_interval_init;

--------------050804010609010301020906--


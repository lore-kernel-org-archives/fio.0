Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:58463 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286Ab2GaTNK (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 31 Jul 2012 15:13:10 -0400
Message-ID: <50182E43.5030309@kernel.dk>
Date: Tue, 31 Jul 2012 21:13:07 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Race condition in fio atexit code
References: <998AA462-26EC-421F-B005-B4B6C936A233@permabit.com> <50182CBA.4060602@kernel.dk>
In-Reply-To: <50182CBA.4060602@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Erik Lattimore <elatt@permabit.com>
Cc: fio@vger.kernel.org

On 2012-07-31 21:06, Jens Axboe wrote:
> On 2012-06-20 01:05, Erik Lattimore wrote:
>> Lately it seems like we've been hitting this more frequently, so I figured I'd file a bug.  Fio starts up a thread running the function disk_thread_main, which periodically calls update_io_ticks, which calls update_io_tick_disk on each entry in a circular linked list. The function disk_thread_main returns when the global variable "threads" is set to null, but it's only checked a couple of times in the loop.
>>
>> The main thread runs the test and exits, and has registered an atexit handler free_shm. This routine sets "threads" to null and frees up storage, including the storage where the linked list used by update_io_ticks is stored.
>>
>> Occasionally, somehow, update_io_tick_disk winds up getting called with a null pointer and crashing. The problem may be exacerbated when memory is tight. Here's the backtrace of the core dump:
>>
>> Program terminated with signal 11, Segmentation fault.
>> #0  update_io_tick_disk (du=<optimized out>) at diskutil.c:80
>> 80              if (!du->users)
>> (gdb) t apply all bt
>>
>> Thread 2 (Thread 0x7faab680b700 (LWP 23148)):
>> #0  0x00007faab58df377 in shmdt () from /lib64/libc.so.6
>> #1  0x000000000040b98d in free_shm () at init.c:231
>> #2  0x00007faab583b7f5 in __run_exit_handlers () from /lib64/libc.so.6
>> #3  0x00007faab583b845 in exit () from /lib64/libc.so.6
>> #4  0x00007faab5824c3d in __libc_start_main () from /lib64/libc.so.6
>> #5  0x0000000000408ed9 in _start ()
>>
>> Thread 1 (Thread 0x7faab32dd700 (LWP 23149)):
>> #0  update_io_tick_disk (du=<optimized out>) at diskutil.c:80
>> #1  update_io_ticks () at diskutil.c:114
>> #2  0x000000000043b303 in disk_thread_main (data=<optimized out>) at backend.c:1589
>> #3  0x00007faab61907b6 in start_thread () from /lib64/libpthread.so.0
>> #4  0x00007faab58dd9cd in clone () from /lib64/libc.so.6
>> #5  0x0000000000000000 in ?? ()
>> (gdb) q--
> 
> This is clearly a race in how the disk util thread is shut down and the
> structures freed. I'll take a look at a fix. It would be useful if you
> told me how you are hitting this most easily, as I don't recall seeing
> it. Would make me more confident in a fix.
> 
> Also, are you sure it's threads == NULL, and not the du's themselves
> being freed? They are in separate storage. It might be a good idea to
> have diskutil.c:free_disk_util() signal and wait for the disk util
> thread to shutdown before going further.

Can you reproduce with this patch?

diff --git a/backend.c b/backend.c
index e1dc0ac..03d35df 100644
--- a/backend.c
+++ b/backend.c
@@ -50,6 +50,8 @@
 #include "server.h"
 
 static pthread_t disk_util_thread;
+struct fio_mutex *disk_util_mutex;
+int disk_util_exit = 0;
 static struct fio_mutex *startup_mutex;
 static struct fio_mutex *writeout_mutex;
 static struct flist_head *cgroup_list;
@@ -1592,9 +1594,9 @@ static void *disk_thread_main(void *data)
 {
 	fio_mutex_up(startup_mutex);
 
-	while (threads) {
+	while (threads && !disk_util_exit) {
 		usleep(DISK_UTIL_MSEC * 1000);
-		if (!threads)
+		if (!threads || disk_util_exit)
 			break;
 		update_io_ticks();
 
@@ -1602,6 +1604,7 @@ static void *disk_thread_main(void *data)
 			print_thread_status();
 	}
 
+	fio_mutex_up(disk_util_mutex);
 	return NULL;
 }
 
@@ -1609,15 +1612,19 @@ static int create_disk_util_thread(void)
 {
 	int ret;
 
+	disk_util_mutex = fio_mutex_init(0);
+
 	ret = pthread_create(&disk_util_thread, NULL, disk_thread_main, NULL);
 	if (ret) {
 		log_err("Can't create disk util thread: %s\n", strerror(ret));
+		fio_mutex_remove(disk_util_mutex);
 		return 1;
 	}
 
 	ret = pthread_detach(disk_util_thread);
 	if (ret) {
 		log_err("Can't detatch disk util thread: %s\n", strerror(ret));
+		fio_mutex_remove(disk_util_mutex);
 		return 1;
 	}
 
diff --git a/diskutil.c b/diskutil.c
index feb8852..36b381f 100644
--- a/diskutil.c
+++ b/diskutil.c
@@ -521,6 +521,9 @@ void free_disk_util(void)
 {
 	struct disk_util *du;
 
+	disk_util_exit = 1;
+	fio_mutex_down(disk_util_mutex);
+
 	while (!flist_empty(&disk_list)) {
 		du = flist_entry(disk_list.next, struct disk_util, list);
 		flist_del(&du->list);
@@ -528,6 +531,7 @@ void free_disk_util(void)
 	}
 
 	last_majdev = last_mindev = -1;
+	fio_mutex_remove(disk_util_mutex);
 }
 
 void print_disk_util(struct disk_util_stat *dus, struct disk_util_agg *agg,
diff --git a/diskutil.h b/diskutil.h
index 5a9b079..c7212fa 100644
--- a/diskutil.h
+++ b/diskutil.h
@@ -3,6 +3,9 @@
 
 #define FIO_DU_NAME_SZ		64
 
+extern struct fio_mutex *disk_util_mutex;
+extern int disk_util_exit;
+
 /*
  * Disk utils as read in /sys/block/<dev>/stat
  */
@@ -106,7 +109,10 @@ extern void update_io_ticks(void);
 #else
 #define print_disk_util(dus, agg, terse)
 #define show_disk_util(terse)
-#define free_disk_util()
+static inline void free_disk_util(void)
+{
+	fio_mutex_remove(disk_util_mutex);
+}
 #define init_disk_util(td)
 #define update_io_ticks()
 #endif

-- 
Jens Axboe


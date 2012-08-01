Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:37880 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754664Ab2HAHlL (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 1 Aug 2012 03:41:11 -0400
Message-ID: <5018DD90.5040700@kernel.dk>
Date: Wed, 01 Aug 2012 09:41:04 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Race condition in fio atexit code
References: <998AA462-26EC-421F-B005-B4B6C936A233@permabit.com> <50182CBA.4060602@kernel.dk> <50182E43.5030309@kernel.dk>
In-Reply-To: <50182E43.5030309@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Erik Lattimore <elatt@permabit.com>
Cc: fio@vger.kernel.org

On 07/31/2012 09:13 PM, Jens Axboe wrote:
> On 2012-07-31 21:06, Jens Axboe wrote:
>> On 2012-06-20 01:05, Erik Lattimore wrote:
>>> Lately it seems like we've been hitting this more frequently, so I figured I'd file a bug.  Fio starts up a thread running the function disk_thread_main, which periodically calls update_io_ticks, which calls update_io_tick_disk on each entry in a circular linked list. The function disk_thread_main returns when the global variable "threads" is set to null, but it's only checked a couple of times in the loop.
>>>
>>> The main thread runs the test and exits, and has registered an atexit handler free_shm. This routine sets "threads" to null and frees up storage, including the storage where the linked list used by update_io_ticks is stored.
>>>
>>> Occasionally, somehow, update_io_tick_disk winds up getting called with a null pointer and crashing. The problem may be exacerbated when memory is tight. Here's the backtrace of the core dump:
>>>
>>> Program terminated with signal 11, Segmentation fault.
>>> #0  update_io_tick_disk (du=<optimized out>) at diskutil.c:80
>>> 80              if (!du->users)
>>> (gdb) t apply all bt
>>>
>>> Thread 2 (Thread 0x7faab680b700 (LWP 23148)):
>>> #0  0x00007faab58df377 in shmdt () from /lib64/libc.so.6
>>> #1  0x000000000040b98d in free_shm () at init.c:231
>>> #2  0x00007faab583b7f5 in __run_exit_handlers () from /lib64/libc.so.6
>>> #3  0x00007faab583b845 in exit () from /lib64/libc.so.6
>>> #4  0x00007faab5824c3d in __libc_start_main () from /lib64/libc.so.6
>>> #5  0x0000000000408ed9 in _start ()
>>>
>>> Thread 1 (Thread 0x7faab32dd700 (LWP 23149)):
>>> #0  update_io_tick_disk (du=<optimized out>) at diskutil.c:80
>>> #1  update_io_ticks () at diskutil.c:114
>>> #2  0x000000000043b303 in disk_thread_main (data=<optimized out>) at backend.c:1589
>>> #3  0x00007faab61907b6 in start_thread () from /lib64/libpthread.so.0
>>> #4  0x00007faab58dd9cd in clone () from /lib64/libc.so.6
>>> #5  0x0000000000000000 in ?? ()
>>> (gdb) q--
>>
>> This is clearly a race in how the disk util thread is shut down and the
>> structures freed. I'll take a look at a fix. It would be useful if you
>> told me how you are hitting this most easily, as I don't recall seeing
>> it. Would make me more confident in a fix.
>>
>> Also, are you sure it's threads == NULL, and not the du's themselves
>> being freed? They are in separate storage. It might be a good idea to
>> have diskutil.c:free_disk_util() signal and wait for the disk util
>> thread to shutdown before going further.
> 
> Can you reproduce with this patch?

I've checked in a different fix, doing proper locking around the du list
and ensuring that the disk util thread has exited before freeing the
structures.

http://git.kernel.dk/?p=fio.git;a=commit;h=feb418556a236aa041a625b083d6b99e55d23d74

-- 
Jens Axboe


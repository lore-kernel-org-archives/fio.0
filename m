Return-Path: <fio-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([64.244.102.31]:52267 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754638Ab0G2JGk (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 29 Jul 2010 05:06:40 -0400
Message-ID: <4C513FF6.7070006@fusionio.com>
Date: Thu, 29 Jul 2010 10:46:46 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: fio crash after running an I/O stress test for about half an  hour
References: <AANLkTimztvyqQPY3dF14awaKKQSm=RMe0Hc6J55O_CAd@mail.gmail.com>
In-Reply-To: <AANLkTimztvyqQPY3dF14awaKKQSm=RMe0Hc6J55O_CAd@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: fio@vger.kernel.org

On 07/26/2010 04:17 PM, Bart Van Assche wrote:
> Hello,
> 
> When I run the fio command below, fio triggers a segmentation fault
> after about half an hour. Is this a known issue ?

Nope.

> fio version 1.41.6 (git repository last commit date 2010-07-09).
> 
> fio --verify=md5 -rw=randwrite --size=10M --bs=4k --loops=1000000
> --iodepth=64 --group_reporting --sync=1 --direct=1 --norandommap
> --ioengine=psync --directory=/mnt --name=test --thread --numjobs=80
> 
> (gdb) bt
> #0  0x0000000000412373 in log_io_piece (td=0x7f7d83e95ec0,
> io_u=0x6f5140) at log.c:184
> #1  0x000000000041b58b in io_completed (td=0x7f7d83e95ec0,
> io_u=0x6f5140, icd=0x7f7d77e0df90) at io_u.c:1111
> #2  0x000000000041b93d in io_u_sync_complete (td=0x7f7d83e95ec0,
> io_u=0x6f5140, bytes=0x7f7d77e0e070) at io_u.c:1174
> #3  0x0000000000409ccb in do_io (td=<value optimized out>) at fio.c:651
> #4  thread_main (td=<value optimized out>) at fio.c:1132
> #5  0x00007f7d8569f65d in start_thread (arg=<value optimized out>) at
> pthread_create.c:297
> #6  0x00007f7d84baae1d in clone () from /lib64/libc.so.6
> #7  0x0000000000000000 in ?? ()
> (gdb) list
> 179     {
> 180             struct rb_node **p, *parent;
> 181             struct io_piece *ipo, *__ipo;
> 182
> 183             ipo = malloc(sizeof(struct io_piece));
> 184             ipo->file = io_u->file;
> 185             ipo->offset = io_u->offset;
> 186             ipo->len = io_u->buflen;
> 187
> 188             /*

So I'm assuming this was a NULL pointer deref, due to malloc() failing?
Fio generally doesn't do malloc checks, it's on my TODO list of things
to get done to harden it a bit more. But it should not leak memory, at
least outside of not caring to clean up init string allocs and such on
exit.

> Valgrind reports the following for a run with --loops=10 and --numjobs=1:
> 
> ==14843== 606,080 (407,040 direct, 199,040 indirect) bytes in 6,360
> blocks are definitely lost in loss record 9 of 9
> ==14843==    at 0x4C24528: malloc (vg_replace_malloc.c:236)
> ==14843==    by 0x41236A: log_io_piece (log.c:183)
> ==14843==    by 0x41B58A: io_completed (io_u.c:1111)
> ==14843==    by 0x41B93C: io_u_sync_complete (io_u.c:1174)
> ==14843==    by 0x409CCA: thread_main (fio.c:651)
> ==14843==    by 0x4E3065C: start_thread (pthread_create.c:297)
> ==14843==    by 0x597AE1C: clone (in /lib64/libc-2.10.1.so)

So that's 600k lost. I did not expect a leak there, I will take a look
and see what is up.

-- 
Jens Axboe


Confidentiality Notice: This e-mail message, its contents and any attachments to it are confidential to the intended recipient, and may contain information that is privileged and/or exempt from disclosure under applicable law. If you are not the intended recipient, please immediately notify the sender and destroy the original e-mail message and any attachments (and any copies that may have been made) from your system or otherwise. Any unauthorized use, copying, disclosure or distribution of this information is strictly prohibited.

Return-Path: <axboe@kernel.dk>
Subject: Re: [sparc64] fio bus error
References: <CADxRZqwnO-UuLgAkDb4bvqVY9hMMSnFFcdkYdPnfwfJukN09yA@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <2dffb54c-6f7d-5a3b-8b47-54cba6dd6039@kernel.dk>
Date: Mon, 22 Aug 2016 11:32:17 -0600
MIME-Version: 1.0
In-Reply-To: <CADxRZqwnO-UuLgAkDb4bvqVY9hMMSnFFcdkYdPnfwfJukN09yA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Anatoly Pugachev <matorola@gmail.com>, fio@vger.kernel.org
Cc: sparclinux@vger.kernel.org, debian-sparc <debian-sparc@lists.debian.org>
List-ID: <fio@vger.kernel.org>

On 08/20/2016 09:19 AM, Anatoly Pugachev wrote:
> Hello!
>
> I'm getting bus error on sparc64 debian sid linux with git compiled fio:
>
> mator@nvg5120:~/fio.git$ git describe
> fio-2.13-77-gd1f6fca
>
> mator@nvg5120:~/fio.git$ cat /tmp/test.fio
> [global]
> bs=8k
> iodepth=16
> iodepth_batch=8
> randrepeat=1
> size=1m
> directory=/home/mator/fio.dir
> numjobs=5
> [job1]
> ioengine=sync
> bs=1k
> direct=1
> rw=randread
> filename=file1:file2
>
>
> mator@nvg5120:~/fio.git$ gdb -q
> (gdb) file ./fio
> Reading symbols from ./fio...done.
> (gdb) set args /tmp/test.fio
> (gdb) run
> Starting program: /home/mator/fio.git/fio /tmp/test.fio
> [Thread debugging using libthread_db enabled]
> Using host libthread_db library "/lib/sparc64-linux-gnu/libthread_db.so.1".
> job1: (g=0): rw=randread, bs=1K-1K/1K-1K/1K-1K, ioengine=sync, iodepth=16
> ...
> fio-2.13-77-gd1f6f
> [New Thread 0xffff80011025b910 (LWP 15753)]
> Starting 5 processes
>
> Thread 2 "fio" received signal SIGBUS, Bus error.
> [Switching to Thread 0xffff80011025b910 (LWP 15753)]
> calc_log_samples () at stat.c:2461
> 2461                            tmp = add_bw_samples(td, &now);
> (gdb) bt
> #0  calc_log_samples () at stat.c:2461
> #1  0x000000000018e944 in helper_thread_main (data=0xffff800100ac5670)
> at helper_thread.c:121
> #2  0xffff80010063ba04 in start_thread (arg=0xffff80011025b910) at
> pthread_create.c:335
> #3  0xffff800100944f58 in __thread_start () at
> ../sysdeps/unix/sysv/linux/sparc/sparc64/clone.S:93
> Backtrace stopped: previous frame identical to this frame (corrupt stack?)
> (gdb)

Does this help?

diff --git a/stat.c b/stat.c
index 552d88dde067..74c2686c660c 100644
--- a/stat.c
+++ b/stat.c
@@ -2457,12 +2457,12 @@ int calc_log_samples(void)
  			next = min(td->o.iops_avg_time, td->o.bw_avg_time);
  			continue;
  		}
-		if (!per_unit_log(td->bw_log)) {
+		if (td->bw_log && !per_unit_log(td->bw_log)) {
  			tmp = add_bw_samples(td, &now);
  			if (tmp < next)
  				next = tmp;
  		}
-		if (!per_unit_log(td->iops_log)) {
+		if (td->iops_log && !per_unit_log(td->iops_log)) {
  			tmp = add_iops_samples(td, &now);
  			if (tmp < next)
  				next = tmp;

-- 
Jens Axboe


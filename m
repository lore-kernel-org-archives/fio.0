Return-Path: <fio-owner@vger.kernel.org>
Received: from g4t3426.houston.hp.com ([15.201.208.54]:41356 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754107AbaHKQFL (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 11 Aug 2014 12:05:11 -0400
Received: from g9t2301.houston.hp.com (g9t2301.houston.hp.com [16.216.185.78])
	by g4t3426.houston.hp.com (Postfix) with ESMTP id 09CC1BF
	for <fio@vger.kernel.org>; Mon, 11 Aug 2014 16:05:10 +0000 (UTC)
Received: from beardog.cce.hp.com (beardog.cce.hp.com [16.84.84.24])
	by g9t2301.houston.hp.com (Postfix) with ESMTP id E5D1962
	for <fio@vger.kernel.org>; Mon, 11 Aug 2014 16:05:10 +0000 (UTC)
Date: Mon, 11 Aug 2014 11:04:18 -0500
From: scameron@beardog.cce.hp.com
Subject: Re: fio main thread got stuck over the weekend
Message-ID: <20140811160418.GG7486@beardog.cce.hp.com>
References: <20140811154423.GE7486@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140811154423.GE7486@beardog.cce.hp.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: scameron@beardog.cce.hp.com

On Mon, Aug 11, 2014 at 10:44:23AM -0500, scameron@beardog.cce.hp.com wrote:
> 
> Hi,
> 
> I was running an fio job over the weekend and the main thread
> seems to have hung.  This in on RHEL6u5 with kernel
> 2.6.32-431.20.3.el6.x86_64 but with a highly modified hpsa
> driver, just in case it matters.
> 
> [root@msablackburn saperf]# uname -a
> Linux msablackburn.americas.hpqcorp.net 2.6.32-431.20.3.el6.x86_64 #1 SMP Fri Jun 6 18:30:54 EDT 2014 x86_64 x86_64 x86_64 GNU/Linux
> [root@msablackburn saperf]# /usr/local/bin/fio --version
> fio-2.1.11-3-g789d
> 
> The jobfile looks like this (note the runtime=216000, that's 60 hours)
> It seems to have hung with about 25 hours remaining.) 
> 
> [root@msablackburn saperf]# cat 2drive_sdr.fio 
> [global]
> direct=1
> ioengine=libaio
> norandommap
> randrepeat=0
> bs=4096
> iodepth=1011
> #iodepth=96
> #numjobs=1
> numjobs=12
> #numjobs=24
> # number_ios=1
> runtime=216000
> #runtime=54000
> time_based=1
> group_reporting
> thread
> gtod_reduce=1
> #iodepth_batch=4
> #iodepth_batch_complete=4
> cpus_allowed=0-5
> cpus_allowed_policy=split
> rw=randread
> 
> [4_KiB_RR_drive_r]
> filename=/dev/sdr
> 
> [4_KiB_RR_drive_s]
> filename=/dev/sds
> 
> 
> Here is all the output so far:
> 
> ---------------8<------------8<-------------8<-----------------
> [root@msablackburn saperf]# fio 2drive_sdr.fio
> 4_KiB_RR_drive_r: (g=0): rw=randread, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=1011
> ...
> 4_KiB_RR_drive_s: (g=0): rw=randread, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=1011
> ...
> fio-2.1.11-3-g789d
> Starting 24 threads
> ^Cbs: 24 (f=24): [r(24)] [1.2% done] [1113MB/0KB/0KB /s] [285K/0/0 iops] [eta 14h:48m:47s] 
> fio: terminating on signal 2
> 
> 4_KiB_RR_drive_r: (groupid=0, jobs=24): err= 0: pid=7696: Fri Aug  8 16:49:19 2014
>   read : io=881568MB, bw=1309.1MB/s, iops=335341, runt=672989msec
>   cpu          : usr=1.75%, sys=23.15%, ctx=1266117, majf=9, minf=835
>   IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%, >=64=100.0%
>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.1%
>      issued    : total=r=225681428/w=0/d=0, short=r=0/w=0/d=0
>      latency   : target=0, window=0, percentile=100.00%, depth=1011
> 
> Run status group 0 (all jobs):
>    READ: io=881568MB, aggrb=1309.1MB/s, minb=1309.1MB/s, maxb=1309.1MB/s, mint=672989msec, maxt=672989msec
> 
> Disk stats (read/write):
>   sdr: ios=112299535/0, merge=0/0, ticks=13349007/0, in_queue=13054755, util=98.57%
>   sds: ios=113359581/0, merge=0/0, ticks=13710834/0, in_queue=13414931, util=98.71%
> [root@msablackburn saperf]# vi !$
> vi 2drive_sdr.fio
> [root@msablackburn saperf]# fio 2drive_sdr.fio
> 4_KiB_RR_drive_r: (g=0): rw=randread, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=1011
> ...
> 4_KiB_RR_drive_s: (g=0): rw=randread, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=1011
> ...
> fio-2.1.11-3-g789d
> Starting 24 threads
> Jobs: 24 (f=24): [r(24)] [57.1% done] [1408MB/0KB/0KB /s] [361K/0/0 iops] [eta 01d:01h:43m:07s]
> ---------------8<------------8<-------------8<-----------------
> 
> And there it sits, the eta does not update.
> 
> 
> I tried connecting to the process with gdb, and doing "info threads" and "bt":
> 
> PID of main thread is 8530:
> 
> root      8530  598  1.0 2159116 170812 pts/0  Sl+  Aug08 23570:56 fio 2drive_sdr.fio
> 
> ...
> (gdb) info threads
>   26 Thread 0x7f65da431700 (LWP 8531)  0x0000003aa4cacced in nanosleep () from /lib64/libc.so.6
>   25 Thread 0x7f65d9a30700 (LWP 8532)  0x0000003c69800667 in io_submit () from /lib64/libaio.so.1
>   24 Thread 0x7f65d902f700 (LWP 8533)  0x0000003c69800667 in io_submit () from /lib64/libaio.so.1
>   23 Thread 0x7f65d862e700 (LWP 8534)  0x0000003c69800667 in io_submit () from /lib64/libaio.so.1
>   22 Thread 0x7f65d7c2d700 (LWP 8535)  0x0000003c69800667 in io_submit () from /lib64/libaio.so.1
>   21 Thread 0x7f65d722c700 (LWP 8536)  0x0000003c69800667 in io_submit () from /lib64/libaio.so.1
>   20 Thread 0x7f65d682b700 (LWP 8537)  0x0000003c69800667 in io_submit () from /lib64/libaio.so.1
>   19 Thread 0x7f65d5e2a700 (LWP 8538)  0x0000003c69800667 in io_submit () from /lib64/libaio.so.1
>   18 Thread 0x7f65d5429700 (LWP 8539)  0x0000003c69800667 in io_submit () from /lib64/libaio.so.1
>   17 Thread 0x7f65d4a28700 (LWP 8540)  0x0000003c69800667 in io_submit () from /lib64/libaio.so.1
>   16 Thread 0x7f65d4027700 (LWP 8541)  0x0000003c69800667 in io_submit () from /lib64/libaio.so.1
>   15 Thread 0x7f65d3626700 (LWP 8542)  0x0000003c69800667 in io_submit () from /lib64/libaio.so.1
>   14 Thread 0x7f65d2c25700 (LWP 8543)  0x0000003c69800667 in io_submit () from /lib64/libaio.so.1
>   13 Thread 0x7f65d2222700 (LWP 8544)  0x0000003c69800667 in io_submit () from /lib64/libaio.so.1
>   12 Thread 0x7f65d1820700 (LWP 8545)  0x0000003c69800667 in io_submit () from /lib64/libaio.so.1
>   11 Thread 0x7f65d0e1e700 (LWP 8546)  td_io_queue (td=0x7f65da496410, io_u=0x7f656804d010) at ioengines.c:344
>   10 Thread 0x7f65d041c700 (LWP 8547)  0x0000003c69800667 in io_submit () from /lib64/libaio.so.1
>   9 Thread 0x7f65cfa1a700 (LWP 8548)  0x0000003c69800667 in io_submit () from /lib64/libaio.so.1
>   8 Thread 0x7f65cf018700 (LWP 8549)  0x0000003c69800667 in io_submit () from /lib64/libaio.so.1
>   7 Thread 0x7f65ce616700 (LWP 8550)  0x0000003c69800667 in io_submit () from /lib64/libaio.so.1
>   6 Thread 0x7f65cdc14700 (LWP 8551)  fio_libaio_event (td=0x7f65da4b06a8, event=<value optimized out>) at engines/libaio.c:65
>   5 Thread 0x7f65cd212700 (LWP 8552)  __get_next_offset (td=0x7f65da4b5a60) at io_u.c:389
>   4 Thread 0x7f65cc810700 (LWP 8553)  0x0000003c69800667 in io_submit () from /lib64/libaio.so.1
>   3 Thread 0x7f65cbe0e700 (LWP 8554)  td_io_u_unlock (td=0x7f65da4c01d0, min_evts=<value optimized out>, bytes=0x7f65cbe0dd10) at fio.h:619
>   2 Thread 0x7f65cb40c700 (LWP 8555)  0x0000003c69800667 in io_submit () from /lib64/libaio.so.1
> * 1 Thread 0x7f65e34c6720 (LWP 8530)  0x0000003aa4cacced in nanosleep () from /lib64/libc.so.6
> (gdb) bt
> #0  0x0000003aa4cacced in nanosleep () from /lib64/libc.so.6
> #1  0x0000003aa4ce1e44 in usleep () from /lib64/libc.so.6
> #2  0x000000000044afe4 in do_usleep () at backend.c:1727
> #3  run_threads () at backend.c:1965
> #4  0x000000000044b84d in fio_backend () at backend.c:2068
> #5  0x0000003aa4c1ed1d in __libc_start_main () from /lib64/libc.so.6
> #6  0x0000000000409c39 in _start ()
> (gdb) detach
> Detaching from program: /usr/local/bin/fio, process 8530
> (gdb) quit
> [root@msablackburn saperf]# 
> 
> I am guessing the 8530 thread is the one that prints out the eta updates?
> Well, maybe not, I see a call to create_disk_util_thread() in backend.c.
> 
> i/o still seems to be running, and there are no messages in dmesg about
> hung i/o or the scsi mid layer getting angry and trying to abort things
> or anything like that.  Seems to be happily cruising along, except that
> the eta isn't updating, and the job should have finished several hours
> ago now.  I'm leaving it running for now just to try to figure out
> what happened.
> 
> Any ideas?  Anything else I should poke at?

A bit more info:

thread 26 looks to be the one that's supposed to print the eta info:

(gdb) thread 26
[Switching to thread 26 (Thread 0x7f65da431700 (LWP 8531))]#0  0x0000003aa4cacced in nanosleep () from /lib64/libc.so.6
(gdb) bt
#0  0x0000003aa4cacced in nanosleep () from /lib64/libc.so.6
#1  0x0000003aa4ce1e44 in usleep () from /lib64/libc.so.6
#2  0x00000000004474a0 in disk_thread_main (data=<value optimized out>) at backend.c:1992
#3  0x0000003aa50079d1 in start_thread () from /lib64/libpthread.so.0
#4  0x0000003aa4ce8b5d in clone () from /lib64/libc.so.6
(gdb)

static void *disk_thread_main(void *data)
{
        int ret = 0;

        fio_mutex_up(startup_mutex);

        while (threads && !ret) {
                usleep(DISK_UTIL_MSEC * 1000);
                if (!threads)
                        break;
                ret = update_io_ticks();

                if (!is_backend)
                        print_thread_status();
        }

        fio_mutex_up(disk_thread_mutex);
        return NULL;
}

that usleep() is where it's in nanosleep, I guess.

from eta.c:

void print_thread_status(void)
{
        struct jobs_eta *je;
        size_t size;

        je = get_jobs_eta(0, &size);
        if (je)
                display_thread_status(je);

        free(je);
}

Maybe that je is coming back false?  which is
probably the return value of calc_thread_status() which, well,
at a glance, I'm not sure what calc_thread_status() is doing. 

-- steve


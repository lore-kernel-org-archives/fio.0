Return-Path: <fio-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:38220 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347AbZFVKvD (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 22 Jun 2009 06:51:03 -0400
Date: Mon, 22 Jun 2009 12:51:05 +0200
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: unexpected results from simple test?
Message-ID: <20090622105104.GC31415@kernel.dk>
References: <1245667272.2704.41.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245667272.2704.41.camel@localhost.localdomain>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: fio@vger.kernel.org

On Mon, Jun 22 2009, Richard Kennedy wrote:
> I been running a hopefully simple fio test, but I don't understand the
> results.
> 
> the test :-
> 
> fio --name=f1 --directory=/sda --rw=rw --size=400m
> 	--name=f2 --directory=/sdb --rw=write --size=1g --startdelay=10
> 
> on linux 2.6.30-git
> 
> running this takes quite while, 'time fio ...' gives
> real	3m49.174s
> user	0m0.838s
> sys	0m7.990s

That does looke very odd.

> (edited highlights of the fio output)
> f1: (groupid=0, jobs=1): err= 0: pid=5181
>   read : io=200MiB, bw=23,480KiB/s, iops=5,870, runt=  8722msec
>   write: io=200MiB, bw=23,499KiB/s, iops=5,874, runt=  8715msec
> f2: (groupid=0, jobs=1): err= 0: pid=5182
>   write: io=1,024MiB, bw=77,231KiB/s, iops=19,307, runt= 13577msec
> 
> The jobs seem to finish reasonable quickly, but then fio seem to be
> stuck waiting for something. CPU usage is 100% but the CPU frequency
> stays at the lowest level and the system is really sluggish in its
> response. It does recover in time but this test does seem to torture my
> system.
> 
> strace shows fio repeating this :-
> open and read several disk stats, such as 
> 
> open("/sys/block/sdb/stat", O_RDONLY)   = 10
> fstat(10, {st_mode=S_IFREG|0444, st_size=4096, ...}) = 0
> mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7ff9ef70c000
> read(10, "   45168    22897  2239004   1505"..., 4096) = 99
> close(10)                               = 0
> munmap(0x7ff9ef70c000, 4096)            = 0
> 
> then...
> 
> gettimeofday({1245665343, 22984}, NULL) = 0
> gettimeofday({1245665343, 23015}, NULL) = 0
> ioctl(1, SNDCTL_TMR_TIMEBASE or TCGETS, {B38400 opost isig icanon echo ...}) = 0
> gettimeofday({1245665343, 23086}, NULL) = 0
> gettimeofday({1245665343, 23115}, NULL) = 0
> gettimeofday({1245665343, 23150}, NULL) = 0
> setitimer(ITIMER_REAL, {it_interval={0, 0}, it_value={0, 250000}}, NULL) = 0
> rt_sigreturn(0)                         = -1 EINTR (Interrupted system call)
> wait4(5321, 0x7fffcfed49d4, WNOHANG, NULL) = 0
> nanosleep({0, 10000000}, NULL)          = 0
> wait4(5321, 0x7fffcfed49d4, WNOHANG, NULL) = 0
> nanosleep({0, 10000000}, NULL)          = 0
> ...
> wait4(5321, 0x7fffcfed49d4, WNOHANG, NULL) = 0
> nanosleep({0, 10000000}, NULL)          = 0
> 
> then back to the open & reads..

This is normal, since it looks like you are stracing the parent process.
You'll want to inspect the two processes that are actually performing
the IO.

> The machine is a AMD X2 64bit with 3G memory & fio is 1.26.

Did you pull changes into that fio repo and not do a make clean before
compiling it? The build system is a bit broken, so it wont always
rebuild everything if eg fio.h had changes to structures. And that'll
cause weird behaviour sometimes.

In any case, please try and download a new fresh version and see if that
makes it any better.

There was also a recent linux kernel futex problem that fio triggered,
so it could also be a kernel issue. Again, knowing what the two other
jobs are doing would help.

-- 
Jens Axboe


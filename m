Return-Path: <fio-owner@vger.kernel.org>
Received: from pasmtpa.tele.dk ([80.160.77.114]:51737 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750727AbYJGJbI (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 7 Oct 2008 05:31:08 -0400
Date: Tue, 7 Oct 2008 11:30:14 +0200
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: BUG: option runtime not working during a particular failure mode.
Message-ID: <20081007093014.GT19428@kernel.dk>
References: <7a2ad2470810061504x2b973b80v3caa136d6d883dd8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7a2ad2470810061504x2b973b80v3caa136d6d883dd8@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Shawn Lewis <shawnlewis@google.com>
Cc: fio <fio@vger.kernel.org>

On Mon, Oct 06 2008, Shawn Lewis wrote:
> Hi,
> 
> I have a random read load in which fio hung on a machine. It is
> time_based with runtime=60. A few of the disks in question experienced
> errors at the same time so I would expect fio to fail or stop after
> 60- seconds.
> 
> I haven't tried to debug this in depth yet. Jens I thought an answer
> might jump out at you. If not I'll take a look.
> 
> Full disclosure: I modified the config and the strace output to show
> fewer disks then were actually being accessed.
> 
> Here is the config file:
> [sda-randomaccess]
> filename=/export/sda3/
> datafile.tmp
> rw=randread
> bs=64k
> ioengine=sync
> time_based=1
> runtime=3600
> bwavgtime=5000
> direct=1
> thread=1
> 
> [sdb-randomaccess]
> filename=/export/sdb3/datafile.tmp
> rw=randread
> bs=64k
> ioengine=sync
> time_based=1
> runtime=3600
> bwavgtime=5000
> direct=1
> thread=1
> 
> [sdc-randomaccess]
> filename=/export/sdc3/datafile.tmp
> rw=randread
> bs=64k
> ioengine=sync
> time_based=1
> runtime=3600
> bwavgtime=5000
> direct=1
> thread=1
> 
> [sdd-randomaccess]
> filename=/export/sdd3/datafile.tmp
> rw=randread
> bs=64k
> ioengine=sync
> time_based=1
> runtime=3600
> bwavgtime=5000
> direct=1
> thread=1
> 
> 
> We get some hints from strace. It looks like we're just doing the
> sig_alrm loop. But why aren't hitting runtime? Are the other threads
> stopped already for some reason?
> 
> static void sig_alrm(int sig)
> {
>         if (threads) {
>                 update_io_ticks();
>                 print_thread_status();
>                 status_timer_arm();
>         }
> }

Good question. What are the other threads doing, have you poked around
to see what they are up to? You mention IO errors, so are some of the
threads stuck in error handling or did they all exit? If they did exit,
did they exit nicely or did they get killed by the kernel?

> strace. This is repeated over and over:
> 
> --- SIGALRM (Alarm clock) @ 0 (0) ---
> open("/sys/block/sdd/stat", O_RDONLY)   = 8
> fstat(8, {st_mode=S_IFREG|0444, st_size=4096, ...}) = 0
> mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
> 0) = 0x2aaaadf29000
> read(8, "15490269   238448 1950476298  87"..., 4096) = 105
> close(8)                                = 0
> munmap(0x2aaaadf29000, 4096)            = 0
> open("/sys/block/sdc/stat", O_RDONLY)   = 8
> fstat(8, {st_mode=S_IFREG|0444, st_size=4096, ...}) = 0
> mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
> 0) = 0x2aaaadf29000
> read(8, "15489598   238450 1950388618  86"..., 4096) = 105
> close(8)                                = 0
> munmap(0x2aaaadf29000, 4096)            = 0
> open("/sys/block/sda/stat", O_RDONLY)   = 8
> fstat(8, {st_mode=S_IFREG|0444, st_size=4096, ...}) = 0
> mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
> 0) = 0x2aaaadf29000
> read(8, "15368259   237021 1934418422 103"..., 4096) = 105
> close(8)                                = 0
> munmap(0x2aaaadf29000, 4096)            = 0
> open("/sys/block/sdb/stat", O_RDONLY)   = 8
> fstat(8, {st_mode=S_IFREG|0444, st_size=4096, ...}) = 0
> mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
> 0) = 0x2aaaadf29000
> read(8, "15665652   241115 1972572554 101"..., 4096) = 105
> close(8)                                = 0
> munmap(0x2aaaadf29000, 4096)            = 0
> setitimer(ITIMER_REAL, {it_interval={0, 0}, it_value={0, 250000}}, NULL) = 0
> rt_sigreturn(0x5875e0)                  = -1 EINTR (Interrupted system call)
> nanosleep({0, 10000000}, NULL)          = 0
> nanosleep({0, 10000000}, NULL)          = 0
> nanosleep({0, 10000000}, NULL)          = 0
> nanosleep({0, 10000000}, NULL)          = 0
> nanosleep({0, 10000000}, NULL)          = 0
> nanosleep({0, 10000000}, NULL)          = 0
> nanosleep({0, 10000000}, NULL)          = 0
> nanosleep({0, 10000000}, NULL)          = 0
> nanosleep({0, 10000000}, NULL)          = 0
> nanosleep({0, 10000000}, NULL)          = 0
> nanosleep({0, 10000000}, NULL)          = 0
> nanosleep({0, 10000000}, NULL)          = 0
> nanosleep({0, 10000000}, NULL)          = 0
> nanosleep({0, 10000000}, NULL)          = 0
> nanosleep({0, 10000000}, NULL)          = 0
> nanosleep({0, 10000000}, NULL)          = 0
> nanosleep({0, 10000000}, NULL)          = 0
> nanosleep({0, 10000000}, NULL)          = 0
> nanosleep({0, 10000000}, NULL)          = 0
> nanosleep({0, 10000000}, NULL)          = 0
> nanosleep({0, 10000000}, NULL)          = 0
> nanosleep({0, 10000000}, NULL)          = 0
> nanosleep({0, 10000000}, 0)             = ? ERESTART_RESTARTBLOCK (To
> be restarted)
> 
> 
> Thanks,
> Shawn
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Jens Axboe


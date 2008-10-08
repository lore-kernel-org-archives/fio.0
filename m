Return-Path: <fio-owner@vger.kernel.org>
Received: from pasmtpa.tele.dk ([80.160.77.114]:52889 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754009AbYJHLBi (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 8 Oct 2008 07:01:38 -0400
Date: Wed, 8 Oct 2008 13:01:06 +0200
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: BUG: option runtime not working during a particular failure mode.
Message-ID: <20081008110106.GN19428@kernel.dk>
References: <7a2ad2470810061504x2b973b80v3caa136d6d883dd8@mail.gmail.com> <20081007093014.GT19428@kernel.dk> <7a2ad2470810070928v6e016700rce84c79026489b11@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7a2ad2470810070928v6e016700rce84c79026489b11@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Shawn Lewis <shawnlewis@google.com>
Cc: fio <fio@vger.kernel.org>

On Tue, Oct 07 2008, Shawn Lewis wrote:
> On Tue, Oct 7, 2008 at 2:30 AM, Jens Axboe <jens.axboe@oracle.com> wrote:
> > On Mon, Oct 06 2008, Shawn Lewis wrote:
> >> Hi,
> >>
> >> I have a random read load in which fio hung on a machine. It is
> >> time_based with runtime=60. A few of the disks in question experienced
> >> errors at the same time so I would expect fio to fail or stop after
> >> 60- seconds.
> >>
> >> I haven't tried to debug this in depth yet. Jens I thought an answer
> >> might jump out at you. If not I'll take a look.
> >>
> >> Full disclosure: I modified the config and the strace output to show
> >> fewer disks then were actually being accessed.
> >>
> >> Here is the config file:
> >> [sda-randomaccess]
> >> filename=/export/sda3/
> >> datafile.tmp
> >> rw=randread
> >> bs=64k
> >> ioengine=sync
> >> time_based=1
> >> runtime=3600
> >> bwavgtime=5000
> >> direct=1
> >> thread=1
> >>
> >> [sdb-randomaccess]
> >> filename=/export/sdb3/datafile.tmp
> >> rw=randread
> >> bs=64k
> >> ioengine=sync
> >> time_based=1
> >> runtime=3600
> >> bwavgtime=5000
> >> direct=1
> >> thread=1
> >>
> >> [sdc-randomaccess]
> >> filename=/export/sdc3/datafile.tmp
> >> rw=randread
> >> bs=64k
> >> ioengine=sync
> >> time_based=1
> >> runtime=3600
> >> bwavgtime=5000
> >> direct=1
> >> thread=1
> >>
> >> [sdd-randomaccess]
> >> filename=/export/sdd3/datafile.tmp
> >> rw=randread
> >> bs=64k
> >> ioengine=sync
> >> time_based=1
> >> runtime=3600
> >> bwavgtime=5000
> >> direct=1
> >> thread=1
> >>
> >>
> >> We get some hints from strace. It looks like we're just doing the
> >> sig_alrm loop. But why aren't hitting runtime? Are the other threads
> >> stopped already for some reason?
> >>
> >> static void sig_alrm(int sig)
> >> {
> >>         if (threads) {
> >>                 update_io_ticks();
> >>                 print_thread_status();
> >>                 status_timer_arm();
> >>         }
> >> }
> >
> > Good question. What are the other threads doing, have you poked around
> > to see what they are up to? You mention IO errors, so are some of the
> > threads stuck in error handling or did they all exit? If they did exit,
> > did they exit nicely or did they get killed by the kernel?
> There was only one thread running as far as I could tell. I don't
> think the kernel killed them.

Unless you have an oops in the kernel, they were likely not killed. What
version of fio is this? Fio used to have problems detecting missing
threads/processes, but it should be solid now.

I haven't been able to (artificially) reproduce this case. I guess, for
safety, I could add a forced exit in the sigalrm loop if we exceeded
ther untime (plus a little margin).


-- 
Jens Axboe


Return-Path: <fio-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:52687 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750889Ab0CVHsc (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 22 Mar 2010 03:48:32 -0400
Date: Mon, 22 Mar 2010 08:48:30 +0100
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: in-progress patch for forcing incremental TSC updates
Message-ID: <20100322074830.GH5768@kernel.dk>
References: <E947AD6A-030E-4625-AB78-FCA2F0CFE9FF@cs.cmu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E947AD6A-030E-4625-AB78-FCA2F0CFE9FF@cs.cmu.edu>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: David Andersen <dga@cs.cmu.edu>
Cc: fio@vger.kernel.org

On Sun, Mar 21 2010, David Andersen wrote:
> This isn't a fully integrated patch -- I apologize, but wanted to send
> it across and see if it was worth polishing further.  The rationale
> for this patch, on a single-core Atom processor with an Intel x25-m
> attached:
> 
> Mode         FIO IOPS
> normal       29337
> gtod_reduce  34186
> FORCE_TSC    32351  <- this patch

I'm curious what the number for pure tsc would look like on that atom?
Can you try that? Nevermind that the timings will be off, it would be
interesting to see a gtod() vs read tsc show down.

> vs the current git version.  The patch works by every 10ms calling a
> "real" gettime function, calculating the TSC clock rate during that
> period, and using the measured TSC clocks per microsecond to estimate
> the results for the next 10ms worth of gettime calls.
> 
> * Advantage:  Works decently even with a non-constant-rate TSC, as
> long as the frequency doesn't change too often.
> * Disadvantage:  A
> context switch at the wrong time can slightly throw off the
> calibration, resulting in incremental timestamp values that are off by
> a few microseconds.
> 
> The patch isn't fully integrated into fio - I left a hook for a
> configuration variable to enable or disable it, but didn't yet add
> that into the config parser, etc.  And I've only tested it on Linux
> with glibc.  But if this seems useful to other people, I'm happy to
> clean it up a bit further.
> 
> To use the patch, compile with -DFORCE_TSC.  Patch adds file tsc.h,
> stolen from glibc.  If the patches don't come through properly on the
> mailing list, they can be grabbed at:

Here's how I think we should proceed:

- Add per-arch hooks for reading the CPU clock, get_cpu_clock() or
  something like that. When an arch provides that, it can set
  ARCH_HAVE_CPU_CLOCK.
- Add a 'clocksource' option, which could be one of:
        - gettimeofday()
        - clock_gettime()
        - cpu
        - cpu-variable

or something like that, where 'cpu' would be the TSC on x86 and
equivalent on other platforms that have proper support for constant rate
clock ticks. cpu-variable (or some better name) would be for variable
rate TSC, which is thankfully going away.

There are other complications with using TSC, some platforms don't have
synced TSC support for multi socket systems (or even SMP). You'd need
support for that too, and even with an initial probe, you could still
risk drift over a longer run.

So on a system that has constant rate TSC and proper synced across CPU
TSC, you could use the pure 'cpu' clock. I'm not sure that variable rate
TSC or unsynced TSC is something that appeals to me, it's never going to
be perfect. And if you can't trust the timings, what good is it to do
them? May as well use gtod_reduce=1 then.

-- 
Jens Axboe


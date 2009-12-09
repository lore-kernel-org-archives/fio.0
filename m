Return-Path: <fio-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:54737 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751492AbZLIVa1 (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 9 Dec 2009 16:30:27 -0500
Date: Wed, 9 Dec 2009 22:30:34 +0100
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: rate option doesnt work with libaio engine
Message-ID: <20091209213033.GB8742@kernel.dk>
References: <66dfd3fe0912091132o7f7164d0r5af02cfe8f63f8e1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <66dfd3fe0912091132o7f7164d0r5af02cfe8f63f8e1@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Radha Ramachandran <radha@google.com>
Cc: fio@vger.kernel.org

On Wed, Dec 09 2009, Radha Ramachandran wrote:
> Hi,
> The rate option currently doesnt work when used with libaio engine.
> The math currently, calculates the time t2 (when the I/O completed) -
> t1 (when the io_u unit was created) as the time it takes for the I/O
> and the bandwidth for the rate calculation is calculated from that.
> This math will work correctly for sync engine as there is only one io
> in progress at a time, but for libaio engine, when there are multiple
> I/Os queued, the same time (as in from t1 to t2) could be attributed
> to other I/Os as well so the actual bandwidth is actually higher.
> I have a patch, but this is more brute force where I take the total
> bytes read/written divided by the time since I/Os started to calculate
> the bandwidth and decide on the time that needs to be spent sleeping
> (if any).This is a little more heavy weight than the previous math. I
> think there are probably simpler/cleaner solutions than this but this
> is the current patch I have for it.

Good analysis, yeah it definitely is broken currently, it basically
turns out to be rate*iodepth. Which is broken, of course. I have applied
your patch in lieu of a better idea. Don't worry about the bit of extra
math. I try to keep fio lean (and it is), the biggest problem is usually
the huge amounts of gettimeofday() calls when you do high iops counts.

-- 
Jens Axboe


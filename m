Return-Path: <fio-owner@vger.kernel.org>
Received: from pasmtpb.tele.dk ([80.160.77.98]:58150 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753003AbYKSNpB (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 19 Nov 2008 08:45:01 -0500
Date: Wed, 19 Nov 2008 14:43:13 +0100
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Help required to understand fio output
Message-ID: <20081119134313.GF26308@kernel.dk>
References: <4924115E.6040701@seanodes.com> <20081119131945.GD26308@kernel.dk> <492417BC.1020701@seanodes.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <492417BC.1020701@seanodes.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Erwan Velu <erwan@seanodes.com>
Cc: fio@vger.kernel.org

On Wed, Nov 19 2008, Erwan Velu wrote:
> Jens Axboe wrote:
> 
> [...]
> >The output could do with a bit of prettying up... It's explained in the
> >documentation, though, The 100=64.24% field means that 64.24% of the ios
> >completed within 50 and 99ms, as you indicate.
> >  
> I would say that [50-99]=64.24% would have been less confusing even if 
> it take more room.
> [...]

That's the primary problem, but I guess it's just to compressed for its
own good...

> >>And then, how should I understan lines 8 & 9 that reports that 100% of 
> >>IOs were completed with a depth=4... What happened ?
> >>    
> >
> >Same deal, 4 means 1-4 completions per io_getevents() call for your test
> >case. So any attempt to retrieve completed IO from the system resulted
> >in a return of 1-4 ios.
> I just don't understand what the reason of that 64 -> 4 depth reduction. 
> Is that related to the storage or the kernel capabilities ?

If you don't tell fio otherwise, it'll attempt to reclaim completed IO
as soon as it can. You can control this behaviour with the iodepth_*
options.

-- 
Jens Axboe


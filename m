Return-Path: <fio-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:58503
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754750Ab3EQKtI (ORCPT
	<rfc822;fio@vger.kernel.org>); Fri, 17 May 2013 06:49:08 -0400
Date: Fri, 17 May 2013 12:48:59 +0200
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: latency measurements when adding thinktime
Message-ID: <20130517104859.GX697@kernel.dk>
References: <OF959B9513.E7C6D2A9-ON80257B6D.00837463-80257B6E.0000140D@uk.ibm.com>
 <20130517074751.GS697@kernel.dk>
 <OFDD7AB964.9096D732-ON80257B6E.00324017-80257B6E.0033AE26@uk.ibm.com>
 <20130517102244.GV697@kernel.dk>
 <20130517104305.GW697@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130517104305.GW697@kernel.dk>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Edoardo Comar <ECOMAR@uk.ibm.com>
Cc: fio@vger.kernel.org

On Fri, May 17 2013, Jens Axboe wrote:
> On Fri, May 17 2013, Jens Axboe wrote:
> > On Fri, May 17 2013, Edoardo Comar wrote:
> > > Hi Jens,
> > > 
> > > thanks a lot, I tried your suggestion straight away: 
> > > The cpu line in the output shows that the job has not been idle at all.
> > > but even with thinktime_spin, the latency stays high at at 150ms.
> > > 
> > > Note also that if I increase thinktime & thinktime_spin by another 10000 
> > > us
> > > to a total of 20000, then the reported latency goes up another 150ms to a 
> > > total of 300ms.
> > > Could this be a bug?
> > 
> > It certainly could. Let me take a look here and see if I can reproduce
> > it.
> 
> And it was... Basically the same issue that was fixed for rate limiting.
> When going to sleep or spinning, ensure that we have all IOs flushed.
> Otherwise we could unfairly attribute the sleep towards the completion
> latencies.
> 
> Fixed here:
> 
> http://git.kernel.dk/?p=fio.git;a=commit;h=002e7183cb86d6100efef690b6fa90bf0988b084
> 
> or just git pull and you'll get the fix.

Also note this:

http://git.kernel.dk/?p=fio.git;a=commit;h=4d01ece69f7b4d7bd56210e0f839944a91c5679f

which explains how thinktime_blocks will effectively reduce iodepth=, if
the former is smaller. So if you want a larger queue depth with
thinktime being set, consider setting thinktime_blocks= to only wait
every X blocks instead. Or keep it at 1, but do realize that this then
caps your effective device queue depth to 1.

-- 
Jens Axboe


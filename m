Return-Path: <fio-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:36958
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757258Ab3BSHrh (ORCPT
	<rfc822;fio@vger.kernel.org>); Tue, 19 Feb 2013 02:47:37 -0500
Date: Tue, 19 Feb 2013 08:46:09 +0100
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Timing information between I/Os in iolog replay
Message-ID: <20130219074608.GC26519@kernel.dk>
References: <CAB-428=TxUnVOq-NaJGn35dL0nqtyGWwAH2Aajc+BFjnFn_D7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAB-428=TxUnVOq-NaJGn35dL0nqtyGWwAH2Aajc+BFjnFn_D7A@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Alireza Haghdoost <haghdoost@gmail.com>
Cc: fio@vger.kernel.org

On Tue, Feb 19 2013, Alireza Haghdoost wrote:
> Hi,
> 
> I am trying to understand how fio respect timing information between
> consecutive IOs in a read_iolog job, However the logic is not very
> clear for me , specially in the following function:
> 
> static int read_iolog2(struct thread_data *td, FILE *f)
> {
> ...
> r = sscanf(p, "%256s %256s %llu %u", fname, act, &offset,
> 									&bytes);
> ...
> 			if (!strcmp(act, "wait"))
> 				rw = DDIR_WAIT;
> ...
> 		if (rw == DDIR_WAIT) {
> 			ipo->delay = offset;
> ...
> 		queue_io_piece(td, ipo);
> }
> 
> Here is my two questions about this function:
> First, I can not see any "wait" command in a typical iolog file
> (collected with write_iolog=str job option). Should I set special
> parameter in job file to collect iolog with respect to IO timing
> information.
> Second, Why request offset assigned to ipo->delay ? I was thinking
> that ipo->delay should get some timing value which represent
> inter-submission time delay. However, In this case  ipo->delay get LBA
> offset which just a byte address in my point view.

That is the format of a delay line, instead of an LBA it has a timing
parameter. Normally you don't have delays at all, it's only for replay
and record of blktraces that would be a factor.

-- 
Jens Axboe


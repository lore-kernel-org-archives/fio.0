Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:51448 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276Ab3F0JB2 (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 27 Jun 2013 05:01:28 -0400
Date: Thu, 27 Jun 2013 11:01:23 +0200
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Generating almost-sequential traffic
Message-ID: <20130627090123.GK25599@kernel.dk>
References: <A7A1D348E34E024BBC74480FB93A2EAB039C63@DAGN05A-E6.exg6.exghost.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A7A1D348E34E024BBC74480FB93A2EAB039C63@DAGN05A-E6.exg6.exghost.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Carl Zwanzig <cpz@coraid.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On Wed, Jun 26 2013, Carl Zwanzig wrote:
> Hi,
> 
> I need to test some devices with "almost-sequential" data traffic. This would have anywhere from 10 to 50 I/Os in order then either drop one from the sequence "1 2 3 (no 4) 5 6" or transpose two adjacent ones "1 2 (4 3) 5 6". This could be done with an iolog, but that seems both wasteful (huge files, 131k lines/MB) and slow (for reading and processing the files). To properly test, I need to move something like 3-4 Tb in 8k blocks.
> 
> It's also inelegant :). 
> 
> It looks like a drop sequence can be done with something like:
> 	blocksize=64k
> 	rw=write:8k
> but I'm at a loss for how to do transposition.  Could be a hack into the get-next-block code in io_u.c, but I don't see how to actually implement that.
> 
> Any ideas (or is an iolog the best way)?

See percentage_random in the man page (or --cmdhelp=percentage_random)

-- 
Jens Axboe


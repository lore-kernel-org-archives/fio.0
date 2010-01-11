Return-Path: <fio-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:42711 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958Ab0AKNy4 (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 11 Jan 2010 08:54:56 -0500
Date: Mon, 11 Jan 2010 14:54:55 +0100
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: io scheduler merges control
Message-ID: <20100111135455.GN4489@kernel.dk>
References: <31699.35262.qm@web55002.mail.re4.yahoo.com> <1262709179.10727.36.camel@cail>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1262709179.10727.36.camel@cail>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: john smith <whalajam@yahoo.com>, fio@vger.kernel.org

On Tue, Jan 05 2010, Alan D. Brunelle wrote:
> On Mon, 2010-01-04 at 17:53 -0800, john smith wrote:
> > Alan,
> > 
> > I've tried 'echo "1"> /sys/block/<dsf>/queue/nomerges' but
> > fio/sequential-reads merges still occur and apparently they are only
> > the simple ones that can't be disabled.
> > 
> > 1) What can I change in the kernel to disable ALL the merges
> > (including the simple ones)?
> > (I tried setting iosched_cfq.ops.elevator_merge_fn,
> > elevator_merged_fn, elevator_merge_req_fn, elevator_allow_merge_fn = 0
> > but still fio reported merges)
> 
> Unfortunately, the "simple" ones were left in precisely because they
> were (a) easy to do, and (b) were expected to happen often enough to
> keep them in. Jens may be able to comment further.

Right, they are both cheap and easy so they were kept. The goal with the
nomerges switch was to save CPU, so it'll still do cheap merges. I don't
think there's a use for disabling merges completely outside of device
testing and benchmarking, it's not a real world problem. That said, I do
occasionally hack that up as well for testing purposes. Perhaps we could
tweak nomerges to accept a '2' value as well, indicating that we don't
want any merges at all.

-- 
Jens Axboe


Return-Path: <fio-owner@vger.kernel.org>
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:34817 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754570Ab0AEQoN (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 5 Jan 2010 11:44:13 -0500
Subject: Re: io scheduler merges control
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
In-Reply-To: <31699.35262.qm@web55002.mail.re4.yahoo.com>
References: <31699.35262.qm@web55002.mail.re4.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Jan 2010 11:32:59 -0500
Message-ID: <1262709179.10727.36.camel@cail>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: john smith <whalajam@yahoo.com>
Cc: fio@vger.kernel.org

On Mon, 2010-01-04 at 17:53 -0800, john smith wrote:
> Alan,
> 
> I've tried 'echo "1"> /sys/block/<dsf>/queue/nomerges' but
> fio/sequential-reads merges still occur and apparently they are only
> the simple ones that can't be disabled.
> 
> 1) What can I change in the kernel to disable ALL the merges
> (including the simple ones)?
> (I tried setting iosched_cfq.ops.elevator_merge_fn,
> elevator_merged_fn, elevator_merge_req_fn, elevator_allow_merge_fn = 0
> but still fio reported merges)

Unfortunately, the "simple" ones were left in precisely because they
were (a) easy to do, and (b) were expected to happen often enough to
keep them in. Jens may be able to comment further.

I can look back to my original patch proposal (which includes nuking all
merge attempts) - basically: look at the code that follows "normerges"
and use the same test for the one-hit caching code will probably be
sufficient.

> 
> 2) One other question I have is why one driver benefits of the io
> scheduler merges and the other doesn't? 
> (Note that HDD's don't have any other io activity - aside from fio -
> and both are doing the same 512B sequential reads)

Are the I/O sizes the same (as reported by iostat)? It could simply be
that one driver/device is performing faster than the other? Would need
to get some good stat data from both drivers/devices to see what was
going on.


> 
> 3) The third question is why the number of fio reported "merge"(s) is
> greater than the number of the "ios"?

Not sure about 'fio's output, but in general: if you have 'N' I/O
submissions and these are merged down into 'M' I/Os, then you could have
a large 'N/M' value (which should be about the number of merges done).
For example, if you are doing 512 byte read/writes and these are merged
into 512 K I/Os, you'll have 1000 merges for each I/O performed.

Regards,
Alan


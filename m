Return-Path: <fio-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:39390 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751300AbZDTGwV (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 20 Apr 2009 02:52:21 -0400
Date: Mon, 20 Apr 2009 08:52:20 +0200
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Bug in stats, KB/s vs. KiB/s?
Message-ID: <20090420065220.GS4593@kernel.dk>
References: <ed038eb20904190607l1f3dde9bi9e595f3b6bdefec6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ed038eb20904190607l1f3dde9bi9e595f3b6bdefec6@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Carl Henrik Lunde <chlunde@ping.uio.no>
Cc: fio@vger.kernel.org

On Sun, Apr 19 2009, Carl Henrik Lunde wrote:
> Hi!  I think there's a bug in the stats report:
> 
> When I specify rate=8192 I got 8388 KiB/s in the report, which happens
> to be 8192*1.024.
> 
> I believe the problem is that bytes / ms is used as KiB/s.  I'm not
> sure what the correct value of "base" should be (1000 vs. 1024), but
> it doesn't affect the result.  I haven't reviewed all the reporting,
> but at least I *think* these three are wrong.

Hmm, it actually seems like the reporting is correct, but that the rate
throttling is off by 1024/1000. So the fix is likely there somewhere,
I'll take a look.

-- 
Jens Axboe


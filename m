Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:46362 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755222Ab2I2H7r (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 29 Sep 2012 03:59:47 -0400
Message-ID: <5066AA52.7030008@kernel.dk>
Date: Sat, 29 Sep 2012 09:59:14 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Should group_reporting be clumping together different groups?
References: <CAFFT=U=WusZz8z+J93NvS8QEe=4NuDtiHHJ6_KJQ=gLAggdouA@mail.gmail.com> <50669495.1080801@kernel.dk> <CAFFT=U=BbSVnFPYP1D81397OZVNv1Zv-_h69Y1KWS=nSu+x58g@mail.gmail.com>
In-Reply-To: <CAFFT=U=BbSVnFPYP1D81397OZVNv1Zv-_h69Y1KWS=nSu+x58g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Akash Verma <akashv@google.com>
Cc: fio <fio@vger.kernel.org>

On 2012-09-29 09:32, Akash Verma wrote:
> That's odd, because I understood it differently. I have gone through
> the HOWTO again to be sure. Please bear with me; I'm copying
> succeeding lines from the HOWTO from version 2.0.9:
> 
> new_groupStart a new reporting group. If this option isn't given,
> jobs in a file will be part of the same reporting group
> unless separated by a stone wall (or if it's a group
> by itself, with the numjobs option).
> 
> numjobs=intCreate the specified number of clones of this job. May be
> used to setup a larger number of threads/processes doing
> the same thing. We regard that grouping of jobs as a
> specific group.
> 
> group_reportingIf 'numjobs' is set, it may be interesting to display
> statistics for the group as a whole instead of for each
> individual job. This is especially true of 'numjobs' is
> large, looking at individual thread/process output quickly
> becomes unwieldy. If 'group_reporting' is specified, fio
> will show the final report per-group instead of per-job.
> 
> Is it just me? Reading that, I don't see any confusion about the
> group_reporting flag being specifically for clumping together results
> that would otherwise be discrete for each job clone because of
> numjobs.
> 
> Even here, the description for new_group implies that jobs in a job
> file are in the same reporting group, unless <condition 1> and
> <condition 2>. But it seems to be the default behavior to not have
> them in the same reporting group. For example, I used the file
> included in the first email, but without numjobs and group_reporting.
> Then I get one report for each job.
> 
> In my opinion, the current functionality is fine, but the
> documentation isn't clear on it.

OK, I see what you mean wrt numjobs=. It is implied that this
constitutes a group of its own, which it doesn't. I agree that the
current behavior is fine, in fact it'd be a bother if numjobs= did imply
a new group. I'll get the documentation updated for that specific case
soon - or I'll take a patch as well, of course :-)

-- 
Jens Axboe


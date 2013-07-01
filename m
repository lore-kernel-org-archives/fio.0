Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:45460 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753753Ab3GAJ76 (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 1 Jul 2013 05:59:58 -0400
Date: Mon, 1 Jul 2013 11:59:54 +0200
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Understanding bandwidth results
Message-ID: <20130701095954.GK15088@kernel.dk>
References: <CAJLXCZSLQ_GcM=v_nn8xKY+4+bBJC5DSqX9cDf58V5Diwm5MQQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJLXCZSLQ_GcM=v_nn8xKY+4+bBJC5DSqX9cDf58V5Diwm5MQQ@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Andrew Davidoff <davidoff@qedmf.net>
Cc: fio@vger.kernel.org

On Sun, Jun 30 2013, Andrew Davidoff wrote:
> Hi,
> 
> In fio output, I see two values for bandwidth that I'd expect to be
> the same, but that are different. For example, in the results from a
> sync randread fileio test:
> 
> read : io=182811KB, bw=18279KB/s, iops=18279, runt= 10001msec
> ...
>     bw (KB  /s): min=  966, max=21410, per=99.59%, avg=18204.94, stdev=5773.57
> 
> 
> I realize they are close, but why are the values for bw= and avg= not
> the same? I want to make sure I understand if these are not actually
> reporting on the same statistic.
> 
> Also, why is per= not 100%, if this job was run with only a single
> thread in a single group?

That's just rounding and imprecise math. Should be fixed up though. It's
calculated in stat.c:show_ddir_status() and I'll be happy to take
patches :-)

-- 
Jens Axboe


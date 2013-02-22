Return-Path: <fio-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:54604
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756733Ab3BVMLh (ORCPT
	<rfc822;fio@vger.kernel.org>); Fri, 22 Feb 2013 07:11:37 -0500
Date: Fri, 22 Feb 2013 13:10:02 +0100
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Looping jobs from within the jobfile
Message-ID: <20130222121002.GV25617@kernel.dk>
References: <CANUChTyH7CxuKJMevxQpVu6d4M9bn17XUpshyjGEfsoHo6LQ9w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANUChTyH7CxuKJMevxQpVu6d4M9bn17XUpshyjGEfsoHo6LQ9w@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Gavin Martin <gavin_martin@xyratex.com>
Cc: fio@vger.kernel.org

On Fri, Feb 22 2013, Gavin Martin wrote:
> Hi,
> 
> I'm trying to understand the "loops" feature.
> 
> I have jobfile that I would like to loop round a number of times:-
> 
> {jobfile.fio}
> [global]
> ioengine=libaio
> direct=1
> 
> [job1]
> rw=randrw
> rwmixread=70
> bsrange=4k-128k
> iodepth=4
> runtime=3m
> filename=/dev/sdm
> size=4G
> time_based
> offset=0
> 
> [job2]
> stonewall
> rw=write
> bs=512K
> size=12G
> filename=/dev/sdm
> iodepth=1
> timeout=5m
> offset=20G
> {/jobfile.fio}
> 
> So above I have a random read/write section followed by a sequential
> write section.  I would like to loop round this for x number of times,
> for example randrw, seqw, randrw, seqw, randrw, etc.  I've tried using
> the "loops=x" option in the global section, but all this does is loop
> each job before moving onto the next, at the moment it does randrw,
> randrw, seqw, seqw.
> 
> Along with the above I was hoping that with the run status group
> report at the end of the run, it would give the average of each of
> those runs with the received min and max values:-
> 
> Run status group 1 (all jobs):
>   WRITE: io=8192.0MB, aggrb=56333KB/s, minb=56333KB/s, maxb=56333KB/s,
> mint=148909msec, maxt=148909msec
> 
> but at the moment the "minb" and "maxb" have the same values.  Ideally
> it would give the max and min values for each of those loops of that
> particular job, along with the average.
> 
> Is this possible from within the jobfile?

That's not currently possible. loops=x just makes fio repeat the same
job section any number of times, and all iterations are included in the
output. So job1 would run x times, then job2 would run x times, because
of the stonewall between them.

If you want separate reporting and also iterations of x{job1,job2}
instead of x{job1} then x{job2}, then it probably is easier to just
script around that and loop around the fio invocation instead.

-- 
Jens Axboe


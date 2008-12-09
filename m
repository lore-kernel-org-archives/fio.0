Return-Path: <fio-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:24653 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750949AbYLIIBc (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 9 Dec 2008 03:01:32 -0500
Date: Tue, 9 Dec 2008 09:01:19 +0100
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Inconsency between cli output and gnuplot
Message-ID: <20081209080118.GQ23742@kernel.dk>
References: <49243E53.10309@seanodes.com> <20081209074645.GP23742@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081209074645.GP23742@kernel.dk>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Erwan Velu <erwan@seanodes.com>
Cc: fio@vger.kernel.org

On Tue, Dec 09 2008, Jens Axboe wrote:
> > slat cli reports values that doesn't match at all what is viewable from 
> > gnuplot output. Averagage is said to be 16 on the cli whereas the 
> > gnuplot trace shows 20 at min.
> > Max is said to be 145 for slat but displayed at 60 on the gnuplot.
> > Slat is also said to be usec on the cli but shown as msec on the y axis 
> > of the gnuplot.
> > 
> > Complete archive showing that could be downloaded at 
> > http://konilope.linuxeries.org/tmp/localr.tar.bz2
> > 
> > It seems that units may vary from the cli output regarding the range of 
> > results. I have some case where clat is shown in usec instead of msec. 
> > Maybe that what confuse the gnuplot output.
> > Like in :
> >  write: io=32,003MiB, bw=124MiB/s, iops=1,294, runt=263681msec
> >    slat (usec): min=12, max=71, avg=15.43, stdev= 2.72
> >    clat (usec): min=663, max=1,537K, avg=49431.63, stdev=108787.82
> >    bw (KiB/s) : min=    0, max=171311, per=99.91%, avg=127152.93, 
> > stdev=21619.46
> 
> I'll take a look at this.

It's weird, must be some gnuplot oddity. The data points are definitely
there and the range of the y-axis reflects this as well, however it
seems to be missing in the output. I've tried increasing the resolution,
but it doesn't change this fact.

-- 
Jens Axboe


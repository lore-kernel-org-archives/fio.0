Return-Path: <fio-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:13148 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751987AbYLIHq7 (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 9 Dec 2008 02:46:59 -0500
Date: Tue, 9 Dec 2008 08:46:46 +0100
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Inconsency between cli output and gnuplot
Message-ID: <20081209074645.GP23742@kernel.dk>
References: <49243E53.10309@seanodes.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49243E53.10309@seanodes.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Erwan Velu <erwan@seanodes.com>
Cc: fio@vger.kernel.org

On Wed, Nov 19 2008, Erwan Velu wrote:
> My 1.23 fio ouput display :
> 
>  read : io=32,003MiB, bw=131MiB/s, iops=1,362, runt=250326msec
>    slat (usec): min=13, max=145, avg=16.69, stdev= 3.39
>    clat (msec): min=31, max=129, avg=46.94, stdev= 7.24
> 
> clat output of gnuplot reports units in msec. The clat gnuplot output 
> show a msec label on the y axis but trace some usec.

The fio_generate_plots doesn't take the usec vs msec into account, it's
basically hard wired. If someone wants to improve the script for better
reporting I'd be happy to take it, it's mainly considered an example of
how to do the reporting quickly.

> slat cli reports values that doesn't match at all what is viewable from 
> gnuplot output. Averagage is said to be 16 on the cli whereas the 
> gnuplot trace shows 20 at min.
> Max is said to be 145 for slat but displayed at 60 on the gnuplot.
> Slat is also said to be usec on the cli but shown as msec on the y axis 
> of the gnuplot.
> 
> Complete archive showing that could be downloaded at 
> http://konilope.linuxeries.org/tmp/localr.tar.bz2
> 
> It seems that units may vary from the cli output regarding the range of 
> results. I have some case where clat is shown in usec instead of msec. 
> Maybe that what confuse the gnuplot output.
> Like in :
>  write: io=32,003MiB, bw=124MiB/s, iops=1,294, runt=263681msec
>    slat (usec): min=12, max=71, avg=15.43, stdev= 2.72
>    clat (usec): min=663, max=1,537K, avg=49431.63, stdev=108787.82
>    bw (KiB/s) : min=    0, max=171311, per=99.91%, avg=127152.93, 
> stdev=21619.46

I'll take a look at this.

-- 
Jens Axboe


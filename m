Return-Path: <fio-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:59217
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750921Ab3AaOJl (ORCPT
	<rfc822;fio@vger.kernel.org>); Thu, 31 Jan 2013 09:09:41 -0500
Date: Thu, 31 Jan 2013 15:08:54 +0100
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Output logs and keep command line display
Message-ID: <20130131140854.GJ8800@kernel.dk>
References: <CANUChTxynLg7p5kK1vex9965qvYxyFagzk8QAtbh-2-=_Mdxhg@mail.gmail.com>
 <20130131140223.GI8800@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130131140223.GI8800@kernel.dk>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Gavin Martin <gavin_martin@xyratex.com>
Cc: fio@vger.kernel.org

On Thu, Jan 31 2013, Jens Axboe wrote:
> On Thu, Jan 31 2013, Gavin Martin wrote:
> > Hi,
> > 
> > Not sure if I am missing a special argument somewhere, but I like the
> > command line display we get from Fio when it runs showing the type of
> > workload and job descriptions and percentage complete, etc.  Is it
> > possible to get the outputs that you get when using the --minimal
> > argument (in JSON, CSV formats) whilst still keeping the command line
> > display.
> > 
> > Having this would make it similar to Iometer, not in a graphical
> > sense, but in a way that you can see exactly what is occurring (and if
> > it has halted or crashed) whilst still having logs that could be
> > charted or plotted into reports.  Especially useful for extended test
> > runs (over several hours!)
> 
> --eta=always
> 
> should do the trick for you, if I understand your request correctly. I
> suppose for that to be useful, you want to redirect the csv/json output
> to a file as well?
> 
> Might be useful to have the behaviour of:
> 
> --output-format=type [file]
> 
> where if 'file' is given, then output goes to that file in the specified
> format, and fio still uses stdout for the ETA output.

So we already have --output, so we don't need the extra argument to the
format option. What is missing is just the below - that will continue to
use the ETA running output to stdout, if a file was chosen for the
output of the results.

IOW, if you do:

$ fio --output-format=json --output=somefile

then fio (with the below patch) would output results to 'somefile' while
still doing the running stdout output.

That should do what you need, correct?


diff --git a/eta.c b/eta.c
index 39fe10f..cfb8679 100644
--- a/eta.c
+++ b/eta.c
@@ -285,7 +285,8 @@ int calc_thread_status(struct jobs_eta *je, int force)
 	static struct timeval rate_prev_time, disp_prev_time;
 
 	if (!force) {
-		if (output_format != FIO_OUTPUT_NORMAL)
+		if (output_format != FIO_OUTPUT_NORMAL &&
+		    f_out == stdout)
 			return 0;
 		if (temp_stall_ts || eta_print == FIO_ETA_NEVER)
 			return 0;

-- 
Jens Axboe


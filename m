Return-Path: <fio-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:59928 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752605AbZDTSF4 (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 20 Apr 2009 14:05:56 -0400
Date: Mon, 20 Apr 2009 20:05:55 +0200
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Recent changes
Message-ID: <20090420180555.GH4593@kernel.dk>
References: <20090418174812.GD4593@kernel.dk> <841550.37802.qm@web63802.mail.re1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <841550.37802.qm@web63802.mail.re1.yahoo.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Girish Satihal <girish.satihal@yahoo.com>
Cc: fio@vger.kernel.org

On Mon, Apr 20 2009, Girish Satihal wrote:
> 
> Hi Jens,
> This build is the latest build after version 1.24. This build was the
> outcome of the request for adding blockalign/ba option. Can you please
> help in resolving this issue of sequential writes on ext3 file system?

I'd love to help you, but you have to help me a bit as well. I asked you
for a job file that reproduces the problem. If you can send me such a
job file (preferably cut down to just a single section that exhibits the
problem), then I can probably find the error quickly.

> 
> Thanks,
> Girish 
> 
> 
> --- On Sat, 4/18/09, Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > From: Jens Axboe <jens.axboe@oracle.com>
> > Subject: Re: Recent changes
> > To: "Girish Satihal" <girish.satihal@yahoo.com>
> > Cc: fio@vger.kernel.org
> > Date: Saturday, April 18, 2009, 11:18 PM
> > On Fri, Apr 17 2009, Girish Satihal wrote:
> > > Hi Jens,
> > > I am seeing a serious problem with fio testing. I
> > tried running fio
> > > test on ext3 partition with Sequential Reads and
> > Writes. I keep
> > > getting the I/O write error for Sequential writes. I
> > tried with
> > > multiple servers with different controllers and I
> > still get the same
> > > error. With Sequential Reads and Random Reads/Writes
> > there is no issue
> > > seen. Please find the attached fio results file for
> > Sequential
> > > Reads/Writes which has the error details pertaining to
> > Sequential
> > > writes on ext3 file system. Thanks, Girish
> > 
> > That's pretty strange. Your test job(s) seem pretty
> > massive, you don't
> > happen to have a cut down version that exhibits the
> > problem?
> > 
> > There also seems to be parts of the error missing from
> > io_u_log_error(),
> > like the file associated with the error and the io_u
> > details (offset=
> > and buflen=, for instance).
> > 
> > What version of fio are you using?
> > 
> > -- 
> > Jens Axboe
> > 
> > --
> > To unsubscribe from this list: send the line
> > "unsubscribe fio" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at 
> > http://vger.kernel.org/majordomo-info.html
> 
> 
>       

-- 
Jens Axboe


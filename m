Return-Path: <girish.satihal@yahoo.com>
Message-ID: <841550.37802.qm@web63802.mail.re1.yahoo.com>
Date: Mon, 20 Apr 2009 07:42:05 -0700 (PDT)
From: Girish Satihal <girish.satihal@yahoo.com>
Reply-To: girish.satihal@yahoo.com
Subject: Re: Recent changes
In-Reply-To: <20090418174812.GD4593@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Jens Axboe <jens.axboe@oracle.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>


Hi Jens,
This build is the latest build after version 1.24. This build was the outcome of the request for adding blockalign/ba option. Can you please help in resolving this issue of sequential writes on ext3 file system?

Thanks,
Girish 


--- On Sat, 4/18/09, Jens Axboe <jens.axboe@oracle.com> wrote:

> From: Jens Axboe <jens.axboe@oracle.com>
> Subject: Re: Recent changes
> To: "Girish Satihal" <girish.satihal@yahoo.com>
> Cc: fio@vger.kernel.org
> Date: Saturday, April 18, 2009, 11:18 PM
> On Fri, Apr 17 2009, Girish Satihal wrote:
> > Hi Jens,
> > I am seeing a serious problem with fio testing. I
> tried running fio
> > test on ext3 partition with Sequential Reads and
> Writes. I keep
> > getting the I/O write error for Sequential writes. I
> tried with
> > multiple servers with different controllers and I
> still get the same
> > error. With Sequential Reads and Random Reads/Writes
> there is no issue
> > seen. Please find the attached fio results file for
> Sequential
> > Reads/Writes which has the error details pertaining to
> Sequential
> > writes on ext3 file system. Thanks, Girish
> 
> That's pretty strange. Your test job(s) seem pretty
> massive, you don't
> happen to have a cut down version that exhibits the
> problem?
> 
> There also seems to be parts of the error missing from
> io_u_log_error(),
> like the file associated with the error and the io_u
> details (offset=
> and buflen=, for instance).
> 
> What version of fio are you using?
> 
> -- 
> Jens Axboe
> 
> --
> To unsubscribe from this list: send the line
> "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at 
> http://vger.kernel.org/majordomo-info.html


      


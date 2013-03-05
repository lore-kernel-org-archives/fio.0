Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:35700 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756932Ab3CEU2T (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 5 Mar 2013 15:28:19 -0500
Date: Tue, 5 Mar 2013 21:28:03 +0100
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Seq Write with holes
Message-ID: <20130305202803.GV7485@kernel.dk>
References: <CANUChTxj5=ZXXkJkkRs-mFoWH7mX+DXjE+5KwYtuUFY3hvXqhw@mail.gmail.com>
 <20130304142725.GP7485@kernel.dk>
 <CANUChTzLZBa0ex7pi+UZoJ_V==NW76bfh-F+YHPmGAc5HrOhDg@mail.gmail.com>
 <20130305135710.GF7485@kernel.dk>
 <CANUChTxbdfzXWFGZTgG0Qq704PaP1dzztS5o9ApMGwPer=yanQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANUChTxbdfzXWFGZTgG0Qq704PaP1dzztS5o9ApMGwPer=yanQ@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Gavin Martin <gavin_martin@xyratex.com>
Cc: fio@vger.kernel.org

On Tue, Mar 05 2013, Gavin Martin wrote:
> On 5 March 2013 13:57, Jens Axboe <axboe@kernel.dk> wrote:
> > On Mon, Mar 04 2013, Gavin Martin wrote:
> >> On 4 March 2013 14:27, Jens Axboe <axboe@kernel.dk> wrote:
> >> > On Mon, Mar 04 2013, Gavin Martin wrote:
> >> >> Hi,
> >> >>
> >> >> I'm trying to setup a job file that tests interleaved data, so in
> >> >> theory writing 256K blocks with a gap of 256K in between, the end
> >> >> results is that I would like to write extra data into the gaps and
> >> >> make sure it is not corrupting neighbouring areas.
> >> >>
> >> >> But I'm having a problem with the first part.
> >> >>
> >> >> Here is the jobfile:-
> >> >>
> >> >> [global]
> >> >> ioengine=libaio
> >> >> direct=1
> >> >> filename=/dev/sdb
> >> >> verify=meta
> >> >> verify_backlog=1
> >> >> verify_dump=1
> >> >> verify_fatal=1
> >> >> stonewall
> >> >>
> >> >> [Job 2]
> >> >> name=SeqWrite256K
> >> >> description=Sequential Write with 1M Bands (256K)
> >> >> rw=write:1M
> >> >> bs=256K
> >> >> do_verify=0
> >> >> verify_pattern=0x33333333
> >> >> size=1G
> >> >>
> >> >> [Job 4]
> >> >> name=SeqVerify256K
> >> >> description=Sequential Read/Verify from Sequential Write (256K)
> >> >> rw=read:1M
> >> >> bs=256K
> >> >> do_verify=1
> >> >> verify_pattern=0x33333333
> >> >> size=1G
> >> >>
> >> >> There seems to be a bug (or maybe by design) when using the 'size='
> >> >> variable.  It seems to count the gaps (1M) within the size of 1G, but
> >> >> only on the write, the reads seems to report the IO transferred as 1G
> >> >>
> >> >> Here is the status of the runs:-
> >> >>
> >> >> Run status group 0 (all jobs):
> >> >>   WRITE: io=209920KB, aggrb=34039KB/s, minb=34039KB/s, maxb=34039KB/s,
> >> >> mint=6167msec, maxt=6167msec
> >> >>
> >> >> Run status group 1 (all jobs):
> >> >>    READ: io=1025.0MB, aggrb=36759KB/s, minb=36759KB/s, maxb=36759KB/s,
> >> >> mint=28553msec, maxt=28553msec
> >> >>
> >> >> And you can see the Write IO is a lot lower than the Read IO, even
> >> >> though I have asked it to cover the same disk space.
> >> >>
> >> >> It could be that this is by design and it is my jobfile that is not
> >> >> setup correctly, has anybody tried something like this before?
> >> >
> >> > They should behave identically - if they don't, then that is a bug. I
> >> > will take a look at this tomorrow.
> >> >
> >> > --
> >> > Jens Axboe
> >> >
> >> Thanks Jens,
> >>
> >> I'm not sure if interleaved is the right term, I suppose could also be
> >> called testing bands?
> >>
> >> I've just repeated using size=1% in case it was an issue with stating
> >> a GB size, but it is still the same.
> >>
> >> I was also using fio-2.0.14 so have just grabbed the latest from Git
> >> (fio-2.0.14-23-g9c63) and it exhibits the same issue.
> >
> > Does this work?
> >
> > diff --git a/libfio.c b/libfio.c
> > index ac629dc..62a0c0b 100644
> > --- a/libfio.c
> > +++ b/libfio.c
> > @@ -81,12 +81,7 @@ static void reset_io_counters(struct thread_data *td)
> >
> >         td->last_was_sync = 0;
> >         td->rwmix_issues = 0;
> > -
> > -       /*
> > -        * reset file done count if we are to start over
> > -        */
> > -       if (td->o.time_based || td->o.loops || td->o.do_verify)
> > -               td->nr_done_files = 0;
> > +       td->nr_done_files = 0;
> >  }
> >
> >  void clear_io_state(struct thread_data *td)
> >
> > --
> > Jens Axboe
> >
> Hi Jens,
> 
> Guessing I've made the change correctly and it does seem to now
> complete the requested size:
> 
> Run status group 0 (all jobs):
>   WRITE: io=1527.6MB, aggrb=19355KB/s, minb=19355KB/s, maxb=19355KB/s,
> mint=80811msec, maxt=80811msec
> 
> Run status group 1 (all jobs):
>    READ: io=1222.0MB, aggrb=1193.4GB/s, minb=1193.4GB/s,
> maxb=1193.4GB/s, mint=1msec, maxt=1msec
>   WRITE: io=1222.0MB, aggrb=3982KB/s, minb=3982KB/s, maxb=3982KB/s,
> mint=314172msec, maxt=314172msec
> 
> Run status group 2 (all jobs):
>    READ: io=1527.6MB, aggrb=143172KB/s, minb=143172KB/s,
> maxb=143172KB/s, mint=10925msec, maxt=10925msec
> 
> The two groups are 0 & 2 that should be identical (0 doing the write @
> 5% of disk, and 2 doing the read).  The above also highlights a
> question I have, in group 1 I'm doing a sequential write with
> verify_backlog set to 1 (I think called an atomic compare?), why does
> the READ aggrb=1193.4GB/s?  Is this a quirk of doing the verify on a
> write?

Are some of these groups buffered IO? It will help if you send the full
job file that you are running.

-- 
Jens Axboe


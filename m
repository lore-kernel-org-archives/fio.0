Return-Path: <Alan.Brunelle@hp.com>
Subject: Re: Large numbers of devices...
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
In-Reply-To: <20090819125147.GB12579@kernel.dk>
References: <1250530429.5341.98.camel@cail>
	 <20090819090317.GW12579@kernel.dk> <1250686030.5589.1.camel@cail>
	 <20090819125147.GB12579@kernel.dk>
Content-Type: text/plain
Date: Wed, 19 Aug 2009 18:44:24 -0400
Message-Id: <1250721864.5589.62.camel@cail>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
To: Jens Axboe <jens.axboe@oracle.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On Wed, 2009-08-19 at 14:51 +0200, Jens Axboe wrote:
> On Wed, Aug 19 2009, Alan D. Brunelle wrote:
> > On Wed, 2009-08-19 at 11:03 +0200, Jens Axboe wrote:
> > 
> > > 
> > > Alan, I haven't run with that many files, so it's indeed possible that
> > > there's an inherent limitiation in the file selection in fio. It's not
> > > my best code, that part... If you have the time and inclination to jump
> > > in there and find out what is going on, then that would be great!
> > > 
> > 
> > OK, will do - I just wanted to check that the fio job-file looked OK. 
> 
> It looks fine, in fact if that is your setup, then you are not using the
> multi file stuff. Your job files basically creates a process per device,
> which should work fine as-is.
> 
> You can try and play with the iodepth batching control, iodepth_batch
> and iodepth_batch_complete. They both default to 1, meaning that it'll
> submit and complete 1 command at the time.
> 

Setting iodepth_batch_complete to 25 (having set iodepth to 128, as
before) seems to have helped quite a bit - I just did the second half of
the test (from about 22 MSAs to 44) and the line looks much smoother to
about 36 or 37 devices and has very similar features as 'aiod' was
exhibiting around 40 devices (drop off as expected). 

With aiod we default to using about 20% of the "depth" for the min value
(iodepth_batch_complete in fio), and that seems to work quite well. In
any event, I think you're "not best code" is looking pretty good! :-)

The only other thing I saw in the code that was strange was your timeout
for the io_getevents call - it looks to be set to 0.0 seconds when
iodepth_batch_complete is set to 0 (default being 1), is this what you
really want? In aiod we set it to 10,000,000 nanoseconds (10
milliseconds), and we use that even if there is a min. 

The new tail graph can be found at : 

http://free.linux.hp.com/~adb/2009-08-17/fio-bcom=25.png

It is a little bit more noisy after 38 or 39 disks than the aiod graph -

http://free.linux.hp.com/~adb/2009-08-17/aiod.png

but nothing earth-shattering. (And I know that we're overloading the
hyperlinks at that state, so it's going to be a bumpy ride no matter
what.)

Thanks!
Alan
PS. This was run on your loop-direct branch'ed OS, so the good news is
that it's handling a lot of traffic OK. So far it's been running quite
solid. 



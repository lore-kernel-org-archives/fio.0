Return-Path: <fio-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:38357 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752474Ab0BBIxH (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 2 Feb 2010 03:53:07 -0500
Date: Tue, 2 Feb 2010 09:53:05 +0100
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Writing to /dev/null with fio
Message-ID: <20100202085305.GA13771@kernel.dk>
References: <e2e108261002012338j62fd1983x7f4a0122d3fd97a4@mail.gmail.com> <20100202074135.GX13771@kernel.dk> <e2e108261002020001sbbf4123p8c0f505858c505b5@mail.gmail.com> <20100202081941.GY13771@kernel.dk> <e2e108261002020024s7502f97eib68fd7489a50d061@mail.gmail.com> <20100202083108.GZ13771@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100202083108.GZ13771@kernel.dk>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: fio@vger.kernel.org

On Tue, Feb 02 2010, Jens Axboe wrote:
> On Tue, Feb 02 2010, Bart Van Assche wrote:
> > On Tue, Feb 2, 2010 at 9:19 AM, Jens Axboe <jens.axboe@oracle.com> wrote:
> > > On Tue, Feb 02 2010, Bart Van Assche wrote:
> > >> The reason I started running such silly tests is because I noticed
> > >> that tests with dd and a small block size complete in a shorter time
> > >> than tests with fio for a fast storage device (e.g. remote RAM disk
> > >> accessed via SRP or iSER). Do the two tests below trigger similar
> > >> system calls ? The ratio of fio time / dd time is about 1.50 for block
> > >> size 512 and about 1.15 for block size 4096.
> > >
> > > Fio definitely has more overhead than a simple read() to buf, write buf
> > > to /dev/null. If you switch off the stat calculations, it'll drop
> > > somewhat (use --gtod_reduce=1). But even then it's going to be slower
> > > than dd. Fio is modular and supports different IO engines etc, so the IO
> > > path is going to be a lot longer than with dd. The flexibility of fio
> > > does come at a cost. If you time(1) fio and dd, you'll most likely see a
> > > lot more usr time in fio.
> > >
> > > That said, it is probably time to do some profiling and make sure that
> > > fio is as fast as it can be.
> > 
> > That would definitely be appreciated. I would like to switch from dd
> > to fio for storage system benchmarking, something I can't do yet
> > because of the different results reported by the two tools.
> 
> So the first thing I noticed is that you get an lseek() because fio
> doesn't track the sequential nature of that job. How close do you get
> for bs=512 with using --gtod_reduce=1 and commenting out the lseek() in
> engines/sync.c:fio_syncio_prep()?

I committed a fix for this, it'll do it automatically now if you use
latest -git. A quick test here on my desktop machine:

fio --bs=4k --size=64G --buffered=1 --rw=write --verify=0
--name=/dev/null --gtod_reduce=1 --disk_util=0

10378MB/s

fio --bs=512 --size=8G --buffered=1 --rw=write --verify=0
--name=/dev/null --gtod_reduce=1 --disk_util=0

1306MB/s

dd if=/dev/zero of=/dev/null bs=4k count=16M
68719476736 bytes (69 GB) copied, 9,71235 s, 7,1 GB/s

dd if=/dev/zero of=/dev/null bs=512 count=8M
4294967296 bytes (4,3 GB) copied, 3,3574 s, 1,3 GB/s

So the same for 512b buffers, fio is much quicker for 64k (must be due
to proper aligning). I'll boot the big box and see what that says.

-- 
Jens Axboe


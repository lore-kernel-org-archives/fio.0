Return-Path: <fio-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:47290 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754620Ab0BBIbK (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 2 Feb 2010 03:31:10 -0500
Date: Tue, 2 Feb 2010 09:31:08 +0100
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Writing to /dev/null with fio
Message-ID: <20100202083108.GZ13771@kernel.dk>
References: <e2e108261002012338j62fd1983x7f4a0122d3fd97a4@mail.gmail.com> <20100202074135.GX13771@kernel.dk> <e2e108261002020001sbbf4123p8c0f505858c505b5@mail.gmail.com> <20100202081941.GY13771@kernel.dk> <e2e108261002020024s7502f97eib68fd7489a50d061@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e2e108261002020024s7502f97eib68fd7489a50d061@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: fio@vger.kernel.org

On Tue, Feb 02 2010, Bart Van Assche wrote:
> On Tue, Feb 2, 2010 at 9:19 AM, Jens Axboe <jens.axboe@oracle.com> wrote:
> > On Tue, Feb 02 2010, Bart Van Assche wrote:
> >> The reason I started running such silly tests is because I noticed
> >> that tests with dd and a small block size complete in a shorter time
> >> than tests with fio for a fast storage device (e.g. remote RAM disk
> >> accessed via SRP or iSER). Do the two tests below trigger similar
> >> system calls ? The ratio of fio time / dd time is about 1.50 for block
> >> size 512 and about 1.15 for block size 4096.
> >
> > Fio definitely has more overhead than a simple read() to buf, write buf
> > to /dev/null. If you switch off the stat calculations, it'll drop
> > somewhat (use --gtod_reduce=1). But even then it's going to be slower
> > than dd. Fio is modular and supports different IO engines etc, so the IO
> > path is going to be a lot longer than with dd. The flexibility of fio
> > does come at a cost. If you time(1) fio and dd, you'll most likely see a
> > lot more usr time in fio.
> >
> > That said, it is probably time to do some profiling and make sure that
> > fio is as fast as it can be.
> 
> That would definitely be appreciated. I would like to switch from dd
> to fio for storage system benchmarking, something I can't do yet
> because of the different results reported by the two tools.

So the first thing I noticed is that you get an lseek() because fio
doesn't track the sequential nature of that job. How close do you get
for bs=512 with using --gtod_reduce=1 and commenting out the lseek() in
engines/sync.c:fio_syncio_prep()?

Alternatively, using --ioengine=psync would remove that overhead as
well.

But realize that fio will never be as fast as dd completely for plain
sync and sequential IO, it's just not possible.

-- 
Jens Axboe


Return-Path: <fio-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:36597 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754897Ab0BBITn (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 2 Feb 2010 03:19:43 -0500
Date: Tue, 2 Feb 2010 09:19:41 +0100
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Writing to /dev/null with fio
Message-ID: <20100202081941.GY13771@kernel.dk>
References: <e2e108261002012338j62fd1983x7f4a0122d3fd97a4@mail.gmail.com> <20100202074135.GX13771@kernel.dk> <e2e108261002020001sbbf4123p8c0f505858c505b5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e2e108261002020001sbbf4123p8c0f505858c505b5@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: fio@vger.kernel.org

On Tue, Feb 02 2010, Bart Van Assche wrote:
> On Tue, Feb 2, 2010 at 8:41 AM, Jens Axboe <jens.axboe@oracle.com> wrote:
> > On Tue, Feb 02 2010, Bart Van Assche wrote:
> >> I noticed that writing with fio to /dev/null takes much more time (220
> >> times more for the test below) than with dd. Did I specify the correct
> >> arguments to fio ? If so, is this known behavior of fio ?
> >>
> >> $ dd if=/dev/zero of=/dev/null bs=1M count=1024
> >> 1024+0 records in
> >> 1024+0 records out
> >> 1073741824 bytes (1.1 GB) copied, 0.121485 s, 8.8 GB/s
> >>
> >> $ fio --bs=1M --size=1G --buffered=1 --rw=write --verify=0
> >> --name=dev-null /dev/null
> >
> > You are writing to a file named dev-null and /dev/null is being ignored
> > as an argument. You want a --filename=/dev/null at the end instead.
> 
> Sorry for this mistake.
> 
> The reason I started running such silly tests is because I noticed
> that tests with dd and a small block size complete in a shorter time
> than tests with fio for a fast storage device (e.g. remote RAM disk
> accessed via SRP or iSER). Do the two tests below trigger similar
> system calls ? The ratio of fio time / dd time is about 1.50 for block
> size 512 and about 1.15 for block size 4096.

Fio definitely has more overhead than a simple read() to buf, write buf
to /dev/null. If you switch off the stat calculations, it'll drop
somewhat (use --gtod_reduce=1). But even then it's going to be slower
than dd. Fio is modular and supports different IO engines etc, so the IO
path is going to be a lot longer than with dd. The flexibility of fio
does come at a cost. If you time(1) fio and dd, you'll most likely see a
lot more usr time in fio.

That said, it is probably time to do some profiling and make sure that
fio is as fast as it can be.

-- 
Jens Axboe


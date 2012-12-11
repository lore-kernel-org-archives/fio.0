Return-Path: <raeburn@permabit.com>
From: Ken Raeburn <raeburn@permabit.com>
Subject: Re: fio --direct=1 and Linux page cache effects
References: <6e624hcpo4.fsf@just-testing.permabit.com>
	<50C108E9.4050408@kernel.dk> <50C1B02F.3000902@kernel.dk>
Date: Mon, 10 Dec 2012 20:00:28 -0500
In-Reply-To: <50C1B02F.3000902@kernel.dk> (Jens Axboe's message of "Fri, 07
	Dec 2012 10:00:31 +0100")
Message-ID: <6evcc9bdxv.fsf@just-testing.permabit.com>
MIME-Version: 1.0
Content-Type: text/plain
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Jens Axboe <axboe@kernel.dk> writes:

> Another idea would be to ensure that we do the bdev cache invalidation
> at a safe point. But that is done at open time right now, which should
> invalidate any cache mappings for the device. If the file close triggers
> blkid and there are no further opens of the device, then those mappings
> would remain.
>
> Would the below work for you?

It looks like it's not enough; the BLKFLSBUF ioctl winds up happening
before blkid runs. I added some instrumentation to the patch and saw
that one thread took the "f->fd != -1" path and then, after
add_file_hash failed, came back to the "from_hash" path. But all of that
seems to finish before blkid gets going, so the pages it pulls in still
won't get invalidated.

Ken


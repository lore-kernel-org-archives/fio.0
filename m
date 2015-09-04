Return-Path: <axboe@kernel.dk>
Subject: Re: failing to flush cache
References: <6eio7rqo35.fsf@just-testing.permabit.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <55E9F0FD.3040105@kernel.dk>
Date: Fri, 4 Sep 2015 13:29:01 -0600
MIME-Version: 1.0
In-Reply-To: <6eio7rqo35.fsf@just-testing.permabit.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: Ken Raeburn <raeburn@permabit.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 09/03/2015 01:50 PM, Ken Raeburn wrote:
>
> I've hit a couple test failures where fio quickly died thusly:
>
>      fio 2.0.7
>      Starting 1 thread
>      fio: pid=6196, err=11/file:filesetup.c:404, func=invalidate_cache, error=Resource temporarily unavailable
>
> (Yeah, we're a little behind. But I think the relevant code is similar.)
>
> We're testing against Linux (RHEL 6.6) multipath block devices, and it
> appears that at the time the fio test starts, the multipath maps for
> those devices may still be in flux. I poked around a bit with systemtap,
> and it appears that while updating the maps, multipathd "suspends" its
> multipath device for a few tens of milliseconds, and the kernel
> multipath code rejects ioctl calls with EAGAIN if the device is
> suspended. It's a small window, but we've managed to hit it multiple
> times, though it's not reliably reproducible.
>
> I know the current sources treat failure here as non-fatal, but if we're
> using fio for performance tests, trying a little harder to do the
> invalidation seems like a good idea. My approach is to add a retry loop
> in __file_invalidate_cache; a patch is attached.
>
> It could also be pushed down into blockdev_invalidate_cache, where it
> could be local to the Linux (and Android?) implementation, since none of
> the others actually do anything. (They return either EAGAIN or zero,
> both of which are taken as success indicators.)

Sounds like broken behavior by the multipath code, at least unless the 
device is opened O_NONBLOCK. But the work-around is simple enough, so 
not a big deal to add that. Will commit, thanks.

-- 
Jens Axboe



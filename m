Return-Path: <richard@rsk.demon.co.uk>
Subject: Re: unexpected results from simple test?
From: Richard Kennedy <richard@rsk.demon.co.uk>
In-Reply-To: <20090622105104.GC31415@kernel.dk>
References: <1245667272.2704.41.camel@localhost.localdomain>
	 <20090622105104.GC31415@kernel.dk>
Content-Type: text/plain
Date: Mon, 22 Jun 2009 12:16:43 +0100
Message-Id: <1245669403.2704.51.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
To: Jens Axboe <jens.axboe@oracle.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On Mon, 2009-06-22 at 12:51 +0200, Jens Axboe wrote:

> 
> Did you pull changes into that fio repo and not do a make clean before
> compiling it? The build system is a bit broken, so it wont always
> rebuild everything if eg fio.h had changes to structures. And that'll
> cause weird behaviour sometimes.
> In any case, please try and download a new fresh version and see if that
> makes it any better.
> 
> There was also a recent linux kernel futex problem that fio triggered,
> so it could also be a kernel issue. Again, knowing what the two other
> jobs are doing would help.
> 

I built fio from fio-1.26.tar.gz so it was in a clean directory.
I've just downloaded the 1.28 snapshot and will try that, but I can try
the git version if you like. 

I get the status of both jobs but it get stuck at 

> Jobs: 1 (f=0): [_W] [100.0% done] [     0/     0 kb/s] [eta 00m:00s] 

I'll try 1.28 & let you know.

I haven't updated the kernel is a few days, so I can try the latest git
as well.

regards
Richard




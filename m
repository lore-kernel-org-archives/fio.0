Return-Path: <sits@sucs.org>
Date: Fri, 7 Feb 2014 03:44:42 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Mutex destruction, invalid memory accesses, leaks
Message-ID: <20140207034439.GA17588@sucs.org>
References: <20140206192135.GB3950@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140206192135.GB3950@kernel.dk>
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On Thu, Feb 06, 2014 at 12:21:35PM -0700, Jens Axboe wrote:
> 
> Similarly, if you know of bugs (particularly regressions from previous
> releases), speak up now so we can get them fixed before 2.1.5 is cut.

I think there is a problem with how mutexes are being destroyed and it's
manifesting as a reproducible segfault in libwinpthread-1.dll on
Windows. From
http://thread.gmane.org/gmane.comp.storage.fio/97/focus=136 :

> I've finally had time to reproduce this on a Windows 7 box. I use a
> different command line:
> 
> ./fio.exe --debug=all --filename=fiojob --thread --size=512 --rw=read --bs=512 --ioengine=sync --verify_pattern=0xdeadbeef --name=fiojobname
> 
> The problem appears to be that the mutex is being destroyed while it
> is still being held by a different thread. Adding return; to the first
> line of fio_mutex_remove in mutex.c papers over the problem...

This issue hasn't seen much interest since it was raised a few weeks ago
and I haven't had time to come up with a proper fix but it looks similar
to the issue described in https://lwn.net/Articles/575460/ (A surprise
with mutexes and reference counts).

Additionally Dr Memory is also flagging up an invalid memory access on
the Windows version of fio (one is in a macro which makes a for loop but
I only have a non-macro fix for it at the moment) and some memory leaks
around string_to_cpu and init_io_u.

-- 
Sitsofe | http://sucs.org/~sits/


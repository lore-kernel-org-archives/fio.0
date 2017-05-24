Return-Path: <axboe@kernel.dk>
Date: Tue, 23 May 2017 20:01:16 -0600
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 0/2] configure
Message-ID: <20170524020114.GA26621@kernel.dk>
References: <20170523184358.48088-1-tkusumi@tuxera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170523184358.48088-1-tkusumi@tuxera.com>
To: kusumi.tomohiro@gmail.com
Cc: fio@vger.kernel.org, Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

On Tue, May 23 2017, kusumi.tomohiro@gmail.com wrote:
> From: Tomohiro Kusumi <tkusumi@tuxera.com>
> 
> Regarding below, whatever I tried ended up just adding unnecessary
> complexity on runtime, so I'd like to submit two patches that weren't
> picked up in the previous series of commits for now. These two are just
> cleanups.
> 
> Printing the fs name to error messages for those that compiles but may
> fail on runtime could be good enough to make it less insane, however
> detecting the fs type from a given regular file path is another less
> trivial thing, especially if we want to do it on all supported platforms
> (I think du(1) does this).
> 
>  http://www.spinics.net/lists/fio/msg05807.html
>  >> Yes, so the next one 2/11 actually mostly reverts this, and replace it
>  >> with runtime check, so that it works not only with this specific
>  >> NetBSD/UFS case, but also for e.g. Linux fs (something other than
>  >> ext4, XFS, etc).
>  >> I wasn't sure if runtime check (execute $TMPE) is preferred.
>  >
>  >Let's just drop 1/11 then, and have the first patch cover the runtime of
>  >it. But don't do that from configure. Whatever fs is hosting configure
>  >is less interesting. Maybe that doesn't support fallocate, but whatever
>  >you end up running on does. Or vice versa.
>  >
>  >> Any how, I'll resend the 1,2,3,4,11 with --cover-letter as you commented.
>  > 
>  >Thanks!

Applied, thanks.

-- 
Jens Axboe



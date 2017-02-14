Return-Path: <axboe@kernel.dk>
Date: Tue, 14 Feb 2017 08:23:48 -0700
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v2 6/7] Acquire file ->lock while the lock itself is
 being copied
Message-ID: <20170214152348.GA32572@kernel.dk>
References: <20170214151948.16460-1-tkusumi@tuxera.com>
 <20170214151948.16460-7-tkusumi@tuxera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170214151948.16460-7-tkusumi@tuxera.com>
To: kusumi.tomohiro@gmail.com
Cc: fio@vger.kernel.org, Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

On Tue, Feb 14 2017, kusumi.tomohiro@gmail.com wrote:
> From: Tomohiro Kusumi <tkusumi@tuxera.com>
> 
> to the destination file pointer.
> The ones in dup_files() doesn't seem to require locking from
> the way it's been called.

I've been thinking about this a little bit, since I could not see what
the race was. Do you spot one, or are you just acting on the comment?
I think the original race was that we copied over the lock, lock owner,
batch, etc. Hence the race was that if someone else grabbed the lock
while we were doing that copy, the fields weren't in a consistent state.
But now we're just copying the pointer to the lock, so I don't think
there's a race. It's just a stale comment.

-- 
Jens Axboe



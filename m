Return-Path: <axboe@kernel.dk>
Date: Wed, 27 Jul 2016 08:30:21 -0600
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 01/15] Make return value type of fio_getaffinity()
 consistent
Message-ID: <20160727143021.GB26856@kernel.dk>
References: <1469626640-13335-1-git-send-email-kusumi.tomohiro@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1469626640-13335-1-git-send-email-kusumi.tomohiro@gmail.com>
To: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On Wed, Jul 27 2016, Tomohiro Kusumi wrote:
> Return type of fio_getaffinity() isn't consistent among supported OS.
> Windows and DragonFlyBSD return void while FreeBSD version is int.
> The default version for those that don't support is do{}while(0).
> 
> Linux version is a macro for sched_getaffinity(2) which returns 0
> on success and -1 otherwise, so others should basically follow that.
> 
> Note that I haven't compiled this on Windows, but it shouldn't fail.

Thanks, applied this and the rest, except for the one I commented on.

-- 
Jens Axboe



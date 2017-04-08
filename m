Return-Path: <axboe@kernel.dk>
Date: Sat, 8 Apr 2017 11:02:54 -0600
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 3/8] Add assert(0) to DDIR_DATASYNC sync path if
 fdatasync(2) is unsupported
Message-ID: <20170408170252.GA13541@kernel.dk>
References: <20170404202218.52260-1-tkusumi@tuxera.com>
 <20170404202218.52260-3-tkusumi@tuxera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170404202218.52260-3-tkusumi@tuxera.com>
To: kusumi.tomohiro@gmail.com
Cc: fio@vger.kernel.org, Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

On Tue, Apr 04 2017, kusumi.tomohiro@gmail.com wrote:
> From: Tomohiro Kusumi <tkusumi@tuxera.com>
> 
> If ddir is DDIR_DATASYNC, it means fio supports fdatasync(2), or it
> at least compiled on ./configure. If a platform without fdatasync(2)
> happens to take DDIR_DATASYNC path in do_io_u_sync(), it's simply wrong
> (because ddir should never be DDIR_DATASYNC due to td->o.fdatasync_blocks == 0)
> thus should be aborted rather than continue with EINVAL.
> 
> This commit also leaves the existing code from #else path to avoid
> compilers complain for uninitialized ret variable.

EINVAL should cause termination, I don't think there's any reason to use
assert here. In general, if we can handle even cases that we think
should not occur, then we should do so instead of dumping core.

-- 
Jens Axboe



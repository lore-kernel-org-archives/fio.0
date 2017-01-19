Return-Path: <axboe@kernel.dk>
Date: Thu, 19 Jan 2017 16:10:12 -0700
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 1/5] Rename FIO_TYPE_BD to FIO_TYPE_BLOCK
Message-ID: <20170119231012.GA27799@kernel.dk>
References: <1484761107-21387-1-git-send-email-tkusumi@tuxera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1484761107-21387-1-git-send-email-tkusumi@tuxera.com>
To: kusumi.tomohiro@gmail.com
Cc: fio@vger.kernel.org, Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

On Thu, Jan 19 2017, kusumi.tomohiro@gmail.com wrote:
> From: Tomohiro Kusumi <tkusumi@tuxera.com>
> 
> Since character device is FIO_TYPE_CHAR, BLOCK (or BLK) makes
> better sense for block device.
> 
> This may break external ioengines on compile-time, but ioengines
> usually don't refer to file type which are regfile/blk/chr/pipe
> (which I believe makes sense to commit this change as there's
> been changes that break not only api but also abi).

Thanks, applied 1-5.

-- 
Jens Axboe



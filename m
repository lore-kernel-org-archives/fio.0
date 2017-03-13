Return-Path: <axboe@kernel.dk>
Date: Mon, 13 Mar 2017 12:27:52 -0600
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 1/7] Make check_mount_writes() test appropriate device
 types
Message-ID: <20170313182752.GC23256@kernel.dk>
References: <20170313181503.33322-1-tkusumi@tuxera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170313181503.33322-1-tkusumi@tuxera.com>
To: kusumi.tomohiro@gmail.com
Cc: fio@vger.kernel.org, Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

On Mon, Mar 13 2017, kusumi.tomohiro@gmail.com wrote:
> From: Tomohiro Kusumi <tkusumi@tuxera.com>
> 
> There are platforms that use chrdev (instead of blkdev) for block
> devices, thus check_mount_writes() needs to test an appropriate file
> type(s) for potential mounted devices.
> 
> fio has had a macro FIO_HAVE_CHARDEV_SIZE basically for those using
> chrdev for block devices, and this macro can be used here as well.
> 
> In FreeBSD and several others, blkdev is no longer used as a file type,
> so it's safe to only test FIO_TYPE_CHAR if FIO_HAVE_CHARDEV_SIZE is
> defined, but this commit leaves FIO_TYPE_BLOCK test since some
> platforms may have/use both for block devices (not sure if exist).

Applied this, and 2-6. Please resend 7/7 with a better commit log.

-- 
Jens Axboe



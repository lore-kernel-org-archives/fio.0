Return-Path: <axboe@kernel.dk>
Date: Tue, 29 Aug 2017 15:15:12 -0600
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 0/6] OS specific fixes
Message-ID: <20170829211511.GA20219@kernel.dk>
References: <20170829211216.42347-1-tkusumi@tuxera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170829211216.42347-1-tkusumi@tuxera.com>
To: kusumi.tomohiro@gmail.com
Cc: fio@vger.kernel.org, Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

On Wed, Aug 30 2017, kusumi.tomohiro@gmail.com wrote:
> From: Tomohiro Kusumi <tkusumi@tuxera.com>
> 
> 
> Tomohiro Kusumi (6):
>   cleanup NetBSD/OpenBSD header
>   HOWTO: add OpenBSD to direct I/O unsupported platform
>   add ifdef __sun__ for Solaris specific code
>   filesetup: add non O_DIRECT direct I/O support for initial layout
>     setup
>   change fio_set_odirect() prototype not to use int fd
>   change os_trim() prototype not to use int fd

Looks good, applied.

-- 
Jens Axboe



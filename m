Return-Path: <axboe@kernel.dk>
Date: Fri, 23 Jun 2017 16:20:15 -0600
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 0/8] option/Makefile fix and void* fixups
Message-ID: <20170623222014.GA8968@kernel.dk>
References: <20170623220801.38178-1-tkusumi@tuxera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170623220801.38178-1-tkusumi@tuxera.com>
To: kusumi.tomohiro@gmail.com
Cc: fio@vger.kernel.org, Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

On Sat, Jun 24 2017, kusumi.tomohiro@gmail.com wrote:
> From: Tomohiro Kusumi <tkusumi@tuxera.com>
> 
> 3/8 to 8/8 are the continuation of void* fixups from below,
> but this time in non-ioengine code.
> This is it and no more of this void* patches...
> 
> http://www.spinics.net/lists/fio/msg05912.html
> >   sg: don't use void* for pointer arithmetic (gcc)
> >   splice: don't use void* for pointer arithmetic (gcc)
> >   binject: don't use void* for pointer arithmetic (gcc)
> 
> Tomohiro Kusumi (8):
>   ignore directory= if the given path is absolute
>   Makefile: use fmt(1) rather than tr(1) on NetBSD/etc
>   server: don't use void* for pointer arithmetic (gcc)
>   io_u: don't use void* for pointer arithmetic (gcc)
>   init: don't use void* for pointer arithmetic (gcc)
>   client: don't use void* for pointer arithmetic (gcc)
>   verify: don't use void* for pointer arithmetic (gcc)
>   smalloc: don't use void* for pointer arithmetic (gcc)

Applied 2-8, thanks.

-- 
Jens Axboe



Return-Path: <axboe@kernel.dk>
Date: Fri, 3 Nov 2017 10:48:54 -0600
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 0/3] Solaris related patches
Message-ID: <20171103164853.GA11375@kernel.dk>
References: <20171103164603.31819-1-tkusumi@tuxera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171103164603.31819-1-tkusumi@tuxera.com>
To: kusumi.tomohiro@gmail.com
Cc: fio@vger.kernel.org, Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

On Fri, Nov 03 2017, kusumi.tomohiro@gmail.com wrote:
> From: Tomohiro Kusumi <tkusumi@tuxera.com>
> 
> Add missing ones in Solaris header.
> Compiled and tested on illumos.
> 
> Tomohiro Kusumi (3):
>   solaris: #include <pthread.h>
>   solaris: add os_phys_mem() implementation
>   solaris: add get_fs_free_size() implementation

Looks good, applied, thanks.

-- 
Jens Axboe



Return-Path: <axboe@kernel.dk>
Date: Tue, 14 Feb 2017 08:25:00 -0700
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v2 0/7]
Message-ID: <20170214152500.GB32572@kernel.dk>
References: <20170214151948.16460-1-tkusumi@tuxera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170214151948.16460-1-tkusumi@tuxera.com>
To: kusumi.tomohiro@gmail.com
Cc: fio@vger.kernel.org, Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

On Tue, Feb 14 2017, kusumi.tomohiro@gmail.com wrote:
> From: Tomohiro Kusumi <tkusumi@tuxera.com>
> 
> configure: Use x86 instead of i386 for $cpu for IA32
>   Added "This change should have been a part of e12f4ede in 2016.".
> 
> Acquire file ->lock while the lock itself is being copied
>   Rewrote the locking using (un)lock_file().
> 
> Tomohiro Kusumi (7):
>   configure: Drop default CONFIG_LITTLE_ENDIAN for Cygwin
>   configure: Use x86 instead of i386 for $cpu for IA32
>   Drop conditional declaration of disk_list
>   Always set ->real_file_size to -1 when failed to get file size
>   Add missing "rand"/"trimwrite" strings to corresponding ddir slots
>   Acquire file ->lock while the lock itself is being copied
>   Use 0 instead of DDIR_READ to iterate from 0 to DDIR_RWDIR_CNT

Applied 1-5, and 7. I don't think we need 6, but I emailed on that
separately. Thanks!

-- 
Jens Axboe



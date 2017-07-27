Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] don't print native_fallocate() error if ENOSYS
References: <20170727203837.97569-1-tkusumi@tuxera.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <507e8c4a-5611-0eb7-f0b0-8f8a5a0702c9@kernel.dk>
Date: Thu, 27 Jul 2017 14:44:10 -0600
MIME-Version: 1.0
In-Reply-To: <20170727203837.97569-1-tkusumi@tuxera.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: kusumi.tomohiro@gmail.com, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

On 07/27/2017 02:38 PM, kusumi.tomohiro@gmail.com wrote:
> From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
> 
> log_err(ENOSYS) on native_fallocate() failure which was newly added
> by 2c3e17be('filesetup: add native fallocate') should be silenced
> or somehow be printed only once instead of being a per file message.
> 
> This happens on a platform like FreeBSD where posix_fallocate(3)
> exists, but native_fallocate() is ENOSYS.
> 
> This commit just silences it if errno is set to ENOSYS on return.
> "native" is the default mode, thus not printing ENOSYS won't be any
> confusing unless fallocate=native is explicitly specified, and
> native_fallocate() has dprint() for ENOSYS case anyway.

I think that's the right fix, ENOSYS is expected for some setups,
so it need not be a visible error.

-- 
Jens Axboe



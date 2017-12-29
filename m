Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] lib/memcpy: fix warning on FreeBSD
References: <20171229133823.13295-1-tkusumi@tuxera.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <856cdf4c-b39a-c7fa-d9f0-fc7a38780ccd@kernel.dk>
Date: Fri, 29 Dec 2017 08:13:22 -0700
MIME-Version: 1.0
In-Reply-To: <20171229133823.13295-1-tkusumi@tuxera.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: kusumi.tomohiro@gmail.com, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

On 12/29/17 6:38 AM, kusumi.tomohiro@gmail.com wrote:
> From: Tomohiro Kusumi <tkusumi@tuxera.com>
> 
> Include struct timeval via sys/time.h.
> http://pubs.opengroup.org/onlinepubs/009604499/basedefs/sys/time.h.html
> 
> --
> In file included from lib/memcpy.c:7:
> lib/../fio_time.h:14:45: warning: declaration of 'struct timeval' will not be visible outside of this function [-Wvisibility]
> extern uint64_t mtime_since_tv(const struct timeval *, const struct timeval *);

Applied, thanks.

-- 
Jens Axboe



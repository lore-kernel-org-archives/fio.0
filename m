Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH 0/6] ioengine fixes
References: <20170612200211.17022-1-tkusumi@tuxera.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <30421d85-521c-21d9-25a5-6e308b1f58af@kernel.dk>
Date: Mon, 12 Jun 2017 14:51:48 -0600
MIME-Version: 1.0
In-Reply-To: <20170612200211.17022-1-tkusumi@tuxera.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: kusumi.tomohiro@gmail.com, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

On 06/12/2017 02:02 PM, kusumi.tomohiro@gmail.com wrote:
> From: Tomohiro Kusumi <tkusumi@tuxera.com>
> 
> 
> Tomohiro Kusumi (6):
>   sg: add missing free(msg); in ->errdetails() handler
>   sg: drop unneeded strdup from ->errdetails() handler
>   sg: drop redundant void* cast
>   sg: don't use void* for pointer arithmetic (gcc)
>   splice: don't use void* for pointer arithmetic (gcc)
>   binject: don't use void* for pointer arithmetic (gcc)

Thanks, applied. Patch 1+2 could have been squashed, but not a big deal.

-- 
Jens Axboe



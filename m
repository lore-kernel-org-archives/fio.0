Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH 0/3] null ioengine fix
References: <20180115195212.1349-1-tkusumi@tuxera.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <b5ef1970-93c2-bb4b-5423-bf4546e25273@kernel.dk>
Date: Tue, 16 Jan 2018 08:33:03 -0700
MIME-Version: 1.0
In-Reply-To: <20180115195212.1349-1-tkusumi@tuxera.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: kusumi.tomohiro@gmail.com, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

On 1/15/18 12:52 PM, kusumi.tomohiro@gmail.com wrote:
> From: Tomohiro Kusumi <tkusumi@tuxera.com>
> 
> Resending these as I forgot to add signed-off-by, sorry.
> 
> Tomohiro Kusumi (3):
>   null: fix compile time warning on OpenBSD
>   null: make *impl_ private
>   null: drop unneeded casts from void* to non-void*

Thanks, applied.

-- 
Jens Axboe



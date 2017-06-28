Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH 0/2] updates for offset= in percentage
References: <20170628142106.31846-1-tkusumi@tuxera.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <522c7810-0de0-f152-b1e3-bf6462bb9f93@kernel.dk>
Date: Wed, 28 Jun 2017 08:31:05 -0600
MIME-Version: 1.0
In-Reply-To: <20170628142106.31846-1-tkusumi@tuxera.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: kusumi.tomohiro@gmail.com, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

On 06/28/2017 08:21 AM, kusumi.tomohiro@gmail.com wrote:
> From: Tomohiro Kusumi <tkusumi@tuxera.com>
> 
> due to the fact that str_to_decimal() supports conversion from
> '%' format to low-level format.
> 
> Tomohiro Kusumi (2):
>   HOWTO/manpage: update percentage explanation using '%'
>   add FD_PARSE debug print for size= option (which exists in offset=)

Applied, thanks.

-- 
Jens Axboe



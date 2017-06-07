Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH 0/5] fixes for ignore_error option
References: <20170607201849.9448-1-tkusumi@tuxera.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <0bb48600-d17f-8c09-cc69-6e85f721a063@kernel.dk>
Date: Wed, 7 Jun 2017 14:24:26 -0600
MIME-Version: 1.0
In-Reply-To: <20170607201849.9448-1-tkusumi@tuxera.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: kusumi.tomohiro@gmail.com, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

On 06/07/2017 02:18 PM, kusumi.tomohiro@gmail.com wrote:
> From: Tomohiro Kusumi <tkusumi@tuxera.com>
> 
> 
> Tomohiro Kusumi (5):
>   fix wrong malloc size for ignore_error buffer
>   don't leave ignore_error_nr[etype] with 4 on blank input or error
>   use enum error_type_bit for ignore_error index
>   use ARRAY_SIZE() for ignore_error_nr[etype]
>   HOWTO: mention some details of ignore_error= option

Looks good, applied all 5, thanks.

-- 
Jens Axboe



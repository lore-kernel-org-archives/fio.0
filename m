Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] zbd: fixup ->zone_size_log2 if zone size is not power of
 2
References: <20200406195610.GA3255@avx2>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <16f9b448-8ec2-c5b8-dbf9-dd796e823d8d@kernel.dk>
Date: Mon, 6 Apr 2020 18:41:59 -0700
MIME-Version: 1.0
In-Reply-To: <20200406195610.GA3255@avx2>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: fio@vger.kernel.org, damien.lemoal@wdc.com
List-ID: <fio@vger.kernel.org>

On 4/6/20 12:56 PM, Alexey Dobriyan wrote:
> Code like this doesn't work if log2 is 0xffffffff.
> 
> 	if (f->zbd_info->zone_size_log2 > 0)
>                 zone_idx = offset >> f->zbd_info->zone_size_log2;
>         else
>                 zone_idx = offset / f->zbd_info->zone_size;
> 
> Other than that everything else works!

Applied, thanks.

-- 
Jens Axboe



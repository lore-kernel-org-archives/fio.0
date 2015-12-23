Return-Path: <axboe@kernel.dk>
Subject: Re: Fix runtime of terse output
References: <64F25A0F43FA9948AF74033DC846D09D6B730876@TGXML313.toshiba.local>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <567AC5BD.8060600@kernel.dk>
Date: Wed, 23 Dec 2015 09:03:09 -0700
MIME-Version: 1.0
In-Reply-To: <64F25A0F43FA9948AF74033DC846D09D6B730876@TGXML313.toshiba.local>
Content-Type: text/plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
To: shoichi.sawada@toshiba.co.jp, fio@vger.kernel.org
Cc: yoshihiro7.tsuchiya@toshiba.co.jp
List-ID: <fio@vger.kernel.org>

On 12/22/2015 01:16 AM, shoichi.sawada@toshiba.co.jp wrote:
> Hi,
> 
> When I used fio with option of '--status-interval=1 --minimal' and 'random_distribution=zipf:1.2',
> 'runtime' of 2nd line was 18446744073709551345.
> This value is -271 in int_64.
> 
> This is because 'runtime' was subtracted in function '__show_running_run_stats'.
> If 'td->io_bytes' is 0 when this function was called,
> and 'td->io_bytes' is not 0 when '__show_run_stats' returned,
> 'runtime' is subtracted by 'rt' even though 'runtime' have not added.
> 
> I fixed the problem by applying this patch to fio-2.2.13.

Thanks, applied.

-- 
Jens Axboe



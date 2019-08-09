Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] t/zbd: Fix I/O bytes rounding errors
References: <20190809032836.10163-1-shinichiro.kawasaki@wdc.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <d394655f-e02a-df7e-4ac0-a5b480a1b3bd@kernel.dk>
Date: Thu, 8 Aug 2019 20:36:48 -0700
MIME-Version: 1.0
In-Reply-To: <20190809032836.10163-1-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>, fio@vger.kernel.org
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>
List-ID: <fio@vger.kernel.org>

On 8/8/19 8:28 PM, Shin'ichiro Kawasaki wrote:
> When fio reports write bytes or read bytes, it rounds the number with
> units MiB or KiB to fit the number within limited number of digits.
> This results in rounding errors of the reported bytes and sometimes
> causes test failures for test case #17 in test-zbd-support
> which reports incorrect total I/O bytes in case both of write bytes
> and read bytes are rounded up.
> 
> To avoid the rounding error, increase the number of digits from default
> value 4 to 10 to keep precision. For example, a number "256MiB" will be
> reported as "267911168B" with this change.

Thanks, applied.

-- 
Jens Axboe



Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH v3 0/3] t/zbd: Fix max_open_zones related failures
References: <20210604113252.765970-1-shinichiro.kawasaki@wdc.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <e098b7b2-44fa-4b2d-0e95-998e014cbada@kernel.dk>
Date: Tue, 8 Jun 2021 15:16:15 -0600
MIME-Version: 1.0
In-Reply-To: <20210604113252.765970-1-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>, fio@vger.kernel.org
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Dmitry Fomichev <Dmitry.Fomichev@wdc.com>, Niklas Cassel <niklas.cassel@wdc.com>
List-ID: <fio@vger.kernel.org>

On 6/4/21 5:32 AM, Shin'ichiro Kawasaki wrote:
> Recent changes in fio [1] triggered three failures in the test script
> t/zbd/test-zoned-support. This series address the failures.
> 
> The first failure was caused by difference between max_open_zones value that fio
> refers and that test script refers. The first patch modifies the test script to
> use the value fio refers.
> 
> The second failure was observed when users specify special max_open_zones values
> larger than the max_open_zones limit of the test target device. The second patch
> adds --ignore_zone_limits option to the fio command only when users specify such
> special conditions.
> 
> The third failure was caused by write target zone count bug in the test case 31.
> Data write to more zones than max_open_zones limit resulted in exceeding
> max_open_zones limit. The third patch fixes the write target zone count logic.
> 
> [1] https://www.spinics.net/lists/fio/msg09502.html

Applied, thanks.

-- 
Jens Axboe



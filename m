Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH v2 0/2] zbd: Fix test case #48 failure
References: <20201030065740.2039936-1-shinichiro.kawasaki@wdc.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <9ad2aaaa-2109-e6c1-e22c-87c542717317@kernel.dk>
Date: Fri, 30 Oct 2020 07:25:12 -0600
MIME-Version: 1.0
In-Reply-To: <20201030065740.2039936-1-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>, fio@vger.kernel.org
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Dmitry Fomichev <Dmitry.Fomichev@wdc.com>, Naohiro Aota <Naohiro.Aota@wdc.com>
List-ID: <fio@vger.kernel.org>

On 10/30/20 12:57 AM, Shin'ichiro Kawasaki wrote:
> When t/zbd/test-zoned-support is run for zoned block devices with slow zone
> reset command operation, test case #48 fails. This series addresses the failure
> with two fixes. First patch avoids excessive and repeated zone resets which
> resulted in too long runtime and test timeout. Second patch fixes wrong test
> target range of the test case which triggered unnecessary zone resets.

Applied, thanks.

-- 
Jens Axboe



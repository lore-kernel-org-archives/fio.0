Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH v4 0/2] zbd: fix zone reset for file reset during
 asynchronous IOs
References: <20210412070225.192504-1-shinichiro.kawasaki@wdc.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <cc2b71c1-e754-eb03-d2be-e1117d50d9b2@kernel.dk>
Date: Mon, 12 Apr 2021 06:56:41 -0600
MIME-Version: 1.0
In-Reply-To: <20210412070225.192504-1-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>, fio@vger.kernel.org
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

On 4/12/21 1:02 AM, Shin'ichiro Kawasaki wrote:
> Hi Jens, could you consider to merge this series to upstream?
> 
> Repeated random write jobs with block size unaligned to zone size and libaio
> engine trigger unaligned command errors because of zone reset during
> asynchronous writes in-flight. The first patch of this series addresses the
> problem by removing the zone reset. The second patch adds a new test case to
> confirm the problem fix and to prevent future regression.

Applied, thanks.

-- 
Jens Axboe



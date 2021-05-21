Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] zbd: add a new --ignore_zone_limits option
References: <20210521133932.269694-1-Niklas.Cassel@wdc.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <cc5ca254-0c14-9b88-5913-2686607c90cd@kernel.dk>
Date: Fri, 21 May 2021 09:03:07 -0600
MIME-Version: 1.0
In-Reply-To: <20210521133932.269694-1-Niklas.Cassel@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Niklas Cassel <Niklas.Cassel@wdc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>
List-ID: <fio@vger.kernel.org>

On 5/21/21 7:39 AM, Niklas Cassel wrote:
> From: Niklas Cassel <niklas.cassel@wdc.com>
> 
> In commit d2f442bc0bd5 ("ioengines: add get_max_open_zones zoned block
> device operation") we added a check that verifies that the specified
> --max_open_zones value is lower than the max value reported by the device.
> 
> For ZNS devices there is a max open zones and a max active zones limit.
> For ZAC/ZBC devices there is only a max open zones limit.
> 
> On ZAC/ZBC, there is thus no limit on the amount of zones that can be
> in zone state closed.
> When doing a write to an empty or closed zone, a ZAC/ZBC drive will
> close an arbitrary implicit open zone in order in order to handle the
> write.
> 
> The ZNS specification has no requirement on closing a zone in order to
> handle a write to an empty or closed zone. The drive is free to return
> an error.
> 
> Even on ZAC/ZBC, you do not want to exceed the max open zones limit,
> since it will lead to additional implicit close zone and implicit open
> zone operations, which will degrade performance.
> However, it seems that this is sometimes done on purpose, in order to
> measure the overhead of these additional operations. Therefore, add
> an option that allows the user to ignore the reported device limits.

This is missing the thread_options_pack and cconv addition for the
option, which would then also need a server version increment as well.

-- 
Jens Axboe



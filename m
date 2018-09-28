Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] zbd: Fix incorrect comments
References: <20180928055353.30977-1-damien.lemoal@wdc.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <66f5e7fb-a6e0-b052-c512-3dfa65210032@kernel.dk>
Date: Fri, 28 Sep 2018 08:52:16 -0600
MIME-Version: 1.0
In-Reply-To: <20180928055353.30977-1-damien.lemoal@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Damien Le Moal <damien.lemoal@wdc.com>, fio@vger.kernel.org
Cc: Bart Van Assche <bvanassche@acm.org>
List-ID: <fio@vger.kernel.org>

On 9/27/18 11:53 PM, Damien Le Moal wrote:
> Commit ee3696bdfd84 ("zbd: Use bytes unit") changed the zone info
> structure zone start and zone wp location unit to bytes. Reflect this
> change in the fio_zone_info structure comments.

Applied, thanks.

-- 
Jens Axboe



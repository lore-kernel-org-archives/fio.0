Return-Path: <bvanassche@acm.org>
Subject: Re: [PATCH v2 5/5] zbd: Use bytes unit
References: <20180830041531.20963-1-damien.lemoal@wdc.com>
 <20180830041531.20963-6-damien.lemoal@wdc.com>
From: Bart Van Assche <bvanassche@acm.org>
Message-ID: <6238a5d2-cd30-f587-d60f-030c36823c8c@acm.org>
Date: Thu, 30 Aug 2018 08:01:07 -0700
MIME-Version: 1.0
In-Reply-To: <20180830041531.20963-6-damien.lemoal@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Damien Le Moal <damien.lemoal@wdc.com>, fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

On 08/29/18 21:15, Damien Le Moal wrote:
> Simplify zbd.c code by using byte unit for the zone information values
> instead of 512B sector count. Doing so, many 9 bits shifts operation
> are removed and code readability improved.

This patch is not related to the other patches in this series so please
leave this patch out from this series.

Thanks,

Bart.


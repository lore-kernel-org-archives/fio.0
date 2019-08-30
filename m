Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] zbd: Improve job zonesize initialization checks
References: <20190830021605.1211-1-damien.lemoal@wdc.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <74fed527-352b-a143-19e1-dc1adbc2c2c0@kernel.dk>
Date: Thu, 29 Aug 2019 20:51:28 -0600
MIME-Version: 1.0
In-Reply-To: <20190830021605.1211-1-damien.lemoal@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Damien Le Moal <damien.lemoal@wdc.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 8/29/19 8:16 PM, Damien Le Moal wrote:
> For a multijob workload, each job may specify a zonesize option for
> access to a zoned block device or regular device with zonemode=zbd.
> In such case, make sure that the zone size value specified by each job
> matches the device zone size.

Applied.

-- 
Jens Axboe



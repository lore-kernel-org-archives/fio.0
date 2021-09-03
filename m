Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH V2] oslib: Fix blkzoned_get_max_open_zones()
References: <20210901064153.312953-1-damien.lemoal@wdc.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <689bd1a0-ffef-8a0b-7863-065f7485f34f@kernel.dk>
Date: Thu, 2 Sep 2021 20:56:30 -0600
MIME-Version: 1.0
In-Reply-To: <20210901064153.312953-1-damien.lemoal@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Damien Le Moal <damien.lemoal@wdc.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 9/1/21 12:41 AM, Damien Le Moal wrote:
> When the kernel does not have the sysfs atttribute file
> queue/max_open_zones, blkzoned_get_max_open_zones() returns success
> without initializing the max_open_zones value to 0 to indicate to the
> caller (zbd_get_max_open_zones() in zbd.c) that the device limit is
> unknown. If the max_open_zones variable in zbd_get_max_open_zones() is
> not already 0 (depending on the memory status), the missing
> initialization in blkzoned_get_max_open_zones() can cause errors or
> misbehavior as an incorrect, random, limit may be used.
> 
> Fix this by always initializing max_open_zones to 0 when the
> max_open_zones sysfs attribute file does not exist.

Applied, thanks.

-- 
Jens Axboe



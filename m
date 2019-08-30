Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] zbd: Fix job zone size initialization
References: <20190830014503.32691-1-damien.lemoal@wdc.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <2915e04d-7e42-46d7-f29a-597cc9046b4c@kernel.dk>
Date: Thu, 29 Aug 2019 19:52:50 -0600
MIME-Version: 1.0
In-Reply-To: <20190830014503.32691-1-damien.lemoal@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Damien Le Moal <damien.lemoal@wdc.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 8/29/19 7:45 PM, Damien Le Moal wrote:
> For a job accessing a zoned block device, the zone size is automatically
> initialized to the device zone size. However, since zone information for
> a zoned block device is parsed once only for the first job
> initialization of a multi job workload, only the first job has its
> zonesize option intialized, causing problem if the zoneskip option is
> also used (assert exit).
> 
> Fix this by always initializing a job zonesize option using the job
> file zbd information when verifying the job ZBD related sizes and
> offsets.

Applied, thanks.

-- 
Jens Axboe



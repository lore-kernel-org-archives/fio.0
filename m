Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] zbd: Fix zone report handling
References: <20190419034049.10226-1-damien.lemoal@wdc.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <e5df9476-1702-2566-725e-91a89727869b@kernel.dk>
Date: Fri, 19 Apr 2019 09:11:51 -0600
MIME-Version: 1.0
In-Reply-To: <20190419034049.10226-1-damien.lemoal@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Damien Le Moal <damien.lemoal@wdc.com>, fio@vger.kernel.org
Cc: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
List-ID: <fio@vger.kernel.org>

On 4/18/19 9:40 PM, Damien Le Moal wrote:
> fio may be executed concurrently with a block device revalidation by
> the kernel. Device revalidation may lead to the block device capacity
> to be changed to a smaller value (device changed) or to even 0 in case
> of revalidation failure. In such case, the BLKREPORTZONE ioctl
> executed from read_zone_info() may report a success with an empty zone
> report when the start sector for the report is above the new capacity
> of the device. This leads to an infinite loop inside parse_zone_info()
> and the fio run never terminating.
> 
> Fix this problem by returning -EIO from read_zone_info() thus
> avoiding the infinite loop in parse_zone_info(). This change does not
> affect the normal case with a stable device as read_zone_info() is
> always called with a valid start sector that does not result in an
> empty zone report.

Applied, thanks.

-- 
Jens Axboe



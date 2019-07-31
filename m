Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] bssplit: Fix handling of 0 percentage
References: <20190731043207.16247-1-damien.lemoal@wdc.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <11fec50c-13da-8238-824c-a6d540a3fa73@kernel.dk>
Date: Wed, 31 Jul 2019 08:48:14 -0600
MIME-Version: 1.0
In-Reply-To: <20190731043207.16247-1-damien.lemoal@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Damien Le Moal <damien.lemoal@wdc.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 7/30/19 10:32 PM, Damien Le Moal wrote:
> If a block size percentage is ispecified as 0 in bssplit, the block size
> defined is not ignored by the loop in get_next_buflen(). In particular,
> if the first (smallest) block size specified has a 0 percentage, the
> loop is existed and that block size used as the next IO size, resulting
> in a behavior equivalent to specifying 100%. E.g. using
> --bssplit=64k/0,1024k/100 results in 100% of issued IOs to be 64KB
> instead of 1MB.
> 
> Fix this by ignoring bssplit entries that have a 0 percentage. This is
> safe as the initialization of the bssplit array ensure that the sum of
> all percentages is always 100, guaranteeing that a block size will be
> chosen for the next IO size.

Applied, thanks Damien.

-- 
Jens Axboe



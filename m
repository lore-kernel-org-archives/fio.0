Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH 1/2] eta: Avoid adjustements to a negative value
References: <20180926064210.2537-1-damien.lemoal@wdc.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <8cecc91e-2e15-4d74-c66a-01f9d72e04bf@kernel.dk>
Date: Wed, 26 Sep 2018 08:26:25 -0600
MIME-Version: 1.0
In-Reply-To: <20180926064210.2537-1-damien.lemoal@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Damien Le Moal <damien.lemoal@wdc.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 9/26/18 12:42 AM, Damien Le Moal wrote:
> In the case of zonemode=strided job with both zone_size and zone_skip
> specified, thread_eta() calculates the upper bound of the number of
> zones that will be processed, including skipped bytes between zones
> (zone_skip). Adjusting bytes_total (i.e. total_io_size) by substracting
> this number of zones times the amount of skipped bytes can result in
> a negative value for bytes_total (a large number of bytes) when for
> example the job operates on an entire disk with a capacity that is not
> divisible exactly by zone_size+zone_skip or if the options --size is
> used to limit the I/O range. In such case, use the lower bound of the
> number of zones to obtain a better approximation of the job eta.
> 
> Additionnally, if --io_size was specified, bytes_total will indicate
> this exact value, so adjusting that value for zonemode != none is not
> necessary.

Applied 1-2, thanks Damien.

-- 
Jens Axboe



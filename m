Return-Path: <bvanassche@acm.org>
Subject: Re: [PATCH v3 1/3] zbd: Improve read randomness
References: <20180831044638.22476-1-damien.lemoal@wdc.com>
 <20180831044638.22476-2-damien.lemoal@wdc.com>
From: Bart Van Assche <bvanassche@acm.org>
Message-ID: <0b7a2bcc-018b-40b3-067e-23c59a750ea7@acm.org>
Date: Fri, 31 Aug 2018 08:04:07 -0700
MIME-Version: 1.0
In-Reply-To: <20180831044638.22476-2-damien.lemoal@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Damien Le Moal <damien.lemoal@wdc.com>, fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

On 08/30/18 21:46, Damien Le Moal wrote:
> With zonemode=zbd, for random read operations with read_beyond_wp=0,
> the zbd code will always adjust an I/O offset so that the I/O hits a
> non empty zone. However, the adjustment always sets the I/O offset to
> the start of the zone, resulting in a high device read cache hit rate
> if the device has few zones written.
> 
> Improve randomness of read I/Os by adjusting the I/O offset to a random
> value within the range of written data of the chosen zone. Also ensure
> that the modified I/O does not cross over the zone wp position by
> adjusting its size. Doing so, the search for a new zone is now done only
> if the target zone cannot accomodate an I/O of at least min_bs bytes.
> 
> The comments have also been changed to better explain the code.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>



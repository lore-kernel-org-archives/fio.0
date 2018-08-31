Return-Path: <bvanassche@acm.org>
Subject: Re: [PATCH v3 2/3] zbd: Remove inexistent functions declaration
References: <20180831044638.22476-1-damien.lemoal@wdc.com>
 <20180831044638.22476-3-damien.lemoal@wdc.com>
From: Bart Van Assche <bvanassche@acm.org>
Message-ID: <6fffa5d4-e3b5-768f-3102-e29f7f96aec9@acm.org>
Date: Fri, 31 Aug 2018 07:32:10 -0700
MIME-Version: 1.0
In-Reply-To: <20180831044638.22476-3-damien.lemoal@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Damien Le Moal <damien.lemoal@wdc.com>, fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

On 08/30/18 21:46, Damien Le Moal wrote:
> The functions zbd_do_trim() and zbd_update_wp() are not implemented.
> Remove there declarations from zbd.h.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>


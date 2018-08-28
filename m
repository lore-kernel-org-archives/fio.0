Return-Path: <bvanassche@acm.org>
Subject: Re: [PATCH] zbd: Remove inexitent function declaration
References: <20180828053428.10143-1-damien.lemoal@wdc.com>
 <20180828053428.10143-3-damien.lemoal@wdc.com>
From: Bart Van Assche <bvanassche@acm.org>
Message-ID: <4fa105b2-1357-b657-3e66-ec2f288e7f00@acm.org>
Date: Tue, 28 Aug 2018 07:34:54 -0700
MIME-Version: 1.0
In-Reply-To: <20180828053428.10143-3-damien.lemoal@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Damien Le Moal <damien.lemoal@wdc.com>, fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

On 08/27/18 22:34, Damien Le Moal wrote:
> zbd_do_trim() and zbd_update_wp() are not implemented.
> Remove there declaration from zbd.h.

Regarding the patch subject: did you perhaps mean "inexistent"?
Otherwise this patch looks fine to me.

Bart.



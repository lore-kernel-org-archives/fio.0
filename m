Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH 3/5] Refine packed annotations in stat.h
References: <20190813020136.15798-1-bvanassche@acm.org>
 <20190813020136.15798-4-bvanassche@acm.org>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <cfaf773a-8fe0-ceaa-3b7d-bbfe7116e2bf@kernel.dk>
Date: Mon, 12 Aug 2019 20:53:54 -0600
MIME-Version: 1.0
In-Reply-To: <20190813020136.15798-4-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Bart Van Assche <bvanassche@acm.org>
Cc: fio@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>
List-ID: <fio@vger.kernel.org>

On 8/12/19 8:01 PM, Bart Van Assche wrote:
> Instead of declaring the whole structure packed, only declare non-aligned
> members packed. This patch is an alternative way to fix the following gcc 9
> compiler warnings:
> 
> eta.c: In function 'calc_thread_status':
> eta.c:510:7: error: taking address of packed member of 'struct jobs_eta' may result in an unaligned pointer value [-Werror=address-of-packed-member]
>    510 |     je->rate);
>        |     ~~^~~~~~
> eta.c:522:66: error: taking address of packed member of 'struct jobs_eta' may result in an unaligned pointer value [-Werror=address-of-packed-member]
>    522 |  calc_rate(unified_rw_rep, disp_time, io_bytes, disp_io_bytes, je->rate);
>        |                                                                ~~^~~~~~
> eta.c:523:64: error: taking address of packed member of 'struct jobs_eta' may result in an unaligned pointer value [-Werror=address-of-packed-member]
>    523 |  calc_iops(unified_rw_rep, disp_time, io_iops, disp_io_iops, je->iops);
>        |

This seems fragile. Not that we change the struct all the time, or even often,
but it'd be easy to add members and end up with different layout on 32-bit
vs 64-bit.

How do we improve on that?

-- 
Jens Axboe



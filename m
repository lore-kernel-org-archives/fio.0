Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] workqueue: update IO counters promptly after handling IO
References: <20181126161502.19992-1-vincentfu@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <10409e85-cacf-d370-c742-20182961731d@kernel.dk>
Date: Mon, 26 Nov 2018 09:17:17 -0700
MIME-Version: 1.0
In-Reply-To: <20181126161502.19992-1-vincentfu@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: vincentfu@gmail.com, fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>

On 11/26/18 9:15 AM, vincentfu@gmail.com wrote:
> From: Vincent Fu <vincent.fu@wdc.com>
> 
> Currently, IO submit worker threads only update parent IO counters when
> the threads are idle or when the threads exit. When offload fio jobs are
> assigned a restrictive CPU mask, this results in reporting and logging
> problems. This patch updates parent IO counters more promptly upon
> completing each IO which resolves the reporting and logging problems.
> 
> In the output below, notice the missing read data direction output in
> the first, simple job and how it appropriately appears after the patch
> is applied. In the second job with logging, notice the missing log
> entries (unequal file sizes) in the first log and how entries are no
> longer missing for the run with the patch applied.

Looks good, thanks, applied.

-- 
Jens Axboe



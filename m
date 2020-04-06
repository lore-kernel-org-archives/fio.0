Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] zbd: Fix potential zone lock deadlock
References: <20200406105132.1291382-1-damien.lemoal@wdc.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <aaa43410-cd54-0581-e104-94a667d56551@kernel.dk>
Date: Mon, 6 Apr 2020 08:31:19 -0700
MIME-Version: 1.0
In-Reply-To: <20200406105132.1291382-1-damien.lemoal@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Damien Le Moal <damien.lemoal@wdc.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 4/6/20 4:51 AM, Damien Le Moal wrote:
> Commit b27aef6abfba ("zbd: use zone_lock to lock a zone") to fix
> potential deadlocks with zonemode=zbd  zone locking was incomplete.
> The execution of the zone lock stress test t/zbd test case 48 still
> sometimes lead to deadlocks (a large number of repeated execution is
> sometimes needed).
> 
> The remaining deadlock pattern identified with the repeated execution
> of this test is due to the concurrent execution of jobs doing random
> async writes to zones. In such case, any of the job may trigger an all
> zone reset through the path get_next_rand_block() -> fio_file_reset()
> while async writes are still inflight. The fix for this is to use the
> zone_lock() function instead of directly calling pthread_mutex_lock()i
> to ensure that no async IO is inflight for a zone that is part of a
> reset range.

Applied, thanks.

-- 
Jens Axboe



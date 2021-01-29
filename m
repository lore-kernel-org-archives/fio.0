Return-Path: <bart.vanassche@gmail.com>
Return-Path: <bart.vanassche@gmail.com>
Subject: Re: [PATCH v4 09/38] zbd: don't unlock zone mutex after verify replay
References: <20210127041945.36909-1-dmitry.fomichev@wdc.com>
 <20210127041945.36909-10-dmitry.fomichev@wdc.com>
From: Bart Van Assche <bvanassche@acm.org>
Message-ID: <33435492-4cb7-e72c-1926-f7695802f13e@acm.org>
Date: Fri, 29 Jan 2021 08:13:56 -0800
MIME-Version: 1.0
In-Reply-To: <20210127041945.36909-10-dmitry.fomichev@wdc.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Dmitry Fomichev <dmitry.fomichev@wdc.com>, Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
Cc: Damien Le Moal <damien.lemoal@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Aravind Ramesh <aravind.ramesh@wdc.com>, Naohiro Aota <naohiro.aota@wdc.com>, Niklas Cassel <niklas.cassel@wdc.com>
List-ID: <fio@vger.kernel.org>

On 1/26/21 8:19 PM, Dmitry Fomichev wrote:
> zbd_adjust_block() always returns with the zone locked if the i/o is
> accepted. The corresponding unlock happens in zbd_put_io(). The
> function description says -
> 
>   * Locking strategy: returns with z->mutex locked if and only if z refers
>   * to a sequential zone and if io_u_accept is returned. z is the zone that
>   * corresponds to io_u->offset at the end of this function.
> 
> Remove the recently added unlock after zbd_replay_write_order() call.
> Add a Coverity annotation to mark the absence of unlock as intentional.
> 
> Fixes: b2726d53bb5d ("zbd: Add a missing pthread_mutex_unlock() call")
> Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
> Reviewed-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> ---
>   zbd.c | 7 ++++++-
>   1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/zbd.c b/zbd.c
> index a3c1ff9a..1ac1357b 100644
> --- a/zbd.c
> +++ b/zbd.c
> @@ -1561,7 +1561,12 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
>   	case DDIR_READ:
>   		if (td->runstate == TD_VERIFYING && td_write(td)) {
>   			zb = zbd_replay_write_order(td, io_u, zb);
> -			zone_unlock(zb);
> +			/*
> +			 * Since we return with the zone lock still held,
> +			 * add an annotation to let Coverity know that it
> +			 * is intentional.
> +			 */
> +			/* coverity[missing_unlock] */
>   			goto accept;
>   		}
>   		/*

Hi Dmitry,

Although I agree with this patch, the Coverity annotation doesn't seem 
to work. This morning I received an email with the following report:

-----------------------------------------------------------------------
Please find the latest report on new defect(s) introduced to axboe/fio 
found with Coverity Scan.

1 new defect(s) introduced to axboe/fio found with Coverity Scan.


New defect(s) Reported-by: Coverity Scan
Showing 1 of 1 defect(s)


** CID 292491:  Program hangs  (LOCK)
/zbd.c: 1789 in zbd_adjust_block()


________________________________________________________________________________________________________
*** CID 292491:  Program hangs  (LOCK)
/zbd.c: 1789 in zbd_adjust_block()
1783     	assert(zb->has_wp);
1784     	assert(zb->cond != ZBD_ZONE_COND_OFFLINE);
1785     	assert(!io_u->zbd_queue_io);
1786     	assert(!io_u->zbd_put_io);
1787     	io_u->zbd_queue_io = zbd_queue_io;
1788     	io_u->zbd_put_io = zbd_put_io;
 >>>     CID 292491:  Program hangs  (LOCK)
 >>>     Returning without unlocking "zb->mutex".
1789     	return io_u_accept;
1790
1791     eof:
1792     	if (zb && zb->has_wp)
1793     		zone_unlock(zb);
1794     	return io_u_eof;
-----------------------------------------------------------------------

Bart.


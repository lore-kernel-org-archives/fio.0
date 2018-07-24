Return-Path: <axboe@kernel.dk>
Subject: Re: [RFC] mmap: under direct=1, only call msync and madvise on writes
References: <20180714001924.34861-1-elliott@hpe.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <144b5dde-2ea3-b65a-9641-c65c0d418dc8@kernel.dk>
Date: Tue, 24 Jul 2018 09:49:42 -0600
MIME-Version: 1.0
In-Reply-To: <20180714001924.34861-1-elliott@hpe.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Robert Elliott <elliott@hpe.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 7/13/18 6:19 PM, Robert Elliott wrote:
> While using the mmap engine with direct=1 (an artificial combination),
> only call msync() and madvise(DONTNEED) for writes; don't worry about
> reads.
> 
> This better simulates an application that periodically wants to flush
> updated data to disk, but wants to keep read data in memory.
> 
> Signed-off-by: Robert Elliott <elliott@hpe.com>
> ---
>  engines/mmap.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/engines/mmap.c b/engines/mmap.c
> index 308b4665..cacf1768 100644
> --- a/engines/mmap.c
> +++ b/engines/mmap.c
> @@ -205,7 +205,7 @@ static enum fio_q_status fio_mmapio_queue(struct thread_data *td,
>  	/*
>  	 * not really direct, but should drop the pages from the cache
>  	 */
> -	if (td->o.odirect && ddir_rw(io_u->ddir)) {
> +	if (td->o.odirect && (io_u->ddir == DDIR_WRITE || io_u->ddir == DDIR_TRIM)) {
>  		if (msync(io_u->mmap_data, io_u->xfer_buflen, MS_SYNC) < 0) {
>  			io_u->error = errno;
>  			td_verror(td, io_u->error, "msync");

Looks fine, but might be a good idea to add a ddir_write() helper for it.
Maybe fio_ro_check() can use it too.

-- 
Jens Axboe



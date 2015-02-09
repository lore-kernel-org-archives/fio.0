Return-Path: <axboe@kernel.dk>
Message-ID: <54D8CF69.5070304@kernel.dk>
Date: Mon, 09 Feb 2015 08:16:57 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] verify: Fix latency log for verify commands.
References: <1423454000-7730-1-git-send-email-gwendal@chromium.org>
In-Reply-To: <1423454000-7730-1-git-send-email-gwendal@chromium.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Gwendal Grignou <gwendal@chromium.org>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 02/08/2015 08:53 PM, Gwendal Grignou wrote:
> When commands when requeued for the verify operation,
> their start time was not reset, resulting in bogus latency graphs.
>
> Signed-off-by: Gwendal Grignou <gwendal@chromium.org>
> ---
>   backend.c | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/backend.c b/backend.c
> index 7ec8d2a..0f6e425 100644
> --- a/backend.c
> +++ b/backend.c
> @@ -565,6 +565,8 @@ static void do_verify(struct thread_data *td, uint64_t verify_bytes)
>   			io_u->end_io = verify_io_u;
>
>   		ddir = io_u->ddir;
> +		if (!td->o.disable_slat)
> +			fio_gettime(&io_u->start_time, NULL);
>
>   		ret = td_io_queue(td, io_u);
>   		switch (ret) {

Thanks, applied.


-- 
Jens Axboe



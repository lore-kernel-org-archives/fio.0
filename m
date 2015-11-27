Return-Path: <axboe@kernel.dk>
Subject: Re: RBD client cache
References: <CADr68WZZqpVAeS-EuUgc5eOz=XoyrcCWCTymx58WBEAger442A@mail.gmail.com>
 <564E318C.3060602@kernel.dk> <1448553070.29391.3.camel@x-ion.de>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <56587F75.80800@kernel.dk>
Date: Fri, 27 Nov 2015 09:06:13 -0700
MIME-Version: 1.0
In-Reply-To: <1448553070.29391.3.camel@x-ion.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Jens Rosenboom <j.rosenboom@x-ion.de>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 11/26/2015 08:51 AM, Jens Rosenboom wrote:
>  From dbd950891a43a7104bce5ec935cd992c7e2b27ff Mon Sep 17 00:00:00 2001
> From: Jens Rosenboom <j.rosenboom@x-ion.de>
> Date: Thu, 26 Nov 2015 16:27:49 +0100
> Subject: [PATCH] Add an option to flush RBD after opening
>
> With recent Ceph releases the default value for
>
> rbd cache writethrough until flush
>
> has been changed to true, so the librbd client cache will stay in
> writethrough mode for fio.
>
> This patch adds an option to perform an rbd_flush() call after opening
> the RBD, causing the client cache to activate writeback mode.
>
> Signed-off-by: Jens Rosenboom <j.rosenboom@x-ion.de>
> ---
>
> This works in my test enviroment and boosts 4k randwrites at iodepth=1 from 100 to 6000.
> Still it would probably be good if other people could test this, too.
>
>
>   engines/rbd.c | 18 ++++++++++++++++++
>   1 file changed, 18 insertions(+)
>
> diff --git a/engines/rbd.c b/engines/rbd.c
> index 2be9b55..b3efedf 100644
> --- a/engines/rbd.c
> +++ b/engines/rbd.c
> @@ -30,6 +30,7 @@ struct rbd_options {
>   	char *pool_name;
>   	char *client_name;
>   	int busy_poll;
> +	int flush_on_open;
>   };
>
>   static struct fio_option options[] = {
> @@ -71,6 +72,16 @@ static struct fio_option options[] = {
>   		.group		= FIO_OPT_G_RBD,
>   	},
>   	{
> +		.name		= "flush_on_open",
> +		.lname		= "Flush on open",
> +		.type		= FIO_OPT_BOOL,
> +		.help		= "Flush on opening the RBD to activate client cache",
> +		.off1		= offsetof(struct rbd_options, flush_on_open),
> +		.def		= "0",
> +		.category	= FIO_OPT_C_ENGINE,
> +		.group		= FIO_OPT_G_RBD,
> +	},
> +	{
>   		.name = NULL,
>   	},
>   };
> @@ -140,6 +151,13 @@ static int _fio_rbd_connect(struct thread_data *td)
>   		log_err("rbd_open failed.\n");
>   		goto failed_open;
>   	}
> +	if (o->flush_on_open) {
> +		r = rbd_flush(rbd->image);
> +		if (r < 0) {
> +			log_err("rbd_flush failed.\n");
> +			goto failed_open;
> +		}
> +	}
>   	return 0;

Looks good, but we should probably limit this to td_write() being true, 
and not do this for read-only opens.

-- 
Jens Axboe



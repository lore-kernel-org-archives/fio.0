Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] Fix 'nice' parameter range: should be -20 to 19, not -19
 to 20.
References: <20171026212823.86536-1-rebecca@bluestop.org>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <1d5f05f4-9bc5-5835-2813-2bc85495e5db@kernel.dk>
Date: Thu, 26 Oct 2017 15:31:50 -0600
MIME-Version: 1.0
In-Reply-To: <20171026212823.86536-1-rebecca@bluestop.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Rebecca Cran <rebecca@bluestop.org>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 10/26/2017 03:28 PM, Rebecca Cran wrote:
> ---
>  options.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/options.c b/options.c
> index 8ee986a7..5813a66b 100644
> --- a/options.c
> +++ b/options.c
> @@ -3252,8 +3252,8 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
>  		.type	= FIO_OPT_INT,
>  		.off1	= offsetof(struct thread_options, nice),
>  		.help	= "Set job CPU nice value",
> -		.minval	= -19,
> -		.maxval	= 20,
> +		.minval	= -20,
> +		.maxval	= 19,
>  		.def	= "0",
>  		.interval = 1,
>  		.category = FIO_OPT_C_GENERAL,

Applied, thanks.

-- 
Jens Axboe



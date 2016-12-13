Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] Change misleading error message for invalid size= value
References: <1481646444-2288-1-git-send-email-jkbs@redhat.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <4a8141d8-915e-8401-c750-6cdb943510d0@kernel.dk>
Date: Tue, 13 Dec 2016 09:32:43 -0700
MIME-Version: 1.0
In-Reply-To: <1481646444-2288-1-git-send-email-jkbs@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
To: Jakub Sitnicki <jkbs@redhat.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 12/13/2016 09:27 AM, Jakub Sitnicki wrote:
> The error message refers to the IO size, yet another parameter, but we
> actually compare the size parameter value against the block size.
> 
> Change the message to reflect the code, and make it easier for the user
> to see what values are we comparing.
> 
> Signed-off-by: Jakub Sitnicki <jkbs@redhat.com>
> ---
>  init.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/init.c b/init.c
> index 382fa1f..36feb51 100644
> --- a/init.c
> +++ b/init.c
> @@ -822,7 +822,8 @@ static int fixup_options(struct thread_data *td)
>  	 * If size is set but less than the min block size, complain
>  	 */
>  	if (o->size && o->size < td_min_bs(td)) {
> -		log_err("fio: size too small, must be larger than the IO size: %llu\n", (unsigned long long) o->size);
> +		log_err("fio: size too small, must not be less than minimum block size: %llu < %u\n",
> +			(unsigned long long) o->size, td_min_bs(td));
>  		ret = 1;
>  	}

Thanks, applied.

-- 
Jens Axboe



Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] smalloc: fix compiler warning
References: <20190731205751.17531-1-vincentfu@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <568b52b6-7203-65ac-6847-5a7e21fed435@kernel.dk>
Date: Wed, 31 Jul 2019 15:17:11 -0600
MIME-Version: 1.0
In-Reply-To: <20190731205751.17531-1-vincentfu@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: vincentfu@gmail.com, fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>

On 7/31/19 2:57 PM, vincentfu@gmail.com wrote:
> From: Vincent Fu <vincent.fu@wdc.com>
> 
> firstfree() triggers a warning from the Windows compiler used by
> AppVeyor because it doesn't return a value if the for loop iterates to
> completion. This patch resolves the compiler warning.
> 
> AppVeyor Windows build log: https://ci.appveyor.com/project/axboe/fio/builds/26381726
> ---
>   smalloc.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/smalloc.c b/smalloc.c
> index c97bcbaa..0d7054a4 100644
> --- a/smalloc.c
> +++ b/smalloc.c
> @@ -347,6 +347,9 @@ static unsigned int firstfree(struct pool *pool)
>                           return i;
>   
>           assert(0);
> +
> +	/* we will never get here but this fixes a compiler warning */
> +	return -1U;
>   }

Thanks, a bit ugly (for Windows), but no big deal.

-- 
Jens Axboe



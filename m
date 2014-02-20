Return-Path: <axboe@kernel.dk>
Date: Thu, 20 Feb 2014 09:18:59 -0800
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [patch 8/9] fio: fix last block never being touched by random
 offsets
Message-ID: <20140220171832.GC30251@kernel.dk>
References: <20140220132051.624645398@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140220132051.624645398@linux.vnet.ibm.com>
To: ehrhardt@linux.vnet.ibm.com
Cc: fio@vger.kernel.org, oberpar@linux.vnet.ibm.com
List-ID: <fio@vger.kernel.org>

On Thu, Feb 20 2014, ehrhardt@linux.vnet.ibm.com wrote:
> *Resend with hopefully non mangled patches*
> References: <20140220131958.965092001@linux.vnet.ibm.com>
> Content-Disposition: inline; filename=fix_last_block.diff
> 
> From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
> 
> Fix the available range for random offsets which never touched the last block.
> 
> Signed-off-by: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
> ---
> [diffstat]
>  io_u.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/io_u.c
> +++ b/io_u.c
> @@ -104,7 +104,7 @@ static int __get_next_rand_offset(struct
>  
>  		dprint(FD_RANDOM, "off rand %llu\n", (unsigned long long) r);
>  
> -		*b = (lastb - 1) * (r / ((uint64_t) rmax + 1.0));
> +		*b = lastb * (r / ((uint64_t) rmax + 1.0));
>  	} else {
>  		uint64_t off = 0;

Wont this generate lastb as the potentially last block? We want lastb-1
as the last one, otherwise the length of IO from it will be 0.

I might be missing something here.

-- 
Jens Axboe



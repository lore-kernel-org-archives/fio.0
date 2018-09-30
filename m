Return-Path: <axboe@kernel.dk>
Subject: Re: [patch] fix hung fio process with large I/O sizes and verify=
 option
References: <x49sh1t48ip.fsf@segfault.boston.devel.redhat.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <22145a9c-8b7a-90f4-112f-2d5f29815420@kernel.dk>
Date: Sun, 30 Sep 2018 08:16:16 -0600
MIME-Version: 1.0
In-Reply-To: <x49sh1t48ip.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Jeff Moyer <jmoyer@redhat.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 9/28/18 3:27 PM, Jeff Moyer wrote:
> Hi,
> 
> If you use a very large I/O size (1G in this instance), and also specify
> the verify option, fio will hang, using up 100% cpu, for ever and ever.
> The problem is that __fill_random_buf_percentage does math that
> overflows the size of an unsigned int.  Fixing that gets fio to
> terminate as expected.
> 
> Here is the job file which showed the problem:
> 
> [global]
> ioengine=dev-dax
> direct=0
> filename=/dev/dax0.0
> verify=crc32c
> bs=1G
> [write]
> rw=write
> runtime=5
> [read]
> stonewall
> rw=read
> runtime=5
> 
> Reported-by: sujith_pandel@dell.com
> Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
> 
> diff --git a/lib/rand.c b/lib/rand.c
> index 46ffe4fb..99846a8d 100644
> --- a/lib/rand.c
> +++ b/lib/rand.c
> @@ -156,7 +156,7 @@ void __fill_random_buf_percentage(unsigned long seed, void *buf,
>  		/*
>  		 * Fill random chunk
>  		 */
> -		this_len = (segment * (100 - percentage)) / 100;
> +		this_len = ((unsigned long long)segment * (100 - percentage)) / 100;
>  		if (this_len > len)
>  			this_len = len;

Thanks Jeff, applied.

-- 
Jens Axboe



Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH 3/4] lib/memalign: don't malloc size twice
References: <20170918175350.38471-1-tkusumi@tuxera.com>
 <20170918175350.38471-4-tkusumi@tuxera.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <2af74845-95d0-9c98-ead2-4fa3d32c7476@kernel.dk>
Date: Mon, 18 Sep 2017 12:04:04 -0600
MIME-Version: 1.0
In-Reply-To: <20170918175350.38471-4-tkusumi@tuxera.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: kusumi.tomohiro@gmail.com, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

On 09/18/2017 11:53 AM, kusumi.tomohiro@gmail.com wrote:
> From: Tomohiro Kusumi <tkusumi@tuxera.com>
> 
> The footer offset (diff between malloc'd address and aligned address)
> is (alignment-1) at most, and footer appears `size' bytes after the
> aligned address, thus required size is (alignment-1 + size + sizeof(*f)).
> 
> The existing code seems to allocate extra unused `size' bytes.
> 
> Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
> ---
>  lib/memalign.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib/memalign.c b/lib/memalign.c
> index 137cc8e..bfbd1e8 100644
> --- a/lib/memalign.c
> +++ b/lib/memalign.c
> @@ -18,7 +18,7 @@ void *fio_memalign(size_t alignment, size_t size)
>  
>  	assert(!(alignment & (alignment - 1)));
>  
> -	ptr = malloc(size + alignment + size + sizeof(*f) - 1);
> +	ptr = malloc(size + alignment + sizeof(*f) - 1);

That does look like a mistake, there's no need to account 'size' twice.
Applied.

-- 
Jens Axboe



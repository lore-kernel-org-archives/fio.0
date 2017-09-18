Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH 1/4] add "invalid IO size" to "first direct IO errored."
 message
References: <20170918175350.38471-1-tkusumi@tuxera.com>
 <20170918175350.38471-2-tkusumi@tuxera.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <1aba24fd-30b1-d8b6-a8b0-4241452be94d@kernel.dk>
Date: Mon, 18 Sep 2017 12:00:41 -0600
MIME-Version: 1.0
In-Reply-To: <20170918175350.38471-2-tkusumi@tuxera.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: kusumi.tomohiro@gmail.com, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

On 09/18/2017 11:53 AM, kusumi.tomohiro@gmail.com wrote:
> From: Tomohiro Kusumi <tkusumi@tuxera.com>
> 
> It could fail due to bs not multiple of sector size.
> 
> Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
> ---
>  ioengines.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/ioengines.c b/ioengines.c
> index fa4acab..b8a31a8 100644
> --- a/ioengines.c
> +++ b/ioengines.c
> @@ -342,8 +342,8 @@ int td_io_queue(struct thread_data *td, struct io_u *io_u)
>  	    td->o.odirect) {
>  
>  		log_info("fio: first direct IO errored. File system may not "
> -			 "support direct IO, or iomem_align= is bad. Try "
> -			 "setting direct=0.\n");
> +			 "support direct IO, or iomem_align= is bad, or "
> +			 "invalid IO size. Try setting direct=0.\n");

Should that say "block size" or something instead of IO size? I think that
would be clearer.

-- 
Jens Axboe



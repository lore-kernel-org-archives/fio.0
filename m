Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH 2/3] verify: mention some default option values
References: <20170526192511.31502-1-tkusumi@tuxera.com>
 <20170526192511.31502-2-tkusumi@tuxera.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <af2c0a3b-062d-5499-0deb-739f54fb59e1@kernel.dk>
Date: Fri, 26 May 2017 13:29:33 -0600
MIME-Version: 1.0
In-Reply-To: <20170526192511.31502-2-tkusumi@tuxera.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: kusumi.tomohiro@gmail.com, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

On 05/26/2017 01:25 PM, kusumi.tomohiro@gmail.com wrote:
> From: Tomohiro Kusumi <tkusumi@tuxera.com>
> 
> Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
> ---
>  HOWTO | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/HOWTO b/HOWTO
> index a899b90..8cfa12c 100644
> --- a/HOWTO
> +++ b/HOWTO
> @@ -2467,6 +2467,7 @@ Verification
>  	contents to one or more separate threads. If using this offload option, even
>  	sync I/O engines can benefit from using an :option:`iodepth` setting higher
>  	than 1, as it allows them to have I/O in flight while verifies are running.
> +	Defaults to 0 async thread, i.e. verification is not asynchronous.

Should be 'threads' there, I made that correction before applying.

-- 
Jens Axboe



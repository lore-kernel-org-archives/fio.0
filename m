Return-Path: <axboe@kernel.dk>
Date: Mon, 13 Feb 2017 08:41:20 -0700
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 1/3] Be more verbose on endianness detection failure
Message-ID: <20170213154120.GA4585@kernel.dk>
References: <20170211142854.23620-1-tkusumi@tuxera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170211142854.23620-1-tkusumi@tuxera.com>
To: kusumi.tomohiro@gmail.com
Cc: fio@vger.kernel.org, Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

On Sat, Feb 11 2017, kusumi.tomohiro@gmail.com wrote:
> From: Tomohiro Kusumi <tkusumi@tuxera.com>
> 
> Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
> ---
>  libfio.c | 29 ++++++++++++++++++++++++-----
>  1 file changed, 24 insertions(+), 5 deletions(-)
> 
> diff --git a/libfio.c b/libfio.c
> index 960daf6..096efe2 100644
> --- a/libfio.c
> +++ b/libfio.c
> @@ -327,16 +327,16 @@ static int endian_check(void)
>  
>  #if defined(CONFIG_LITTLE_ENDIAN)
>  	if (be)
> -		return 1;
> +		return 1; /* should be little */
>  #elif defined(CONFIG_BIG_ENDIAN)
>  	if (le)
> -		return 1;
> +		return 2; /* should be big */

I think this deserves and enum. That also enables the compiler to check
if the below switch covers all the potential values.

-- 
Jens Axboe



Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH 2/4] add fio_set_directio() error message for platforms
 without direct I/O
References: <20170918175350.38471-1-tkusumi@tuxera.com>
 <20170918175350.38471-3-tkusumi@tuxera.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <f8a1aec6-75fb-7c90-0ef2-2b0f98bdd71f@kernel.dk>
Date: Mon, 18 Sep 2017 12:02:48 -0600
MIME-Version: 1.0
In-Reply-To: <20170918175350.38471-3-tkusumi@tuxera.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: kusumi.tomohiro@gmail.com, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

On 09/18/2017 11:53 AM, kusumi.tomohiro@gmail.com wrote:
> From: Tomohiro Kusumi <tkusumi@tuxera.com>
> 
> This lets platforms without dio (e.g. OpenBSD) fail with an explicit
> message, otherwise they fail without a clue about dio even with
> --debug=all enabled.
> 
> "if (!OS_O_DIRECT)" is needed so that only platforms without both
> O_DIRECT and FIO_OS_DIRECTIO print this message if/when called.
> 
> Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
> ---
>  filesetup.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/filesetup.c b/filesetup.c
> index b51ab35..c5eb7cf 100644
> --- a/filesetup.c
> +++ b/filesetup.c
> @@ -1868,6 +1868,8 @@ int fio_set_directio(struct thread_data *td, struct fio_file *f)
>  
>  	return 0;
>  #else
> +	if (!OS_O_DIRECT)
> +		log_err("fio: the file system does not seem to support direct IO\n");
>  	return -1;
>  #endif

Does that need the OS_O_DIRECT check? We know that FIO_OS_DIRECTIO isn't
set at that point, that should be enough.


-- 
Jens Axboe



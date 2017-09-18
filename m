Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH v2 2/2] add fio_set_directio() error message for platforms
 without direct I/O
References: <20170918182355.45590-1-tkusumi@tuxera.com>
 <20170918182355.45590-3-tkusumi@tuxera.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <a2df534e-1ba1-27e4-7467-8be21271d838@kernel.dk>
Date: Mon, 18 Sep 2017 12:26:40 -0600
MIME-Version: 1.0
In-Reply-To: <20170918182355.45590-3-tkusumi@tuxera.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: kusumi.tomohiro@gmail.com, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

On 09/18/2017 12:23 PM, kusumi.tomohiro@gmail.com wrote:
> From: Tomohiro Kusumi <tkusumi@tuxera.com>
> 
> This lets platforms without dio (e.g. OpenBSD) fail with an explicit
> message, otherwise they fail without a clue about dio even with
> --debug=all enabled.
> 
> The message assumes platforms with O_DIRECT do not call this function
> (and in fact they don't so it's not really a problem).
> 
> Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
> ---
>  filesetup.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/filesetup.c b/filesetup.c
> index b51ab35..9813873 100644
> --- a/filesetup.c
> +++ b/filesetup.c
> @@ -1868,6 +1868,7 @@ int fio_set_directio(struct thread_data *td, struct fio_file *f)
>  
>  	return 0;
>  #else
> +	log_err("fio: the file system does not seem to support direct IO\n");

Should have caught this the first time, sorry... But that should say "the operating
system", it's not a file system condition. I'd use something ala:

fio: direct IO is not supported on this host operating system

since it is possible that the OS does in fact support some variant of direct
IO, but fio doesn't support it on that platform.

-- 
Jens Axboe



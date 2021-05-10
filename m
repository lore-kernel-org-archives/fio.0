Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH v2] Make fill_device to stop writing on EDQUOT
References: <YJm19oa9P0bscNjI@dione.lan>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <fd25baf4-9598-57f7-cfc0-42a087154ef7@kernel.dk>
Date: Mon, 10 May 2021 17:22:59 -0600
MIME-Version: 1.0
In-Reply-To: <YJm19oa9P0bscNjI@dione.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Martin Bukatovic <martin.bukatovic@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 5/10/21 4:38 PM, Martin Bukatovic wrote:
> diff --git a/filesetup.c b/filesetup.c
> index e664f8b4..57173637 100644
> --- a/filesetup.c
> +++ b/filesetup.c
> @@ -226,11 +226,17 @@ static int extend_file(struct thread_data *td, struct fio_file *f)
>  			if (r < 0) {
>  				int __e = errno;
>  
> -				if (__e == ENOSPC) {
> +				if (__e == ENOSPC || __e == EDQUOT) {
> +					const char* __e_name;

'*' goes with the variable name in the fio coding style.

>  					if (td->o.fill_device)
>  						break;
> -					log_info("fio: ENOSPC on laying out "
> -						 "file, stopping\n");
> +					if (__e == ENOSPC) {
> +						__e_name = "ENOSPC";
> +					} else {
> +						__e_name = "EDQUOT";
> +					}

And no braces for single lines.

Apart from that, looks fine to me. Can you do a quick v3 with those
changes?

-- 
Jens Axboe



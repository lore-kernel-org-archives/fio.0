Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] Make fill_device to stop writing on EDQUOT
References: <20200829203456.GA18156@dione.lan>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <5cef0533-4e2c-fc1e-7293-401523848a6d@kernel.dk>
Date: Sat, 29 Aug 2020 15:17:39 -0600
MIME-Version: 1.0
In-Reply-To: <20200829203456.GA18156@dione.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Martin Bukatovic <martin.bukatovic@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 8/29/20 2:34 PM, Martin Bukatovic wrote:
> diff --git a/filesetup.c b/filesetup.c
> index d382fa24..39a17521 100644
> --- a/filesetup.c
> +++ b/filesetup.c
> @@ -233,6 +233,10 @@ static int extend_file(struct thread_data *td, struct fio_file *f)
>  						 "file, stopping\n");
>  					break;
>  				}
> +				if (__e == EDQUOT) {
> +					if (td->o.fill_device)
> +						break;
> +				}
>  				td_verror(td, errno, "write");
>  			} else
>  				td_verror(td, EIO, "write");

This should just extent the previous ENOSPC check, and modify the
print statement as well.

-- 
Jens Axboe



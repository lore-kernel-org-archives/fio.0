Return-Path: <axboe@kernel.dk>
Subject: Re: Wee nit in backend.c
References: <CANvN+enkXyJPKpsg00vOm6A3e25NYYmH1W_w5dO+vOeNvEBVVw@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <55E9EF9E.9000700@kernel.dk>
Date: Fri, 4 Sep 2015 13:23:10 -0600
MIME-Version: 1.0
In-Reply-To: <CANvN+enkXyJPKpsg00vOm6A3e25NYYmH1W_w5dO+vOeNvEBVVw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 09/04/2015 01:18 PM, Andrey Kuzmin wrote:
> diff --git a/backend.c b/backend.c
> index 80bd361..fec423e 100644
> --- a/backend.c
> +++ b/backend.c
> @@ -539,7 +539,7 @@ sync_done:
>                          *ret = ret2;
>                  break;
>          default:
> -               assert(ret < 0);
> +               assert(*ret < 0);
>                  td_verror(td, -(*ret), "td_io_queue");
>                  break;
>          }

Good catch, that was broken by e9d512d8e7d2.

-- 
Jens Axboe



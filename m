Return-Path: <axboe@kernel.dk>
Date: Thu, 13 Feb 2014 09:17:33 -0700
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] io_u_qiter: Fix buffer overrun
Message-ID: <20140213161733.GD10926@kernel.dk>
References: <20140213070625.GA9117@sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140213070625.GA9117@sucs.org>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On Thu, Feb 13 2014, Sitsofe Wheeler wrote:
> In io_u_queue.h the io_u_qiter macro is loops around io_u_queue
> structures. The problem comes with the end of loop initialisation:
> i++, io_u = (q)->io_us[i]
> For example, if io_us consists of one element and i is 0 then after the
> first iteration is completed i++, io_u = (q)->io_us[i] will access
> beyond the end of io_us.
> 
> Fix this by moving io_u initialisation to the expression part of the for
> loop (yuck).
> 
> Found by Dr Memory.
> 
> Signed-off-by: Sitsofe Wheeler <sitsofe@yahoo.com>
> ---
>  io_u_queue.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/io_u_queue.h b/io_u_queue.h
> index 4f6e8e6..5b6cad0 100644
> --- a/io_u_queue.h
> +++ b/io_u_queue.h
> @@ -29,7 +29,7 @@ static inline int io_u_qempty(struct io_u_queue *q)
>  }
>  
>  #define io_u_qiter(q, io_u, i)	\
> -	for (i = 0, io_u = (q)->io_us[0]; i < (q)->nr; i++, io_u = (q)->io_us[i])
> +	for (i = 0; i < (q)->nr && (io_u = (q)->io_us[i]); i++)

Initially I didn't see the issue, but then I realized that ->io_us is a
pointer to the io_u pointer. So it is an issue. The fix isn't super
pretty, but it gets rid of the bug, so I'll apply it. It might be nicer
to split it into a top and bottom define.

-- 
Jens Axboe



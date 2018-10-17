Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH v2 2/4] fio: enable cross-thread overlap checking with
 processes
References: <20181017145225.14546-1-vincentfu@gmail.com>
 <20181017145225.14546-3-vincentfu@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <f98f3bc3-85dc-151a-1431-7a00eb5da24a@kernel.dk>
Date: Wed, 17 Oct 2018 09:32:59 -0600
MIME-Version: 1.0
In-Reply-To: <20181017145225.14546-3-vincentfu@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: vincentfu@gmail.com, fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>

On 10/17/18 8:52 AM, vincentfu@gmail.com wrote:
> -bool io_u_qinit(struct io_u_queue *q, unsigned int nr)
> +bool io_u_qinit(struct io_u_queue *q, unsigned int nr, bool shared)
>  {
> -	q->io_us = calloc(nr, sizeof(struct io_u *));
> +	if (shared) {
> +		q->io_us = smalloc(nr * sizeof(struct io_u *));
> +		memset(q->io_us, 0, nr * sizeof(struct io_u *));
> +	}
> +	else
> +		q->io_us = calloc(nr, sizeof(struct io_u *));
> +

smalloc() returns zeroed memory.

Apart from that, I think this patch looks fine.

-- 
Jens Axboe



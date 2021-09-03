Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH v2] options: Add thinktime_iotime option
References: <20210903083719.1757299-1-shinichiro.kawasaki@wdc.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <ef8b37bd-d743-5e89-eb98-c619523c34e2@kernel.dk>
Date: Fri, 3 Sep 2021 06:38:39 -0600
MIME-Version: 1.0
In-Reply-To: <20210903083719.1757299-1-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>, fio@vger.kernel.org
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>
List-ID: <fio@vger.kernel.org>

On 9/3/21 2:37 AM, Shin'ichiro Kawasaki wrote:
> diff --git a/options.c b/options.c
> index 8c2ab7cc..3fe1e6bd 100644
> --- a/options.c
> +++ b/options.c
> @@ -3688,6 +3688,20 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
>  		},
>  		.parent = "thinktime",
>  	},
> +	{
> +		.name	= "thinktime_iotime",
> +		.lname	= "Thinktime interval",
> +		.type	= FIO_OPT_INT,
> +		.off1	= offsetof(struct thread_options, thinktime_iotime),
> +		.help	= "IO time interval between 'thinktime'",
> +		.is_time = 1,
> +		.is_seconds = 1,
> +		.def	= "0",
> +		.parent	= "thinktime",
> +		.hide	= 1,
> +		.category = FIO_OPT_C_IO,
> +		.group	= FIO_OPT_G_THINKTIME,
> +	},

Please line these up nicely as is done elsewhere.

Apart from that, this looks fine. Could really use an example job
though, and an improvement in the explanation. The commit message looks
great, but then the doc additions are pretty lackluster. Maybe steal a
bit of the text you wrote from the commit message and put it in the
shipped documentation?

-- 
Jens Axboe



Return-Path: <axboe@kernel.dk>
Subject: Re: fio max blocksize
References: <MWHPR04MB032082F03EB254879C04F26B8F470@MWHPR04MB0320.namprd04.prod.outlook.com>
 <15f67a56-7f53-cfca-f4e6-289e1d6c2b14@kernel.dk>
 <MWHPR04MB0320E4A6307D8C818D3666418F590@MWHPR04MB0320.namprd04.prod.outlook.com>
 <4c57a31e-7955-d0b2-ed27-9d494f090651@kernel.dk>
 <MWHPR04MB032079BDBD1D6341D9B1D77A8F590@MWHPR04MB0320.namprd04.prod.outlook.com>
 <e0d997fd-0ee3-2157-1dac-4f0c4c0dfcda@kernel.dk>
 <MWHPR04MB0320A295A6828D92707C552D8F590@MWHPR04MB0320.namprd04.prod.outlook.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <c36b2cb1-5af7-5171-3f84-6279b216b1d6@kernel.dk>
Date: Thu, 12 Jul 2018 16:33:41 -0600
MIME-Version: 1.0
In-Reply-To: <MWHPR04MB0320A295A6828D92707C552D8F590@MWHPR04MB0320.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Jeff Furlong <jeff.furlong@wdc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 7/12/18 4:13 PM, Jeff Furlong wrote:
>> Right, it's just converting (if needed) the general case to be ull based
> I added a FIO_OPT_ULL case and made the maxval appropriate there.

> diff --git a/parse.c b/parse.c
> index 6261fca..d125ffc 100644
> --- a/parse.c
> +++ b/parse.c
> @@ -615,25 +617,25 @@ static int __handle_option(const struct fio_option *o, const char *ptr,
>  		if (fn)
>  			ret = fn(data, &ull);
>  		else {
> -			if (o->type == FIO_OPT_INT) {
> +			if ((o->type == FIO_OPT_INT) || (o->type == FIO_OPT_ULL)) {
>  				if (first)
> -					val_store(ilp, ull, o->off1, 0, data, o);
> +					val_store(ullp, ull, o->off1, 0, data, o);

This isn't going to work, as FIO_OPT_INT will be an integer pointer, not
a pointer to an unsigned long long. The above will overwrite nearby
members.

-- 
Jens Axboe



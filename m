Return-Path: <axboe@kernel.dk>
Subject: Re: fio max blocksize
References: <MWHPR04MB032082F03EB254879C04F26B8F470@MWHPR04MB0320.namprd04.prod.outlook.com>
 <15f67a56-7f53-cfca-f4e6-289e1d6c2b14@kernel.dk>
 <MWHPR04MB0320E4A6307D8C818D3666418F590@MWHPR04MB0320.namprd04.prod.outlook.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <4c57a31e-7955-d0b2-ed27-9d494f090651@kernel.dk>
Date: Thu, 12 Jul 2018 12:20:38 -0600
MIME-Version: 1.0
In-Reply-To: <MWHPR04MB0320E4A6307D8C818D3666418F590@MWHPR04MB0320.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Jeff Furlong <jeff.furlong@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 7/12/18 12:08 PM, Jeff Furlong wrote:
>> if/when we up the size I can just see someone raising an issue about how using fio with 16GByte blocks at an iodepth of 8 didn't work...
> Agreed.  But we already see folks today using bs=1MB, numjobs=512, and iodepth=1024 as a "test."  Folks just need to be aware of what IO they are really trying to do.
> 
>> Post the patch and we can take a look at it.
> Here's my partial patch.  I didn't (yet) change anything in blktrace.c, and the hack to parse.c is rough.  Also I have a few make warnings to resolve.

"rough" is one way to express it, "not doing at all what you think" would be
another :-)

> diff --git a/parse.c b/parse.c
> index 6261fca..fd08a60 100644
> --- a/parse.c
> +++ b/parse.c
> @@ -582,7 +582,7 @@ static int __handle_option(const struct fio_option *o, const char *ptr,
>  			return 1;
>  		}
>  
> -		if (o->maxval && ull > o->maxval) {
> +		if (o->maxval && ull > o->maxval && ((o->name!="bs") && (o->name!="ba"))) {

I'm guessing you do more python than C :-)

In any case, the real fix would be to make FIO_OPT_RANGE work on ull,
not unsignd ints. That one is trivial, the other block size related
options are worse since they are used by other options as well. Probably
the easiest to just introduce ULL versions of the ones used, and reuse
most of the code for that. Basically the unsigned int version should
just be a subset of the ull, with the min/max settings things would just
work out nicely.

-- 
Jens Axboe



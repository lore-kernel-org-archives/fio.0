Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
References: <x49sh1t48ip.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49sh1t48ip.fsf@segfault.boston.devel.redhat.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sun, 30 Sep 2018 10:35:40 +0100
Message-ID: <CALjAwxhG3-KcquEz4JBJxaOZpA86OJPe5TFK6VLYFjtE-MKdcA@mail.gmail.com>
Subject: Re: [patch] fix hung fio process with large I/O sizes and verify= option
Content-Type: text/plain; charset="UTF-8"
To: Jens Axboe <axboe@kernel.dk>
Cc: fio <fio@vger.kernel.org>, jmoyer@redhat.com
List-ID: <fio@vger.kernel.org>

I'm not sure if you've overlooked this one Jens so I'm re-mentioning it...

On Fri, 28 Sep 2018 at 22:31, Jeff Moyer <jmoyer@redhat.com> wrote:
>
> Hi,
>
> If you use a very large I/O size (1G in this instance), and also specify
> the verify option, fio will hang, using up 100% cpu, for ever and ever.
> The problem is that __fill_random_buf_percentage does math that
> overflows the size of an unsigned int.  Fixing that gets fio to
> terminate as expected.
>
> Here is the job file which showed the problem:
>
> [global]
> ioengine=dev-dax
> direct=0
> filename=/dev/dax0.0
> verify=crc32c
> bs=1G
> [write]
> rw=write
> runtime=5
> [read]
> stonewall
> rw=read
> runtime=5
>
> Reported-by: sujith_pandel@dell.com
> Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
>
> diff --git a/lib/rand.c b/lib/rand.c
> index 46ffe4fb..99846a8d 100644
> --- a/lib/rand.c
> +++ b/lib/rand.c
> @@ -156,7 +156,7 @@ void __fill_random_buf_percentage(unsigned long seed, void *buf,
>                 /*
>                  * Fill random chunk
>                  */
> -               this_len = (segment * (100 - percentage)) / 100;
> +               this_len = ((unsigned long long)segment * (100 - percentage)) / 100;
>                 if (this_len > len)
>                         this_len = len;
>

-- 
Sitsofe | http://sucs.org/~sits/


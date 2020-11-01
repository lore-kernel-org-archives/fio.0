Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
References: <20201005170854.25544-1-ykorman@gmail.com>
In-Reply-To: <20201005170854.25544-1-ykorman@gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sun, 1 Nov 2020 09:20:14 +0000
Message-ID: <CALjAwxhSFwRs7HD=4GR9OhmWWj7uyNCRY3XEc077H-AePsYHog@mail.gmail.com>
Subject: Re: [PATCH] fio: fix dynamic engines soname definition
Content-Type: text/plain; charset="UTF-8"
To: Yigal Korman <ykorman@gmail.com>
Cc: fio <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

Did this one get overlooked? CC'ing Jens...


On Mon, 5 Oct 2020 at 18:17, Yigal Korman <ykorman@gmail.com> wrote:
>
> The SONAME of the engines should not match the name of the dependent
> library. Otherwise it confuses the dynamic loader into thinking the
> dependency is already resolved.
>
> Prefixing the name with fio make more sense here.
>
> Signed-off-by: Yigal Korman <ykorman@gmail.com>
> ---
>  Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/Makefile b/Makefile
> index 5ed8a808..48788f24 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -569,7 +569,7 @@ endif
>
>  ifdef CONFIG_DYNAMIC_ENGINES
>  engines/lib$(1).so: $$($(1)_OBJS)
> -       $$(QUIET_LINK)$(CC) -shared -rdynamic -fPIC -Wl,-soname,lib$(1).so.1 $$($(1)_LIBS) -o $$@ $$<
> +       $$(QUIET_LINK)$(CC) -shared -rdynamic -fPIC -Wl,-soname,fio-$(1).so.1 $$($(1)_LIBS) -o $$@ $$<
>  endif
>
>  clean: FORCE
> --
> 2.17.1
>


--
Sitsofe | http://sucs.org/~sits/


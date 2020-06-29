Return-Path: <jmoyer@redhat.com>
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH v1 3/3] fio: suggest installing engine package when missing
References: <cover.1592981060.git.ykorman@gmail.com>
	<cover.1592981060.git.ykorman@gmail.com>
	<678d10332ad5edb5d076d0fe94a833fe595a3020.1592981060.git.ykorman@gmail.com>
Date: Mon, 29 Jun 2020 11:25:30 -0400
In-Reply-To: <678d10332ad5edb5d076d0fe94a833fe595a3020.1592981060.git.ykorman@gmail.com>
	(Yigal Korman's message of "Sun, 28 Jun 2020 22:27:58 +0300")
Message-ID: <x49zh8l28t1.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
To: Yigal Korman <ykorman@gmail.com>
Cc: axboe@kernel.dk, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Yigal Korman <ykorman@gmail.com> writes:

> Signed-off-by: Yigal Korman <ykorman@gmail.com>
> ---
>  ioengines.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/ioengines.c b/ioengines.c
> index 78262bc1..20224e59 100644
> --- a/ioengines.c
> +++ b/ioengines.c
> @@ -79,10 +79,16 @@ static struct ioengine_ops *find_ioengine(const char *name)
>  static void *dlopen_external(struct thread_data *td, const char *engine)
>  {
>  	char engine_path[PATH_MAX];
> +	void *dlhandle;
>  
>  	sprintf(engine_path, "%s/lib%s.so", FIO_EXT_ENG_DIR, engine);
>  
> -	return dlopen(engine_path, RTLD_LAZY);
> +	dlhandle = dlopen(engine_path, RTLD_LAZY);
> +	if (!dlhandle)
> +		log_info("Engine not available; Install the fio-engine-%s package\n",
> +			 engine);
> +
> +	return dlhandle;
>  }
>  #else
>  #define dlopen_external(td, engine) (NULL)

This assumes fio is part of a package, and that's not always (often?)
the case.  It may be that the engine simply wasn't built.

-Jeff



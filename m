Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] Fio's initial RTEMS port
References: <1531732006-11136-1-git-send-email-dev.madaari@gmail.com>
 <1531732006-11136-2-git-send-email-dev.madaari@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <246d6db1-ae2f-a4aa-9ca7-d305245b55dc@kernel.dk>
Date: Tue, 24 Jul 2018 09:47:30 -0600
MIME-Version: 1.0
In-Reply-To: <1531732006-11136-2-git-send-email-dev.madaari@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: dev.madaari@gmail.com, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 7/16/18 3:06 AM, dev.madaari@gmail.com wrote:
> diff --git a/cgroup.c b/cgroup.c
> index 77e31a4..0a3d372 100644
> --- a/cgroup.c
> +++ b/cgroup.c
> @@ -224,7 +224,12 @@ out:
>  	sfree(mnt);
>  }
>  
> -static void fio_init cgroup_init(void)
> +#ifdef __rtems__
> +void
> +#else /* __rtems__ */
> +static void fio_init
> +#endif /* __rtems__ */
> +cgroup_init(void)

For all of these, just make the non-static for all platforms. I don't
like having stuff like this all over the generic code. If need be,
fio_init can be different for rtems.

> diff --git a/crc/xxhash.h b/crc/xxhash.h
> index 8850d20..81bf51d 100644
> --- a/crc/xxhash.h
> +++ b/crc/xxhash.h
> @@ -107,9 +107,16 @@ XXH32() :
>  // Advanced Hash Functions
>  //****************************
>  
> +/* Unlike most desktop OS, In Newlib unsigned int and uint32_t are different */
> +#ifndef __rtems__
>  void*         XXH32_init   (unsigned int seed);
>  XXH_errorcode XXH32_update (void* state, const void* input, int len);
>  unsigned int  XXH32_digest (void* state);
> +#else /* __rtems__ */
> +void*         XXH32_init   (uint32_t seed);
> +XXH_errorcode XXH32_update (void* state, const void* input, int len);
> +uint32_t  XXH32_digest (void* state);
> +#endif /* __rtems__ */

Same for this stuff, there's no need for this to be any different for
rtems.

> diff --git a/fio.c b/fio.c
> index f19db1b..d4e0821 100644
> --- a/fio.c
> +++ b/fio.c
> @@ -65,3 +65,6 @@ done:
>  	deinitialize_fio();
>  	return ret;
>  }
> +#ifdef __rtems__
> +#include <os/rtems/rtems-fio-wrap.h>
> +#endif /* __rtems__ */

Put that in your OS header.

> diff --git a/fio.h b/fio.h
> index 3ac552b..e382eb7 100644
> --- a/fio.h
> +++ b/fio.h
> @@ -785,7 +785,11 @@ static inline void td_flags_clear(struct thread_data *td, unsigned int *flags,
>  	if (!td_async_processing(td))
>  		*flags &= ~value;
>  	else
> +#ifndef __rtems__
>  		__sync_fetch_and_and(flags, ~value);
> +#else /* __rtems__ */
> +		atomic_fetch_and_explicit(flags, ~value, memory_order_relaxed);
> +#endif /* __rtems__ */

Handle this in your OS header as well.

> diff --git a/fio_sem.c b/fio_sem.c
> index 3b48061..b5bc9c2 100644
> --- a/fio_sem.c
> +++ b/fio_sem.c
> @@ -56,9 +56,15 @@ struct fio_sem *fio_sem_init(int value)
>  {
>  	struct fio_sem *sem = NULL;
>  
> +#ifndef __rtems__
>  	sem = (void *) mmap(NULL, sizeof(struct fio_sem),
>  				PROT_READ | PROT_WRITE,
>  				OS_MAP_ANON | MAP_SHARED, -1, 0);
> +#else /* __rtems__ */
> +	sem = (void *) mmap(NULL, sizeof(struct fio_sem),
> +				PROT_READ | PROT_WRITE,
> +				OS_MAP_ANON | MAP_PRIVATE, -1, 0);
> +#endif /* __rtems__ */

Hmm?

General comment - everytime you feel the need to add an ifdef __rtems__
(or ifndef), you are going down the wrong path. Look at how the other OS
types handle special cases and mimic that approach. Looks like your main
difference is that you have to call initializers manually, which is a
bit nasty. But differences in types etc should not be handled by having
ifdefs in the generic code.

-- 
Jens Axboe



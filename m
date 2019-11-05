Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
References: <20191005164319.1341600-1-raj.khem@gmail.com>
In-Reply-To: <20191005164319.1341600-1-raj.khem@gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Tue, 5 Nov 2019 05:46:02 +0000
Message-ID: <CALjAwxiy4upAq6fHG9XCCj+rzZrWVX_LFTwz7x_CrBKqdMkeKQ@mail.gmail.com>
Subject: Re: [PATCH] arch-arm: Consider armv7ve arch as well
Content-Type: text/plain; charset="UTF-8"
To: Khem Raj <raj.khem@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, fio <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Hi Khem,

It might have been nicer for 7VE to come before 8A but it's easy to
get the gist...

Jens - I think this patch may have been overlooked...

On Sat, 5 Oct 2019 at 17:45, Khem Raj <raj.khem@gmail.com> wrote:
>
> Signed-off-by: Khem Raj <raj.khem@gmail.com>
> ---
>  arch/arch-arm.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arch-arm.h b/arch/arch-arm.h
> index 78cb2ebe..4f722967 100644
> --- a/arch/arch-arm.h
> +++ b/arch/arch-arm.h
> @@ -11,7 +11,7 @@
>  #define nop             __asm__ __volatile__("mov\tr0,r0\t@ nop\n\t")
>  #define read_barrier() __asm__ __volatile__ ("" : : : "memory")
>  #define write_barrier()        __asm__ __volatile__ ("" : : : "memory")
> -#elif defined(__ARM_ARCH_7A__) || defined(__ARM_ARCH_8A__)
> +#elif defined(__ARM_ARCH_7A__) || defined(__ARM_ARCH_8A__) || defined(__ARM_ARCH_7VE__)
>  #define        nop             __asm__ __volatile__ ("nop")
>  #define read_barrier() __sync_synchronize()
>  #define write_barrier()        __sync_synchronize()
> --
> 2.23.0
>

-- 
Sitsofe | http://sucs.org/~sits/


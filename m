Return-Path: <axboe@kernel.dk>
Message-ID: <54EE375B.3060000@kernel.dk>
Date: Wed, 25 Feb 2015 13:58:03 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] Add missing pre-defined ARM arch compiler macro
References: <1424872660-20240-1-git-send-email-raphael.philipe@ossystems.com.br>
In-Reply-To: <1424872660-20240-1-git-send-email-raphael.philipe@ossystems.com.br>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
To: Raphael Silva <rapphil@gmail.com>, fio@vger.kernel.org
Cc: Raphael Silva <raphael.philipe@ossystems.com.br>
List-ID: <fio@vger.kernel.org>

On 02/25/2015 06:57 AM, Raphael Silva wrote:
> Signed-off-by: Raphael Silva <raphael.philipe@ossystems.com.br>
> ---
>  arch/arch-arm.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arch-arm.h b/arch/arch-arm.h
> index 7cd9502..bab886e 100644
> --- a/arch/arch-arm.h
> +++ b/arch/arch-arm.h
> @@ -19,7 +19,8 @@
>  #endif
>  
>  #if defined (__ARM_ARCH_4__) || defined (__ARM_ARCH_4T__) \
> -	|| defined (__ARM_ARCH_5__) || defined (__ARM_ARCH_5T__) || defined (__ARM_ARCH_5TE__) || defined (__ARM_ARCH_5TEJ__) \
> +	|| defined (__ARM_ARCH_5__) || defined (__ARM_ARCH_5T__) || defined (__ARM_ARCH_5E__)\
> +	|| defined (__ARM_ARCH_5TE__) || defined (__ARM_ARCH_5TEJ__) \
>  	|| defined(__ARM_ARCH_6__)  || defined(__ARM_ARCH_6J__) || defined(__ARM_ARCH_6Z__) || defined(__ARM_ARCH_6ZK__)
>  #define nop             __asm__ __volatile__("mov\tr0,r0\t@ nop\n\t")
>  #define read_barrier()	__asm__ __volatile__ ("" : : : "memory")

Added, thanks.

-- 
Jens Axboe



Return-Path: <axboe@kernel.dk>
Date: Thu, 13 Feb 2014 09:18:16 -0700
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] cpuid: Null terminate x86 CPU string.
Message-ID: <20140213161816.GE10926@kernel.dk>
References: <20140213060742.GA1847@sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140213060742.GA1847@sucs.org>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On Thu, Feb 13 2014, Sitsofe Wheeler wrote:
> Signed-off-by: Sitsofe Wheeler <sitsofe@yahoo.com>
> ---
>  arch/arch-x86-common.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arch-x86-common.h b/arch/arch-x86-common.h
> index 179572d..26a14a8 100644
> --- a/arch/arch-x86-common.h
> +++ b/arch/arch-x86-common.h
> @@ -60,6 +60,7 @@ static inline int arch_init(char *envp[])
>  			 (unsigned int *) &str[8],
>  			 (unsigned int *) &str[4]);
>  
> +	str[11] = '\0';
>  	if (!strcmp(str, "GenuineIntel"))
>  		tsc_reliable = arch_init_intel(level);
>  	else if (!strcmp(str, "AuthenticAMD"))

Applied, thanks.

-- 
Jens Axboe



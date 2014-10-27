Return-Path: <axboe@kernel.dk>
Message-ID: <544E5BA4.1070505@kernel.dk>
Date: Mon, 27 Oct 2014 08:50:12 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH v4] fio: Fix padding properly
References: <544ABB51.1040107@kernel.dk> <1414278272-14168-1-git-send-email-gwendal@chromium.org>
In-Reply-To: <1414278272-14168-1-git-send-email-gwendal@chromium.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
To: Gwendal Grignou <gwendal@chromium.org>
Cc: fio@vger.kernel.org, vapier@chromium.org, puthik@chromium.org
List-ID: <fio@vger.kernel.org>

On 10/25/2014 05:04 PM, Gwendal Grignou wrote:
> diff --git a/stat.h b/stat.h
> index 16b3d1a..db83f65 100644
> --- a/stat.h
> +++ b/stat.h
> @@ -158,6 +158,8 @@ struct thread_stat {
>  	uint32_t io_u_lat_u[FIO_IO_U_LAT_U_NR];
>  	uint32_t io_u_lat_m[FIO_IO_U_LAT_M_NR];
>  	uint32_t io_u_plat[DDIR_RWDIR_CNT][FIO_IO_U_PLAT_NR];
> +	uint32_t pad;
> +
>  	uint64_t total_io_u[3];
>  	uint64_t short_io_u[3];
>  	uint64_t drop_io_u[3];
> @@ -171,8 +173,10 @@ struct thread_stat {
>  	/*
>  	 * IO Error related stats
>  	 */
> -	uint16_t continue_on_error;
> -	uint16_t filler[3];
> +	union {
> +		uint16_t continue_on_error;
> +		uint64_t pad;
> +	};
>  	uint64_t total_err_count;
>  	uint32_t first_error;
>  

These two hunks are both in struct thread_stat, the compile wont be
happy about the duplicate naming...

-- 
Jens Axboe



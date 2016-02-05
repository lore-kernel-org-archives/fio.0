Return-Path: <axboe@kernel.dk>
Subject: Re: Copy/paste nit in io_ddir.h?
References: <CANvN+emGxSfGdx=XO9_Lgfgjuybd1+PDJMW1xsMN-LVUQFw_Cw@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <56B4BC11.6050909@kernel.dk>
Date: Fri, 5 Feb 2016 08:13:21 -0700
MIME-Version: 1.0
In-Reply-To: <CANvN+emGxSfGdx=XO9_Lgfgjuybd1+PDJMW1xsMN-LVUQFw_Cw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 02/05/2016 01:59 AM, Andrey Kuzmin wrote:
> diff --git a/io_ddir.h b/io_ddir.h
> index e5eff68..071b036 100644
> --- a/io_ddir.h
> +++ b/io_ddir.h
> @@ -17,7 +17,7 @@ enum fio_ddir {
>   static inline const char *io_ddir_name(enum fio_ddir ddir)
>   {
>          const char *name[] = { "read", "write", "trim", "sync", "datasync",
> -                               "sync_file_range", "write", };
> +                               "sync_file_range", "wait", };
>          if (ddir < DDIR_LAST)
>                  return name[ddir];

Indeed, thanks, applied.

-- 
Jens Axboe



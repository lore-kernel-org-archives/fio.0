Return-Path: <axboe@kernel.dk>
Subject: Re: io_size vs. time_based discrepancy
References: <CANvN+e=pcwpAMe0U_UhpLKAR1Rrt8uM9T3b7CrLqFjZZMb8XaQ@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <565C8515.40200@kernel.dk>
Date: Mon, 30 Nov 2015 10:19:17 -0700
MIME-Version: 1.0
In-Reply-To: <CANvN+e=pcwpAMe0U_UhpLKAR1Rrt8uM9T3b7CrLqFjZZMb8XaQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 11/30/2015 03:52 AM, Andrey Kuzmin wrote:
> I'm witnessing an annoying discrepancy between the outcome of the same
> job when being run as io_size-based vs. time_based. In the former
> mode, the job does exactly what I want it to do, writing the
> prescribed amount of data randomly w/o being concerned whether that
> total bytes written is in any way related to the target file size.
>
> On the contrary, in the latter mode that same job, after writing the
> file's size worth of bytes, resets random generator and essentially
> restarts the just completed loop. The offending code is below, and the
> suggested fix brings back home the io_size-like behavior when running
> time-based. Nonetheless, I'm in doubt regarding whether the do_io loop
> break-out below was intended to support the designed behavior (looks
> unlikely to me, as looping like that is produced by the 'loops'
> option, although time_based definition under HOWTO is rather unclear
> in this regard) or is a bug worth fixing.
>
> Regards,
> Andrey
>
> diff --git a/backend.c b/backend.c
> index 4e192e3..c7584a0 100644
> --- a/backend.c
> +++ b/backend.c
> @@ -868,7 +868,7 @@ static uint64_t do_io(struct thread_data *td)
>                  if (flow_threshold_exceeded(td))
>                          continue;
>
> -               if (bytes_issued >= total_bytes)
> +               if (!td->o.time_based && bytes_issued >= total_bytes)
>                          break;
>
>                  io_u = get_io_u(td);

I think the patch is fine. The general worry is that we get stuck in a 
loop not finding new work, but the get_io_u() should bail out for that 
case for us. I'll apply your patch, thanks.

-- 
Jens Axboe



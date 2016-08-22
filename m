Return-Path: <matorola@gmail.com>
MIME-Version: 1.0
In-Reply-To: <2dffb54c-6f7d-5a3b-8b47-54cba6dd6039@kernel.dk>
References: <CADxRZqwnO-UuLgAkDb4bvqVY9hMMSnFFcdkYdPnfwfJukN09yA@mail.gmail.com>
 <2dffb54c-6f7d-5a3b-8b47-54cba6dd6039@kernel.dk>
From: Anatoly Pugachev <matorola@gmail.com>
Date: Mon, 22 Aug 2016 22:17:24 +0300
Message-ID: <CADxRZqzjZFOR8uV9WVEQvd=Qk_WjWoK3L1zWcDuABhzoic5KxA@mail.gmail.com>
Subject: Re: [sparc64] fio bus error
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, sparclinux@vger.kernel.org, debian-sparc <debian-sparc@lists.debian.org>
List-ID: <fio@vger.kernel.org>

On Mon, Aug 22, 2016 at 8:32 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On 08/20/2016 09:19 AM, Anatoly Pugachev wrote:
>> Thread 2 "fio" received signal SIGBUS, Bus error.
>> [Switching to Thread 0xffff80011025b910 (LWP 15753)]
>> calc_log_samples () at stat.c:2461
>> 2461                            tmp = add_bw_samples(td, &now);
>> (gdb) bt
>> #0  calc_log_samples () at stat.c:2461
>> #1  0x000000000018e944 in helper_thread_main (data=0xffff800100ac5670)
>> at helper_thread.c:121
>> #2  0xffff80010063ba04 in start_thread (arg=0xffff80011025b910) at
>> pthread_create.c:335
>> #3  0xffff800100944f58 in __thread_start () at
>> ../sysdeps/unix/sysv/linux/sparc/sparc64/clone.S:93
>> Backtrace stopped: previous frame identical to this frame (corrupt stack?)
>> (gdb)
>
>
> Does this help?
>
> diff --git a/stat.c b/stat.c
> index 552d88dde067..74c2686c660c 100644
> --- a/stat.c
> +++ b/stat.c
> @@ -2457,12 +2457,12 @@ int calc_log_samples(void)
>                         next = min(td->o.iops_avg_time, td->o.bw_avg_time);
>                         continue;
>                 }
> -               if (!per_unit_log(td->bw_log)) {
> +               if (td->bw_log && !per_unit_log(td->bw_log)) {
>                         tmp = add_bw_samples(td, &now);
>                         if (tmp < next)
>                                 next = tmp;
>                 }
> -               if (!per_unit_log(td->iops_log)) {
> +               if (td->iops_log && !per_unit_log(td->iops_log)) {
>                         tmp = add_iops_samples(td, &now);
>                         if (tmp < next)
>                                 next = tmp;
>


Jens,

yes, this patch fixed sigbus. Thanks.


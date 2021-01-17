Return-Path: <glqinhongwei@gmail.com>
MIME-Version: 1.0
References: <cover.1610876646.git.glqinhongwei@gmail.com> <d1a6de3435104ed9092c1520b5c5c6fe59b52239.1610876646.git.glqinhongwei@gmail.com>
In-Reply-To: <d1a6de3435104ed9092c1520b5c5c6fe59b52239.1610876646.git.glqinhongwei@gmail.com>
From: Hongwei Qin <glqinhongwei@gmail.com>
Date: Sun, 17 Jan 2021 20:48:03 +0800
Message-ID: <CAKvRR0ShEVPV=YdC_kiFtoDEyJ9AG_QYZ2GShQjQH6k4aocT9A@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] Fix thinktime_blocks
Content-Type: text/plain; charset="UTF-8"
To: fio@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, sitsofe@gmail.com
List-ID: <fio@vger.kernel.org>

Hi Sitsofe,

>
> At this point wouldn't it be better to update the help to reflect the
> code rather than the other way around?
>

Consider this configuration:
[global]
thread
kb_base=1000
direct=1
size=28GiB
group_reporting
io_size=64KiB
ioengine=libaio
iodepth=32
bs=4096
filename=/dev/qblkdev

[fio_randwrite]
rw=randwrite
thinktime_blocks=4
thinktime=1s

I write this job file to simulate a data server that periodically
writes back a certain amount of data (In this case,16KiB per second).
Note that we cannot use the rate_iops here because it will send 1 request
per 250ms.
If we keep the code as it is, the job will finish immediately after
the test starts.
And this is usually not what the user wants.

Or, should we introduce a new parameter to distinguish between
"think after finish" and "think after issue"?

Regards,
Hongwei

On Sun, Jan 17, 2021 at 5:54 PM HongweiQin <glqinhongwei@gmail.com> wrote:
>
> According to the manual, the thinktime_blocks controls how many blocks to issue (instead of complete) before waiting.
>
> Signed-off-by: HongweiQin <glqinhongwei@gmail.com>
> ---
>  backend.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/backend.c b/backend.c
> index e20a2e0..c85669c 100644
> --- a/backend.c
> +++ b/backend.c
> @@ -864,7 +864,7 @@ static void handle_thinktime(struct thread_data *td, enum fio_ddir ddir)
>         uint64_t total;
>         int left;
>
> -       b = ddir_rw_sum(td->io_blocks);
> +       b = ddir_rw_sum(td->io_issues);
>         if (b % td->o.thinktime_blocks)
>                 return;
>
> --
> 1.8.3.1
>


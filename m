Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAEyTGCdUUN=3vUUJzN9zSdQg5CsRPm1vdBvoTkOMhxrnKtJ_bA@mail.gmail.com>
References: <CAEyTGCdUUN=3vUUJzN9zSdQg5CsRPm1vdBvoTkOMhxrnKtJ_bA@mail.gmail.com>
Date: Sat, 7 Feb 2015 07:02:32 +0000
Message-ID: <CALjAwxhk4qqPsRuvvsdJuGBPTvLVdup3=60MxJE=m3o11abDEw@mail.gmail.com>
Subject: Re: io_u->flags & IO_U_F_FLIGHT failed errors when using libaio
From: Sitsofe Wheeler <sitsofe@gmail.com>
Content-Type: text/plain; charset=UTF-8
To: Lakshmi <sendtold@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 6 February 2015 at 20:03, Lakshmi <sendtold@gmail.com> wrote:
>
> cmd="$FIO --name=test  --group_reporting=1 --ioengine=libaio
> --invalidate=1 --iodepth=32 --bs=4K --filename=/dev/sde --rw=randread
> --direct=1 --buffered=0 --time_based --runtime=300 --numjobs=64"

I could be wrong but doesn't an iodepth of 32 and 64 jobs means that
you would try and queue up 2048 (32*64) 4K I/Os on the same disk at
once? Does /dev/sde really have a queue depth that high (cat
/sys/block/sde/queue/nr_requests will tell you the kernel side) and is
that your intent?

-- 
Sitsofe | http://sucs.org/~sits/


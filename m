Return-Path: <andrey.v.kuzmin@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAEyTGCdUUN=3vUUJzN9zSdQg5CsRPm1vdBvoTkOMhxrnKtJ_bA@mail.gmail.com>
References: <CAEyTGCdUUN=3vUUJzN9zSdQg5CsRPm1vdBvoTkOMhxrnKtJ_bA@mail.gmail.com>
From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Date: Sat, 7 Feb 2015 01:12:09 +0400
Message-ID: <CANvN+ekhc-H==0tjrsUTkHDcb-GLBoCbuczgHiaNAjWP1fhc5A@mail.gmail.com>
Subject: Re: io_u->flags & IO_U_F_FLIGHT failed errors when using libaio
Content-Type: text/plain; charset=UTF-8
To: Lakshmi <sendtold@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On Fri, Feb 6, 2015 at 11:03 PM, Lakshmi <sendtold@gmail.com> wrote:
> Hi Jens,
>    I have a job file that looks like below and it keeps giving errors
> like attached in screen shot. I am using fio-2.2.4
>
> cmd="$FIO --name=test  --group_reporting=1 --ioengine=libaio
> --invalidate=1 --iodepth=32 --bs=4K --filename=/dev/sde --rw=randread
> --direct=1 --buffered=0 --time_based --runtime=300 --numjobs=64"

While t's perfectly legal, you're setting a rather large total io
depth for a single device (32 by 64), but otherwise the job seems fine
(and runs fine against a regular file with fio 2.2.5 here). If the bug
persists, you might want to rerun it under gdb to get a clue (such as
to print out the io_u that triggers the assert).

Regards,
Andrey

>
> Any idea what is causing this?
>
> Thanks
> LD


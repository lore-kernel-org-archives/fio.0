Return-Path: <axboe@kernel.dk>
Message-ID: <54D52E8C.4060803@kernel.dk>
Date: Fri, 06 Feb 2015 14:13:48 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: io_u->flags & IO_U_F_FLIGHT failed errors when using libaio
References: <CAEyTGCdUUN=3vUUJzN9zSdQg5CsRPm1vdBvoTkOMhxrnKtJ_bA@mail.gmail.com>
In-Reply-To: <CAEyTGCdUUN=3vUUJzN9zSdQg5CsRPm1vdBvoTkOMhxrnKtJ_bA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Lakshmi <sendtold@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 02/06/2015 01:03 PM, Lakshmi wrote:
> Hi Jens,
>    I have a job file that looks like below and it keeps giving errors
> like attached in screen shot. I am using fio-2.2.4
> 
> cmd="$FIO --name=test  --group_reporting=1 --ioengine=libaio
> --invalidate=1 --iodepth=32 --bs=4K --filename=/dev/sde --rw=randread
> --direct=1 --buffered=0 --time_based --runtime=300 --numjobs=64"
> 
> Any idea what is causing this?

Is this on ppc64?


-- 
Jens Axboe



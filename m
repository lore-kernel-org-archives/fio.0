Return-Path: <axboe@kernel.dk>
Subject: Re: fio with polling mode
References: <CAFiDJ59S0zhHDNbbron+Q1X06kBZ2i24VXYzHrSbrr0ujAR74w@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <56E85B38.9010904@kernel.dk>
Date: Tue, 15 Mar 2016 11:58:00 -0700
MIME-Version: 1.0
In-Reply-To: <CAFiDJ59S0zhHDNbbron+Q1X06kBZ2i24VXYzHrSbrr0ujAR74w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Ley Foon Tan <lftan.linux@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 03/15/2016 04:20 AM, Ley Foon Tan wrote:
> Hi
>
> In the kernel v4.4 above, we can use polling mode for the NVMe data
> transfer with command below:
>
> echo 1 > /sys/block/nvme0n1/queue/io_poll
>
> We can see NVMe throughput increase with polling mode with dd command.
> Can we run fio with polling mode as well? If yes, what are the correct
> fio parameters/arguments should we use?

direct=1, and use one of the sync IO engines (psync would be a good 
one). And enable io_poll like you did above, then fio should be in 
polled mode.

-- 
Jens Axboe



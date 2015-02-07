Return-Path: <axboe@kernel.dk>
Message-ID: <54D6476B.8070200@kernel.dk>
Date: Sat, 07 Feb 2015 10:12:11 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: io_u->flags & IO_U_F_FLIGHT failed errors when using libaio
References: <CAEyTGCdUUN=3vUUJzN9zSdQg5CsRPm1vdBvoTkOMhxrnKtJ_bA@mail.gmail.com> <54D52E8C.4060803@kernel.dk> <94D849AD-CCC8-4DE5-842D-A5AA16F789CA@gmail.com>
In-Reply-To: <94D849AD-CCC8-4DE5-842D-A5AA16F789CA@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Of <sendtold@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 02/06/2015 04:32 PM, Of wrote:
> Yes Jens it is ppc64

I'm pretty sure we have some memory ordering issues, or perhaps the 
barriers on ppc64 are just wrong. I'll have to check them.

The job:

>>> cmd="$FIO --name=test  --group_reporting=1 --ioengine=libaio
>>> --invalidate=1 --iodepth=32 --bs=4K --filename=/dev/sde --rw=randread
>>> --direct=1 --buffered=0 --time_based --runtime=300 --numjobs=64"

does indeed have 32 * 64 potentially pending, which is huge. So there 
are valid questions on whether this is really what you want. But 
regardless of that, it should not pose a problem for fio.

Is this on Linux? If so, can you send the output of /proc/cpuinfo, so I 
can see what CPU this is exactly.

-- 
Jens Axboe



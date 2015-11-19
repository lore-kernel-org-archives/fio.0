Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] Fix ETA calculations
References: <1447944744.32482.13.camel@x-ion.de>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <564E31D5.6040800@kernel.dk>
Date: Thu, 19 Nov 2015 13:32:21 -0700
MIME-Version: 1.0
In-Reply-To: <1447944744.32482.13.camel@x-ion.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Jens Rosenboom <j.rosenboom@x-ion.de>, Fio <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 11/19/2015 07:52 AM, Jens Rosenboom wrote:
> There are a couple of issues in eta.c:
>
> - The comparison for time- vs. rate-based ETA calculation is done the
>    wrong way round.
> - The elapsed ramp time should only be subtracted when the thread has
>    indeed entered the ramp phase.
> - Currently jobs that are stonewalled are not taken into account for ETA
>    calculation. This patch at least fixes this for the case that there is
>    only a single job per stonewall group.
> ---
>
> This patch tries to fix some issues I have found, this may
> also be related to the ones mentioned earlier in
> http://www.spinics.net/lists/fio/msg04187.html
>
> The part regarding stonewalled jobs may require some further work, but
> at least it gives proper values now for my standard fio runs containing
> just a sequence of singular jobs.

Thanks this is great, I'll get this applied and tested.

> Also, I'm still wondering about the intention behind the way done_secs
> is meant to work. It cumulates time spent in finished jobs globally, but
> is being used in per-job ETA calculations. This seems to break at
> least for the case of stonewalled jobs, too.

The eta output could use some love, no doubt about that. It could easily 
be a lot more clever wrt multiple jobs, fluctuations, etc.

-- 
Jens Axboe



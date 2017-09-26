Return-Path: <axboe@kernel.dk>
Subject: Re: Fixing CPU clock mismatch error in --cpuclock-test
References: <6ccd72db-3698-3132-2bcb-76e3a7dc958f@bluestop.org>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <24d22a5f-6e4d-6eda-aa9c-185733997dc7@kernel.dk>
Date: Tue, 26 Sep 2017 20:37:15 +0200
MIME-Version: 1.0
In-Reply-To: <6ccd72db-3698-3132-2bcb-76e3a7dc958f@bluestop.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Rebecca Cran <rebecca@bluestop.org>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 09/26/2017 07:15 PM, Rebecca Cran wrote:
> Hi,
> 
> I'm working on adding CPU clock support to AARCH64. But I'm getting 
> messages like the following when I run --cpuclock-test :
> 
> cs: CPU clock mismatch (diff=158):
>           CPU  0: TSC=13558679258196, SEQ=383792
>           CPU  1: TSC=13558679258038, SEQ=383793
> cs: CPU clock mismatch (diff=54):
>           CPU  0: TSC=13558679258924, SEQ=383850
>           CPU  1: TSC=13558679258870, SEQ=383851
> cs: CPU clock mismatch (diff=52):
>           CPU  0: TSC=13558679259752, SEQ=383906
>           CPU  1: TSC=13558679259700, SEQ=383907
> cs: Failed: 2772
> 
> 
> Are these likely a problem with the platform, or something that can be 
> fixed in fio?

It's either a problem with the platform, or a bug in the code that fio
has to check whether or not the CPU clocks are synced. What the above is
saying, if we take the first one, is that a lower numbered sequence
(383792) on CPU0 had a higher TSC cycle count than a higher sequenced
entry from CPU1. This would mean that fio would potentially see the
clock going back in time.

What does your platform guarantee? For x86, fully synced TSC means
that the above can never happen. If you look at the code in fio, it's
basically (on each CPU):

c->seq = atomic32_inc_return(t->seq);
c->tsc = get_cpu_clock();
add_c_to_global_list();

and each CPU will run this in parallel. I guess the code isn't
completely bullet proof, we could have something like this going on:

CPU0				CPU1
atomic32_inc_return(x)
[stalled]			atomic32_inc_return(x);
				tsc = get_cpu_clock();
tsc = get_cpu_clock()

and for that case, CPU0 would have a lower sequence, but a later TSC
count. Never seen that hit on x86, but it does look possible.

Usually when the TSC isn't synced, you'll get get grossly invalid
entries. Yours are very close, which makes me suspicious that you might
be hitting the above race.

I'll give some thought as to how we can close that tiny hole. We'd
really need the inc/tsc_get to be one atomic instruction, but I don't
want to add locking as it pretty much defeats the purpose of it.

-- 
Jens Axboe



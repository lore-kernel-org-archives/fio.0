Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qk0-f177.google.com ([209.85.220.177]:34827 "EHLO
	mail-qk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880AbcGNSsI (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 14 Jul 2016 14:48:08 -0400
Received: by mail-qk0-f177.google.com with SMTP id s63so81027105qkb.2
        for <fio@vger.kernel.org>; Thu, 14 Jul 2016 11:48:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <19326c3d-bfdc-09ab-88ba-034206c7d4aa@gmail.com>
References: <CAJ9yE1D_J5hvq_=vJ_DbgYy5nrQM0bC_nMhRKziDWjnbw23i-w@mail.gmail.com>
 <19326c3d-bfdc-09ab-88ba-034206c7d4aa@gmail.com>
From: Karl Cronburg <kcronbur@redhat.com>
Date: Thu, 14 Jul 2016 14:48:07 -0400
Message-ID: <CAJ9yE1AqxZwwcMfZWjfuVQQaTe5oamNGHrvu92_L46eP=cQ4JA@mail.gmail.com>
Subject: Re: fiologparser
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Mark Nelson <mark.a.nelson@gmail.com>
Cc: fio@vger.kernel.org

On Thu, Jul 14, 2016 at 12:29 PM, Mark Nelson <mark.a.nelson@gmail.com> wrote:
>
>
> On 07/14/2016 10:35 AM, Karl Cronburg wrote:
>>
>> Hello all,
>>
>> I have written a new version of fiologparser and could use some feedback
>> from anyone who uses the tool regularly. It is on branch fiologparser of
>> my fork
>> of fio:
>>
>> https://github.com/cronburg/fio/blob/fiologparser/tools/fiologparser.py
>>
>> It uses numpy and cython to speed up the data parsing and percentile
>> calculations,
>> while decreasing the memory footprint and making it scalable.
>
>
> I was really trying to avoid the extra dependencies. :/  That's why Ben's
> last commit was reworked so we could avoid adding numpy as a dependency in
> the fio distribution (not that fio itself would need it, but it would be
> really swell if none of the tools needed anything other than stock python).
>
> How much improvement are you seeing and where is the speedup coming from?  I

All the speedup is coming from using dedicated parsing libraries (pandas),
numpy arrays (with vector math) instead of python lists, and streaming smaller
portions of the data at a time into memory.

On a single 39 MB latency log file it takes ~ a tenth of a second per
interval to calculate
percentiles for each interval whereas the one in wip-interval (with
slight modification
to stop a NoneType error) takes 5+ seconds per interval.

> suspect we can get similar gains without needing to bring it in.  For now
> though I really think we need to worry about correctness rather than speed.

I would think someone running python on a large data set would be more than
willing to install something as widely used and supported as numpy. If anything
numpy gives us better correctness guarantees and less technical debt.

Who else is using / wants the percentiles fiologparser is calculating? If enough
users are put-off by the dependencies I understand, the data scientist
in me is just
really sad that the exact thing numpy was built for is being re-engineered.

> As such, does this version use a similar technique as what's in
> wip-interval?

Yes - weighted percentiles are calculated using the fraction of a
sample falling in
the given interval.

>
> https://github.com/markhpc/fio/commits/wip-interval
>
> If so, we should probably merge that first and make sure we have test cases
> for it to make sure the idea is sound.  If this is something new, it would
> be good to showcase that it's as good or better than wip-interval.  I could
> easily be convinced that it is, but let's demonstrate it.

Will do - I'll make some test cases to see where wip-interval differs
with this implementation.
If anything I figure it's good to maintain both for now to see where
our thinking differs - just looking
at your code I wasn't even sure what numbers should be calculated, but
now that I've implemented
weighted latency percentiles myself I have a better idea what we want.

-Karl-

>
> Mark
>
>
>>
>> -Karl Cronburg-
>> --
>> To unsubscribe from this list: send the line "unsubscribe fio" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>

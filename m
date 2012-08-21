Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:63947 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753629Ab2HULf6 (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 21 Aug 2012 07:35:58 -0400
Received: by mail-bk0-f46.google.com with SMTP id j10so2150359bkw.19
        for <fio@vger.kernel.org>; Tue, 21 Aug 2012 04:35:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <503230E9.2000406@kernel.dk>
References: <CAHaS=Qz0FBWFh1o4avw5wTapGFTO8-argLW38mrdXHWLJ0-Ygg@mail.gmail.com>
	<CAHaS=QxJeWf-YvKkLktR45W2g-dRhEcXgM=7napOxb8ct7pKEg@mail.gmail.com>
	<503230E9.2000406@kernel.dk>
Date: Tue, 21 Aug 2012 21:35:57 +1000
Message-ID: <CAHaS=QzK4xhuu4vgqOQfNtLaVJE6kbsHtCj1A-BCCTFs=0eTYA@mail.gmail.com>
Subject: Re: Rate problems (Windows)
From: Greg Sullivan <greg.sullivan@sullivang.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

On 20 August 2012 22:43, Jens Axboe <axboe@kernel.dk> wrote:
> On 08/20/2012 03:42 AM, Greg Sullivan wrote:
>> On 19 August 2012 22:39, Greg Sullivan <greg.sullivan@sullivang.net> wrote:
>>> I'm finding that the throughput is varying wildly during a run - more
>>> than I think is probably normal. It happens regardless of whether I
>>> limit by data rate or io rate, although I think it's worse when I
>>> limit by io.
>>>
>>> Here is a test job followed by the output. The io rate fluctuated
>>> wildly - I watched it in the Windows Performance Monitor. The io rate
>>> should be extremely easy to maintain. The "CR=80" looks suspicious -
>>> why is there an 80 there when I requested 40?
>> [stuff removed]
>>
>> I tried the same test on Ubuntu, and I think it's working properly -
>> the iops figures displayed by fio are relatively constant as the test
>> runs.  (although I'm having trouble relating the the output of iostat
>> to the actual workload that should be generated) I still get the
>> CR=<double the requested rate> on Ubuntu, so I assume this is normal.
>> The iops figures over on the right of the output look kosher. (as they
>> do on Windows, except for the wide fluctuations)
>
> The CR=x/y reading is as follows:
>
> - x is the target read _and_ write commit rate. If your workload was a
>   read/write workload, it'd be 40 from each. I should change that, it's
>   confusing. But for now, suffice to say that it is to be expected and
>   the 40 is parsed/understood by fio.
> - y is the same, but the minimum rate (if that is set).
>
> See below patch, should make it more easily understandable.
>
> As to the Windows rate fluctuations - a quick guess would be that the
> timing is too coarse on Windows.
>
> diff --git a/eta.c b/eta.c
> index 9114595..552845d 100644
> --- a/eta.c
> +++ b/eta.c
> @@ -285,11 +285,18 @@ int calc_thread_status(struct jobs_eta *je, int force)
>                     || td->runstate == TD_FSYNCING
>                     || td->runstate == TD_PRE_READING) {
>                         je->nr_running++;
> -                       je->t_rate += td->o.rate[0] + td->o.rate[1];
> -                       je->m_rate += td->o.ratemin[0] + td->o.ratemin[1];
> -                       je->t_iops += td->o.rate_iops[0] + td->o.rate_iops[1];
> -                       je->m_iops += td->o.rate_iops_min[0] +
> -                                       td->o.rate_iops_min[1];
> +                       if (td_read(td)) {
> +                               je->t_rate += td->o.rate[DDIR_READ];
> +                               je->t_iops += td->o.rate_iops[DDIR_READ];
> +                               je->m_rate += td->o.ratemin[DDIR_READ];
> +                               je->m_iops += td->o.rate_iops_min[DDIR_READ];
> +                       }
> +                       if (td_write(td)) {
> +                               je->t_rate += td->o.rate[DDIR_WRITE];
> +                               je->t_iops += td->o.rate_iops[DDIR_WRITE];
> +                               je->m_rate += td->o.ratemin[DDIR_WRITE];
> +                               je->m_iops += td->o.rate_iops_min[DDIR_WRITE];
> +                       }
>                         je->files_open += td->nr_open_files;
>                 } else if (td->runstate == TD_RAMP) {
>                         je->nr_running++;
>
> --
> Jens Axboe
>

I have now done a basic test of the rate functionality on Ubuntu, and
it seems to be working fine. I am more confident now that there is
indeed a problem when running fio on Windows.

Greg.

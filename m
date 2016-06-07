Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-oi0-f52.google.com ([209.85.218.52]:35308 "EHLO
	mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755297AbcFGPsN convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Tue, 7 Jun 2016 11:48:13 -0400
Received: by mail-oi0-f52.google.com with SMTP id s139so44183186oie.2
        for <fio@vger.kernel.org>; Tue, 07 Jun 2016 08:48:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BN3PR0401MB1457F4D614F9E2A038D0D5D5F75C0@BN3PR0401MB1457.namprd04.prod.outlook.com>
References: <CAJ9yE1BYp_jqjwVVap1U-zjYfGT6bsOuXbOMcJV0r8Mz-5LQBQ@mail.gmail.com>
	<a67cead2-b23f-5cf3-cfc3-f1705989f9b4@gmail.com>
	<BN3PR0401MB1457F4D614F9E2A038D0D5D5F75C0@BN3PR0401MB1457.namprd04.prod.outlook.com>
Date: Tue, 7 Jun 2016 11:48:12 -0400
Message-ID: <CAJ9yE1ACX5kjrM7-F6q5SZJ1-P0EyVv0qY8y=Qxd3=ZzXi3K-g@mail.gmail.com>
Subject: Re: computing percentiles from fio data
From: Karl Cronburg <kcronbur@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jeff Furlong <jeff.furlong@hgst.com>
Cc: Mark Nelson <mark.a.nelson@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

Mark: The main insight of the algorithm(s) in the paper is that one
can get logarithmic space and time (per operation) usage in the number
of operations, with input parameters of a set of desired percentiles
and corresponding error bounds (e.g. 99th percentile with a strict
error bound of 1% on the value).

Jeff: Right, will keep that in mind. Outputting slightly different
statistics than what log_avg_msec outputs could solve this without
introducing any more overhead than log_avg_msec. I'm just not sure
what to output to then make it feasible to have a post-processing step
which gives strict error bounds on the percentiles.

-Karl-

On Mon, Jun 6, 2016 at 7:31 PM, Jeff Furlong <jeff.furlong@hgst.com> wrote:
> If you add some more logging or sorting options to fio, be sure that the extra overhead does not slow down fio in any way (decrease IOPs, increase latency, increase CPU utilization, etc.).  Having a post process step (within fio) or separate parser script (outside fio) would keep the overhead low when running fio measurements.
>
> Regards,
> Jeff
>
>
> -----Original Message-----
> From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On Behalf Of Mark Nelson
> Sent: Monday, June 6, 2016 2:11 PM
> To: Karl Cronburg <kcronbur@redhat.com>; fio@vger.kernel.org
> Subject: Re: computing percentiles from fio data
>
> On 06/06/2016 04:00 PM, Karl Cronburg wrote:
>> Hello,
>>
>> In benchmarking ceph I've been using fio / fiologparser, and want to
>> get out the sort of stats & percentiles fiologparser currently gives
>> (min, avg, max, percentiles). However I'm concerned the data coming
>> out of fio is insufficient when I pass it the log_avg_msec argument.
>> Namely using the average of a possibly asymmetric sample distribution
>> (the set of I/O request samples over which fio is averaging when I
>> pass it this argument) will not give accurate percentiles.
>>
>> Something like this argument is necessary though to keep the log files
>> a reasonable size. Would it be a good idea to push the sort of
>> statistics done in the log parser directly into fio? I'm considering
>> writing some code to compute the quantiles directly in fio, either
>> brute-force by maintaining a sorted list or implementing something
>> like the algorithm described here:
>>
>> http://www.cs.rutgers.edu/~muthu/bquant.pdf
>>
>> with some acceptable user-defined level of error given to fio when
>> asked to compute the percentiles on long-running / large data sets.
>>
>> Is there any interest in having this added directly into fio? If so
>> where in the code should I be looking?
>
> I think it would be great!  I confess I haven't read through the paper yet (and may not be able to before I leave on holiday for 2 weeks).  The big thing will be having some kind of reasonable test case data to make sure the results are reasonable and an explanation of how it works.
> It's one of the things missing from fiologparser.py right now.
>
> Potentially this could benefit a lot more folks than just those of us doing ceph testing, so I'd say go for it. :)
>
>>
>> -Karl Cronburg-
>> --
>> To unsubscribe from this list: send the line "unsubscribe fio" in the
>> body of a message to majordomo@vger.kernel.org More majordomo info at
>> http://vger.kernel.org/majordomo-info.html
>>
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Western Digital Corporation (and its subsidiaries) E-mail Confidentiality Notice & Disclaimer:
>
> This e-mail and any files transmitted with it may contain confidential or legally privileged information of WDC and/or its affiliates, and are intended solely for the use of the individual or entity to which they are addressed. If you are not the intended recipient, any disclosure, copying, distribution or any action taken or omitted to be taken in reliance on it, is prohibited. If you have received this e-mail in error, please notify the sender immediately and delete the e-mail in its entirety from your system.

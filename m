Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qa0-f43.google.com ([209.85.216.43]:54092 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754746AbaGNNDU convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Mon, 14 Jul 2014 09:03:20 -0400
Received: by mail-qa0-f43.google.com with SMTP id w8so3261065qac.30
        for <fio@vger.kernel.org>; Mon, 14 Jul 2014 06:03:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <9E26C6259ACF1842A4815F929194EDD394B5AC14@phex01.corp.bitmicro.com>
References: <9E26C6259ACF1842A4815F929194EDD394B5AC14@phex01.corp.bitmicro.com>
Date: Mon, 14 Jul 2014 09:03:19 -0400
Message-ID: <CAFTzLMNa1XQXKnn+L+r25P1yiZawNPyYU51cij=Hk1w521bK5A@mail.gmail.com>
Subject: Re: Generate Terse Output at specific time interval
From: Vasily Tarasov <tarasov@vasily.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Ritchie Babaylan <Ritchie.Babaylan@bitmicro.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Ritchie,

You can use

 --status-interval <interval_in_seconds>

switch to achieve what you want. One thing to notice, is that fio will
print aggregated statistics from the very beginning of the run, but
not the instantaneous statistics for the last 10 seconds.

Instanteneous statistics can be recalculated from the aggregated one,
but it would be really nice to have an ability in fio to print
instantaneous performance numbers by its own...

Vasily

On Mon, Jul 14, 2014 at 8:22 AM, Ritchie Babaylan
<Ritchie.Babaylan@bitmicro.com> wrote:
> Hi,
>
> Does FIO has a feature that can generate terse output (i.e. IOPS, throughput, latency) at specific interval (say, every 1-sec or every 10-sec or every T-sec)?
>
> If none, will this be added in the future?
>
> The reason I ask is because I bumped to one of a software called vdbench which can be able to generate the results based from user defined interval. The only catch that I see in vdbench is in relation to accesses below 32KB---it seems vdbench is capping it.
>
> Appreciate feedback on this matter.
>
>
> Thanks,
>
> Ritchie Babaylan
> Advance CORE Engineering
> BiTMICRO Networks, Inc.
>
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

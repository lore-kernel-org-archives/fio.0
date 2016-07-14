Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-it0-f46.google.com ([209.85.214.46]:38581 "EHLO
	mail-it0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbcGNQ32 (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 14 Jul 2016 12:29:28 -0400
Received: by mail-it0-f46.google.com with SMTP id h190so76582836ith.1
        for <fio@vger.kernel.org>; Thu, 14 Jul 2016 09:29:27 -0700 (PDT)
Subject: Re: fiologparser
References: <CAJ9yE1D_J5hvq_=vJ_DbgYy5nrQM0bC_nMhRKziDWjnbw23i-w@mail.gmail.com>
From: Mark Nelson <mark.a.nelson@gmail.com>
Message-ID: <19326c3d-bfdc-09ab-88ba-034206c7d4aa@gmail.com>
Date: Thu, 14 Jul 2016 11:29:26 -0500
MIME-Version: 1.0
In-Reply-To: <CAJ9yE1D_J5hvq_=vJ_DbgYy5nrQM0bC_nMhRKziDWjnbw23i-w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Karl Cronburg <kcronbur@redhat.com>, fio@vger.kernel.org



On 07/14/2016 10:35 AM, Karl Cronburg wrote:
> Hello all,
>
> I have written a new version of fiologparser and could use some feedback
> from anyone who uses the tool regularly. It is on branch fiologparser of my fork
> of fio:
>
> https://github.com/cronburg/fio/blob/fiologparser/tools/fiologparser.py
>
> It uses numpy and cython to speed up the data parsing and percentile
> calculations,
> while decreasing the memory footprint and making it scalable.

I was really trying to avoid the extra dependencies. :/  That's why 
Ben's last commit was reworked so we could avoid adding numpy as a 
dependency in the fio distribution (not that fio itself would need it, 
but it would be really swell if none of the tools needed anything other 
than stock python).

How much improvement are you seeing and where is the speedup coming 
from?  I suspect we can get similar gains without needing to bring it 
in.  For now though I really think we need to worry about correctness 
rather than speed.  As such, does this version use a similar technique 
as what's in wip-interval?

https://github.com/markhpc/fio/commits/wip-interval

If so, we should probably merge that first and make sure we have test 
cases for it to make sure the idea is sound.  If this is something new, 
it would be good to showcase that it's as good or better than 
wip-interval.  I could easily be convinced that it is, but let's 
demonstrate it.

Mark


>
> -Karl Cronburg-
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

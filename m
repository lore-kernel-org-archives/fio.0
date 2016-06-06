Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-it0-f44.google.com ([209.85.214.44]:36423 "EHLO
	mail-it0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886AbcFFVLH (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 6 Jun 2016 17:11:07 -0400
Received: by mail-it0-f44.google.com with SMTP id f67so53766166ith.1
        for <fio@vger.kernel.org>; Mon, 06 Jun 2016 14:11:06 -0700 (PDT)
Subject: Re: computing percentiles from fio data
References: <CAJ9yE1BYp_jqjwVVap1U-zjYfGT6bsOuXbOMcJV0r8Mz-5LQBQ@mail.gmail.com>
From: Mark Nelson <mark.a.nelson@gmail.com>
Message-ID: <a67cead2-b23f-5cf3-cfc3-f1705989f9b4@gmail.com>
Date: Mon, 6 Jun 2016 16:11:04 -0500
MIME-Version: 1.0
In-Reply-To: <CAJ9yE1BYp_jqjwVVap1U-zjYfGT6bsOuXbOMcJV0r8Mz-5LQBQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Karl Cronburg <kcronbur@redhat.com>, fio@vger.kernel.org

On 06/06/2016 04:00 PM, Karl Cronburg wrote:
> Hello,
>
> In benchmarking ceph I've been using fio / fiologparser, and want to
> get out the sort of stats & percentiles fiologparser currently gives
> (min, avg, max, percentiles). However I'm concerned the data coming
> out of fio is insufficient when I pass it the log_avg_msec argument.
> Namely using the average of a possibly asymmetric sample distribution
> (the set of I/O request samples over which fio is averaging when I
> pass it this argument) will not give accurate percentiles.
>
> Something like this argument is necessary though to keep the log files
> a reasonable size. Would it be a good idea to push the sort of
> statistics done in the log parser directly into fio? I'm considering
> writing some code to compute the quantiles directly in fio, either
> brute-force by maintaining a sorted list or implementing something
> like the algorithm described here:
>
> http://www.cs.rutgers.edu/~muthu/bquant.pdf
>
> with some acceptable user-defined level of error given to fio when
> asked to compute the percentiles on long-running / large data sets.
>
> Is there any interest in having this added directly into fio? If so
> where in the code should I be looking?

I think it would be great!  I confess I haven't read through the paper 
yet (and may not be able to before I leave on holiday for 2 weeks).  The 
big thing will be having some kind of reasonable test case data to make 
sure the results are reasonable and an explanation of how it works. 
It's one of the things missing from fiologparser.py right now.

Potentially this could benefit a lot more folks than just those of us 
doing ceph testing, so I'd say go for it. :)

>
> -Karl Cronburg-
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

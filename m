Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:36427 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685Ab3F0KpM (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 27 Jun 2013 06:45:12 -0400
Received: by mail-la0-f42.google.com with SMTP id eb20so614808lab.29
        for <fio@vger.kernel.org>; Thu, 27 Jun 2013 03:45:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130627090227.GL25599@kernel.dk>
References: <255129448.30162533.1372322165642.JavaMail.root@framestore.com>
	<803980722.30163228.1372322272381.JavaMail.root@framestore.com>
	<20130627090227.GL25599@kernel.dk>
Date: Thu, 27 Jun 2013 06:45:10 -0400
Message-ID: <CABFR9T3w9iOFZbjffxam13yKv9xUSNnV5VcwzPiyUnhB_0frfg@mail.gmail.com>
Subject: Re: Simulating bursts at different rates at irregular intervals?
From: Roger Sibert <roger_sibert@xyratex.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: FIO <fio@vger.kernel.org>

Just a thought that came to mind.

To work around the problem would the following work?
Run fio to get you max MB/s
Write a script to generate you work/jobs file that has randomizes
length of time for the job to run and % of max for it to run at.

Thanks,
Roger

On Thu, Jun 27, 2013 at 5:02 AM, Jens Axboe <axboe@kernel.dk> wrote:
> On Thu, Jun 27 2013, James Vanns wrote:
>> Hi. I'm new to fio and though I've read the HOWTO from the git repo several times now, I'm unsure if it is possible to achieve what I want;
>>
>> I can simulate a mix of sequential and random writes for a duration at
>> an average rate or throughput of say, 5.4MB/s.  I presume that fio
>> will attempt to sustain that rate? My real question is this - is it
>> possible in either the same job or a different job in the same file to
>> simulate bursts of higher rates? I.e. on average attempt to write at
>> nMB/s but at random or irregular intervals during this period attempt
>> a 'burst' of 138MB/s for 5 minutes and then return to the 'normal'
>> rate. Then again at some other point a burst of 57MB/s for 30minutes
>> etc.
>>
>> Is this possible? Presently I've found that I cannot do this. Or
>> rather, thinking about it, I'd have to specify n jobs for each
>> different rate and then perhaps use 'ratecycle' and 'thinktime'? I
>> can't see how to skew 'thinktime' randomly though?
>
> That's currently not possible, fio only supports a fixed rate. But if
> you have a good idea on how to express your criteria as an option (or
> options), then it can surely be added :-)
>
> --
> Jens Axboe
>
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

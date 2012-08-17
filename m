Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39825 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754599Ab2HQGks (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 17 Aug 2012 02:40:48 -0400
Received: by bkwj10 with SMTP id j10so1161391bkw.19
        for <fio@vger.kernel.org>; Thu, 16 Aug 2012 23:40:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <502DE3E3.2050901@kernel.dk>
References: <CAHaS=QzhdnM-TpzWb9eC3woLXZPM9t-LmcUzsf24rzUfUzPn-Q@mail.gmail.com>
	<502DE3E3.2050901@kernel.dk>
Date: Fri, 17 Aug 2012 16:40:46 +1000
Message-ID: <CAHaS=QyU7dEb9OrANOZE0h=6R=9Ws08KJX3tDHFXcbjf8nhXrA@mail.gmail.com>
Subject: Re: Suggestion: Add ramp-up for rate testing.
From: Greg Sullivan <greg.sullivan@sullivang.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org

On 17 August 2012 16:25, Jens Axboe <axboe@kernel.dk> wrote:
> On 08/16/2012 05:24 PM, Greg Sullivan wrote:
>> I suggest adding a ramp-up time parameter that can be used to prevent
>> the rate testing from occurring until the ramp-up time has passed.
>> This will more accurately model the throughput capacity of streaming
>> systems that have a pre-load buffer to ride over the initial cache
>> warm-up period.
>
> There's already a ramp time setting, and the rate will not be checked
> before that has passed. Not sure what extra setting you would like? A
> ramp time, and then a rate ramp time after that?
>

Thanks - that's exactly what I wanted, and I apologise for not reading
the manual (again). Note that I did scroll up and down a bit around
the rate related settings and didn't see anything related to ramping,
but I should have looked harder.

Regards,
Greg.

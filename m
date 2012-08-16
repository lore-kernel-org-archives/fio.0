Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:58971 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354Ab2HPXck (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 16 Aug 2012 19:32:40 -0400
Received: by bkwj10 with SMTP id j10so1102099bkw.19
        for <fio@vger.kernel.org>; Thu, 16 Aug 2012 16:32:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <22FC97D7-F97F-480D-8132-5DB13B2DFC59@joshcarter.com>
References: <CAHaS=QzhdnM-TpzWb9eC3woLXZPM9t-LmcUzsf24rzUfUzPn-Q@mail.gmail.com>
	<22FC97D7-F97F-480D-8132-5DB13B2DFC59@joshcarter.com>
Date: Fri, 17 Aug 2012 09:32:38 +1000
Message-ID: <CAHaS=Qy-kckL5FUcqof3ELLJ9ev0b9YHn76RAWEfBwYg=fiEVw@mail.gmail.com>
Subject: Re: Suggestion: Add ramp-up for rate testing.
From: Greg Sullivan <greg.sullivan@sullivang.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Josh Carter <public@joshcarter.com>
Cc: fio@vger.kernel.org

Thanks Josh. Note that at the moment, I'd be happy to just have a
simple time delay before ratemin testing begins.

Greg.

On 17/08/2012, Josh Carter <public@joshcarter.com> wrote:
> Greg (and all),
>
> I actually did some work on this, however I didn't have it ready to push
> upstream. I used the existing "ratemin" and "rate" configuration options to
> represent the starting rate and the final (target) rate, then I added a
> "ratestep" option which added to the current rate every 5 "ratecycles".
>
> Problem was, when I changed the rate, there was a brief spike in bandwidth
> for that bw measurement interval. I didn't determine if the problem was
> actually in the rate limiting (most likely), or in the bandwidth measurement
> (less likely but possible). In any case, I didn't want to offer the patch
> until that was solved.
>
> I'm not able to work on this right now, so I'll pass along the patch as-is.
> Maybe someone else can take it and run with it.
>
> Best regards,
> Josh
>
>

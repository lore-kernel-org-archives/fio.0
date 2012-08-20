Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:42679 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022Ab2HTBmo (ORCPT <rfc822;fio@vger.kernel.org>);
	Sun, 19 Aug 2012 21:42:44 -0400
Received: by bkwj10 with SMTP id j10so1730938bkw.19
        for <fio@vger.kernel.org>; Sun, 19 Aug 2012 18:42:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAHaS=Qz0FBWFh1o4avw5wTapGFTO8-argLW38mrdXHWLJ0-Ygg@mail.gmail.com>
References: <CAHaS=Qz0FBWFh1o4avw5wTapGFTO8-argLW38mrdXHWLJ0-Ygg@mail.gmail.com>
Date: Mon, 20 Aug 2012 11:42:43 +1000
Message-ID: <CAHaS=QxJeWf-YvKkLktR45W2g-dRhEcXgM=7napOxb8ct7pKEg@mail.gmail.com>
Subject: Re: Rate problems (Windows)
From: Greg Sullivan <greg.sullivan@sullivang.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

On 19 August 2012 22:39, Greg Sullivan <greg.sullivan@sullivang.net> wrote:
> I'm finding that the throughput is varying wildly during a run - more
> than I think is probably normal. It happens regardless of whether I
> limit by data rate or io rate, although I think it's worse when I
> limit by io.
>
> Here is a test job followed by the output. The io rate fluctuated
> wildly - I watched it in the Windows Performance Monitor. The io rate
> should be extremely easy to maintain. The "CR=80" looks suspicious -
> why is there an 80 there when I requested 40?
[stuff removed]

I tried the same test on Ubuntu, and I think it's working properly -
the iops figures displayed by fio are relatively constant as the test
runs.  (although I'm having trouble relating the the output of iostat
to the actual workload that should be generated) I still get the
CR=<double the requested rate> on Ubuntu, so I assume this is normal.
The iops figures over on the right of the output look kosher. (as they
do on Windows, except for the wide fluctuations)

Greg.

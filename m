Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:49743 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754014Ab2HULoe (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 21 Aug 2012 07:44:34 -0400
Received: by bkwj10 with SMTP id j10so2152822bkw.19
        for <fio@vger.kernel.org>; Tue, 21 Aug 2012 04:44:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <503373F4.80000@cran.org.uk>
References: <CAHaS=Qz0FBWFh1o4avw5wTapGFTO8-argLW38mrdXHWLJ0-Ygg@mail.gmail.com>
	<CAHaS=QxJeWf-YvKkLktR45W2g-dRhEcXgM=7napOxb8ct7pKEg@mail.gmail.com>
	<503230E9.2000406@kernel.dk>
	<CAHaS=QzK4xhuu4vgqOQfNtLaVJE6kbsHtCj1A-BCCTFs=0eTYA@mail.gmail.com>
	<503373F4.80000@cran.org.uk>
Date: Tue, 21 Aug 2012 21:44:32 +1000
Message-ID: <CAHaS=Qz74ZHJCkFc4r-syfBM5q+nbzNZS9UYedr5E1nFbZwLcQ@mail.gmail.com>
Subject: Re: Rate problems (Windows)
From: Greg Sullivan <greg.sullivan@sullivang.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Bruce Cran <bruce@cran.org.uk>
Cc: fio@vger.kernel.org

On 21 August 2012 21:41, Bruce Cran <bruce@cran.org.uk> wrote:
> On 21/08/2012 12:35, Greg Sullivan wrote:
>>
>> I have now done a basic test of the rate functionality on Ubuntu, and
>> it seems to be working fine. I am more confident now that there is
>> indeed a problem when running fio on Windows.
>
>
> Are you running the test on a new filesystem on a separate disk, or in a
> directory on a disk that's got lots of other files on it?
>
> --
> Bruce Cran

A dedicated disk. It has some files on it, but not much. There are no
other processes accessing the disk.  Are you not able to reproduce the
problem?

Thanks,
Greg.

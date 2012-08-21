Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:55017 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754350Ab2HUMja (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 21 Aug 2012 08:39:30 -0400
Received: by bkwj10 with SMTP id j10so2169256bkw.19
        for <fio@vger.kernel.org>; Tue, 21 Aug 2012 05:39:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <503376AD.5020602@cran.org.uk>
References: <CAHaS=Qz0FBWFh1o4avw5wTapGFTO8-argLW38mrdXHWLJ0-Ygg@mail.gmail.com>
	<CAHaS=QxJeWf-YvKkLktR45W2g-dRhEcXgM=7napOxb8ct7pKEg@mail.gmail.com>
	<503230E9.2000406@kernel.dk>
	<CAHaS=QzK4xhuu4vgqOQfNtLaVJE6kbsHtCj1A-BCCTFs=0eTYA@mail.gmail.com>
	<503373F4.80000@cran.org.uk>
	<CAHaS=Qz74ZHJCkFc4r-syfBM5q+nbzNZS9UYedr5E1nFbZwLcQ@mail.gmail.com>
	<503376AD.5020602@cran.org.uk>
Date: Tue, 21 Aug 2012 22:39:28 +1000
Message-ID: <CAHaS=QwPXBMn=enaT+0xRpG_vCywz4jc6HuJCmP6wA-A2LiBTg@mail.gmail.com>
Subject: Re: Rate problems (Windows)
From: Greg Sullivan <greg.sullivan@sullivang.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Bruce Cran <bruce@cran.org.uk>
Cc: fio@vger.kernel.org

On 21 August 2012 21:53, Bruce Cran <bruce@cran.org.uk> wrote:
> On 21/08/2012 12:44, Greg Sullivan wrote:
>>
>> A dedicated disk. It has some files on it, but not much. There are no
>> other processes accessing the disk.  Are you not able to reproduce the
>> problem?
>
>
> I saw the problem last week on an old installation of Server 2008 R2 on a
> disk that was over 40% fragmented and had other traffic to it but now, on
> Windows 8 the IOPS stay between 39 and 40.
>
> --
> Bruce

It's working sometimes for me. However, sometimes it fails miserably.
For example, I just ran a job with a target rate of 50 iops, and the
output was on zero iops for ages (maybe about 20 seconds), and then it
briefly flashed up 1118 iops.  It might be working better in buffered
mode than it is in direct mode. (not 100% sure yet)

Greg.

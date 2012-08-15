Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:37073 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420Ab2HOH6i (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 15 Aug 2012 03:58:38 -0400
Received: by bkwj10 with SMTP id j10so411520bkw.19
        for <fio@vger.kernel.org>; Wed, 15 Aug 2012 00:58:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <502B5528.3000102@cran.org.uk>
References: <CAHaS=Qz8_g=0RqV53G_PuSM7Apvbbn3ksuF5MvkFUo7vme40Fw@mail.gmail.com>
	<201208142232.41100.Martin@lichtvoll.de>
	<CAHaS=QzFqSB_eo1fWCw4ddQjFfuhuuQaiU2VsV-7XSzSkCfp8A@mail.gmail.com>
	<201208142324.48504.Martin@lichtvoll.de>
	<CAHaS=QxneG_nUx9GBsDL1dVJTLd2X7scO_vjxvDxEibB1NMrCw@mail.gmail.com>
	<502B5528.3000102@cran.org.uk>
Date: Wed, 15 Aug 2012 17:58:37 +1000
Message-ID: <CAHaS=Qy8ye1iVQR6==QFPxpB7QRvmv9of1MCiDHBK5ip304+=w@mail.gmail.com>
Subject: Re: How to do strict synchronous i/o on Windows?
From: Greg Sullivan <greg.sullivan@sullivang.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Bruce Cran <bruce@cran.org.uk>
Cc: Martin Steigerwald <Martin@lichtvoll.de>, fio@vger.kernel.org

On 15/08/2012, Bruce Cran <bruce@cran.org.uk> wrote:
> On 15/08/2012 03:46, Greg Sullivan wrote:
>> Thanks - that runs, but it's still queuing. As I said before, I can't
>> use the sync engine - I receive an error. Is there a synchronous
>> engine available for Windows? Perhaps that's the only problem.
>> Can you check to see whether your system is queuing at the file
>> system/device level when you run that test?
>
> The sync ioengine doesn't work on Windows. You should be able to get the
> same behaviour by using sync=1 and direct=1 with windowsaio.
>
> --
> Bruce Cran
>
Thanks Bruce. The reason I hadn't tried sync=1 is because I thought it
only applied to writes, which I'm not interested in. I'll give it a
try though and report back.

Greg.

Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:36974 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838Ab2HNNTe (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 14 Aug 2012 09:19:34 -0400
Received: by yhmm54 with SMTP id m54so397766yhm.19
        for <fio@vger.kernel.org>; Tue, 14 Aug 2012 06:19:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <502A4D22.3090200@kernel.dk>
References: <CAHaS=Qz8_g=0RqV53G_PuSM7Apvbbn3ksuF5MvkFUo7vme40Fw@mail.gmail.com>
	<502A4D22.3090200@kernel.dk>
Date: Tue, 14 Aug 2012 23:19:33 +1000
Message-ID: <CAHaS=Qz9b2UzcUegFBbFzdiy0j48JJ-DP_oFMqAWYhjYP3BQiA@mail.gmail.com>
Subject: Re: How to do strict synchronous i/o on Windows?
From: Greg Sullivan <greg.sullivan@sullivang.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: 
Cc: fio@vger.kernel.org

Thanks Jens. I do in fact have an application that reads in exactly the
manner I described. I have monitored the queue depth - it does not rise
above 1.  It is a real time musical sample streamer.

Please consider this a new feature request for fio - thankyou.

Greg.


On Aug 14, 2012 11:06 PM, "Jens Axboe" <axboe@kernel.dk> wrote:
>
> On 08/14/2012 08:24 AM, Greg Sullivan wrote:
> > I need to simulate strict synchronous, round robin i/o to a group of
> > files. I am on Windows 7 32-bit.
> > fio is very nearly working, except that even with a queue depth of 1,
> > it is still resulting in a disk queue that is > 1, because the
> > "iodepth" parameter is not global - it is per thread. (correct?)
> >
> > I've tried using the "sync" engine, however that doesn't work at all -
> > just spews out errors.
>
> That'll be the case for ANY platform and IO engine. If you have more
> than 1 thread or process going, you can have > 1 depth at the device
> side. The definition of a sync IO call is that the call doesn't return
> until the IO is done. If you have overlapped calls due to more than 1
> thread, then that is no longer true.
>
> What you are looking for is outside the scope of an application. You
> would have to limit the queue depth on the operating system side to
> achieve that. Or artificially limit fio in some way, which would not
> make a lot of sense imho.
>
> --
> Jens Axboe
>

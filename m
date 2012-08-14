Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:51085 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004Ab2HNH6J (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 14 Aug 2012 03:58:09 -0400
Received: by ggdk6 with SMTP id k6so109838ggd.19
        for <fio@vger.kernel.org>; Tue, 14 Aug 2012 00:58:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAHaS=Qz8_g=0RqV53G_PuSM7Apvbbn3ksuF5MvkFUo7vme40Fw@mail.gmail.com>
References: <CAHaS=Qz8_g=0RqV53G_PuSM7Apvbbn3ksuF5MvkFUo7vme40Fw@mail.gmail.com>
Date: Tue, 14 Aug 2012 17:58:08 +1000
Message-ID: <CAHaS=QyhAHqoWuf5L4ugbRXT13rdDuQ3_wJnKj1H1r5KVgHg1A@mail.gmail.com>
Subject: Re: How to do strict synchronous i/o on Windows?
From: Greg Sullivan <greg.sullivan@sullivang.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The error I receive when attempting to use the "sync" io engine in Windows 7:

"fio: pid=4904, err=5/file:backend.c:633, func=full resid,
error=Input/output error"

I tried psync - that ran, but didn't seem to do the proper io. vsync
didn't work at all.

If there are no synchronous engines available at the moment for
Windows, I suggest adding an option to simulate synchronous io when
using the Windows AIO engine.

Greg.


On 14 August 2012 16:24, Greg Sullivan <greg.sullivan@sullivang.net> wrote:
> I need to simulate strict synchronous, round robin i/o to a group of
> files. I am on Windows 7 32-bit.
> fio is very nearly working, except that even with a queue depth of 1,
> it is still resulting in a disk queue that is > 1, because the
> "iodepth" parameter is not global - it is per thread. (correct?)
>
> I've tried using the "sync" engine, however that doesn't work at all -
> just spews out errors.
>
> Any assistance much appreciated.
>
> Greg.

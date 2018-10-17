Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vs1-f47.google.com ([209.85.217.47]:38907 "EHLO
        mail-vs1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727014AbeJRDkt (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 17 Oct 2018 23:40:49 -0400
Received: by mail-vs1-f47.google.com with SMTP id a202so21541473vsd.5
        for <fio@vger.kernel.org>; Wed, 17 Oct 2018 12:43:36 -0700 (PDT)
MIME-Version: 1.0
References: <CAH6Skxqj9ysWrK4=7ym1qVjpVPZ=4zN0+Zc1Z6Ymcb5AE_cOug@mail.gmail.com>
In-Reply-To: <CAH6Skxqj9ysWrK4=7ym1qVjpVPZ=4zN0+Zc1Z6Ymcb5AE_cOug@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Wed, 17 Oct 2018 20:43:09 +0100
Message-ID: <CALjAwxhuy992vSXLz-A8E5i_tfaFhqCY65dHQYGKk0VKypxAog@mail.gmail.com>
Subject: Re: Problems with CentOS 7.5
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Kip Ingram <kip.ingram@gmail.com>
Cc: fio <fio@vger.kernel.org>, Eric Sandeen <sandeen@redhat.com>

On Wed, 17 Oct 2018 at 11:42, Kip Ingram <kip.ingram@gmail.com> wrote:
>
> Hi guys.  Earlier this year I installed fio (from latest source) on a
> CentOS 7.4 install, and had nothing but stellar operation - very
> smooth, very good.
>
> Recently I've done the same on a CentOS 7.5 install, and I'm having
> difficulties.  I've rolled back my target software to known good
> (we're storage developers), I've tested with both os drivers and spdk,
> and I've tried to roll back the fio snapshot as well, all to no avail.
>
> The symptom varies depending on whether or not I'm using spdk -
> without spdk, I see my performance drop but not to zero, after the
> test has run successfully for some random but usually small length of
> time.  With spdk, I/O seems to stop completely after a similar length
> of time.  With spdk the fio output line ceases to show ay bandwidth or
> IOPS info.  The timer will count down to zero, but the job doesn't
> stop; the timer just resets itself to some large value and things
> continue to run.

So the issue only happens only when you use the external spdk plugin?
Have you tried talking to the spdk project?

>
> With spdk, before the problem I can use ctrl-C to interrupt the job;
> afterthe problem I can't - I have to use kill -9.
>
> Tests with spdk's "perf" utility have uniformly seemed to run
> perfectly - that's the primary reason I don't believe spdk is the
> issue here (well, that and the fact that I also have problems with the
> os drivers).  The behavior in fio isn't exactly the same with and
> without os drivers, but it's problematic in both cases.
>
> I THINK I have probed old fio build points enough to think that this
> isn't arising from a recent change in fio.  My main suspicion right
> now is that something is different in CentOS 7.5 that fio is unhappy
> with - is anyone aware of issues with that particular Linux distro?
>
> Thanks very much,
> Kip

It might be worth mentioning this to the fio package's EPEL maintainer
in case they know...

-- 
Sitsofe | http://sucs.org/~sits/


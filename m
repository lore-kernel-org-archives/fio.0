Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-lf1-f51.google.com ([209.85.167.51]:35853 "EHLO
        mail-lf1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726904AbeJQSgg (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 17 Oct 2018 14:36:36 -0400
Received: by mail-lf1-f51.google.com with SMTP id d4-v6so19430901lfa.3
        for <fio@vger.kernel.org>; Wed, 17 Oct 2018 03:41:29 -0700 (PDT)
MIME-Version: 1.0
From: Kip Ingram <kip.ingram@gmail.com>
Date: Wed, 17 Oct 2018 05:41:17 -0500
Message-ID: <CAH6Skxqj9ysWrK4=7ym1qVjpVPZ=4zN0+Zc1Z6Ymcb5AE_cOug@mail.gmail.com>
Subject: Problems with CentOS 7.5
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi guys.  Earlier this year I installed fio (from latest source) on a
CentOS 7.4 install, and had nothing but stellar operation - very
smooth, very good.

Recently I've done the same on a CentOS 7.5 install, and I'm having
difficulties.  I've rolled back my target software to known good
(we're storage developers), I've tested with both os drivers and spdk,
and I've tried to roll back the fio snapshot as well, all to no avail.

The symptom varies depending on whether or not I'm using spdk -
without spdk, I see my performance drop but not to zero, after the
test has run successfully for some random but usually small length of
time.  With spdk, I/O seems to stop completely after a similar length
of time.  With spdk the fio output line ceases to show ay bandwidth or
IOPS info.  The timer will count down to zero, but the job doesn't
stop; the timer just resets itself to some large value and things
continue to run.

With spdk, before the problem I can use ctrl-C to interrupt the job;
afterthe problem I can't - I have to use kill -9.

Tests with spdk's "perf" utility have uniformly seemed to run
perfectly - that's the primary reason I don't believe spdk is the
issue here (well, that and the fact that I also have problems with the
os drivers).  The behavior in fio isn't exactly the same with and
without os drivers, but it's problematic in both cases.

I THINK I have probed old fio build points enough to think that this
isn't arising from a recent change in fio.  My main suspicion right
now is that something is different in CentOS 7.5 that fio is unhappy
with - is anyone aware of issues with that particular Linux distro?

Thanks very much,
Kip


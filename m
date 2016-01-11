Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:34611 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758239AbcAKLJt (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 11 Jan 2016 06:09:49 -0500
Received: by mail-lb0-f181.google.com with SMTP id cl12so34621940lbc.1
        for <fio@vger.kernel.org>; Mon, 11 Jan 2016 03:09:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CADr68WZJ0+r4M5WArqvRkHHTAj=uLg8bi8xmGr+mMJ=KamQ+UQ@mail.gmail.com>
References: <CADr68WZJ0+r4M5WArqvRkHHTAj=uLg8bi8xmGr+mMJ=KamQ+UQ@mail.gmail.com>
Date: Mon, 11 Jan 2016 12:09:47 +0100
Message-ID: <CADr68Wam45zdOL_d_4PPAZ-O8nfuoVxHDHnPUkCYqSd720FwYA@mail.gmail.com>
Subject: Re: engine rbd broken after commit 2466096336bd0fbc1a94811aa338926af6baf42f
From: Jens Rosenboom <j.rosenboom@x-ion.de>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio <fio@vger.kernel.org>

2016-01-08 12:15 GMT+01:00 Jens Rosenboom <j.rosenboom@x-ion.de>:
> When running fio-2.3 with the rbd engine, the tests themselves run
> fine, but instead of the results being printed, I get:
>
> fio: mutex.c:163: fio_mutex_down: Assertion `mutex->magic ==
> 0x4d555445U' failed.
>
> The command I am using is
>
> fio --ioengine=rbd --clientname=admin --pool=test --rbdname=test1
> --rw=randwrite --runtime=10 --ramp_time=None --numjobs=1 --direct=1
> --bs=1048576B --iodepth=64 --name=test1
>
> If I instead use another engine, everything is fine, e.g.:
>
> fio --ioengine=libaio --filename=/dev/sdb1 --rw=randwrite --runtime=10
> --ramp_time=None --numjobs=1 --direct=1 --bs=1048576B --iodepth=64
> --name=test1
>
> Going back to fio-2.2.13 makes the error go away and running a git
> bisect leads to the commit mentioned in the subject as the culprit,
> the error turns into a Segmentation Fault at that point, though.

Accidentally I found out that I can also reproduce the bug with libaio if I set

LD_PRELOAD=../jemalloc/lib/libjemalloc.so

compiled from https://github.com/jemalloc/jemalloc.git (tested with
3.6.0 and 4.0.4)

So it seems there is some use-after-free issue in this commit. I'll
try to dig into this a bit more when I get the time, but I won't be
sad if someone else is faster. ;)
